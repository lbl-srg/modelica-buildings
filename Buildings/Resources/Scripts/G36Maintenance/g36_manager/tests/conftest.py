from __future__ import annotations

import shutil
from pathlib import Path

import pytest


@pytest.fixture
def fixtures_dir() -> Path:
    return Path(__file__).parent / "fixtures"


@pytest.fixture
def sample_tracker_path(fixtures_dir: Path) -> Path:
    return fixtures_dir / "sample_tracker.json"


@pytest.fixture
def sample_library_copy(tmp_path: Path, fixtures_dir: Path) -> Path:
    src = fixtures_dir / "sample_library"
    dst = tmp_path / "sample_library"
    shutil.copytree(src, dst)
    return dst
