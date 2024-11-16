from __future__ import annotations

import subprocess
import sys

import pytest
from zerolib import command


async def test_basic() -> None:
    assert await command.run("ls", __file__) == f"{__file__}\n".encode()


async def test_basic_lines() -> None:
    assert await command.run("ls", __file__, lines=True) == [__file__]


async def test_error() -> None:
    with pytest.raises(subprocess.CalledProcessError) as exc:
        await command.run("echo x >&2 && false")
    assert exc.value.stderr == "x"


async def test_error_stderr_empty() -> None:
    with pytest.raises(subprocess.CalledProcessError) as exc:
        await command.run("echo ' ' >&2 && false")
    assert exc.value.stderr == ""


async def test_stdin() -> None:
    assert await command.run("cat", stdin=b"a") == b"a"


async def test_buffers(capfd: pytest.CaptureFixture) -> None:  # type: ignore[type-arg]
    await command.run("echo a && echo >&2 b", stdout=sys.stdout, stderr=sys.stderr)
    captured = capfd.readouterr()
    # FIXME: why? assert captured.out == "a\n"
    assert captured.err == "b\n"
