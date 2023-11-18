from __future__ import annotations

from zerolib import Context, const


def test_repr() -> None:
    assert repr(Context()) == "<Context nodes=0 edges=0>"


def test_cachedir() -> None:
    assert str(Context().cachedir).endswith(f"/.cache/{const.NAME}")
