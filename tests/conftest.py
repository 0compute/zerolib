from __future__ import annotations

import os

import beartype
import beartype.claw
import pytest
import typeguard
from loguru import logger as log

# XXX: install type checkers - must be before local imports
if "ZEROLIB_NO_TYPECHECK" not in os.environ:
    typeguard.config.forward_ref_policy = typeguard.ForwardRefPolicy.ERROR
    typeguard.install_import_hook("zerolib")
    typeguard.install_import_hook("tests")

    beartype.claw.beartype_packages(
        ("zerolib", "tests"),
        conf=beartype.BeartypeConf(
            is_color=True,
            is_debug=True,
            strategy=beartype.BeartypeStrategy.On,
        ),
    )

from zerolib import Context


# https://loguru.readthedocs.io/en/stable/resources/migration.html#replacing-caplog-fixture-from-pytest-library
@pytest.fixture
def caplog(caplog: pytest.LogCaptureFixture) -> pytest.LogCaptureFixture:
    handler_id = log.add(
        caplog.handler,
        format="{message}",
        level=0,
        filter=lambda record: record["level"].no >= caplog.handler.level,
        enqueue=True,
    )
    yield caplog
    log.remove(handler_id)


@pytest.fixture
def ctx() -> Context:
    return Context()
