from __future__ import annotations

import contextlib
import io
import subprocess

# export this so consumers don't need to
from subprocess import CalledProcessError
from typing import TYPE_CHECKING, overload

import anyio
import atools
from anyio.streams.text import TextReceiveStream
from loguru import logger

from . import util

if TYPE_CHECKING:
    from collections.abc import Mapping
    from typing import IO, Any, Literal

    from anyio.abc import ByteReceiveStream


@overload
async def run(*command: Any) -> bytes:
    ...


@overload
async def run(*command: Any, stdin: bytes, env: Mapping[str, str]) -> bytes:
    ...


@overload
async def run(*command: Any, lines: Literal[True]) -> list[str]:
    ...


@overload
async def run(*command: Any, lines: Literal[True], cwd: anyio.Path) -> list[str]:
    ...


@util.trace(
    desc=lambda *command, **_kwargs: subprocess.list2cmdline(command),
    log=logger,
)
async def run(
    *command: Any,
    stdin: bytes | None = None,
    stdout: int | IO[Any] | None = subprocess.PIPE,
    stderr: int | IO[Any] | None = subprocess.PIPE,
    cwd: anyio.Path | None = None,
    env: Mapping[str, str] | None = None,
    lines: bool = False,
) -> bytes | list[str] | None:
    if cwd is not None:
        logger.trace(f"cwd: {cwd}")
    async with (
        anyio.create_task_group() as tg,
        await anyio.open_process(
            list(map(str, command)),
            stdin=subprocess.PIPE if stdin else subprocess.DEVNULL,
            stderr=stderr,
            cwd=cwd,
            env=env,
        ) as proc,
    ):
        if stdout is subprocess.PIPE:
            stdout_buffer = io.BytesIO()
            tg.start_soon(_process_stdout, proc.stdout, stdout_buffer)
        if stderr is subprocess.PIPE:
            stderr_lines: list[str] = []
            tg.start_soon(_process_stderr, proc.stderr, stderr_lines)
        if stdin:
            await proc.stdin.send(stdin)
            await proc.stdin.aclose()
        try:
            returncode = await proc.wait()
        except BaseException:  # pragma: no cover - error path
            with contextlib.suppress(ProcessLookupError):
                proc.kill()
            raise
    out = stdout_buffer.getvalue() if stdout is subprocess.PIPE else None
    if returncode != 0:  # pragma: no cover - error path
        raise CalledProcessError(
            returncode,
            command,
            out,
            "\n".join(stderr_lines) if stderr is subprocess.PIPE else None,
        )
    if out is not None and lines:
        return out.decode().strip().splitlines()
    return out


async def _process_stdout(stream: ByteReceiveStream, buffer: io.BytesIO) -> None:
    async for chunk in stream:
        buffer.write(chunk)


async def _process_stderr(stream: ByteReceiveStream, lines: list[str]) -> None:
    async for line in TextReceiveStream(stream):
        if line := line.rstrip():  # pragma: no branch
            lines.append(line)
            logger.debug(f"err: {line}")


@atools.memoize
async def sha256sum(path: anyio.Path) -> str:
    return (await run("sha256sum", path)).decode().split()[0]
