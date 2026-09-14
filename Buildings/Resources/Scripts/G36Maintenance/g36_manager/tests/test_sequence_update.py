from __future__ import annotations

from pathlib import Path

from g36_manager.sequence_update import run_sequence_update
from g36_manager.tracker import load_tracker


def test_sequence_update_creates_new_version(sample_library_copy: Path, sample_tracker_path: Path) -> None:
    tracker = load_tracker(sample_tracker_path)

    report = run_sequence_update(
        library_root=sample_library_copy,
        tracker=tracker,
        new_version=2027,
        dry_run=False,
    )

    assert report.source_version == 2024
    assert report.target_version == 2027

    target_dir = (
        sample_library_copy
        / "Buildings"
        / "Controls"
        / "OBC"
        / "G36_2027"
    )
    assert target_dir.exists()

    helper = target_dir / "Common" / "Helper.mo"
    helper_text = helper.read_text(encoding="utf-8")
    assert "G36_2027.Common" in helper_text
    assert "WARNING: DO NOT MODIFY THIS FILE." in helper_text

    diverged = target_dir / "AHUs" / "MultiZone" / "VAV" / "Controller.mo"
    diverged_text = diverged.read_text(encoding="utf-8")
    assert "G36_2027.AHUs.MultiZone.VAV" in diverged_text
    assert "WARNING: DO NOT MODIFY THIS FILE." in diverged_text


def test_sequence_update_dry_run_no_changes(sample_library_copy: Path, sample_tracker_path: Path) -> None:
    tracker = load_tracker(sample_tracker_path)

    report = run_sequence_update(
        library_root=sample_library_copy,
        tracker=tracker,
        new_version=2027,
        dry_run=True,
    )

    assert report.total_mo_files > 0
    assert not (
        sample_library_copy
        / "Buildings"
        / "Controls"
        / "OBC"
        / "G36_2027"
    ).exists()
