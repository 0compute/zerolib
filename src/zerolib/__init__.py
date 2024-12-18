from __future__ import annotations

from . import command, logging, serialize, util
from .context import Context
from .dic import Dic
from .exc import CircularError
from .graph import Graph
from .loguru_compat import log
from .type import (
    FrozenNode,
    FrozenStruct,
    Node,
    Struct,
    field,
    register_ext_type,
    union,
)

# https://loguru.readthedocs.io/en/0.7.2/resources/recipes.html#configuring-loguru-to-be-used-by-a-library-or-an-application
log.disable(__package__)
del log

__all__ = (
    "CircularError",
    "Context",
    "Dic",
    "FrozenNode",
    "FrozenStruct",
    "Graph",
    "Node",
    "Struct",
    "command",
    "field",
    "logging",
    "register_ext_type",
    "serialize",
    "union",
    "util",
)
