from __future__ import annotations

from zerolib import Context


def test_repr() -> None:
    assert repr(Context()) == "<Context nodes=0 edges=0>"


def test_contextmanager() -> None:
    ctx = Context()
    assert ctx.cache
    with ctx(cache=False):
        assert not ctx.cache
    assert ctx.cache
