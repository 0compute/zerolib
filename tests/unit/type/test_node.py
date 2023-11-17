from __future__ import annotations

from typing import TYPE_CHECKING

import pytest
from zerolib import Context, FrozenNode, Graph, Node

if TYPE_CHECKING:
    from collections.abc import Generator


class Impl(Node):
    a: str = "1"

    def __str__(self) -> str:
        return self.a

    def __hash__(self) -> int:
        return hash(str(self))


class FrozenImpl(FrozenNode):  # type: ignore[misc]
    a: str = "1"


# give each test a clean graph
@pytest.fixture(autouse=True)
def _graph(ctx: Context) -> Generator[None, None, None]:
    with ctx(graph=Graph.factory()):
        yield


def test_add_has_node() -> None:
    obj = Impl()
    assert not obj.has_node
    obj.add_node()
    assert obj.has_node


def test_is_unlinked() -> None:
    obj = Impl()
    assert obj.is_unlinked


def test_relations() -> None:
    obj = Impl()
    obj2 = Impl(a="2")
    obj.add_child(obj2)
    assert obj2.parents[0][0] == obj
    assert obj.children[0][0] == obj2
    assert obj.descendants() == [obj2]
    assert obj2.ancestors() == [obj]


def test_child_lifecycle() -> None:
    obj = Impl()
    obj2 = Impl(a="2")
    obj.add_child(obj2)
    assert obj.has_child(obj2)
    obj.remove_child(obj2)
    assert not obj.has_child(obj2)


def test_subgraph() -> None:
    obj = Impl()
    obj2 = Impl(a="2")
    obj.add_child(obj2)
    assert obj.subgraph()._self_node_index_map == {obj2: 0}


def test_topo_iter() -> None:
    obj = Impl()
    obj2 = Impl(a="2")
    obj3 = Impl(a="3")
    obj4 = Impl(a="4")
    obj.add_child(obj2)
    obj2.add_child(obj3)
    obj.add_child(obj4)
    assert list(obj.ctx.graph) == [{obj}, {obj2, obj4}, {obj3}]


def test_frozen() -> None:
    obj = FrozenImpl()
    with pytest.raises(AttributeError):
        obj.a = "2"
