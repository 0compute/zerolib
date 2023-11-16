from __future__ import annotations

import datetime
import io
import sys
from typing import TYPE_CHECKING, Any, Literal
from urllib.parse import urlparse

import anyio
import appdirs
import atools
import httpx
import tqdm
from contextvars_extras import ContextVarsRegistry
from packaging.tags import sys_tags
from packaging.version import Version

from . import const, util
from .dic import Dic
from .serialize import MsgSpecSerde

if TYPE_CHECKING:
    from types import TracebackType

    from packaging.tags import Self, Tag


class AioBytesIO(io.BytesIO):
    async def __aenter__(self) -> Self:
        return self

    async def __aexit__(
        self,
        _exc_type: type[BaseException] | None,
        _exc_val: BaseException | None,
        _exc_tb: TracebackType | None,
    ) -> None:
        ...

    async def write(self, buffer: io.ReadableBuffer) -> int:
        return super().write(buffer)

    async def flush(self) -> None:
        ...


class Config(Dic):
    index: str = "https://pypi.org/pypi"
    """PyPi/Wharehouse json API"""

    max_age: datetime.timedelta | None = datetime.timedelta(weeks=52)
    # max_age: datetime.timedelta | None = None
    """Do not consider releases older than this"""

    as_at: datetime.datetime | None = None
    """Make as if it was this date time"""

    # runtime options, not part of hash
    http: Dic = Dic(timeout=10)
    """Passed as keywords to `httpx.AsyncClient`"""

    options: Dic | None = None
    """Options set on init. Used to pass through command line options"""

    prefer: Literal["bdist", "sdist"] = "sdist"
    """Preferred distribution type"""

    ttl: datetime.timedelta = datetime.timedelta(days=1)
    """TTL for index refresh"""

    cache: bool = True
    """Whether to cache"""

    def __hash__(self) -> int:
        return hash(self._hashdict())

    def __str__(self) -> str:
        return util.irepr(
            [f"{key}={value}" for key, value in self._hashdict().items()], repr=str
        )

    def __repr__(self) -> str:
        return f"<Config {self}>"

    def sha256_hex(self) -> str:
        return self._hashdict().sha256_hex()

    def _hashdict(self) -> Dic:
        return Dic(
            {
                key: value
                for key, value in {
                    key: getattr(self, key)
                    for key in self.__annotations__
                    if key not in ("http", "options", "prefer", "ttl")
                }.items()
                if value
            }
        )


class Context(ContextVarsRegistry):
    """
    Application Context

    Context-local global state used for config and services
    """

    cfg = Config()
    """Configutation"""

    serde: MsgSpecSerde = MsgSpecSerde()
    """Msgspec serde wrapper"""

    # type is really Collector but it needs to be imported in the global scope which is circular
    # XXX: smell
    collector: Any | None = None
    """Current Collector"""

    @util.cached_property
    async def cachedir(self) -> anyio.Path:
        """Application cache directoy in XDG_CACHE_HOME"""
        return anyio.Path(
            await anyio.to_thread.run_sync(appdirs.user_cache_dir, const.NAME)
        )

    @util.cached_property
    def http(self) -> httpx.AsyncClient:
        """An HTTP client"""
        return httpx.AsyncClient(
            headers={"User-Agent": f"{const.NAME} {const.VERSION}"},
            follow_redirects=True,
            **self.cfg.http,
        )

    @util.trace(desc=lambda _self, url, **_kwargs: f"GET {url}")
    async def http_stream(
        self,
        url: str,
        *,
        method: str = "GET",
        desc: str | None = None,
        path: anyio.Path | None = None,
        size: int = 0,
        total: int | None = None,
    ) -> str | None:
        """An HTTP stream with progress bar"""
        if path is not None:
            await path.parent.mkdir(parents=True, exist_ok=True)
        headers = Dic(Range=f"bytes={size}-") if size != 0 else Dic()
        with tqdm.tqdm(
            desc=desc or f"GET {urlparse(url).path}",
            total=total,
            initial=size,
            unit_scale=True,
            unit_divisor=1024,
            unit="B",
            colour="green",
            leave=True,
        ) as progress:
            async with (
                AioBytesIO() if path is None else await path.open("ab")
            ) as stream, self.http.stream(method, url, headers=headers) as response:
                response.raise_for_status()
                content_size = int(response.headers["Content-Length"])
                if progress.total is None:
                    progress.total = content_size
                elif content_size != (expected_size := progress.total - size):
                    raise RuntimeError(
                        f"content length mismatch: got {content_size} expected {expected_size}"
                    )
                num_bytes_downloaded = response.num_bytes_downloaded
                try:
                    async for chunk in response.aiter_bytes():
                        await stream.write(chunk)
                        await stream.flush()
                        progress.update(
                            response.num_bytes_downloaded - num_bytes_downloaded
                        )
                        num_bytes_downloaded = response.num_bytes_downloaded
                except anyio.get_cancelled_exc_class():
                    raise KeyboardInterrupt from None
            if path is None:
                return stream.getvalue().decode()

    @util.cached_property
    def sys_tags(self) -> set[Tag]:
        return set(sys_tags())

    @util.cached_property
    def sys_version(self) -> Version:
        v = sys.version_info
        return self.instance(Version, f"{v.major}.{v.minor}.{v.micro}")

    def __hash__(self) -> int:
        return hash(self.cfg)

    def __repr__(self) -> str:
        return f"<Context {self.cfg}>"

    @classmethod
    async def factory(cls, options: Dic | None = None) -> Context:
        options = options.copy()
        self = cls()
        # __import__('pdb').set_trace()
        for key in list(options):
            if key in Config.__annotations__:
                setattr(self.cfg, key, options.pop(key))
        self.options = options
        return self

    @staticmethod
    @atools.memoize
    def instance(cls: type, value: str) -> Any | None:
        """Memoized instances for str-valued primatives i.e. Version and SpecifierSet"""
        return cls(value)
