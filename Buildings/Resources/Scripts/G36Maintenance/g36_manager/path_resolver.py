from __future__ import annotations

from pathlib import Path

TRACKER_PREFIX = "Buildings.Controls.OBC.G36"


class PathResolutionError(ValueError):
    """Raised when a tracker path cannot be resolved."""


def to_relative_path(modelica_path: str) -> Path:
    """Tracker Modelica path -> relative file path within a G36_XXXX directory."""
    prefix = f"{TRACKER_PREFIX}."
    if not modelica_path.startswith(prefix):
        raise PathResolutionError(
            f"Modelica path must start with '{prefix}', got: {modelica_path}"
        )

    suffix = modelica_path[len(prefix) :]
    if not suffix:
        raise PathResolutionError("Modelica path suffix cannot be empty.")
    return Path(*suffix.split(".")).with_suffix(".mo")


def to_modelica_path(relative_path: Path | str) -> str:
    """Relative file path within G36_XXXX -> tracker Modelica path."""
    path = Path(relative_path)
    if path.suffix != ".mo":
        raise PathResolutionError(
            f"Expected a .mo file for Modelica path conversion, got: {path}"
        )

    no_ext = path.with_suffix("")
    parts = [part for part in no_ext.parts if part and part != "."]
    if not parts:
        raise PathResolutionError("Relative path cannot be empty.")

    return f"{TRACKER_PREFIX}.{'.'.join(parts)}"
