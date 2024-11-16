from __future__ import annotations

import contextlib
import inspect
from typing import Any, Self

import atools

from .. import util
from ..graph import Graph, NodeFilterType, NodeListEdgeDataType, NodeListType
from .struct import Struct


class cached_edge_property(util.cached_property):  # noqa: N801
    ...


class cached_child_edge_property(util.cached_property):  # noqa: N801
    ...


class cached_parent_edge_property(util.cached_property):  # noqa: N801
    ...


class Node(Struct):
    """
    A Graph Node

    Must implement `__hash__`
    """

    @classmethod
    @atools.memoize
    def _cached_edge_properties(cls) -> list[str]:
        return [
            key
            for key, attr in inspect.getmembers(cls)
            if isinstance(attr, cached_edge_property)
        ]

    @classmethod
    @atools.memoize
    def _cached_child_edge_properties(cls) -> list[str]:
        return [
            key
            for key, attr in inspect.getmembers(cls)
            if isinstance(attr, cached_child_edge_property)
        ]

    @classmethod
    @atools.memoize
    def _cached_parent_edge_properties(cls) -> list[str]:
        return [
            key
            for key, attr in inspect.getmembers(cls)
            if isinstance(attr, cached_parent_edge_property)
        ]

    def _clear_cached_edge_properties(self, name: str) -> None:
        for key in (
            getattr(self, f"_cached_{name}_edge_properties")()
            + self._cached_edge_properties()
        ):
            with contextlib.suppress(AttributeError):
                delattr(self, key)

    def _clear_edge_cache(self, child: Self) -> None:
        self._clear_cached_edge_properties("child")
        child._clear_cached_edge_properties("parent")

    @cached_parent_edge_property
    def parents(self) -> NodeListEdgeDataType:
        return self.ctx.graph.parents(self)

    @cached_child_edge_property
    def children(self) -> NodeListEdgeDataType:
        return self.ctx.graph.children(self)

    @property
    def has_node(self) -> bool:
        return self.ctx.graph.has_node(self)

    # TOGO: wanted?
    @property
    def is_unlinked(self) -> bool:
        return not self.children and not self.parents

    def add_node(self) -> None:
        self.ctx.graph.add_node(self)

    def has_child(self, node: Self) -> bool:
        return self.ctx.graph.has_child(self, node)

    def add_child(self, child: Self, **kwargs: Any) -> None:
        self.log.debug(f"add_child {kwargs and f'{kwargs} ' or ''}{child!r}")
        self.ctx.graph.add_child(self, child, kwargs)
        self._clear_edge_cache(child)

    def remove_child(self, child: Self) -> None:
        self.log.debug(f"remove_child {child!r}")
        self.ctx.graph.remove_child(self, child)

    def ancestors(self, filter: NodeFilterType = None) -> NodeListType:
        return self.ctx.graph.ancestors(self, filter)

    def descendants(self, filter: NodeFilterType = None) -> NodeListType:
        return self.ctx.graph.descendants(self, filter)

    def subgraph(self, filter: NodeFilterType = None) -> Graph:
        return self.ctx.graph.subgraph(self, filter)


class FrozenNode(Node, frozen=True):  #  type: ignore[misc]
    ...
