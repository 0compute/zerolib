from __future__ import annotations

import functools
import io
from typing import TYPE_CHECKING

import pytest
from zerolib import Dic, serialize

from .type.test_struct import Impl

if TYPE_CHECKING:
    from typing import Any


@pytest.mark.parametrize(
    ("fmt", "obj"),
    functools.reduce(
        lambda base, fmt: [
            *base,
            *[(fmt, obj) for obj in (dict(a=1), [1], 1, "a", None, Dic(a=1))],
        ],
        serialize.SERIALIZE,
        [],
    ),
)
def test_dump_load(fmt: str, obj: Any) -> None:
    stream = (io.BytesIO if fmt == "msgpack" else io.StringIO)()
    if fmt == "msgpack":
        # special case: see util.dump
        stream.buffer = stream
    serialize.dump(obj, file=stream, fmt=fmt)
    stream.seek(0)
    assert serialize.load(file=stream, fmt=fmt) == obj
    assert serialize.loads(serialize.dumps(obj)) == obj


def test_dump_struct() -> None:
    obj = Impl()
    dump = serialize.dumps(obj, fmt="yaml")
    assert dump == "mstr: a\nmint: 0\n_mbool: false"
