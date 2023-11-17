from __future__ import annotations

from loguru import logger as log

from . import command, logging, serialize, util
from .context import Context
from .dic import Dic
from .exc import CircularError
from .graph import Graph
from .type import FrozenNode, FrozenStruct, Node, Struct, field, union

# https://loguru.readthedocs.io/en/stable/resources/recipes.html#configuring-loguru-to-be-used-by-a-library-or-an-application
log.disable(__package__)
del log
