from __future__ import annotations

import inspect
import logging
import os
import pathlib
import sys
import warnings
from typing import TYPE_CHECKING

from loguru import logger

from . import serialize
from .dic import Dic

if TYPE_CHECKING:
    from typing import Any

COLOR_DEFAULT = "auto"

COLOR_CHOICES = (COLOR_DEFAULT, "always", "never")


def _showwarning(message: str, *_args: Any, **_kwargs: Any) -> None:
    logger.opt(depth=2).warning(message)


# https://loguru.readthedocs.io/en/stable/overview.html#entirely-compatible-with-standard-logging
class InterceptHandler(logging.Handler):
    def emit(self, record: logging.LogRecord) -> None:
        level: str | int
        try:
            level = logger.level(record.levelname).name
        except ValueError:
            level = record.levelno
        frame, depth = inspect.currentframe(), 0
        while frame and (depth == 0 or frame.f_code.co_filename == logging.__file__):
            frame = frame.f_back
            depth += 1
        logger.opt(depth=depth, exception=record.exc_info).log(
            level, record.getMessage()
        )


def configure(
    *, debug: bool = False, verbose: int = 0, color: str = COLOR_DEFAULT
) -> None:
    # read config
    cfg = Dic(
        serialize.load((pathlib.Path(__file__).parent / "logconfig.yml").read_text())
    )

    default = cfg.logger.handlers[0]
    default.update(
        sink=sys.stderr,
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

    logger.remove()
    logger.configure(**cfg.logger)
    logger.enable(__package__)

    # intercept warnings + stdlib logging
    warnings.showwarning = _showwarning
    logging.basicConfig(handlers=[InterceptHandler()], level=0, force=True)

    # # set individual logger levels
    for name, level in cfg.levels.items():
        logging.getLogger(name).setLevel(getattr(logging, level.upper()))
    # # reset start time so we don't count imports
    # logging._startTime = time.time()  # type: ignore[attr-defined]
