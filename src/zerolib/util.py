from __future__ import annotations

import contextlib
import functools
import os
import tempfile
import time
from typing import TYPE_CHECKING

import aiofiles
import anyio
import atools
from loguru import logger as log

from . import const

if TYPE_CHECKING:
    from collections.abc import Callable, Generator, Iterable
    from typing import Any

    from loguru._logger import Logger


def run_sync(func: Callable, *args: Any, debug: bool = False, **kwargs: Any) -> Any:
    return anyio.run(
        functools.partial(func, *args, **kwargs), backend_options=dict(debug=debug)
    )


def joinmap(
    iterable: Iterable, func: Callable[[Any], str] = str, sep: str = ", "
) -> str:
    return sep.join(map(func, iterable))


REPR_MAX_LENGTH = 70


def trepr(
    obj: Any,
    *,
    repr: Callable[[Any], str] = repr,
    max_length: int | None = REPR_MAX_LENGTH,
) -> str:
    """Truncated repr"""
    repr_str = repr(obj)
    # XXX: coverage branch broken: below is False in
    # ../../tests/unit/test_util.py::test_trepr_default
    if max_length is not None and len(repr_str) - 2 > max_length:  # pragma: no branch
        if "\\n" in repr_str:
            repr_str = repr_str.split("\\n", maxsplit=1)[0]
        end = ""
        match repr_str[0]:
            case "[":
                end = "]"
            case "{":
                end = "}"
            case "(" | "Dic(":
                end = ")"
            case "<":
                end = ">"
            case "'":  # pragma: no branch
                end = "'"
        repr_str = f"{repr_str[:max_length]}…{end}"
    return repr_str


def irepr(
    iterable: Iterable,
    sep: str = ", ",
    repr: Callable[[Any], str] = repr,
    max_length: int | None = REPR_MAX_LENGTH,
) -> str:
    """Iterable repr"""
    return joinmap(
        sorted(iterable) if isinstance(iterable, set) else iterable,
        functools.partial(trepr, repr=repr, max_length=max_length),
        sep,
    )


def trace(
    desc: str | Callable[[], str] | None = None,
    end_desc: str | Callable[[], str] | None = None,
    *,
    log: Logger = log,
    level: str = "DEBUG",
) -> Callable:
    def wrapper(func: Callable) -> Callable:
        @functools.wraps(func)
        async def wrapped(*args: Any, **kwargs: Any) -> Any:
            start = time.monotonic()
            _log = log(*args, **kwargs) if callable(log) else log
            _log = _log.opt(depth=1).log
            msg = desc(*args, **kwargs) if callable(desc) else desc
            if msg is not None:
                _log(level, msg)
            result = await func(*args, **kwargs)
            msg = (
                f"{func}: {irepr(args)} {irepr(kwargs)}"
                if msg is None
                else msg
                if end_desc is None
                else end_desc(*args, **kwargs)
                if callable(end_desc)
                else end_desc
            )
            _log(
                level,
                f"{msg} in {time.monotonic() - start:.4f}s",
            )
            return result

        return wrapped

    return wrapper


TMPDIR_PREFIX = f"{const.NAME}-"


def tmpdir(
    **kwargs: Any,
) -> aiofiles.tempfile.AiofilesContextManagerTempDir:
    kwargs["prefix"] = TMPDIR_PREFIX
    return aiofiles.tempfile.TemporaryDirectory(**kwargs)


def is_tmpdir(path: str) -> bool:
    return path.startswith(f"{tempfile.gettempdir()}{os.sep}{TMPDIR_PREFIX}")


@contextlib.contextmanager
def patch(target: object, attr: str, patch: Any) -> Generator[None, None, None]:
    # assumes that attr exists on target - we have no use case where it is not
    orig = getattr(target, attr)
    setattr(target, attr, patch)
    try:
        yield
    finally:
        setattr(target, attr, orig)


# functools.cached_property is broken: https://github.com/python/cpython/issues/87634
class cached_property(property):  # noqa: N801
    def __init__(self, fget: Callable[[Any], Any]) -> None:
        super().__init__(atools.memoize(fget, keygen=lambda self: (id(self),)))

    def __delete__(self, obj: Any) -> None:
        memoized = self.fget.memoize  # type: ignore[attr-defined]
        key = memoized.get_key(memoized.keygen(obj))
        if key not in memoized.memos:
            raise AttributeError(self.fget.__name__)
        memoized.reset_key(key)

    def __repr__(self) -> str:
        return repr(self.fget)
