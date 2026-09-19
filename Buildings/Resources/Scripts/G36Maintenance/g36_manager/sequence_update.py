from __future__ import annotations

import logging
import shutil
from pathlib import Path

from .path_resolver import to_relative_path
from .reporting import SequenceUpdateReport
from .tracker import Tracker
from .version_discovery import discover_versions
from .warning_comment import insert_or_replace_warning_comment


class SequenceUpdateError(RuntimeError):
    """Raised for sequence update failures."""


def _replace_version_text(root_dir: Path, source_version: int, target_version: int) -> None:
    old = f"G36_{source_version}"
    new = f"G36_{target_version}"

    for file_path in root_dir.rglob("*"):
        if not file_path.is_file():
            continue
        if file_path.suffix.lower() not in {".mo", ".mos", ".txt"} and file_path.name != "package.order":
            continue

        content = file_path.read_text(encoding="utf-8")
        if old in content:
            file_path.write_text(content.replace(old, new), encoding="utf-8")


def run_sequence_update(
    library_root: Path | str,
    tracker: Tracker,
    new_version: int,
    dry_run: bool = False,
    logger: logging.Logger | None = None,
) -> SequenceUpdateReport:
    log = logger or logging.getLogger(__name__)
    root = Path(library_root)
    obc_dir = root / "Buildings" / "Controls" / "OBC"  / "ASHRAE"

    versions = discover_versions(obc_dir)
    if not versions:
        raise SequenceUpdateError(f"No G36 versions found under: {obc_dir}")

    latest_version = max(versions)
    if new_version <= latest_version:
        raise SequenceUpdateError(
            f"Version {new_version} must be greater than latest existing version {latest_version}."
        )

    source_dir = obc_dir / f"G36_{latest_version}"
    target_dir = obc_dir / f"G36_{new_version}"
    if target_dir.exists():
        raise SequenceUpdateError(f"Directory G36_{new_version} already exists. Aborting.")

    diverged_set = {
        to_relative_path(mod.modelica_path)
        for mod in tracker.modules
        if new_version in mod.changed_at
    }

    report = SequenceUpdateReport(
        source_version=latest_version,
        target_version=new_version,
        dry_run=dry_run,
    )

    if dry_run:
        for src_mo in source_dir.rglob("*.mo"):
            report.total_mo_files += 1
            rel = src_mo.relative_to(source_dir)
            if rel in diverged_set:
                report.diverged_skips.append(rel)
            else:
                report.warning_inserted += 1
        return report

    created_target = False
    try:
        shutil.copytree(source_dir, target_dir)
        created_target = True

        _replace_version_text(target_dir, latest_version, new_version)

        for mo_file in target_dir.rglob("*.mo"):
            report.total_mo_files += 1
            rel = mo_file.relative_to(target_dir)
            if rel in diverged_set:
                report.diverged_skips.append(rel)
                log.info("SKIPPED warning - module diverged for %s: %s", new_version, rel)
                continue

            content = mo_file.read_text(encoding="utf-8")
            updated = insert_or_replace_warning_comment(content, tracker.base_version)
            mo_file.write_text(updated, encoding="utf-8")
            report.warning_inserted += 1

        return report
    except Exception:
        if created_target and target_dir.exists():
            shutil.rmtree(target_dir)
        raise
