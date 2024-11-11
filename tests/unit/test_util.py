from __future__ import annotations

import pytest
from zerolib import Dic, util


def test_irepr() -> None:
    assert util.irepr({"a", "B"}) == "'B', 'a'"


def test_trepr_default() -> None:
    assert util.trepr("xxxx", max_length=None) == "'xxxx'"
    assert util.trepr("xxxx", max_length=4) == "'xxxx'"


def test_trepr_trunc1() -> None:
    assert util.trepr("xxxx", max_length=2) == "'x…'"


def test_trepr_trunc2() -> None:
    assert util.trepr("xxxxx", max_length=4) == "'xxx…'"


def test_trepr_trunc_nl() -> None:
    assert util.trepr("xxx\ny", max_length=4) == "'xxx…'"


def test_trepr_trunc_seq() -> None:
    assert util.trepr([1, 2, 3], max_length=4) == "[1, …]"
    assert util.trepr((1, 2, 3), max_length=4) == "(1, …)"
    assert util.trepr({1, 2, 3}, max_length=4) == "{1, …}"


def test_trepr_trunc_obj() -> None:
    assert util.trepr(object(), max_length=4) == "<obj…>"


def test_trepr_trunc_dict() -> None:
    assert util.trepr(dict(a=2, b=3, c=3), max_length=4) == "{'a'…}"


async def test_trace(caplog: pytest.LogCaptureFixture) -> None:
    @util.trace()
    async def func() -> None: ...

    await func()
    record = caplog.records[0]
    assert "function test_trace.<locals>.func" in record.message
    assert record.levelname == "DEBUG"


async def test_tmpdir() -> None:
    async with util.tmpdir() as tmpdir:
        assert util.is_tmpdir(tmpdir)


def test_patch() -> None:
    obj = Dic()
    obj.a = 1
    with util.patch(obj, "a", 2):
        assert obj.a == 2
    assert obj.a == 1


class Impl:
    @util.cached_property
    def aproperty(self) -> int:
        return 1


def test_cached_property() -> None:
    memoized = Impl.aproperty.fget.memoize
    instance = Impl()
    instance_key = memoized.get_key(memoized.keygen(instance))
    instance2 = Impl()
    assert not memoized.memos
    assert instance.aproperty == 1
    assert instance_key in memoized.memos
    assert instance.aproperty == 1
    assert instance2.aproperty == 1
    assert len(memoized.memos) == 2
    del instance.aproperty
    with pytest.raises(AttributeError):
        del instance.aproperty
    assert instance_key not in memoized.memos
    assert len(memoized.memos) == 1
    assert "Impl.aproperty" in repr(Impl.aproperty)
