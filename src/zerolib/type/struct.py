from __future__ import annotations

import functools
from typing import TYPE_CHECKING, Any, ClassVar, Self, Union, cast

import anyio

try:
    import msgpack
except ImportError:
    msgpack = None
import msgspec

try:
    import yaml
except ImportError:
    yaml = None
from loguru import logger as log

# export msgspec field for import convenience
from msgspec import field  # noqa: F401

from .. import serialize, util
from ..context import Context
from ..dic import Dic

if TYPE_CHECKING:
    from collections.abc import Callable
    from typing import Literal

    from loguru._logger import Logger

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

    if msgpack is not None:  # pragma: no branch

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

    if yaml is not None:  # pragma: no branch

        @util.cached_property
        def yaml(self) -> EncoderType:
            return functools.partial(msgspec.yaml.encode, enc_hook=str)  # type: ignore[attr-defined]


class Decoder:
    @util.cached_property
    def json(self) -> DecoderType:
        return msgspec.json.Decoder(
            type=self._typed_union,
            dec_hook=self._decode,
        ).decode

    if msgpack is not None:  # pragma: no branch

        @util.cached_property
        def msgpack(self) -> DecoderType:
            return msgspec.msgpack.Decoder(
                type=self._typed_union,
                dec_hook=self._decode,
                ext_hook=self._ext,
            ).decode

        def _ext(self, code: int, data: memoryview) -> Any:
            """Extension decode hook"""
            cls = self._ext_types.get(code)
            if cls is None:
                raise NotImplementedError(
                    f"ext_hook: type undefined for EXT code {code}"
                )
            return DECODERS.get(cls, lambda data: cls(data.decode()))(data.tobytes())

        @util.cached_property
        def _ext_types(self) -> dict:
            return {v: k for k, v in EXT_TYPES.items()}

    if yaml is not None:  # pragma: no branch

        @util.cached_property
        def yaml(self) -> DecoderType:
            return functools.partial(
                msgspec.yaml.decode,  # type: ignore[attr-defined]
                type=self._typed_union,
                dec_hook=self._decode,
            )

    @util.cached_property
    def _typed_union(self) -> Union | Any:
        return Union[*UNION_TYPES] if UNION_TYPES else Any

    # decode callback
    @staticmethod
    def _decode(cls: type, obj: Any) -> Any:
        cls = getattr(cls, "__origin__", cls)
        if cls in EXT_TYPES:
            return obj
        if cls is set:
            return set(*obj)
        if issubclass(cls, dict):
            return Dic(obj) if issubclass(cls, Dic) else cls(obj)
        raise NotImplementedError(f"dec_hook: {cls!r}")


class Struct(
    msgspec.Struct,
    order=True,
    omit_defaults=True,
    forbid_unknown_fields=True,
    tag=True,
    array_like=True,
    dict=True,
):
    ctx: ClassVar[Context] = Context()

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
        except Exception:  # pragma] no ftest ptest cover
            return f"<unprintable {name}>"

    async def __setstate__(self) -> None:
        """Set runtime state after msgspec decoding"""
        ...

    @classmethod
    def factory(cls, *args: Any, **kwargs: Any) -> Self:
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
        for key, value in kwargs.items():
            setattr(self, f"_{key}", value)
        return self

    @classmethod
    async def get(
        cls,
        key: str | None = None,
        default: Any = None,
        *,
        path: anyio.Path | None = None,
    ) -> Self | None:
        if cls.ctx.cache:
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
                    await self.__setstate__()
                    return self
        return default

    async def put(self, path: anyio.Path | None = None) -> None:
        if self.ctx.cache:
            if path is None:
                path = self._key_path(self)
            # TODO: lock
            await path.parent.mkdir(parents=True, exist_ok=True)
            await path.write_bytes(self.encode())
            self.log.debug(f"wrote to {path}")

    async def delete(self, path: anyio.Path | None = None) -> None:
        if path is None:
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
