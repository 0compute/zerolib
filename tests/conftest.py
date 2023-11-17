from __future__ import annotations

from typing import TYPE_CHECKING

import pytest
from loguru import logger
from zerolib import Context, Graph

if TYPE_CHECKING:
    from collections.abc import Generator


# https://loguru.readthedocs.io/en/stable/resources/migration.html#replacing-caplog-fixture-from-pytest-library
@pytest.fixture()
def caplog(caplog: pytest.LogCaptureFixture) -> pytest.LogCaptureFixture:
    handler_id = logger.add(
        caplog.handler,
        format="{message}",
        level=0,
        filter=lambda record: record["level"].no >= caplog.handler.level,
        enqueue=True,
    )
    yield caplog
    logger.remove(handler_id)


# give each test a clean graph
@pytest.fixture(autouse=True)
def _graph() -> Generator[None, None, None]:
    with Context()(graph=Graph()):
        yield
