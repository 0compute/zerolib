from typing import Any

from typing_extensions import Buffer, Protocol

class _WriteStream(Protocol):
    def write(self, b: bytes) -> int: ...

class _Stream(Protocol):
    def read(self) -> bytes: ...

def pack(o: Any, stream: _WriteStream, **kwargs: Any) -> None: ...
def packb(o: Any, **kwargs: Any) -> bytes: ...
def unpack(stream: _Stream, **kwargs: Any) -> Any: ...
def unpackb(packed: Buffer, **kwargs: Any) -> Any: ...
