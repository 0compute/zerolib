from __future__ import annotations

import pytest
from zerolib import CircularError, Graph


@pytest.fixture
def graph() -> Graph:
    return Graph.factory()


def test_bool(graph: Graph) -> None:
    assert not graph
    graph.add_node(1)
    assert graph


def test_str(graph: Graph) -> None:
    assert "nodes=0" in str(graph)
    graph.add_node(1)
    assert "nodes=1" in str(graph)


def test_factory() -> None:
    rgraph = Graph._digraph()
    graph = Graph.factory(graph=rgraph)
    assert graph.__wrapped__ == rgraph


def test_add_node(graph: Graph) -> None:
    graph.add_node(1)
    assert 1 in graph._self_node_index_map
    # show idempotent
    graph.add_node(1)


def test_has_node(graph: Graph) -> None:
    assert not graph.has_node(1)
    graph.add_node(1)
    assert graph.has_node(1)


def test_has_child(graph: Graph) -> None:
    assert not graph.has_child(1, 2)
    graph.add_child(1, 2)
    assert not graph.has_child(2, 3)
    assert graph.has_child(1, 2)


def test_get_edge_data(graph: Graph) -> None:
    graph.add_child(1, 2)
    assert graph.get_edge_data(1, 2) is None
    graph.add_child(2, 3, dict(a=1))
    assert graph.get_edge_data(2, 3) == dict(a=1)


def test_add_double(graph: Graph) -> None:
    graph.add_child(1, 2)
    with pytest.raises(RuntimeError):
        graph.add_child(1, 2)


def test_add_circular(graph: Graph) -> None:
    graph.add_child(1, 2)
    with pytest.raises(CircularError):
        graph.add_child(2, 1)


def test_parents(graph: Graph) -> None:
    graph.add_child(1, 2)
    assert graph.parents(2)[0][0] == 1
    graph.remove_node(1)
    assert not graph.parents(2)
    assert not graph.parents(3)


def test_children(graph: Graph) -> None:
    graph.add_child(1, 2, dict(a=1))
    assert graph.children(1)[0] == (2, dict(a=1))
    assert not graph.children(2)


def test_remove_node(graph: Graph) -> None:
    graph.add_node(1)
    assert graph.has_node(1)
    graph.remove_node(1)
    assert not graph.has_node(1)
    # to hit the KeyError except block
    graph.remove_node(1)


def test_remove_child(graph: Graph) -> None:
    graph.add_child(1, 2)
    assert graph.has_child(1, 2)
    graph.remove_child(1, 2)
    assert not graph.has_child(1, 2)
    graph.add_child(1, 2)
    assert graph.has_child(1, 2)
    graph.add_child(3, 2)
    assert graph.has_child(3, 2)
    graph.remove_child(1, 2)
    assert not graph.has_child(1, 2)


def test_ancestors(graph: Graph) -> None:
    graph.add_child(1, 2)
    assert graph.ancestors(2) == [1]
    assert graph.ancestors(2, int) == [1]
    assert graph.ancestors(2, lambda node: isinstance(node, int)) == [1]


def test_descendants(graph: Graph) -> None:
    graph.add_child(1, 2)
    assert graph.descendants(1) == [2]
    assert graph.descendants(1, int) == [2]
    assert graph.descendants(1, lambda node: isinstance(node, int)) == [2]


def test_subgraph(graph: Graph) -> None:
    graph.add_child(1, 2)
    graph.add_child(2, 3)
    assert graph.subgraph(1)._self_node_index_map == {2: 0, 3: 1}


def test_topo_iter(graph: Graph) -> None:
    graph.add_child(1, 2)
    graph.add_child(2, 3.0)
    graph.add_child(1, 4)
    assert list(graph) == [{1}, {2, 4}, {3.0}]
    graph.filter = lambda node: isinstance(node, int)
    assert list(graph) == [{1}, {2, 4}]


def test_clear(graph: Graph) -> None:
    graph.add_child(1, 2)
    graph.clear()
    assert not graph
