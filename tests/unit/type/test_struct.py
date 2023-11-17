from __future__ import annotations

from typing import TYPE_CHECKING

import anyio
import pytest
from zerolib import Context, Dic, FrozenStruct, Struct, serialize, union

if TYPE_CHECKING:
    import pathlib
    from collections.abs import Generator


@union
class Impl(Struct):
    mstr: str = "a"
    mdic: Dic = Dic()
    mset: set = set()  # noqa: RUF012 - not mutable, msgspec magic
    mint: int = 0
    _mbool: bool = False

    def __str__(self) -> str:
        return self.mstr


@union
class Impl2(Impl):
    path: anyio.Path | None = None


class FailImpl(Struct):
    def __str__(self) -> str:
        raise Exception


@union
class FrozenImpl(FrozenStruct):  # type: ignore[misc]
    a: str = "1"


def test_log(caplog: pytest.LogCaptureFixture) -> None:
    obj = Impl.factory()
    obj.log.info("test")
    pytest.skip("todo")
    assert "test" in caplog.textlog.text


def test_hash() -> None:
    obj = Impl.factory()
    assert hash(obj) == hash("Impla")


def test_eq() -> None:
    obj = Impl.factory()
    assert obj == Impl.factory()
    assert obj != Impl.factory("b")


def test_repr() -> None:
    obj = Impl.factory()
    assert repr(obj) == "<Impl a>"
    obj2 = FailImpl.factory()
    assert repr(obj2) == "<unprintable FailImpl>"


def test_factory() -> None:
    obj = Impl.factory(mbool=True, x=2)
    assert obj._mbool
    # runtime member
    assert obj._x == 2  # type: ignore[attr-defined]


def test_asdict() -> None:
    obj = Impl.factory()
    assert obj.asdict() == dict(mstr="a", mdic=Dic(), mset=set(), mint=0, _mbool=False)


def test_replace() -> None:
    assert Impl.factory().replace(mstr="b") == Impl("b")


@pytest.mark.parametrize("fmt", serialize.SERIALIZE)
def test_serde(fmt: str) -> None:
    # use Impl2 with anyio.Path field for msgpack to exercise EXT types
    cls: type[Impl] = Impl2 if fmt == "msgpack" else Impl
    obj = cls.factory(path=anyio.Path("."))
    assert cls.decode(obj.encode(fmt), fmt) == obj


@pytest.fixture
def ctx(ctx: Context, tmp_path: pathlib.Path) -> Generator[Context, None, None]:
    with ctx(cachedir=anyio.Path(tmp_path)):
        yield ctx


async def test_store_key(ctx: Context) -> None:
    obj = Impl.factory()
    await obj.put()
    assert await Impl.get(str(obj)) == obj
    await obj.delete()
    assert await Impl.get(str(obj)) is None
    ctx.cache = False
    obj = Impl.factory()
    await obj.put()
    assert await Impl.get(str(obj)) is None
    # second delete to exercise error branch
    await obj.delete()


async def test_store_path(ctx: Context) -> None:
    obj = Impl.factory()
    path = ctx.cachedir / "x"
    await obj.put(path)
    assert await path.exists()
    assert await Impl.get(path=path) == obj
    ctx.cache = False
    assert await Impl.get(path=path) is None


async def test_get_exc(ctx: Context, monkeypatch: pytest.MonkeyPatch) -> None:
    obj = Impl.factory()
    path = ctx.cachedir / "x"
    await obj.put(path)
    assert await path.exists()

    def _raiser(_encoded: bytes) -> None:
        raise TypeError

    monkeypatch.setattr(Impl, "decode", _raiser)
    assert await Impl.get(path=path) is None
    assert not await path.exists()


def test_frozen() -> None:
    obj = FrozenImpl()
    with pytest.raises(AttributeError):
        obj.a = "x"
