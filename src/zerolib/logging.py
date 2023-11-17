from __future__ import annotations

import inspect
import logging
import os
import sys
import warnings
from typing import TYPE_CHECKING

import anyio
from loguru import _logger, logger as log

from . import serialize
from .dic import Dic

if TYPE_CHECKING:
    from typing import TextIO

COLOR_DEFAULT = "auto"

COLOR_CHOICES = (COLOR_DEFAULT, "always", "never")


async def configure(
    *, debug: bool = False, verbose: int = 0, color: str = COLOR_DEFAULT
) -> _logger.Logger:
    # read config
    cfg = Dic(
        serialize.loads(await (anyio.Path(__file__).parent / "logging.yml").read_text())
    )
    cfg.logger.handlers[0].format = " ".join(cfg.logger.handlers[0].format)

    default = cfg.logger.handlers[0]
    default.update(
        sink=sys.stderr,
        # colorize=None is auto based on sys.stderr.isatty
        # NO_COLOR: see https://no-color.org/
        colorize=(
            None if "NO_COLOR" in os.environ or color == "auto" else color == "always"
        ),
    )

    # debug mode
    if debug:  # pragma: no cover
        cfg.loggers["asyncio"] = "notset"
        verbose = 2

    # set level from verbose
    match verbose:  # pragma: no cover
        case 0:
            default.level = "INFO"
        case 1:
            default.level = "DEBUG"
        case _:
            default.level = "TRACE"

    # set individual logger levels
    for name, level in cfg.levels.items():
        logging.getLogger(name).setLevel(getattr(logging, level.upper()))
    # reset start time (don't count import time)
    _logger.start_time = _logger.aware_now()

    # configure logger
    log.remove()
    log.configure(**cfg.logger)
    log.enable(__package__)

    # intercept warnings + stdlib logging
    warnings.showwarning = _showwarning
    logging.basicConfig(handlers=[InterceptHandler()], level=0, force=True)

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
class InterceptHandler(logging.Handler):
    def emit(self, record: logging.LogRecord) -> None:
        level: str | int
        try:
            level = log.level(record.levelname).name
        except ValueError:
            level = record.levelno
        frame, depth = inspect.currentframe(), 0
        while frame and (depth == 0 or frame.f_code.co_filename == logging.__file__):
            frame = frame.f_back
            depth += 1
        log.opt(depth=depth, exception=record.exc_info).log(level, record.getMessage())
