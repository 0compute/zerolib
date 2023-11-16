from __future__ import annotations

import hashlib
from typing import TYPE_CHECKING, TypeAlias

import atools
import deepmerge
from loguru import logger

if TYPE_CHECKING:
    from collections.abc import Callable, Iterable, Mapping
    from typing import _KT, _VT, Any, Self

SeqType: TypeAlias = list | set | tuple

BASE_TYPES = (float, int, str, tuple)


# TODO: look at using sha512 - meant to be faster
@atools.memoize
def _sha256_hex(value: str) -> str:
    return hashlib.sha256(value.encode()).hexdigest()


class Dic(dict):
    """A hashable dictionary that supports key access as attribute."""

    def __init__(
        self,
        base: Mapping[_KT, _VT] | Iterable[tuple[_KT, _VT]] | None = None,
        /,
        **kwargs: _VT,
    ):
        super().__init__(
            {
                key: self._convert(value)
                for key, value in self._merge_args(base, kwargs).items()
            }
        )

    def _convert(self, obj: Any) -> Any:
        if not (obj and isinstance(obj, dict | SeqType)):
            return obj
        match obj:
            case Dic():
                # noop: here so that dict() below doesn't recurse
                ...
            case dict():
                obj = type(self)(obj)
            # TODO: typevar
            case list() | set() | tuple():  # pragma: no branch - there is no default case
                obj = type(obj)(map(self._convert, obj))
        return obj

    def _merge_args(
        self,
        base: Mapping[_KT, _VT] | Iterable[tuple[_KT, _VT]] | None,
        kwargs: _VT,
    ) -> Dic:
        return dict(base) if base is not None else {} | kwargs

    def __setattr__(self, key: _KT, value: _VT) -> Any:
        return self.__setitem__(key, self._convert(value))

    def __getattr__(self, key: _KT) -> Any:
        try:
            return self.__getitem__(key)
        except KeyError as exc:
            raise AttributeError(str(exc)) from None

    def __delattr__(self, key: _KT) -> Any:
        try:
            return self.__delitem__(key)
        except KeyError as exc:
            raise AttributeError(str(exc)) from None

    def __hash__(self) -> int:  # type: ignore[override]
        return hash(self._to_tuple())

    def __lt__(self, other: Any) -> bool:
        return self._to_tuple() < self._to_tuple(other)

    def sha256_hex(self) -> str:
        return _sha256_hex("".join(map(str, self._to_tuple())))

    # TODO:
    # __and__
    # __or__

    def _to_tuple(self, obj: Self | list | set | tuple | None = None) -> tuple:
        if obj is None:
            obj = self
        match obj:
            case dict():
                return tuple(
                    (key, self._to_tuple(value)) for key, value in sorted(obj.items())
                )
            case list() | set() | tuple():
                if isinstance(obj, set):
                    obj = sorted(obj)
                return tuple(self._to_tuple(value) for value in obj)
        return (obj,)

    def setdefault(self, key: _KT, default: _VT) -> Self:
        return super().setdefault(key, self._convert(default))

    def update(self, m: Mapping[_KT, _VT] | None = None, /, **kwargs: _VT) -> None:
        super().update(self._convert(self._merge_args(m, kwargs)))

    def merge(self, other: dict) -> Self:
        deepmerge.always_merger.merge(self, other)

    @staticmethod
    def _has_value(value: Any) -> bool:
        return value or isinstance(value, int | float)

    def clean(self) -> Self:
        clean = type(self)()
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

    def export(self, *, stringify: bool = False) -> dict:
        clean = dict(self.clean())
        for key, value in clean.items():
            match value:
                case dict():
                    if not isinstance(value, Dic):
                        logger.warning(f"{key} = {value!r} - should be Dic")
                        value = Dic(value)
                    value = value.export(stringify=stringify)
                case list() | set() | tuple():
                    if isinstance(value, set):
                        value = self._set_to_list(value)
                    if stringify:
                        value = [
                            v.export(stringify=stringify)
                            if isinstance(v, Dic)
                            else v
                            if isinstance(v, BASE_TYPES)
                            else str(v)
                            for v in value
                        ]
                case _:
                    if stringify and not isinstance(value, BASE_TYPES):
                        value = str(value)
            clean[key] = value
        return clean

    def sorted(self, key: Callable | None = None, *, reverse: bool = False) -> Self:
        return type(self)(
            {key: self[key] for key in sorted(self.keys(), key=key, reverse=reverse)}
        )

    def _set_to_list(self, obj: Any) -> Any:
        match obj:
            case dict():
                clean = type(obj)()
                for key, value in obj.items():
                    match value:
                        case dict():
                            value = self._set_to_list(value)
                        case set():
                            value = sorted(value, key=self._to_tuple)
                    clean[key] = value
                return clean
            case set():
                return sorted(obj, key=self._to_tuple)
            case _:
                return obj
