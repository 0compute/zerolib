from __future__ import annotations

import logging
import warnings
from typing import TYPE_CHECKING

from loguru import logger as log

if TYPE_CHECKING:
    import pytest


async def test_basic(caplog: pytest.LogCaptureFixture) -> None:
    log.debug("x")
    record = caplog.records[0]
    assert record.message == "x"
    assert record.levelname == "DEBUG"


async def test_intercept(caplog: pytest.LogCaptureFixture) -> None:
    logging.getLogger("xxx").info("y")
    record = caplog.records[0]
    assert record.message == "y"
    assert record.levelname == "INFO"


async def test_warning(caplog: pytest.LogCaptureFixture) -> None:
    warnings.warn("x", stacklevel=2)
    record = caplog.records[0]
    assert record.message == "x"
    assert record.levelname == "WARNING"
