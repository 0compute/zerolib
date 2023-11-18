from __future__ import annotations

import contextlib
import io
import subprocess

# export this so consumers don't need to
from subprocess import CalledProcessError
from typing import TYPE_CHECKING, overload

import anyio
from anyio.streams.text import TextReceiveStream
from loguru import logger as log

from . import util

if TYPE_CHECKING:
    from collections.abc import Mapping
    from typing import IO, Any, Literal, TextIO

    from anyio.abc import ByteReceiveStream


@overload
async def run(command: str) -> bytes:
    ...


@overload
async def run(*command: Any) -> bytes:
    ...


@overload
async def run(command: str, stdin: bytes) -> bytes:
    ...


@overload
async def run(command: str, stdout: TextIO, stderr: TextIO) -> bytes:
    ...


@overload
async def run(*command: Any, lines: Literal[True]) -> list[str]:
    ...


@util.trace(lambda *command, **_kwargs: subprocess.list2cmdline(command), log=log)
async def run(
    *command: Any,
    stdin: bytes | None = None,
    stdout: int | IO[Any] | None = subprocess.PIPE,
    stderr: int | IO[Any] | None = subprocess.PIPE,
    cwd: anyio.Path | None = None,
    env: Mapping[str, str] | None = None,
    lines: bool = False,
) -> bytes | list[str] | None:
    async with (
        anyio.create_task_group() as tg,
        await anyio.open_process(
            command[0]
            if len(command) == 1 and isinstance(command[0], str)
            else list(map(str, command)),
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
    # XXX: branch coverage broken: lines=False in
    # ../../tests/functional/test_command.py::test_basic
    if lines:  # pragma: no branch
        return [] if out is None else out.decode().strip().splitlines()
    return out


async def _process_stdout(stream: ByteReceiveStream, buffer: io.BytesIO) -> None:
    async for chunk in stream:
        buffer.write(chunk)


async def _process_stderr(stream: ByteReceiveStream, lines: list[str]) -> None:
    async for line in TextReceiveStream(stream):
        if line := line.rstrip():  # pragma: no branch
            lines.append(line)
            log.debug(f"err: {line}")
