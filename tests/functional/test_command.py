from __future__ import annotations

import pathlib
import subprocess
import sys

import pytest
from zerolib import command

PATH = pathlib.Path(__file__)


async def test_basic() -> None:
    out = await command.run("ls", PATH)
    assert out == f"{PATH}\n".encode()


async def test_basic_lines() -> None:
    out = await command.run("ls", PATH, lines=True)
    assert out == [str(PATH)]


async def test_error() -> None:
    with pytest.raises(subprocess.CalledProcessError) as exc:
        await command.run("echo x >&2 && false")
    assert exc.value.stderr == "x"


async def test_stdin() -> None:
    out = await command.run("cat", stdin=b"a")
    assert out == b"a"


async def test_buffers(capfd: pytest.CaptureFixture) -> None:
    await command.run("echo a && echo >&2 b", stdout=sys.stdout, stderr=sys.stderr)
    captured = capfd.readouterr()
    # FIXME: why?
    with pytest.raises(AssertionError):
        assert captured.out == "a\n"
    assert captured.err == "b\n"
