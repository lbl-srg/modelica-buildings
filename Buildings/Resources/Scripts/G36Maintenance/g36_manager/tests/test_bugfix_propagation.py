from __future__ import annotations

from pathlib import Path

from g36_manager.bugfix_propagation import run_bugfix_propagation, should_propagate
from g36_manager.tracker import load_tracker


def test_should_propagate_rules(sample_tracker_path: Path) -> None:
    tracker = load_tracker(sample_tracker_path)

    ok, reason = should_propagate(Path("Common") / "Helper.mo", 2024, tracker)
    assert ok and reason is None

    ok, reason = should_propagate(Path("AHUs") / "MultiZone" / "VAV" / "Controller.mo", 2024, tracker)
    assert not ok
    assert reason == "diverged at 2024"


def test_bugfix_propagation_updates_non_diverged_only(
    sample_library_copy: Path,
    sample_tracker_path: Path,
) -> None:
    tracker = load_tracker(sample_tracker_path)

    base_helper = (
        sample_library_copy
        / "Buildings"
        / "Controls"
        / "OBC"
        / "G36_2021"
        / "Common"
        / "Helper.mo"
    )
    base_helper.write_text(
        "within Buildings.Controls.OBC.G36_2021.Common;\n"
        "block Helper \"Helper\"\n"
        "  parameter Real h = 99;\n"
        "end Helper;\n",
        encoding="utf-8",
    )

    report = run_bugfix_propagation(
        library_root=sample_library_copy,
        tracker=tracker,
        dry_run=False,
    )
    assert report.base_version == 2021
    assert report.per_version

    target_helper = (
        sample_library_copy
        / "Buildings"
        / "Controls"
        / "OBC"
        / "G36_2024"
        / "Common"
        / "Helper.mo"
    )
    helper_text = target_helper.read_text(encoding="utf-8")
    assert "parameter Real h = 99;" in helper_text
    assert "G36_2024.Common" in helper_text
    assert "WARNING: DO NOT MODIFY THIS FILE." in helper_text

    target_diverged = (
        sample_library_copy
        / "Buildings"
        / "Controls"
        / "OBC"
        / "G36_2024"
        / "AHUs"
        / "MultiZone"
        / "VAV"
        / "Controller.mo"
    )
    diverged_text = target_diverged.read_text(encoding="utf-8")
    assert "Controller diverged" in diverged_text


def test_bugfix_propagation_dry_run_no_changes(
    sample_library_copy: Path,
    sample_tracker_path: Path,
) -> None:
    tracker = load_tracker(sample_tracker_path)

    original = (
        sample_library_copy
        / "Buildings"
        / "Controls"
        / "OBC"
        / "G36_2024"
        / "Common"
        / "Helper.mo"
    ).read_text(encoding="utf-8")

    run_bugfix_propagation(
        library_root=sample_library_copy,
        tracker=tracker,
        dry_run=True,
    )

    after = (
        sample_library_copy
        / "Buildings"
        / "Controls"
        / "OBC"
        / "G36_2024"
        / "Common"
        / "Helper.mo"
    ).read_text(encoding="utf-8")
    assert after == original
