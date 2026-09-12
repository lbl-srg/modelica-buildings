from __future__ import annotations

from pathlib import Path

import pytest

from g36_manager.tracker import TrackerValidationError, load_tracker


def test_load_tracker_success(sample_tracker_path: Path) -> None:
    tracker = load_tracker(sample_tracker_path)
    assert tracker.base_version == 2021
    assert tracker.lookup("Buildings.Controls.OBC.G36.AHUs.MultiZone.VAV.Controller") is not None


def test_load_tracker_invalid_changed_at(tmp_path: Path) -> None:
    tracker_path = tmp_path / "bad.json"
    tracker_path.write_text(
        """
        {
          "base_version": 2021,
          "modules": [
            {
              "modelica_path": "Buildings.Controls.OBC.G36.AHUs.MultiZone.VAV.Controller",
              "changed_at": [2024, 2021],
              "first_appeared": 2021,
              "obsoleted_after": null
            }
          ]
        }
        """,
        encoding="utf-8",
    )

    with pytest.raises(TrackerValidationError):
        load_tracker(tracker_path)
