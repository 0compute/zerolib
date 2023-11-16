from __future__ import annotations

from zerolib.base import Struct


class Impl(Struct):
    name: str
    two: None = None

    def __str__(self) -> str:
        return self.name


class FailImpl(Struct):
    def __str__(self) -> str:
        raise Exception


def test_hash() -> None:
    obj = Impl("xxx")
    assert hash(obj) == hash("Implxxx")


def test_eq() -> None:
    obj = Impl("xxx")
    assert obj == Impl("xxx")
    assert obj != Impl("yyy")


def test_repr() -> None:
    obj = Impl("xxx")
    assert repr(obj) == "<Impl xxx>"
    obj = FailImpl()
    assert repr(obj) == "<unprintable FailImpl>"


def test_asdict() -> None:
    obj = Impl("xxx")
    assert obj.asdict() == dict(name="xxx", two=None)


def test_replace() -> None:
    assert Impl("xxx").replace(name="yyy") == Impl("yyy")
