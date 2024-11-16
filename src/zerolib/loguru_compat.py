# HACK: loguru uses a stub file for type hints hence this
# https://github.com/Delgan/loguru/issues/1101

from __future__ import annotations

from typing import TYPE_CHECKING

from loguru import logger as log

if TYPE_CHECKING:
    from loguru import Logger
else:
    Logger = type(log)

__all__ = ("Logger", "log")
