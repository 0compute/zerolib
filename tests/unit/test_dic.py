from __future__ import annotations

import datetime

import pytest
from zerolib.dic import Dic


def test_setattr() -> None:
    d = Dic()
    d.a = 1
    assert d["a"] == 1
    d.b = dict(a=1)
    assert isinstance(d.b, Dic)


def test_getattr() -> None:
    d = Dic(a=1)
    assert d.a == 1
    with pytest.raises(AttributeError):
        d.b  # noqa: B018


def test_delattr() -> None:
    d = Dic(a=1)
    del d.a
    assert "a" not in d
    with pytest.raises(AttributeError):
        del d.a


def test_str() -> None:
    d = Dic(a=1)
    assert str(d) == "{'a': 1}"


def test_repr() -> None:
    d = Dic(a=1)
    assert repr(d) == "{'a': 1}"


def test_hash() -> None:
    d = Dic(a=1, b=[1], c={1}, d=(1,))
    assert isinstance(hash(d), int)


def test_order() -> None:
    d = Dic(a=1)
    d2 = Dic(a=2)
    assert sorted((d2, d)) == [d, d2]


def test_convert() -> None:
    d = Dic()
    assert d._convert(1) == 1
    assert d._convert(dict()) == d
    assert d._convert(list()) == list()
    assert d._convert(set()) == set()
    assert d._convert(tuple()) == tuple()


def test_setdefault() -> None:
    d = Dic()
    d.setdefault("a", dict(b=1))
    assert isinstance(d.a, Dic)


def test_update() -> None:
    d = Dic(a=1)
    d.update(a=2, b=dict(a=1), c=[dict(a=1)], d=(1,), e={1})
    assert d.a == 2
    assert isinstance(d.b, Dic)
    assert isinstance(d.c[0], Dic)


def test_merge() -> None:
    d = Dic(a=1, b=dict(c=1))
    d.merge(dict(b=dict(c=2)))
    assert isinstance(d.b, Dic)
    assert d.b.c == 2


def test_clean() -> None:
    d = Dic(
        a=1,
        b=dict(c=1),
        c=False,
        d=0,
        e=[],
        f=[None],
        g=(dict(a=""),),
        i=[dict(a=1)],
        j={1},
    )
    assert d.clean() == Dic(a=1, b=dict(c=1), c=False, d=0, i=[dict(a=1)], j={1})


@pytest.mark.skip()
def test_export() -> None:
    d = Dic(a=None)
    assert not d.export()
    now = datetime.datetime.now(datetime.timezone.utc)
    d = Dic(a=Dic(b=now), c={1, Dic(d=2)})
    assert d.export() == Dic(a=Dic(b=now), c=[1, dict(d=2)])
    assert d.export(stringify=True).a == Dic(b=str(now))
