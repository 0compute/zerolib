from __future__ import annotations


class CircularError(Exception):
    def __init__(self, edges: list):
        edges = [(edge[0], edge[2]) for edge in edges] + [(edges[-1][1], None)]
        super().__init__(
            " => ".join(str(edge[1]) for edge in edges),
            edges,
        )
