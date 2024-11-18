from __future__ import annotations

import contextlib
import io
import subprocess
from collections.abc import Callable, Mapping

# export this so consumers don't need to
from subprocess import CalledProcessError
from typing import IO, Any, Literal, TextIO, cast, overload

import anyio
from anyio.abc import ByteReceiveStream
from anyio.streams.text import TextReceiveStream

from . import util
from .loguru_compat import log


@overload
async def run(command: str) -> bytes: ...


@overload
async def run(*command: Any) -> bytes: ...


@overload
async def run(command: str, stdin: bytes) -> bytes: ...


@overload
async def run(command: str, stdout: TextIO, stderr: TextIO) -> bytes: ...


@overload
async def run(*command: Any, lines: Literal[True]) -> list[str]: ...


@util.trace(
    lambda *command, **_kwargs: _coerce_command(command, subprocess.list2cmdline),
    log=log,
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
    async with (
        anyio.create_task_group() as tg,
        await anyio.open_process(
            _coerce_command(command, lambda command: list(map(str, command))),
            stdin=subprocess.PIPE if stdin else subprocess.DEVNULL,
            stderr=stderr,
            cwd=cwd,
            env=env,
        ) as proc,
    ):
        if stdout is subprocess.PIPE:
            stdout_buffer = io.BytesIO()
            tg.start_soon(
                _process_stdout,
                # XXX: anyio Process.stdout and Process.stderr is incorrectly typed
                # as ByteReceiveStream | None - it is never None
                cast(ByteReceiveStream, proc.stdout),
                stdout_buffer,
            )
        if stderr is subprocess.PIPE:
            stderr_lines: list[str] = []
            tg.start_soon(
                _process_stderr,
                # XXX: per above
                cast(ByteReceiveStream, proc.stderr),
                stderr_lines,
            )
        if proc.stdin is not None:
            await proc.stdin.send(cast(bytes, stdin))
            await proc.stdin.aclose()
        try:
            returncode = await proc.wait()
        except BaseException:  # pragma: no cover - TODO: test this
            with contextlib.suppress(ProcessLookupError):
                proc.kill()
            raise
    out = stdout_buffer.getvalue() if stdout is subprocess.PIPE else None
    if returncode != 0:
        raise CalledProcessError(
            returncode,
            command,
            out or "",
            "\n".join(stderr_lines) if stderr is subprocess.PIPE else "",
        )
    # XXX: branch coverage broken: lines=False in
    # ../../tests/functional/test_command.py::test_basic
    if lines:  # pragma: no branch
        return [] if out is None else out.decode().strip().splitlines()
    return out


def _coerce_command(command: Any, coerce: Callable[[Any], list[str] | str]) -> Any:
    """Return str command if command is tuple[str] otherwise coerced command"""
    return (
        command[0]
        if len(command) == 1 and isinstance(command[0], str)
        else coerce(command)
    )


async def _process_stdout(stream: ByteReceiveStream, buffer: io.BytesIO) -> None:
    async for chunk in stream:
        buffer.write(chunk)


async def _process_stderr(stream: ByteReceiveStream, lines: list[str]) -> None:
    async for line in TextReceiveStream(stream):
        if line := line.rstrip():
            lines.append(line)
            log.debug(f"err: {line}")
