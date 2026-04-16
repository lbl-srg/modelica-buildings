from __future__ import annotations

import re


class WarningInsertionError(ValueError):
    """Raised when warning comments cannot be inserted into Modelica source."""


_SENTINEL = "// WARNING: DO NOT MODIFY THIS FILE."
_CLASS_DECL_RE = re.compile(
    r"^\s*(?:partial\s+)?(?:encapsulated\s+)?(?:expandable\s+)?"
    r"(?:model|block|package|function|record|connector|class|type)\b"
)


def warning_lines(base_version: int) -> list[str]:
    return [
        "  // =========================================================================",
        "  // WARNING: DO NOT MODIFY THIS FILE.",
        f"  // All changes must be made in the base version (G36_{base_version}) and propagated",
        "  // using the G36 version management tool.",
        "  // =========================================================================",
        "",
    ]


def _strip_existing_warning(lines: list[str]) -> list[str]:
    out: list[str] = []
    i = 0
    while i < len(lines):
        if _SENTINEL not in lines[i]:
            out.append(lines[i])
            i += 1
            continue

        start = max(0, i - 1)
        while start > 0 and lines[start - 1].strip().startswith("//"):
            start -= 1

        end = i
        while end + 1 < len(lines) and lines[end + 1].strip().startswith("//"):
            end += 1
        if end + 1 < len(lines) and lines[end + 1].strip() == "":
            end += 1

        out.extend(lines[:start])
        lines = lines[end + 1 :]
        i = 0

    out.extend(lines)
    return out


def _find_insert_index(lines: list[str]) -> int:
    found_class_line = False

    for i, line in enumerate(lines):
        if not found_class_line and _CLASS_DECL_RE.match(line):
            found_class_line = True

            quote_count = line.count('"') - line.count('\\"')
            if quote_count == 0 or quote_count % 2 == 0:
                return i + 1
            continue

        if found_class_line:
            quote_count = line.count('"') - line.count('\\"')
            if quote_count % 2 == 1:
                return i + 1

    raise WarningInsertionError("Could not locate class declaration in file content.")


def insert_or_replace_warning_comment(content: str, base_version: int) -> str:
    """Insert warning after class declaration, replacing existing warning if present."""
    lines = content.splitlines()
    lines = _strip_existing_warning(lines)

    insert_index = _find_insert_index(lines)
    lines[insert_index:insert_index] = warning_lines(base_version)
    return "\n".join(lines) + ("\n" if content.endswith("\n") else "")
