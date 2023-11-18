from __future__ import annotations

import contextlib
import functools
import io
import sys
from typing import TYPE_CHECKING, Literal, overload

from .dic import Dic

if TYPE_CHECKING:
    from collections.abc import Callable
    from typing import IO, Any

    IOType = IO | io.BytesIO | io.StringIO

# define serializers in order fast to slow
SERIALIZE = Dic()


with contextlib.suppress(ImportError):
    import msgpack

    SERIALIZE.msgpack = Dic(
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
    import orjson
except ImportError:
    import json

    _JSON_DEFAULTS = dict(default=str, indent=2)

    SERIALIZE.json = Dic(
        dump=dict(
            file=functools.partial(json.dump, **_JSON_DEFAULTS),
            str=functools.partial(json.dumps, **_JSON_DEFAULTS),
        ),
        load=dict(
            file=json.load,
            str=json.loads,
        ),
    )
else:  # pragma: no cover
    # WIP: orjson impl
    SERIALIZE.json = Dic(
        dump=dict(
            file=lambda obj, file, *args, **kwargs: file.write(
                orjson.dumps(obj, *args, **kwargs).decode()
            ),
            str=orjson.dumps,
        ),
        load=dict(
            file=lambda file, *args, **kwargs: json.loads(file.read(), *args, **kwargs),
            str=orjson.loads,
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

    SERIALIZE.yaml = Dic(
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

# fast serializer is the first defined
FAST_SERIALIZER = SERIALIZERS[0]

# default serializer is the last defined
DEFAULT_SERIALIZER = SERIALIZERS[-1]


def dump(
    obj: Any, file: IOType = sys.stdout, fmt: str = DEFAULT_SERIALIZER, **kwargs: Any
) -> None:
    if fmt == "msgpack" and hasattr(file, "buffer"):
        # msgpack writes bytes so needs a buffer
        file = file.buffer
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
    dumper: Callable[[Any], bytes | str | None],
    *args: Any,
    stringify: bool = True,
    **kwargs: Any,
) -> bytes | str | None:
    if (asdict := getattr(obj, "asdict", None)) is not None:
        obj = asdict()
    if isinstance(obj, Dic):
        obj = obj.export(stringify=stringify)
    return dumper(obj, *args, **kwargs)


def load(file: IOType = sys.stdin, fmt: str = DEFAULT_SERIALIZER, **kwargs: Any) -> Any:
    return _load(SERIALIZE[fmt].load.file(file, **kwargs))


def loads(value: bytes | str, fmt: str = DEFAULT_SERIALIZER, **kwargs: Any) -> dict:
    return _load(SERIALIZE[fmt].load.str(value, **kwargs))


def _load(obj: Any) -> Any:
    return Dic(obj) if isinstance(obj, dict) else obj
