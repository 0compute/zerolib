from __future__ import annotations

import contextlib
import functools
import io
import sys
from typing import TYPE_CHECKING, Literal, Union, overload

import anyio
import msgspec
from packaging.version import Version

from . import util
from .dic import Dic

if TYPE_CHECKING:
    from collections.abc import Callable
    from typing import IO, Any

    from .type import Struct

# https://jcristharif.com/msgspec/extending.html#defining-a-custom-extension-messagepack-only
EXT_CODES = {
    anyio.Path: 1,
    Version: 2,
}

EXT_CODES_TYPE = {v: k for k, v in EXT_CODES.items()}

ENCODERS = {}

DECODERS = {}


class MsgSpecSerde(Dic):
    """Wrap msgspec encoder and decoder"""

    # fallback for unsupported on msgpack encode
    @staticmethod
    def _msgpack_encode(obj: Any) -> Any:
        cls = type(obj)
        ext_code = EXT_CODES.get(cls)
        if ext_code is None:
            raise NotImplementedError(f"enc_hook: EXT code undefined for {cls!r}")
        encoder = ENCODERS.get(cls, lambda obj: str(obj).encode())
        return msgspec.msgpack.Ext(ext_code, encoder(obj))

    ENCODERS = Dic(
        msgpack=msgspec.msgpack.Encoder(enc_hook=_msgpack_encode),
        json=msgspec.json.Encoder(enc_hook=str),
        yaml=Dic(encode=functools.partial(msgspec.yaml.encode, enc_hook=str)),
    )

    def encode(
        self, obj: Struct, encoder: Literal[*ENCODERS.keys()] = "msgpack"
    ) -> bytes:
        return self.ENCODERS[encoder].encode(obj)

    def decode(self, encoded: bytes) -> Struct:
        return self._decoder.decode(encoded)

    @util.cached_property
    def _decoder(self) -> msgspec.msgpack.Decoder:
        # UNION_TYPES is not complete (also circular) at import time hence this lazy load
        from .type import UNION_TYPES

        return msgspec.msgpack.Decoder(
            Union[*UNION_TYPES],
            dec_hook=self._decode,
            ext_hook=self._ext,
        )

    # decode callback
    @staticmethod
    def _decode(cls: type, obj: Any) -> Any:
        cls = getattr(cls, "__origin__", cls)
        if cls in EXT_CODES:
            return obj
        if cls is set:
            return set(*obj)
        if issubclass(cls, dict):
            return Dic(obj) if issubclass(cls, Dic) else cls(obj)
        raise NotImplementedError(f"dec_hook: {cls!r}")

    # extension decode hook
    @staticmethod
    def _ext(code: int, data: memoryview) -> Any:
        cls = EXT_CODES_TYPE.get(code)
        if cls is None:
            raise NotImplementedError(f"ext_hook: type undefined for EXT code {code}")
        return DECODERS.get(cls, lambda data: cls(data.decode()))(data.tobytes())


# define serializers in order fast to slow
SERIALIZE = Dic()


with contextlib.suppress(ImportError):
    import msgpack

    SERIALIZE.msgpack = dict(
        dump=dict(
            file=msgpack.pack,
            str=msgpack.packb,
        ),
        load=dict(
            file=msgpack.unpack,
            str=msgpack.unpackb,
        ),
    )


try:
    import orjson as json
except ImportError:
    import json

_JSON_DEFAULTS = dict(default=str, indent=2)

SERIALIZE.json = dict(
    dump=dict(
        file=functools.partial(json.dump, **_JSON_DEFAULTS),
        str=functools.partial(json.dumps, **_JSON_DEFAULTS),
    ),
    load=dict(
        file=json.load,
        str=json.loads,
    ),
)


with contextlib.suppress(ImportError):
    import yaml

    _yaml_dump = functools.partial(
        yaml.dump, Dumper=yaml.CDumper, default_flow_style=False, sort_keys=False
    )

    def _yaml_dumps(obj: Any, *args: Any, **kwargs: Any) -> str:
        stream = io.StringIO()
        _yaml_dump(obj, *args, stream=stream, **kwargs)
        return stream.getvalue()

    SERIALIZE.yaml = dict(
        dump=dict(
            file=_yaml_dump,
            str=_yaml_dumps,
        ),
        load=dict(
            file=functools.partial(yaml.load, Loader=yaml.CLoader),
        ),
    )
    SERIALIZE.yaml.load.str = SERIALIZE.yaml.load.file


SERIALIZERS = list(SERIALIZE.keys())

# default serializer is the last defined
DEFAULT_SERIALIZER = SERIALIZERS[-1]


def dump(
    obj: Any, file: IO = sys.stdout, fmt: str = DEFAULT_SERIALIZER, **kwargs: Any
) -> None:
    if fmt == "msgpack" and hasattr(file, "buffer"):
        # msgpack writes bytes so needs a buffer
        file = file.buffer  # type: ignore[attr-defined]
    _dump(obj, SERIALIZE[fmt].dump.file, file, **kwargs)


@overload
def dumps(obj: Any) -> str:
    ...


@overload
def dumps(obj: Any, fmt: Literal["json", "yaml"]) -> str:
    ...


@overload
def dumps(obj: Any, fmt: Literal["msgpack"]) -> bytes:
    ...


def dumps(obj: Any, fmt: str = DEFAULT_SERIALIZER, **kwargs: Any) -> bytes | str:
    return _dump(obj, SERIALIZE[fmt].dump.str, **kwargs).strip()


def _dump(
    obj: Any,
    dumper: Callable,
    *args: Any,
    stringify: bool = True,
    **kwargs: Any,
) -> bytes | str:
    if (asdict := getattr(obj, "asdict", None)) is not None:
        obj = asdict()
    if isinstance(obj, Dic):  # pragma: no branch
        obj = obj.export(stringify=stringify)
    return dumper(obj, *args, **kwargs)


def load(file: IO = sys.stdin, fmt: str = DEFAULT_SERIALIZER, **kwargs: Any) -> Any:
    return _load(SERIALIZE[fmt].load.file(file, **kwargs))


def loads(value: bytes | str, fmt: str = DEFAULT_SERIALIZER, **kwargs: Any) -> dict:
    return _load(SERIALIZE[fmt].load.str(value, **kwargs))


def _load(obj: Any) -> Any:
    return Dic(obj) if isinstance(obj, dict) else obj
