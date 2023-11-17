from __future__ import annotations

from zerolib import Node


class Impl(Node):
    a: str = "1"

    def __str__(self) -> str:
        return self.a

    def __hash__(self) -> int:
        return hash(str(self))


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
