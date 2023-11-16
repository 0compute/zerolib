from __future__ import annotations

from typing import TYPE_CHECKING, ClassVar

import msgspec
from loguru import logger

from . import util
from .context import Context
from .dic import Dic

if TYPE_CHECKING:
    from typing import Any, Self

    import anyio
    from loguru import Logger

# export msgspec field for import convenience
field = msgspec.field

UNION_TYPES: set[type[Struct]] = set()


def union(cls: type[Struct]) -> type[Struct]:
    """Join class to the tagged union used by msgspec decoder"""
    UNION_TYPES.add(cls)
    return cls


class Struct(  # type: ignore[call-arg]
    msgspec.Struct,
    order=True,
    omit_defaults=True,
    forbid_unknown_fields=True,
    tag=True,
    # TOGO: once this is all stable - makes debugging harder
    # array_like=True,
    dict=True,
):
    ctx: ClassVar[Context] = Context()

    @util.cached_property
    def log(self) -> Logger:
        return logger.bind(self=self)

    def __hash__(self) -> int:
        return hash(self.__class__.__name__ + str(self))

    # def __eq__(self, other: object) -> bool:
    #     if not isinstance(other, str):
    #         other = str(other)
    #     return str(self) == other

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
    def frommsgpack(cls, encoded: bytes) -> Self:
        return cls.ctx.serde.decode(encoded)

    @classmethod
    async def get(
        cls,
        key: str | None = None,
        default: Any = None,
        *,
        path: anyio.Path | None = None,
    ) -> Self | None:
        if cls.ctx.cfg.cache:
            if path is None:
                if key is None:
                    raise TypeError("either key or path must be provided")
                path = await cls._key_path(key)
            try:
                encoded = await path.read_bytes()
            except FileNotFoundError:
                ...
            else:
                try:
                    instance = cls.frommsgpack(encoded)
                except (
                    msgspec.DecodeError,
                    msgspec.ValidationError,
                    NotImplementedError,
                    TypeError,
                ):
                    await path.unlink()
                    logger.exception(f"get: decode fail - unlinked {path}")
                else:
                    instance.log.debug(f"cached: {path}")
                    await instance.__setstate__()
                    return instance
        return default

    async def put(self, path: anyio.Path | None = None) -> None:
        if self.ctx.cfg.cache:
            if path is None:
                path = await self._key_path(self)
            # TODO: lock
            await path.parent.mkdir(parents=True, exist_ok=True)
            await path.write_bytes(self.asmsgpack())
            self.log.debug(f"wrote to {path}")

    async def delete(self) -> None:
        path = await self._key_path(self)
        try:
            await path.unlink()
        except FileNotFoundError:
            self.warning(f"not found on delete: {path}")
        else:
            self.log.debug(f"deleted {path}")

    @classmethod
    async def _key_path(cls, key: str | Self) -> anyio.Path:
        # key with ctx hash so configs are isolated
        key = f"{key}-{cls.ctx.cfg.sha256_hex()}"
        return (await cls.ctx.cachedir) / "db" / cls.__name__.lower() / f"{key}.msgpack"

    def _key(self) -> str:
        return str(self)

    def replace(self, **changes: Any) -> Self:
        return msgspec.structs.replace(self, **changes)

    def asdict(self) -> Dic:
        return Dic(msgspec.structs.asdict(self))

    def asmsgpack(self) -> str:
        return self.ctx.serde.encode(self)

    def asjson(self) -> str:
        return self.ctx.serde.encode(self, "json")

    def asyaml(self) -> str:
        return self.ctx.serde.encode(self, "yaml")


class FrozenStruct(Struct, frozen=True):
    ...
