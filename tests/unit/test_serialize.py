from __future__ import annotations

import datetime
import io

import pytest
from zerolib import Dic, serialize

from .type.test_struct import Impl

ODICT = Dic(
    one=list(),
    two=2,
    three=dict(x=1),
    four=False,
    five=None,
    six={2, 1},
    seven=datetime.datetime.now(datetime.timezone.utc),
    eight={},
    nine={Dic(a=1)},
)

ODICT_EXPORT = ODICT.export(stringify=True)


def _assert_clean(odict: dict) -> None:
    assert "one" not in odict
    assert "two" in odict
    assert "three" in odict
    assert "four" in odict
    assert "five" not in odict
    assert "six" in odict
    assert "seven" in odict
    assert "eight" not in odict
    assert odict["nine"] == [Dic(a=1)]


@pytest.mark.parametrize("fmt", serialize.SERIALIZE)
def test_dump_load(fmt: str) -> None:
    # dump/load
    stream_cls = io.BytesIO if fmt == "msgpack" else io.StringIO
    stream = stream_cls()
    serialize.dump(ODICT, file=stream, fmt=fmt)
    stream.seek(0)
    dumped = serialize.load(file=stream, fmt=fmt)
    _assert_clean(dumped)
    assert dumped == ODICT_EXPORT
    # dumps/loads
    # FIXME: I've spent enough time fucking with mypy - the overload for dumps needs
    # fixing
    dump = serialize.dumps(ODICT, fmt=fmt)  # type: ignore[call-overload]
    dumped = serialize.loads(dump, fmt=fmt)
    assert dumped == ODICT_EXPORT
    # box dumps/loads
    check = Dic(a=1)
    dump = serialize.dumps(check, fmt=fmt)  # type: ignore[call-overload]
    dumped = serialize.loads(dump, fmt=fmt)
    assert dumped == check


def test_dump_struct() -> None:
    obj = Impl()
    dump = serialize.dumps(obj)
    assert dump == "mstr: a\nmint: 0\n_mbool: false"
