from __future__ import annotations

import functools
import io
import json
import sys
from collections.abc import Callable
from typing import IO, Any, Literal, cast, overload

import msgpack
import yaml

from .dic import Dic

IOType = IO[Any] | io.BytesIO | io.StringIO

_JSON_DEFAULTS = dict(default=str, indent=2)

_yaml_dump = functools.partial(
    yaml.dump, Dumper=yaml.CDumper, default_flow_style=False, sort_keys=False
)


def _yaml_dumps(obj: Any, *args: Any, **kwargs: Any) -> str:
    stream = io.StringIO()
    _yaml_dump(obj, *args, stream=stream, **kwargs)
    return stream.getvalue()


# define serializers in order fast to slow
SERIALIZE = Dic(
    msgpack=Dic(
        dump=dict(
            file=msgpack.pack,
            str=msgpack.packb,
        ),
        load=dict(
            file=msgpack.unpack,
            str=msgpack.unpackb,
        ),
    ),
    json=Dic(
        dump=dict(
            file=functools.partial(json.dump, **_JSON_DEFAULTS),  # type: ignore[arg-type]
            str=functools.partial(json.dumps, **_JSON_DEFAULTS),  # type: ignore[arg-type]
        ),
        load=dict(
            file=json.load,
            str=json.loads,
        ),
    ),
    yaml=Dic(
        dump=dict(
            file=_yaml_dump,
            str=_yaml_dumps,
        ),
        load=dict(
            file=functools.partial(yaml.load, Loader=yaml.CLoader),
        ),
    ),
)

SERIALIZE.yaml.load.str = SERIALIZE.yaml.load.file

SERIALIZERS = tuple(SERIALIZE.keys())

FAST_SERIALIZER = SERIALIZERS[0]

DEFAULT_SERIALIZER = SERIALIZERS[-1]

FormatType = Literal[*SERIALIZERS]  # type: ignore[valid-type]


def dump(
    obj: Any,
    file: IOType = sys.stdout,
    fmt: FormatType = DEFAULT_SERIALIZER,
    **kwargs: Any,
) -> None:
    if fmt == "msgpack" and hasattr(file, "buffer"):
        # msgpack writes bytes so needs a buffer
        file = file.buffer
    _dump(obj, SERIALIZE[fmt].dump.file, file, **kwargs)


@overload
def dumps(obj: Any) -> str: ...


@overload
def dumps(obj: Any, fmt: Literal["json", "yaml"]) -> str: ...


@overload
def dumps(obj: Any, fmt: Literal["msgpack"]) -> bytes: ...


def dumps(obj: Any, fmt: FormatType = DEFAULT_SERIALIZER, **kwargs: Any) -> bytes | str:
    return cast(bytes | str, _dump(obj, SERIALIZE[fmt].dump.str, **kwargs)).strip()


def _dump(
    obj: Any,
    dumper: Callable[..., bytes | str | None],
    *args: Any,
    stringify: bool = True,
    **kwargs: Any,
) -> bytes | str | None:
    if (asdict := getattr(obj, "asdict", None)) is not None:
        obj = asdict()
    #  XXX: coverage broken - not Dic in
    #  ../../tests/unit/test_serialize.py::test_dump_load
    if isinstance(obj, Dic):  # pragma: no branch
        obj = obj.export(stringify=stringify)
    return dumper(obj, *args, **kwargs)


def load(
    file: IOType = sys.stdin, fmt: FormatType = DEFAULT_SERIALIZER, **kwargs: Any
) -> Any:
    return _load(SERIALIZE[fmt].load.file(file, **kwargs))


def loads(
    value: bytes | str, fmt: FormatType = DEFAULT_SERIALIZER, **kwargs: Any
) -> Any:
    return _load(SERIALIZE[fmt].load.str(value, **kwargs))


def _load(obj: Any) -> Any:
    return Dic(obj) if isinstance(obj, dict) else obj
