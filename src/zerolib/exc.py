from __future__ import annotations

from collections.abc import Hashable
from typing import Any


class CircularError(Exception):
    def __init__(self, cycle: list[tuple[Hashable, Hashable, dict[str, Any] | None]]):
        edges = [(edge[0], edge[2]) for edge in cycle] + [(cycle[-1][1], None)]
        super().__init__(
            " => ".join(str(edge[1]) for edge in edges),
            edges,
        )
