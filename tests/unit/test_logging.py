from __future__ import annotations

import logging
import warnings
from typing import TYPE_CHECKING

import zerolib
from loguru import logger as log

if TYPE_CHECKING:
    import pytest


def test_basic(caplog: pytest.LogCaptureFixture) -> None:
    log.debug("x")
    record = caplog.records[0]
    assert record.message == "x"
    assert record.levelname == "DEBUG"


async def test_debug() -> None:
    log = await zerolib.logging.configure(debug=True)
    assert logging.getLogger("asyncio").level == logging.NOTSET
    assert log._core.min_level == 5  # type: ignore[attr-defined]
    log = await zerolib.logging.configure(verbose=1)
    assert log._core.min_level == 10  # type: ignore[attr-defined]


def test_intercept(caplog: pytest.LogCaptureFixture) -> None:
    logging.getLogger("xxx").info("y")
    record = caplog.records[0]
    assert record.message == "y"
    assert record.levelname == "INFO"


def test_warning(caplog: pytest.LogCaptureFixture) -> None:
    warnings.warn("x", stacklevel=2)
    record = caplog.records[0]
    assert record.message == "x"
    assert record.levelname == "WARNING"
