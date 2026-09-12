from __future__ import annotations

from pathlib import Path

import pytest

from g36_manager.path_resolver import (
    PathResolutionError,
    to_modelica_path,
    to_relative_path,
)


def test_to_relative_path_roundtrip() -> None:
    modelica_path = "Buildings.Controls.OBC.G36.AHUs.MultiZone.VAV.Controller"
    rel = to_relative_path(modelica_path)
    assert rel == Path("AHUs") / "MultiZone" / "VAV" / "Controller.mo"

    back = to_modelica_path(rel)
    assert back == modelica_path


def test_to_relative_path_invalid_prefix() -> None:
    with pytest.raises(PathResolutionError):
        to_relative_path("Buildings.Controls.OBC.G37.AHUs.Controller")


def test_to_modelica_path_requires_mo_suffix() -> None:
    with pytest.raises(PathResolutionError):
        to_modelica_path(Path("AHUs") / "Controller.txt")
