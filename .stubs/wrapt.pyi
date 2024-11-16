from typing import Any, Generic, TypeVar

_T = TypeVar("_T", bound=Any)

class ObjectProxy(Generic[_T]):
    __wrapped__: _T

    def __init__(self, wrapped: _T): ...
