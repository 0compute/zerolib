from __future__ import annotations

import hashlib
from typing import TYPE_CHECKING

import atools
import deepmerge
from loguru import logger as log

if TYPE_CHECKING:
    from collections.abc import Callable, Iterable, Mapping
    from typing import KT, VT, Any, Self  # type: ignore[attr-defined]

SeqType = list | set | tuple

PrimitiveType = float | int | str | tuple


class Dic(dict):
    """A hashable dictionary that supports key access as attribute."""

    def __init__(
        self,
        base: Mapping[KT, VT] | Iterable[tuple[KT, VT]] | None = None,
        /,
        **kwargs: VT,
    ):
        super().__init__(
            {
                key: self._convert(value)
                for key, value in self._merge_args(base, kwargs).items()
            }
        )

    def _convert(self, obj: Any) -> Any:
        match obj:
            case Dic():
                # noop: here so that dict() below doesn't recurse
                ...
            case dict():
                obj = type(self)(obj)
            case list() | set() | tuple():
                obj = type(obj)(map(self._convert, obj))
        return obj

    def _merge_args(
        self,
        base: Mapping[KT, VT] | Iterable[tuple[KT, VT]] | None,
        kwargs: VT,
    ) -> dict:
        return dict(base) if base is not None else {} | kwargs

    def __setattr__(self, key: KT, value: VT) -> Any:
        return self.__setitem__(key, self._convert(value))

    def __getattr__(self, key: KT) -> Any:
        try:
            return self.__getitem__(key)
        except KeyError as exc:
            raise AttributeError(str(exc)) from None

    def __delattr__(self, key: KT) -> Any:
        try:
            return self.__delitem__(key)
        except KeyError as exc:
            raise AttributeError(str(exc)) from None

    def __lt__(self, other: Any) -> bool:
        return self._to_tuple_str() < self._to_tuple_str(other)

    def __hash__(self) -> int:  # type: ignore[override]
        return hash(self._to_tuple())

    def sha256_hex(self) -> str:
        return self._sha256_hex(self._to_tuple_str())

    @staticmethod
    @atools.memoize
    def _sha256_hex(value: str) -> str:
        return hashlib.sha256(value.encode()).hexdigest()

    # TODO:
    # __and__
    # __or__

    def _to_tuple(self, obj: Self | PrimitiveType | SeqType | None = None) -> tuple:
        if obj is None:
            obj = self
        match obj:
            case dict():  # pragma: no branch - branch coverage broken
                return tuple(
                    (key, self._to_tuple(value)) for key, value in sorted(obj.items())
                )
            case list() | set() | tuple():
                if isinstance(obj, set):  # pragma: no branch - branch coverage broken
                    obj = sorted(obj)
                return tuple(self._to_tuple(value) for value in obj)
            case _:  # case statement for coverage - otherwise could return this outside
                return (obj,)

    def _to_tuple_str(self, obj: Self | SeqType | None = None) -> str:
        return str(self._to_tuple(obj))

    def setdefault(self, key: KT, default: VT) -> Self:  # type: ignore[override]
        return super().setdefault(key, self._convert(default))

    def update(self, m: Mapping[KT, VT] | None = None, /, **kwargs: VT) -> None:  # type: ignore[override]
        super().update(self._convert(self._merge_args(m, kwargs)))

    def merge(self, other: dict) -> Self:
        deepmerge.always_merger.merge(self, other)

    def sorted(
        self, key: Callable[[Any], str] | None = None, *, reverse: bool = False
    ) -> Self:
        return type(self)(
            {key: self[key] for key in sorted(self.keys(), key=key, reverse=reverse)}
        )

    def clean(self, cls: type[dict] | None = None) -> Self | dict:
        if cls is None:
            cls = type(self)
        clean = cls()
        for key, value in self.items():
            match value:
                case Dic():
                    value = value.clean()
                case list() | set() | tuple():
                    vtype = type(value)
                    value = list(value)
                    for i, xvalue in enumerate(value):
                        if isinstance(xvalue, Dic):
                            xvalue = value[i] = xvalue.clean()
                        if not self._has_value(xvalue):
                            del value[i]
                    if vtype is not list:
                        value = vtype(value)
            if self._has_value(value):
                clean[key] = value
        return clean

    @staticmethod
    def _has_value(value: Any) -> bool:
        return bool(value) or isinstance(value, int | float)

    def export(self, *, stringify: bool = False) -> dict:
        clean = self.clean(dict)
        if not clean:
            log.warning("empty export")
            return clean
        # XXX: coverage branch broken
        for key, value in clean.items():  # pragma: no branch
            match value:
                case dict():
                    if not isinstance(value, Dic):
                        raise RuntimeError(f"{key} = {value!r} - should be Dic")  # noqa: TRY004
                    value = value.export(stringify=stringify)
                case list() | set() | tuple():
                    if isinstance(value, set):
                        value = sorted(value, key=self._to_tuple_str)
                    value = [
                        v.export(stringify=stringify)
                        if isinstance(v, Dic)
                        else sorted(value, key=self._to_tuple_str)
                        if isinstance(v, set)
                        else v
                        if isinstance(v, PrimitiveType) or not stringify  # type: ignore[arg-type,misc]
                        else str(v)
                        for v in value
                    ]
                case _:
                    if stringify and not isinstance(value, PrimitiveType):  # type: ignore[arg-type,misc]
                        value = str(value)
            clean[key] = value
        return clean
