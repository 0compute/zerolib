from __future__ import annotations

from .node import FrozenNode, Node
from .struct import FrozenStruct, Struct, field  # noqa: TCH001

UNION_TYPES: set[type[Struct]] = set()


def union(cls: type[Struct]) -> type[Struct]:
    """Join class to the tagged union used by msgspec decoder"""
    UNION_TYPES.add(cls)
    return cls
