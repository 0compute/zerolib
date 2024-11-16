from __future__ import annotations

from collections.abc import Generator
from typing import TYPE_CHECKING

import pytest
from loguru import logger as log

if TYPE_CHECKING:
    from zerolib import Context

# XXX: Do not import zerolib in global scope so typeguard can instrument the package


# https://loguru.readthedocs.io/en/stable/resources/migration.html#replacing-caplog-fixture-from-pytest-library
@pytest.fixture
def caplog(
    caplog: pytest.LogCaptureFixture,
) -> Generator[pytest.LogCaptureFixture, None, None]:
    from zerolib import logging

    logging.configure.sync()
    handler_id = log.add(
        caplog.handler,
        format="{message}",
        level=0,
        filter=lambda record: record["level"].no >= caplog.handler.level,
    )
    yield caplog
    log.remove(handler_id)


@pytest.fixture
def ctx() -> Context:
    from zerolib import Struct

    return Struct.ctx
