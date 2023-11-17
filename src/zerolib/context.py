from __future__ import annotations

from typing import TYPE_CHECKING

import anyio
import appdirs
from contextvars_extras import ContextVarsRegistry

from . import const, util
from .graph import Graph
from .serialize import MsgSpecSerde

if TYPE_CHECKING:
    from .dic import Dic


class Context(ContextVarsRegistry):
    """
    Application Context

    Context-local state for config and services
    """

    graph = Graph()
    """DAG for Node type"""

    serde: MsgSpecSerde = MsgSpecSerde()
    """Msgspec serde wrapper"""

    @util.cached_property
    async def cachedir(self) -> anyio.Path:
        """Application cache directoy in XDG_CACHE_HOME"""
        return anyio.Path(
            await anyio.to_thread.run_sync(appdirs.user_cache_dir, const.NAME)
        )

    # def __hash__(self) -> int:
    #     return hash(self.cfg)

    def __repr__(self) -> str:
        return f"<Context {self.graph}>"

    @classmethod
    async def factory(cls, options: Dic | None = None) -> Context:
        self = cls()
        if options:
            self.options = options.copy()
        return self
