from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class SequenceUpdateReport:
    source_version: int
    target_version: int
    total_mo_files: int = 0
    warning_inserted: int = 0
    diverged_skips: list[Path] = field(default_factory=list)
    dry_run: bool = False

    def render(self) -> str:
        lines = [
            "=================================================================",
            "G36 Version Management - Sequence Update Summary",
            "=================================================================",
            f"  Source version   : G36_{self.source_version}",
            f"  Target version   : G36_{self.target_version}",
            f"  Total .mo files  : {self.total_mo_files}",
            f"  Warning inserted : {self.warning_inserted}",
            f"  Diverged (no warning) : {len(self.diverged_skips)}",
        ]
        for path in self.diverged_skips:
            lines.append(f"      - {path.as_posix()}")
        lines.extend(
            [
                f"  Dry run          : {'Yes' if self.dry_run else 'No'}",
                "=================================================================",
            ]
        )
        return "\n".join(lines)


@dataclass
class PropagationVersionReport:
    version: int
    propagated: int = 0
    skipped: list[tuple[Path, str]] = field(default_factory=list)


@dataclass
class BugfixPropagationReport:
    base_version: int
    per_version: list[PropagationVersionReport]
    dry_run: bool = False

    def render(self) -> str:
        target_versions = ", ".join(f"G36_{item.version}" for item in self.per_version) or "(none)"
        lines = [
            "=================================================================",
            "G36 Version Management - Bug Fix Propagation Summary",
            "=================================================================",
            f"  Base version     : G36_{self.base_version}",
            f"  Target versions  : {target_versions}",
            "  -----------------------------------------------------------------",
        ]

        for item in self.per_version:
            lines.append(f"  G36_{item.version}:")
            lines.append(f"    Propagated     : {item.propagated:>3}")
            lines.append(f"    Skipped        : {len(item.skipped):>3}")
            for path, reason in item.skipped:
                lines.append(f"      - {path.as_posix()}  ({reason})")
            lines.append("  -----------------------------------------------------------------")

        lines.extend(
            [
                f"  Dry run          : {'Yes' if self.dry_run else 'No'}",
                "=================================================================",
            ]
        )
        return "\n".join(lines)
