from __future__ import annotations

from zerolib.type import Struct


class Impl(Struct):
    name: str
    two: None = None

    def __str__(self) -> str:
        return self.name


class FailImpl(Struct):
    def __str__(self) -> str:
        raise Exception


def test_hash() -> None:
    obj = Impl.factory("xxx")
    assert hash(obj) == hash("Implxxx")


def test_eq() -> None:
    obj = Impl.factory("xxx")
    assert obj == Impl.factory("xxx")
    assert obj != Impl.factory("yyy")


def test_repr() -> None:
    obj = Impl.factory("xxx")
    assert repr(obj) == "<Impl xxx>"
    obj = FailImpl.factory()
    assert repr(obj) == "<unprintable FailImpl>"


def test_asdict() -> None:
    obj = Impl.factory("xxx")
    assert obj.asdict() == dict(name="xxx", two=None)


def test_replace() -> None:
    assert Impl.factory("xxx").replace(name="yyy") == Impl("yyy")
