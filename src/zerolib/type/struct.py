from __future__ import annotations

import functools
from typing import (
    TYPE_CHECKING,
    Any,
    ClassVar,
    Self,
    Union,
    cast,
    dataclass_transform,
    get_origin,
)

import anyio
import msgspec
from loguru import logger as log

# export msgspec field for import convenience
from msgspec import field  # noqa: F401

from .. import serialize, util
from ..context import Context
from ..dic import Dic

if TYPE_CHECKING:
    from collections.abc import Callable
    from typing import Literal

    from loguru import Logger

    EncoderType = Callable[["Struct"], bytes]

    DecoderType = Callable[[bytes], "Struct"]

    CodeType = Literal[*serialize.SERIALIZE]  # type: ignore[valid-type]


# msgpack ext types
# https://jcristharif.com/msgspec/extending.html#defining-a-custom-extension-messagepack-only
EXT_TYPES: dict[type, int] = {}


def register_ext_type(cls: type) -> int:
    index = len(EXT_TYPES) + 1
    EXT_TYPES[cls] = index
    return index


# only anyio.Path here - consumers add more as required
register_ext_type(anyio.Path)

# TOGO: maybe, leaving for a while in case not
# hooks for custom encoders and decoders
ENCODERS: dict[type, EncoderType] = {}
DECODERS: dict[type, DecoderType] = {}


class Encoder:
    @util.cached_property
    def json(self) -> EncoderType:
        return msgspec.json.Encoder(enc_hook=str).encode

    @util.cached_property
    def msgpack(self) -> EncoderType:
        return msgspec.msgpack.Encoder(enc_hook=self._msgpack_encode).encode

    # fallback for unsupported on msgpack encode
    @staticmethod
    def _msgpack_encode(obj: Any) -> Any:
        cls = type(obj)
        ext_code = EXT_TYPES.get(cls)
        if ext_code is None:
            raise NotImplementedError(f"enc_hook: EXT code undefined for {cls!r}")
        encoder = ENCODERS.get(cls, lambda obj: str(obj).encode())
        return msgspec.msgpack.Ext(ext_code, encoder(obj))

    @util.cached_property
    def yaml(self) -> EncoderType:
        return functools.partial(msgspec.yaml.encode, enc_hook=str)


class Decoder:
    @util.cached_property
    def json(self) -> DecoderType:
        return msgspec.json.Decoder(
            type=self._typed_union,
            dec_hook=self._dec_hook,
        ).decode

    @util.cached_property
    def msgpack(self) -> DecoderType:
        return msgspec.msgpack.Decoder(
            type=self._typed_union,
            dec_hook=self._dec_hook,
            ext_hook=self._msgpack_ext_hook,
        ).decode

    def _msgpack_ext_hook(self, code: int, data: memoryview) -> Any:
        cls = self._msgpack_ext_types.get(code)
        if cls is None:
            raise NotImplementedError(f"ext_hook: type undefined for EXT code {code}")
        return DECODERS.get(cls, lambda data: cls(data.decode()))(data.tobytes())

    @util.cached_property
    def _msgpack_ext_types(self) -> dict:
        return {v: k for k, v in EXT_TYPES.items()}

    @util.cached_property
    def yaml(self) -> DecoderType:
        return functools.partial(
            msgspec.yaml.decode,
            type=self._typed_union,
            dec_hook=self._dec_hook,
        )

    @util.cached_property
    def _typed_union(self) -> Union | Any:
        return Union[*UNION_TYPES] if UNION_TYPES else Any

    @staticmethod
    def _dec_hook(cls: type, obj: Any) -> Any:
        cls = get_origin(cls) or cls
        if cls in EXT_TYPES:
            return obj
        raise NotImplementedError(f"dec_hook: {cls!r}")


@dataclass_transform()
class Struct(
    msgspec.Struct,
    order=True,
    omit_defaults=True,
    forbid_unknown_fields=True,
    tag=True,
    # TODO: maybe faster, but less debugability: array_like=True,
    dict=True,
):
    ctx: ClassVar[Context] = Context.factory()

    _encoder: ClassVar[Encoder] = Encoder()
    _decoder: ClassVar[Decoder] = Decoder()

    @util.cached_property
    def log(self) -> Logger:
        return log.bind(self=self)

    # FIXME: not the right way to hash
    def __hash__(self) -> int:
        return hash(self.__class__.__name__ + str(self))

    def __repr__(self) -> str:
        name = type(self).__name__
        try:
            return f"<{name} {self}>"
        except Exception:
            return f"<unprintable {name}>"

    def __str__(self) -> str:
        raise NotImplementedError  # pragma: no cover

    async def _set_runtime_state(self) -> None:
        """Set runtime state after msgspec decoding"""

    @classmethod
    def factory(cls, *args: Any, **kwargs: Any) -> Self:
        """
        Create instance

        Does not set runtime state
        """
        attrs = {}
        # set struct members
        for key in cls.__struct_fields__:
            # rename private members
            if key.startswith("_") and (pkey := key[1:]) in kwargs:
                kwargs[key] = kwargs.pop(pkey)
            if key in kwargs:
                value = kwargs.pop(key)
                attrs[key] = value
        self = cls(*args, **attrs)
        # set runtime members
        # XXX: coverage branch broken
        for key, value in kwargs.items():  # pragma: no branch
            setattr(self, f"_{key}", value)
        return self

    @classmethod
    async def factory_async(cls, *args: Any, **kwargs: Any) -> Self:
        """Create instance and set runtime state"""
        self = cls.factory(*args, **kwargs)
        await self._set_runtime_state()
        return self

    @classmethod
    async def get(
        cls,
        key: str | None = None,
        default: Any = None,
        *,
        path: anyio.Path | None = None,
    ) -> Self | None:
        # XXX: coverage branch broken: cls.ctx.cache is False in
        # ../../tests/unit/type/test_struct.py::test_store_path_nocache
        if cls.ctx.cache:  # pragma: no branch
            if path is None:
                if key is None:
                    raise TypeError("either key or path must be provided")
                path = cls._key_path(key)
            try:
                encoded = await path.read_bytes()
            except FileNotFoundError:
                ...
            else:
                try:
                    self = cls.decode(encoded)
                except (
                    msgspec.DecodeError,
                    msgspec.ValidationError,
                    NotImplementedError,
                    TypeError,
                ):
                    await path.unlink()
                    log.exception(f"get: decode fail - unlinked {path}")
                else:
                    self.log.debug(f"cache hit: {path}")
                    await self._set_runtime_state()
                    return self
        return default

    async def put(self, path: anyio.Path | None = None) -> None:
        if self.ctx.cache:
            # XXX: coverage branch broken: path is not None in
            # ../../tests/unit/type/test_struct.py::test_store_path
            if path is None:  # pragma: no branch
                path = self._key_path(self)
            # TODO: lock
            await path.parent.mkdir(parents=True, exist_ok=True)
            await path.write_bytes(self.encode())
            self.log.debug(f"wrote to {path}")

    async def delete(self, path: anyio.Path | None = None) -> None:
        # XXX: coverage branch broken: path is not None in
        # ../../tests/unit/type/test_struct.py::test_store_path
        if path is None:  # pragma: no branch
            path = self._key_path(self)
        await path.unlink()
        self.log.debug(f"deleted {path}")

    @classmethod
    def _key_path(cls, key: str | Self) -> anyio.Path:
        return cls.ctx.cachedir / "db" / cls.__name__.lower() / f"{key}.msgpack"

    @classmethod
    def decode(cls, encoded: bytes, type: CodeType = serialize.FAST_SERIALIZER) -> Self:
        return cast(Self, getattr(cls._decoder, type)(encoded))

    def encode(self, type: CodeType = serialize.FAST_SERIALIZER) -> bytes:
        return getattr(self._encoder, type)(self)

    def replace(self, **changes: Any) -> Self:
        return msgspec.structs.replace(self, **changes)

    def asdict(self) -> Dic:
        return Dic(msgspec.structs.asdict(self))


class FrozenStruct(Struct, frozen=True):  # type: ignore[misc]
    ...


UNION_TYPES: set[type[Struct]] = set()


def union(cls: type[Struct]) -> type[Struct]:
    """Join class to the tagged union used by msgspec decoder"""
    UNION_TYPES.add(cls)
    return cls
