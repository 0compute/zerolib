from __future__ import annotations

import os
from typing import TYPE_CHECKING

import beartype
import beartype.claw
import pytest
import typeguard
from loguru import logger as log

# install type checkers - must be before local imports
if "ZEROLIB_NO_TYPECHECK" not in os.environ:  # pragma: no branch
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

from zerolib import Struct, logging, util

if TYPE_CHECKING:
    from collections.abc import Generator

    from zerolib import Context


# https://loguru.readthedocs.io/en/stable/resources/migration.html#replacing-caplog-fixture-from-pytest-library
@pytest.fixture
def caplog(
    caplog: pytest.LogCaptureFixture
) -> Generator[pytest.LogCaptureFixture, None, None]:
    util.run_sync(logging.configure)
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
    return Struct.ctx
