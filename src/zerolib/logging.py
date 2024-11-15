from __future__ import annotations

import inspect
import logging
import sys
import warnings
from typing import TYPE_CHECKING

import anyio
from loguru import logger as log

from . import serialize, util
from .dic import Dic

if TYPE_CHECKING:
    from typing import IO, TextIO

    from loguru import Logger


HERE = anyio.Path(__file__).parent


async def configure(
    *,
    debug: bool = False,
    verbose: int = 0,
    color: util.CliColorType = util.CLI_COLOR_DEFAULT,
    config: anyio.Path = HERE / "logging.yml",
    sink: IO | None = None,
    enable_for: tuple[str, ...] = (__package__,),
) -> Logger:
    # read config
    cfg = Dic(serialize.loads(await config.read_text()))

    default = cfg.logger.handlers[0]
    default.update(
        # sink defaults to stderr, not as default argument since sys.stderr may be a
        # wrapper under test
        sink=sink or sys.stderr,
        # format is specified as a list for ease of yaml formatting
        format=" ".join(default.format),
        # colorize=None is auto based on sys.stderr.isatty
        colorize=util.cli_color(color),
    )

    # debug mode
    if debug:
        cfg.levels["asyncio"] = "notset"
        verbose = 2

    # set level from verbose
    match verbose:
        case 0:
            default.level = "INFO"
        case 1:
            default.level = "DEBUG"
        case _:
            default.level = "TRACE"

    # set individual logger levels
    for name, level in cfg.levels.items():
        logging.getLogger(name).setLevel(getattr(logging, level.upper()))

    # configure logger
    log.remove()
    log.configure(**cfg.logger)
    for package in enable_for:
        log.enable(package)

    # intercept warnings + stdlib logging
    warnings.showwarning = _showwarning
    logging.basicConfig(handlers=[_InterceptHandler()], level=0, force=True)

    return log


def _showwarning(
    message: Warning | str,
    category: type[Warning],
    filename: str,  # noqa: ARG001
    lineno: int,  # noqa: ARG001
    file: TextIO | None = None,  # noqa: ARG001
    line: str | None = None,  # noqa: ARG001
) -> None:
    log.opt(depth=2).warning(str(message), category)


# https://loguru.readthedocs.io/en/stable/overview.html#entirely-compatible-with-standard-logging
class _InterceptHandler(logging.Handler):
    def emit(self, record: logging.LogRecord) -> None:
        level = log.level(record.levelname).name
        frame, depth = inspect.currentframe(), 0
        while frame and (depth == 0 or frame.f_code.co_filename == logging.__file__):
            frame = frame.f_back
            depth += 1
        log.opt(depth=depth, exception=record.exc_info).log(level, record.getMessage())
