from __future__ import annotations

from g36_manager.warning_comment import insert_or_replace_warning_comment


def test_insert_warning_after_declaration() -> None:
    src = (
        "within Buildings.Controls.OBC.G36_2024.AHUs.MultiZone.VAV;\n"
        "block Controller \"Controller\"\n"
        "  parameter Real k = 1;\n"
        "end Controller;\n"
    )

    out = insert_or_replace_warning_comment(src, 2021)
    assert "// WARNING: DO NOT MODIFY THIS FILE." in out
    assert "(G36_2021)" in out

    lines = out.splitlines()
    assert lines[2].strip() == "// ========================================================================="


def test_replace_existing_warning_idempotent() -> None:
    src = (
        "within Buildings.Controls.OBC.G36_2024.AHUs.MultiZone.VAV;\n"
        "block Controller \"Controller\"\n"
        "  // =========================================================================\n"
        "  // WARNING: DO NOT MODIFY THIS FILE.\n"
        "  // old\n"
        "  // =========================================================================\n"
        "\n"
        "  parameter Real k = 1;\n"
        "end Controller;\n"
    )

    out = insert_or_replace_warning_comment(src, 2021)
    assert out.count("// WARNING: DO NOT MODIFY THIS FILE.") == 1
    assert "// old" not in out
