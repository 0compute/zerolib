from __future__ import annotations

from collections.abc import Callable, Generator, Hashable
from typing import Any, Self, cast

import rustworkx
import wrapt

from .exc import CircularError
from .loguru_compat import log

NodeFilterType = tuple[type, ...] | type | Callable[[Hashable], bool] | None

NodeAttrsType = dict[str, Any] | None

NodeListType = list[Hashable]

NodeListEdgeDataType = list[tuple[Hashable, NodeAttrsType]]


class Graph(wrapt.ObjectProxy):  # type: ignore[type-arg]
    _self_node_index_map: dict[Hashable, int]
    _self_index_node_map: dict[int, Hashable]
    _self_filter: NodeFilterType

    # XXX: need a factory because superclass does not allow setting self members in
    # __init__ - trying results in "ValueError: wrapper has not been initialized"
    @classmethod
    def factory(cls, graph: rustworkx.PyDiGraph | None = None) -> Self:  # type: ignore[type-arg]
        if graph is None:
            graph = cls._digraph()
        self = cls(graph)
        self._self_node_index_map = {}
        self._self_index_node_map = {}
        self._self_filter = None
        return self

    @classmethod
    def _digraph(cls) -> rustworkx.PyDiGraph:  # type: ignore[type-arg]
        return rustworkx.PyDiGraph(multigraph=False)

    def __str__(self) -> str:
        return (
            f"nodes={self.__wrapped__.num_nodes()} edges={self.__wrapped__.num_edges()}"
        )

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
        sorter = rustworkx.TopologicalSorter(
            self.__wrapped__,
            # we don't need to check cycle - it's done already in `.add_child`
            check_cycle=False,
        )
        while sorter.is_active():
            ready = sorter.get_ready()
            nodes = set(
                self._filter_nodes(
                    {self._self_index_node_map[index] for index in ready},
                    self.filter,
                )
            )
            if nodes:
                yield nodes
            sorter.done(ready)

    def has_node(self, node: Hashable) -> bool:
        return node in self._self_node_index_map

    def add_node(self, node: Hashable) -> int:
        index = self._self_node_index_map.get(node)
        # XXX: coverage branch broken: index is 0 in
        # ../../tests/unit/test_graph.py::test_add_node "show idempotent"
        if index is None:  # pragma: no branch
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
        return cast(bool, self.__wrapped__.has_edge(parent_index, child_index))

    def add_child(
        self,
        parent: Hashable,
        child: Hashable,
        attrs: NodeAttrsType = None,
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
            for edge in rustworkx.digraph_find_cycle(self.__wrapped__, child_index)
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

    def children(self, node: Hashable) -> NodeListEdgeDataType:
        try:
            index = self._self_node_index_map[node]
        except KeyError:
            return []
        return [
            (self._self_index_node_map[e[1]], e[2])
            for e in self.__wrapped__.out_edges(index)
        ]

    def parents(self, node: Hashable) -> NodeListEdgeDataType:
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
    ) -> NodeListType:
        return self._relations("descendants", node, filter)

    def ancestors(self, node: Hashable, filter: NodeFilterType = None) -> NodeListType:
        return self._relations("ancestors", node, filter)

    def _relations(
        self, func: str, node: Hashable, filter: NodeFilterType = None
    ) -> NodeListType:
        nodes = [
            self._self_index_node_map[n]
            for n in getattr(rustworkx, func)(
                self.__wrapped__, self._self_node_index_map[node]
            )
        ]
        return self._filter_nodes(nodes, filter)

    @staticmethod
    def _filter_nodes(
        nodes: NodeListType | set[Hashable], filter: NodeFilterType
    ) -> NodeListType:
        # XXX: coverage branch broken: filter is None in
        # ../../tests/unit/test_graph.py::test_ancestors
        if filter is None:  # pragma: no branch
            return list(nodes)
        return [
            node
            for node in nodes
            if (
                isinstance(node, filter)
                if isinstance(filter, tuple | type)
                else filter(node)
            )
        ]

    def get_edge_data(self, parent: Hashable, child: Hashable) -> NodeAttrsType:
        return cast(
            NodeAttrsType,
            self.__wrapped__.get_edge_data(
                self._self_node_index_map[parent], self._self_node_index_map[child]
            ),
        )

    def subgraph(self, node: Hashable, filter: NodeFilterType = None) -> Graph:
        descendants = self.descendants(node, filter)
        graph = Graph.factory(
            graph=self.__wrapped__.subgraph(
                [self._self_node_index_map[node] for node in descendants],
                preserve_attrs=True,
            )
        )
        # XXX: coverage branch broken: loop does complete
        for index, gnode in enumerate(graph.__wrapped__.nodes()):  # pragma: no branch
            graph._self_index_node_map[index] = gnode
            graph._self_node_index_map[gnode] = index
        return graph

    def clear(self) -> None:
        self.__wrapped__ = self._digraph()
        self._self_node_index_map = {}
        self._self_index_node_map = {}
