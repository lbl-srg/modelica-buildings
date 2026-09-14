from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path

from .path_resolver import TRACKER_PREFIX


class TrackerValidationError(ValueError):
    """Raised when tracker content is invalid."""


@dataclass(frozen=True)
class TrackerModule:
    modelica_path: str
    changed_at: tuple[int, ...]
    first_appeared: int
    obsoleted_after: int | None


@dataclass(frozen=True)
class Tracker:
    base_version: int
    modules: tuple[TrackerModule, ...]

    def lookup(self, modelica_path: str) -> TrackerModule | None:
        for mod in self.modules:
            if mod.modelica_path == modelica_path:
                return mod
        return None


def _validate_module(module: dict) -> TrackerModule:
    required_keys = {
        "modelica_path",
        "changed_at",
        "first_appeared",
        "obsoleted_after",
    }
    missing = required_keys.difference(module.keys())
    if missing:
        missing_keys = ", ".join(sorted(missing))
        raise TrackerValidationError(f"Module entry missing keys: {missing_keys}")

    modelica_path = module["modelica_path"]
    changed_at = module["changed_at"]
    first_appeared = module["first_appeared"]
    obsoleted_after = module["obsoleted_after"]

    if not isinstance(modelica_path, str):
        raise TrackerValidationError("modelica_path must be a string.")
    if not modelica_path.startswith(f"{TRACKER_PREFIX}."):
        raise TrackerValidationError(
            f"modelica_path must use prefix '{TRACKER_PREFIX}.': {modelica_path}"
        )

    if not isinstance(changed_at, list) or not changed_at:
        raise TrackerValidationError(
            f"changed_at must be a non-empty list for module {modelica_path}."
        )
    if any(not isinstance(year, int) for year in changed_at):
        raise TrackerValidationError(
            f"changed_at must contain only integers for module {modelica_path}."
        )
    if changed_at != sorted(changed_at):
        raise TrackerValidationError(
            f"changed_at must be sorted ascending for module {modelica_path}."
        )

    if not isinstance(first_appeared, int):
        raise TrackerValidationError(
            f"first_appeared must be int for module {modelica_path}."
        )
    if first_appeared > min(changed_at):
        raise TrackerValidationError(
            f"first_appeared ({first_appeared}) must be <= min(changed_at) "
            f"({min(changed_at)}) for module {modelica_path}."
        )

    if obsoleted_after is not None and not isinstance(obsoleted_after, int):
        raise TrackerValidationError(
            f"obsoleted_after must be int or null for module {modelica_path}."
        )
    if obsoleted_after is not None and obsoleted_after < max(changed_at):
        raise TrackerValidationError(
            f"obsoleted_after ({obsoleted_after}) must be >= max(changed_at) "
            f"({max(changed_at)}) for module {modelica_path}."
        )

    return TrackerModule(
        modelica_path=modelica_path,
        changed_at=tuple(changed_at),
        first_appeared=first_appeared,
        obsoleted_after=obsoleted_after,
    )


def load_tracker(tracker_path: Path | str) -> Tracker:
    path = Path(tracker_path)
    if not path.exists():
        raise TrackerValidationError(f"Tracker file not found: {path}")

    try:
        raw = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as err:
        raise TrackerValidationError(
            f"Tracker file is not valid JSON: {path}: {err}"
        ) from err

    if not isinstance(raw, dict):
        raise TrackerValidationError("Tracker root must be a JSON object.")

    if "base_version" not in raw or "modules" not in raw:
        raise TrackerValidationError("Tracker must contain 'base_version' and 'modules'.")

    base_version = raw["base_version"]
    modules_raw = raw["modules"]

    if not isinstance(base_version, int):
        raise TrackerValidationError("base_version must be an integer.")
    if not isinstance(modules_raw, list):
        raise TrackerValidationError("modules must be a list.")

    modules: list[TrackerModule] = []
    seen_paths: set[str] = set()
    for item in modules_raw:
        if not isinstance(item, dict):
            raise TrackerValidationError("Each module entry must be an object.")
        parsed = _validate_module(item)
        if parsed.modelica_path in seen_paths:
            raise TrackerValidationError(
                f"Duplicate module entry: {parsed.modelica_path}"
            )
        seen_paths.add(parsed.modelica_path)
        modules.append(parsed)

    return Tracker(base_version=base_version, modules=tuple(modules))
