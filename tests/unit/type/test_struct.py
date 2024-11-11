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
    mset: set = set()
    mint: int = 0
    _mbool: bool = False

    def __str__(self) -> str:
        return self.mstr

    async def _set_runtime_state(self) -> None:
        self._runtime = True


class FailImpl(Struct):
    def __str__(self) -> str:
        raise Exception


@union
class FrozenImpl(FrozenStruct):  # type: ignore[misc]
    a: str = "1"


def test_log(caplog: pytest.LogCaptureFixture) -> None:
    obj = Impl.factory()
    obj.log.info("test")
    assert "test" in caplog.text


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


async def test_factory_async() -> None:
    obj = Impl.factory()
    assert not hasattr(obj, "_runtime")
    obj = await Impl.factory_async()
    assert obj._runtime


def test_asdict() -> None:
    obj = Impl.factory()
    assert obj.asdict() == dict(mstr="a", mdic=Dic(), mset=set(), mint=0, _mbool=False)


def test_replace() -> None:
    assert Impl.factory().replace(mstr="b") == Impl("b")


@pytest.mark.parametrize("fmt", serialize.SERIALIZE)
def test_serde(fmt: str) -> None:
    # use Impl2 with anyio.Path field for msgpack to exercise EXT types
    cls: type[Impl] = Impl2 if fmt == "msgpack" else Impl
    obj = cls.factory(
        mdict=Dic(a=1), mset={1}, mint=1, mbool=True, path=anyio.Path(".")
    )
    assert cls.decode(obj.encode(fmt), fmt) == obj


@pytest.fixture
def ctx(ctx: Context, tmp_path: pathlib.Path) -> Generator[Context, None, None]:
    with ctx(cachedir=anyio.Path(tmp_path)):
        yield ctx


async def test_store_key(ctx: Context) -> None:  # noqa: ARG001
    obj = Impl.factory()
    await obj.put()
    assert await Impl.get(str(obj)) == obj
    await obj.delete()
    assert await Impl.get(str(obj)) is None


async def test_store_key_nocache(ctx: Context) -> None:
    obj = Impl.factory()
    await obj.put()
    assert await Impl.get(str(obj)) == obj
    with ctx(cache=False):
        assert await Impl.get(str(obj)) is None


async def test_store_path(ctx: Context) -> None:
    obj = Impl.factory()
    path = ctx.cachedir / "x"
    await obj.put(path)
    assert await path.exists()
    assert await Impl.get(path=path) == obj
    await obj.delete(path)
    assert not await path.exists()
    assert await Impl.get(path=path) is None


async def test_store_path_nocache(ctx: Context) -> None:
    with ctx(cache=False):
        obj = Impl.factory()
        path = ctx.cachedir / "x"
        await obj.put(path)
        assert not await path.exists()
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
