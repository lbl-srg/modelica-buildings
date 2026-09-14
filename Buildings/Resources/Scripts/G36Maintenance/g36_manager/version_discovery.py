from __future__ import annotations

import re
from pathlib import Path

_VERSION_DIR_PATTERN = re.compile(r"^G36_(\d{4})$")


class VersionDiscoveryError(RuntimeError):
    """Raised when version directories cannot be discovered."""


def discover_versions(obc_dir: Path | str) -> list[int]:
    """Return sorted list of version years found on disk."""
    directory = Path(obc_dir)
    if not directory.exists():
        raise VersionDiscoveryError(f"OBC directory does not exist: {directory}")
    if not directory.is_dir():
        raise VersionDiscoveryError(f"OBC path is not a directory: {directory}")

    versions: list[int] = []
    for entry in directory.iterdir():
        if not entry.is_dir():
            continue
        match = _VERSION_DIR_PATTERN.match(entry.name)
        if match:
            versions.append(int(match.group(1)))

    return sorted(versions)
