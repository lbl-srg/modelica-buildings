from __future__ import annotations

import logging
from pathlib import Path

from .path_resolver import to_modelica_path
from .reporting import BugfixPropagationReport, PropagationVersionReport
from .tracker import Tracker
from .version_discovery import discover_versions
from .warning_comment import insert_or_replace_warning_comment


class BugfixPropagationError(RuntimeError):
    """Raised for bug-fix propagation failures."""


def should_propagate(relative_path: Path, target_version: int, tracker: Tracker) -> tuple[bool, str | None]:
    """Return (should_propagate, reason_if_skipped)."""
    modelica_path = to_modelica_path(relative_path)
    module = tracker.lookup(modelica_path)

    if module is None:
        return True, None

    first_change = min(module.changed_at)
    if target_version >= first_change:
        return False, f"diverged at {first_change}"

    if module.obsoleted_after is not None and target_version > module.obsoleted_after:
        return False, f"obsoleted after {module.obsoleted_after}"

    return True, None


def _replace_version_text(content: str, base_version: int, target_version: int) -> str:
    return content.replace(f"G36_{base_version}", f"G36_{target_version}")


def run_bugfix_propagation(
    library_root: Path | str,
    tracker: Tracker,
    dry_run: bool = False,
    logger: logging.Logger | None = None,
) -> BugfixPropagationReport:
    log = logger or logging.getLogger(__name__)

    root = Path(library_root)
    obc_dir = root / "Buildings" / "Controls" / "OBC"
    versions = discover_versions(obc_dir)

    base_version = tracker.base_version
    base_dir = obc_dir / f"G36_{base_version}"
    if not base_dir.exists():
        raise BugfixPropagationError(
            f"Base version directory G36_{base_version} not found."
        )

    target_versions = [v for v in versions if v > base_version]
    for version in target_versions:
        target_dir = obc_dir / f"G36_{version}"
        if not target_dir.exists():
            raise BugfixPropagationError(f"Expected directory G36_{version} not found.")

    base_mo_files = [
        file_path.relative_to(base_dir)
        for file_path in base_dir.rglob("*.mo")
    ]
    base_order_files = [
        file_path.relative_to(base_dir)
        for file_path in base_dir.rglob("package.order")
    ]

    version_reports: list[PropagationVersionReport] = []

    for version in target_versions:
        target_dir = obc_dir / f"G36_{version}"
        version_report = PropagationVersionReport(version=version)

        for rel in base_mo_files:
            do_copy, reason = should_propagate(rel, version, tracker)
            if not do_copy:
                version_report.skipped.append((rel, reason or "skipped"))
                log.info("SKIP %s -> G36_%s: %s", rel.as_posix(), version, reason)
                continue

            source_path = base_dir / rel
            target_path = target_dir / rel

            content = source_path.read_text(encoding="utf-8")
            content = _replace_version_text(content, base_version, version)
            content = insert_or_replace_warning_comment(content, base_version)

            if dry_run:
                log.info("[DRY RUN] WOULD WRITE %s", target_path)
            else:
                target_path.parent.mkdir(parents=True, exist_ok=True)
                target_path.write_text(content, encoding="utf-8")

            version_report.propagated += 1

        for rel in base_order_files:
            src = base_dir / rel
            dst = target_dir / rel
            content = _replace_version_text(src.read_text(encoding="utf-8"), base_version, version)
            if dry_run:
                log.info("[DRY RUN] WOULD WRITE %s", dst)
            else:
                dst.parent.mkdir(parents=True, exist_ok=True)
                dst.write_text(content, encoding="utf-8")

        version_reports.append(version_report)

    return BugfixPropagationReport(
        base_version=base_version,
        per_version=version_reports,
        dry_run=dry_run,
    )
