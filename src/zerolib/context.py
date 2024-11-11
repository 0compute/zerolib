from __future__ import annotations

import contextlib
import functools
from typing import TYPE_CHECKING

import anyio
import appdirs
from contextvars_extras import ContextVarDescriptor

from . import const
from .graph import Graph

if TYPE_CHECKING:
    from collections.abc import Generator
    from typing import Any, Self


class Context:
    """
    Application Context

    Context-local state for config and services
    """

    graph = ContextVarDescriptor(default=Graph.factory())
    """DAG for Node type"""

    cache = ContextVarDescriptor(default=True)
    """Whether to cache"""

    cachedir = ContextVarDescriptor(
        default=anyio.Path(appdirs.user_cache_dir(const.NAME))
    )
    """Cache directory"""

    def __repr__(self) -> str:
        return f"<{type(self).__name__}>"

    @contextlib.contextmanager
    def __call__(self, **kwargs: Any) -> Generator[Self, None, None]:
        reset = []
        for key, value in kwargs.items():
            descriptor = getattr(self.__class__, key)
            reset.append(functools.partial(descriptor.reset, descriptor.set(value)))
        try:
            yield self
        finally:
            for func in reset:
                func()

    @classmethod
    def factory(cls, name: str = const.NAME) -> Context:
        self = cls()
        self.cachedir = anyio.Path(appdirs.user_cache_dir(name))
        return self
