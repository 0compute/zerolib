from __future__ import annotations

import pytest
from zerolib import util


def test_irepr() -> None:
    assert util.irepr({"a", "B"}) == "'B', 'a'"


def test_trepr() -> None:
    assert util.trepr("xxxx", max_length=4) == "'xxxx'"
    assert util.trepr("xxxxx", max_length=4) == "'xxx…'"
    assert util.trepr([1, 2, 3], max_length=4) == "[1, …]"
    assert util.trepr((1, 2, 3), max_length=4) == "(1, …)"
    assert util.trepr({1, 2, 3}, max_length=4) == "{1, …}"
    assert util.trepr(object(), max_length=4) == "<obj…>"
    assert util.trepr(dict(a=2, b=3, c=3), max_length=4) == "{'a'…}"


async def test_tmpdir() -> None:
    async with util.tmpdir() as tmpdir:
        assert util.is_tmpdir(tmpdir)


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
    assert repr(instance.aproperty) == repr(1)
