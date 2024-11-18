from __future__ import annotations

import contextlib
import pathlib
from collections.abc import Generator

import anyio
import pytest

from zerolib import Context, Dic, FrozenStruct, Struct, field, serialize, union


@union
class Impl(Struct):
    mstr: str = "a"
    mdict: Dic = Dic()
    mset: set[int] = set()  # noqa: RUF012
    mint: int = 0
    _mbool: bool = False

    def __str__(self) -> str:
        return self.mstr

    async def _set_runtime_state(self) -> None:
        self._runtime = True


@pytest.fixture(autouse=True)
def _reset_ext_types() -> None:
    for key in ("_msgpack_ext_types", "json", "msgpack", "yaml"):
        with contextlib.suppress(AttributeError):
            delattr(Struct._decoder, key)


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

    class FailImpl(Struct):
        def __str__(self) -> str:
            raise Exception  # noqa: TRY002

    obj2 = FailImpl.factory()
    assert repr(obj2) == "<unprintable FailImpl>"


def test_factory() -> None:
    obj = Impl.factory()
    assert obj.mstr == "a"
    assert not obj._mbool
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
    assert obj.asdict() == dict(mstr="a", mdict=Dic(), mset=set(), mint=0, _mbool=False)


def test_replace() -> None:
    assert Impl.factory().replace(mstr="b") == Impl("b")


@union
class Impl2(Impl):
    path: anyio.Path | None = None


@pytest.mark.parametrize("fmt", serialize.SERIALIZE)
def test_serde(fmt: str) -> None:
    # use Impl2 with anyio.Path field for msgpack to exercise EXT types
    cls: type[Impl] = Impl2 if fmt == "msgpack" else Impl
    obj = cls.factory(
        mdict=Dic(a=1),
        mset={1},
        mint=1,
        mbool=True,
        path=anyio.Path("."),
    )
    assert cls.decode(obj.encode(fmt), fmt) == obj


class Obj: ...


@union
class Impl3(Impl):
    obj: Obj = field(default_factory=Obj)


def test_serde_msgpack_ext_encode_notimplemented() -> None:
    fmt = "msgpack"
    obj = Impl3.factory()
    with pytest.raises(NotImplementedError):
        obj.encode(fmt)


def test_serde_msgpack_ext_decode_notimplemented(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    fmt = "msgpack"
    obj = Impl2.factory(path=anyio.Path("."))
    encoded = obj.encode(fmt)
    monkeypatch.setattr("zerolib.type.struct.EXT_TYPES", {})
    # del Struct._decoder._msgpack_ext_types
    with pytest.raises(NotImplementedError):
        Impl2.decode(encoded, fmt)


def test_serde_json_dec_hook_notimplemented() -> None:
    fmt = "json"
    obj = Impl3.factory()
    encoded = obj.encode(fmt)
    with pytest.raises(NotImplementedError):
        Impl.decode(encoded, fmt)


@pytest.fixture
def ctx(ctx: Context, tmp_path: pathlib.Path) -> Generator[Context, None, None]:
    with ctx(cachedir=anyio.Path(tmp_path)):
        yield ctx


async def test_store_key(ctx: Context, tmp_path: pathlib.Path) -> None:
    with ctx(cachedir=anyio.Path(tmp_path)):
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
    assert await Impl.get(path) == obj
    await obj.delete()
    assert not await path.exists()
    assert await Impl.get(path) is None


async def test_store_path_nocache(ctx: Context) -> None:
    with ctx(cache=False):
        obj = Impl.factory()
        path = ctx.cachedir / "x"
        await obj.put(path)
        assert not await path.exists()
        assert await Impl.get(path) is None


async def test_get_exc(
    ctx: Context, monkeypatch: pytest.MonkeyPatch, caplog: pytest.LogCaptureFixture
) -> None:
    obj = Impl.factory()
    path = ctx.cachedir / "x"
    await obj.put(path)
    assert await path.exists()

    class CustomError(Exception): ...

    def _raiser(_encoded: bytes) -> None:
        raise CustomError

    monkeypatch.setattr(Impl, "decode", _raiser)
    assert await Impl.get(path) is None
    assert not await path.exists()
    record = caplog.records[-1]
    assert record.levelname == "ERROR"
    assert record.message.startswith("get: decode fail")
    assert "CustomError" in record.message


def test_frozen() -> None:
    @union
    class FrozenImpl(FrozenStruct):  # type: ignore[misc]
        a: str = "1"

    obj = FrozenImpl()
    assert obj.a == "1"
    with pytest.raises(AttributeError):
        obj.a = "x"
