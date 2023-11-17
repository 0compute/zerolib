from __future__ import annotations

import anyio
import appdirs
from contextvars_extras import ContextVarsRegistry

from . import const
from .graph import Graph


class Context(ContextVarsRegistry):
    """
    Application Context

    Context-local state for config and services
    """

    graph = Graph.factory()
    """DAG for Node type"""

    cache = True
    """Whether to cache"""

    cachedir = anyio.Path(appdirs.user_cache_dir(const.NAME))
    """User cache dir"""

    def __repr__(self) -> str:
        return f"<Context {self.graph}>"
