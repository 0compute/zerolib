from __future__ import annotations

from typing import TYPE_CHECKING

import rustworkx
import wrapt
from loguru import logger as log

from .exc import CircularError

if TYPE_CHECKING:
    from collections.abc import Callable, Generator, Hashable
    from typing import Self

    NodeFilterType = tuple[type, ...] | type | Callable[[Hashable], bool] | None


class Graph(wrapt.ObjectProxy):
    _self_node_index_map: dict[Hashable, int]
    _self_index_node_map: dict[int, Hashable]
    _self_filter: NodeFilterType

    # XXX: need a factory because superclass does not allow setting self members in
    # __init__ - trying results in "ValueError: wrapper has not been initialized"
    @classmethod
    def factory(cls, graph: rustworkx.PyDiGraph | None = None) -> Self:
        if graph is None:
            graph = cls._digraph()
        self = cls(graph)
        self._self_node_index_map = {}
        self._self_index_node_map = {}
        self._self_filter = None
        return self

    @classmethod
    def _digraph(cls) -> rustworkx.PyDiGraph:
        return rustworkx.PyDiGraph(multigraph=False)

    def __str__(self) -> str:
        return f"nodes={self.num_nodes()} edges={self.num_edges()}"

    def __repr__(self) -> str:
        return repr(self.__wrapped__)

    def __bool__(self) -> bool:
        return bool(self._self_node_index_map)

    @property
    def filter(self) -> NodeFilterType:
        return self._self_filter

    @filter.setter
    def filter(self, value: NodeFilterType) -> None:
        self._self_filter = value

    def __iter__(self) -> Generator[set[Hashable], None, None]:
        sorter = rustworkx.TopologicalSorter(  # type: ignore[attr-defined]
            self.__wrapped__,
            # we don't need to check cycle - it's been done already
            check_cycle=False,
        )
        ready: list | None = None
        while True:
            if not sorter.is_active():
                break
            if ready is not None:
                sorter.done(ready)
            ready = sorter.get_ready()
            nodes: set[Hashable] = {self._self_index_node_map[index] for index in ready}
            if self.filter is not None:
                nodes = set(self._filter_nodes(nodes, self.filter))
            if nodes:
                yield nodes

    def has_node(self, node: Hashable) -> bool:
        return node in self._self_node_index_map

    def add_node(self, node: Hashable) -> int:
        index = self._self_node_index_map.get(node)
        if index is None:
            index = self.__wrapped__.add_node(node)
            self._self_node_index_map[node] = index
            self._self_index_node_map[index] = node
        return index

    def remove_node(self, node: Hashable) -> None:
        self._remove_node(node)

    def _remove_node(self, node: Hashable) -> None:
        log.debug(f"{self!r} remove_node {node!r}")
        try:
            index = self._self_node_index_map[node]
        except KeyError:
            log.warning(f"{node} not found")
        else:
            self.__wrapped__.remove_node(index)
            del self._self_node_index_map[node]
            del self._self_index_node_map[index]

    def has_child(self, parent: Hashable, child: Hashable) -> bool:
        try:
            parent_index = self._self_node_index_map[parent]
        except KeyError:
            return False
        try:
            child_index = self._self_node_index_map[child]
        except KeyError:
            return False
        return self.__wrapped__.has_edge(parent_index, child_index)

    def add_child(
        self,
        parent: Hashable,
        child: Hashable,
        attrs: dict | None = None,
    ) -> None:
        parent_index = self.add_node(parent)
        child_index = self.add_node(child)
        if self.__wrapped__.has_edge(parent_index, child_index):
            raise RuntimeError(
                f"{parent!r} already has child {child!r}: "
                f"{self.__wrapped__.get_edge_data(parent_index, child_index)}"
            )
        self.__wrapped__.add_edge(
            parent_index, child_index, attrs if attrs is None else attrs
        )
        cycle = [
            (
                self._self_index_node_map[edge[0]],
                self._self_index_node_map[edge[1]],
                self.__wrapped__.get_edge_data(*edge),
            )
            for edge in rustworkx.digraph_find_cycle(self.__wrapped__, child_index)  # type: ignore[attr-defined]
        ]
        if cycle:
            raise CircularError(cycle)

    def remove_child(self, parent: Hashable, child: Hashable) -> None:
        if len(self.parents(child)) == 1:
            self._remove_node(child)
        else:
            self.__wrapped__.remove_edge(
                self._self_node_index_map[parent], self._self_node_index_map[child]
            )

    def children(self, node: Hashable) -> list[tuple[Hashable, dict | None]]:
        try:
            index = self._self_node_index_map[node]
        except KeyError:
            return []
        return [
            (self._self_index_node_map[e[1]], e[2])
            for e in self.__wrapped__.out_edges(index)
        ]

    def parents(self, node: Hashable) -> list[tuple[Hashable, dict | None]]:
        try:
            index = self._self_node_index_map[node]
        except KeyError:
            return []
        return [
            (self._self_index_node_map[e[0]], e[2])
            for e in self.__wrapped__.in_edges(index)
        ]

    def descendants(
        self, node: Hashable, filter: NodeFilterType = None
    ) -> list[Hashable]:
        return self._descendants(node, filter)

    def _descendants(
        self, node: Hashable, filter: NodeFilterType = None
    ) -> list[Hashable]:
        descendants = [
            self._self_index_node_map[n]
            for n in rustworkx.descendants(  # type: ignore[attr-defined]
                self.__wrapped__, self._self_node_index_map[node]
            )
        ]
        if filter is not None:
            descendants = self._filter_nodes(descendants, filter)
        return descendants

    def ancestors(
        self, node: Hashable, filter: NodeFilterType = None
    ) -> list[Hashable]:
        ancestors = [
            self._self_index_node_map[n]
            for n in rustworkx.ancestors(  # type: ignore[attr-defined]
                self.__wrapped__, self._self_node_index_map[node]
            )
        ]
        if filter is not None:
            ancestors = self._filter_nodes(ancestors, filter)
        return ancestors

    @staticmethod
    def _filter_nodes(nodes: list | set, filter: NodeFilterType = None) -> list:
        return [
            node
            for node in nodes
            if (
                isinstance(node, filter)
                if isinstance(filter, tuple | type)
                else filter(node)
            )
        ]

    def get_edge_data(self, parent: Hashable, child: Hashable) -> dict | None:
        return self.__wrapped__.get_edge_data(
            self._self_node_index_map[parent], self._self_node_index_map[child]
        )

    def subgraph(self, node: Hashable, filter: NodeFilterType = None) -> Self:
        descendants = self._descendants(node, filter)
        graph = Graph.factory(
            graph=self.__wrapped__.subgraph(
                [self._self_node_index_map[node] for node in descendants],
                preserve_attrs=True,
            )
        )
        for index, gnode in enumerate(graph.nodes()):
            graph._self_index_node_map[index] = gnode
            graph._self_node_index_map[gnode] = index
        return graph

    def clear(self) -> None:
        self.__wrapped__ = self._digraph()
        self._self_node_index_map = {}
        self._self_index_node_map = {}
