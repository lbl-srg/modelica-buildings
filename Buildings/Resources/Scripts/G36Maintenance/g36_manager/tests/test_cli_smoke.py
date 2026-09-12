from __future__ import annotations

from pathlib import Path

from g36_manager.g36_manager import main


def test_cli_sequence_update_dry_run_smoke(
    sample_library_copy: Path,
    sample_tracker_path: Path,
    capsys,
) -> None:
    code = main(
        [
            "--library-root",
            str(sample_library_copy),
            "--tracker",
            str(sample_tracker_path),
            "--dry-run",
            "sequence-update",
            "--new-version",
            "2027",
        ]
    )

    captured = capsys.readouterr()
    assert code == 0
    assert "Sequence Update Summary" in captured.out
    assert "G36_2027" in captured.out


def test_cli_propagate_bugfix_dry_run_smoke(
    sample_library_copy: Path,
    sample_tracker_path: Path,
    capsys,
) -> None:
    code = main(
        [
            "--library-root",
            str(sample_library_copy),
            "--tracker",
            str(sample_tracker_path),
            "--dry-run",
            "propagate-bugfix",
        ]
    )

    captured = capsys.readouterr()
    assert code == 0
    assert "Bug Fix Propagation Summary" in captured.out
    assert "G36_2024" in captured.out
