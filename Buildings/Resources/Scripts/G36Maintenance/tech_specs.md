# Technical Specification: G36 Version Management Tool

---

## 1. Overview

| Field | Details |
|---|---|
| **Feature Name** | G36 Version Management Tool |
| **Date** | *(today)* |
| **Status** | Draft |
| **Language** | Python |
| **Domain** | Modelica Buildings Library — `Buildings.Controls.OBC.G36` |

### 1.1 Purpose

This tool automates two maintenance workflows for versioned copies of the ASHRAE Guideline 36 control sequence packages within the Modelica Buildings library:

1. **Sequence Update** — When a new G36 publication is released, create a new versioned package by copying the latest existing version, applying warning comments to all files that are *not* being actively modified for the new release.
2. **Bug Fix Propagation** — When a bug is fixed in the base (authoritative) version, propagate that fix to all later versioned packages, skipping modules that have intentionally diverged.

A **tracker** (JSON file) serves as the single source of truth for which modules have diverged across versions.

---

## 2. Glossary

| Term | Definition |
|---|---|
| **G36 package** | A Modelica package implementing ASHRAE Guideline 36 sequences (e.g., `G36_2021`). |
| **Version year** | The ASHRAE G36 publication year a package corresponds to (e.g., `2021`, `2024`). |
| **Base version** | The earliest *supported* version year. All bug fixes originate here. Not necessarily the earliest year in the tracker. |
| **Module** | A single `.mo` file representing a Modelica class. |
| **Tracker** | A JSON file listing modules that have intentionally diverged from the base due to G36 document changes. |
| **Warning comment** | A Modelica line comment inserted into copied files instructing developers not to modify them directly. |
| **Diverged module** | A module listed in the tracker whose content differs from the base version due to a G36 specification change. |

---

## 3. System Context

### 3.1 Package Layout on Disk

Each G36 version year is a separate top-level Modelica package under `Buildings/Controls/OBC/`:

```
<library_root>/
└── Buildings/
    └── Controls/
        └── OBC/
            ├── G36_2021/                ← base version
            │   ├── package.mo
            │   ├── package.order
            │   ├── AHUs/
            │   │   ├── package.mo
            │   │   ├── package.order
            │   │   └── MultiZone/
            │   │       └── VAV/
            │   │           ├── Controller.mo
            │   │           └── ...
            │   └── ThermalZones/
            │       └── ...
            ├── G36_2024/
            │   ├── package.mo
            │   ├── ...  (same internal structure, paths reference G36_2024)
            │   └── ...
            └── ...
```

**Key structural rules:**

- All version packages share the same internal directory/file hierarchy.
- Inside each `.mo` file, `within` clauses and internal references use the version-specific package name (e.g., `Buildings.Controls.OBC.G36_2024.AHUs`).
- `package.order` files are plain-text lists of class names (no Modelica syntax).

### 3.2 Tracker File Schema

**File:** `g36_tracker.json`

```json
{
  \"base_version\": 2021,
  \"modules\": [
    {
      \"modelica_path\": \"Buildings.Controls.OBC.G36.AHUs.MultiZone.VAV.Controller\",
      \"changed_at\": [2024],
      \"first_appeared\": 2021,
      \"obsoleted_after\": null
    },
    {
      \"modelica_path\": \"Buildings.Controls.OBC.G36.ZoneGroups.ZoneStatus\",
      \"changed_at\": [2021, 2024],
      \"first_appeared\": 2018,
      \"obsoleted_after\": null
    },
    {
      \"modelica_path\": \"Buildings.Controls.OBC.G36.Legacy.OldController\",
      \"changed_at\": [2021],
      \"first_appeared\": 2018,
      \"obsoleted_after\": 2021
    }
  ]
}
```

**Field definitions:**

| Field | Type | Description |
|---|---|---|
| `base_version` | `int` | The base (authoritative) version year. |
| `modules` | `list[object]` | List of diverged module entries. |
| `modules[].modelica_path` | `string` | Version-agnostic Modelica path. Uses `G36` (no year suffix) as a placeholder. |
| `modules[].changed_at` | `list[int]` | Sorted ascending list of version years at which the module's content diverged from its predecessor. |
| `modules[].first_appeared` | `int` | Version year the module was first introduced. |
| `modules[].obsoleted_after` | `int \\| null` | Last version year the module existed in before removal. `null` if still active. |

**Validation rules:**

- `changed_at` must be sorted ascending.
- `first_appeared <= min(changed_at)`.
- If `obsoleted_after` is not null: `obsoleted_after >= max(changed_at)`.
- `modelica_path` must use the prefix `Buildings.Controls.OBC.G36.`.

### 3.3 Path Resolution

The tracker uses **version-agnostic** Modelica paths. Resolution to a concrete file on disk requires mapping through a specific version year.

```
Tracker path :  Buildings.Controls.OBC.G36.AHUs.MultiZone.VAV.Controller
                ├────── common prefix ──────┤  ├── relative part ────────┤

Version 2024 :  Buildings.Controls.OBC.G36_2024.AHUs.MultiZone.VAV.Controller

File path    :  <library_root>/Buildings/Controls/OBC/G36_2024/AHUs/MultiZone/VAV/Controller.mo
```

**Conversion logic:**

```python
TRACKER_PREFIX = \"Buildings.Controls.OBC.G36\"

def to_relative_path(modelica_path: str) -> str:
    \"\"\"Tracker Modelica path → relative file path within a G36_XXXX directory.\"\"\"
    suffix = modelica_path[len(TRACKER_PREFIX) + 1:]   # \"AHUs.MultiZone.VAV.Controller\"
    return suffix.replace(\".\", os.sep) + \".mo\"          # \"AHUs/MultiZone/VAV/Controller.mo\"

def to_modelica_path(relative_path: str) -> str:
    \"\"\"Relative file path within G36_XXXX → tracker Modelica path.\"\"\"
    no_ext = relative_path.removesuffix(\".mo\")
    parts = no_ext.replace(os.sep, \".\")
    return f\"{TRACKER_PREFIX}.{parts}\"
```

### 3.4 Version Discovery

Available G36 versions are discovered at runtime by scanning the filesystem:

```python
def discover_versions(obc_dir: str) -> list[int]:
    \"\"\"Return sorted list of version years found on disk.\"\"\"
    pattern = re.compile(r\"^G36_(\\d{4})$\")
    versions = []
    for entry in os.scandir(obc_dir):
        if entry.is_dir():
            m = pattern.match(entry.name)
            if m:
                versions.append(int(m.group(1)))
    return sorted(versions)
```

---

## 4. Detailed Design

### 4.1 Function 1 — Sequence Update (New Version Creation)

#### 4.1.1 Trigger

A new ASHRAE G36 publication has been released (e.g., 2027). The developer:

1. Manually updates the tracker with any modules that have changed for the new version year.
2. Runs the script with `sequence-update` mode.

#### 4.1.2 Inputs

| Input | Source | Example |
|---|---|---|
| `new_version` | CLI argument | `2027` |
| `library_root` | CLI argument | `/home/user/buildings-library` |
| `tracker_path` | CLI argument | `g36_tracker.json` |
| `dry_run` | CLI flag (optional) | `--dry-run` |

#### 4.1.3 Derived Values

```python
obc_dir        = <library_root>/Buildings/Controls/OBC/
existing        = discover_versions(obc_dir)            # e.g., [2018, 2021, 2024]
latest_version  = max(existing)                         # 2024
source_dir      = obc_dir / f\"G36_{latest_version}\"     # G36_2024/
target_dir      = obc_dir / f\"G36_{new_version}\"        # G36_2027/
```

#### 4.1.4 Algorithm

```
SEQUENCE-UPDATE(new_version, library_root, tracker):

 1.  Validate inputs:
       - new_version > latest_version
       - target_dir does not already exist
       - Tracker file passes schema validation

 2.  COPY the entire source package directory to target:
       shutil.copytree(source_dir, target_dir)

 3.  RENAME all version-specific identifiers within the copied files:
       For every file in target_dir (recursively):
         Replace all occurrences of f\"G36_{latest_version}\" with f\"G36_{new_version}\"
         (in file contents — covers `within` clauses, references, annotations, etc.)

 4.  BUILD the set of diverged module relative paths for this new version:
       diverged_set = set()
       For each module in tracker.modules:
         if new_version in module.changed_at:
           diverged_set.add( to_relative_path(module.modelica_path) )

 5.  INSERT warning comments:
       For every .mo file in target_dir (recursively):
         relative = file path relative to target_dir
         if relative NOT in diverged_set:
           insert_warning_comment(file, tracker.base_version)
         else:
           log: \"SKIPPED warning — module diverged for {new_version}\"

 6.  Log summary.
```

#### 4.1.5 `buildingspy` Integration

The preferred approach uses **`shutil.copytree`** for the filesystem copy combined with **manual string replacement** for renaming, because:

- `buildingspy.development.refactor.Refactor.move_class()` performs a **move**, not a copy.
- A copy + bulk rename is simpler and more predictable for an entire package.

**Use `buildingspy` for:**

| Utility | Purpose |
|---|---|
| `buildingspy.development.refactor.write_package_order()` | Regenerate `package.order` files if class names change (unlikely in this workflow but available as a safety net). |
| `buildingspy.development.verificationtest` | Post-copy validation — ensure the copied package is syntactically valid. |

> If a future `buildingspy` release adds a `copy_class()` API, it should be preferred over `shutil.copytree` + manual renaming.

#### 4.1.6 Output

- New directory `G36_{new_version}/` on disk.
- All `.mo` files contain updated version-specific paths.
- Non-diverged `.mo` files contain warning comments.
- Console summary report.

---

### 4.2 Function 2 — Bug Fix Propagation

#### 4.2.1 Trigger

A developer has fixed a bug in a module within the **base** version package (e.g., `G36_2021`). The fix needs to be propagated to all later versioned packages that still share the same (un-diverged) copy of that module.

#### 4.2.2 Inputs

| Input | Source | Example |
|---|---|---|
| `library_root` | CLI argument | `/home/user/buildings-library` |
| `tracker_path` | CLI argument | `g36_tracker.json` |
| `dry_run` | CLI flag (optional) | `--dry-run` |

#### 4.2.3 Derived Values

```python
base_version    = tracker.base_version                   # 2021
base_dir        = obc_dir / f\"G36_{base_version}\"        # G36_2021/
target_versions = [v for v in discover_versions(obc_dir)
                   if v > base_version]                   # [2024, 2027]
```

#### 4.2.4 Skip Logic

For each `.mo` file in the base package being considered for propagation to target version `v`:

```
SHOULD-PROPAGATE(relative_path, target_version, tracker) → bool:

  modelica_path = to_modelica_path(relative_path)
  module = tracker.lookup(modelica_path)

  IF module is None:
      RETURN True                          # Not in tracker → always propagate

  # Module is in the tracker (it has diverged at some version)
  first_change = min(module.changed_at)

  IF target_version >= first_change:
      RETURN False                         # Target is at or beyond divergence point
      Reason: \"Module diverged at version {first_change}\"

  IF module.obsoleted_after is not None AND target_version > module.obsoleted_after:
      RETURN False                         # Module no longer exists in this version
      Reason: \"Module obsoleted after version {module.obsoleted_after}\"

  RETURN True                              # Safe to propagate
```

**Worked examples:**

| Module | `changed_at` | `obsoleted_after` | Target `2023` | Target `2024` | Target `2027` |
|---|---|---|---|---|---|
| `AHUs.Controller` | `[2024]` | `null` | ✅ Propagate | ❌ Diverged@2024 | ❌ Diverged@2024 |
| `ZoneGroups.Status` | `[2021, 2024]` | `null` | ❌ Diverged@2021 | ❌ Diverged@2021 | ❌ Diverged@2021 |
| `Legacy.OldCtrl` | `[2021]` | `2021` | ❌ Obsoleted | ❌ Obsoleted | ❌ Obsoleted |
| `Dampers.Valve` | *(not in tracker)* | — | ✅ Propagate | ✅ Propagate | ✅ Propagate |

#### 4.2.5 Algorithm

```
PROPAGATE-BUGFIX(library_root, tracker):

 1.  Validate inputs:
       - base_dir exists
       - All target version directories exist
       - Tracker file passes schema validation

 2.  COLLECT all .mo files in base_dir:
       base_files = walk base_dir for *.mo files
       Compute relative paths from base_dir

 3.  For each target_version in target_versions (ascending order):

       target_dir = obc_dir / f\"G36_{target_version}\"

       For each relative_path in base_files:

         a.  Check SHOULD-PROPAGATE(relative_path, target_version, tracker)

         b.  IF should NOT propagate:
               Log: \"SKIP {relative_path} → G36_{target_version}: {reason}\"
               Continue

         c.  Read source file from base_dir / relative_path

         d.  Replace version identifiers in content:
               content = content.replace(f\"G36_{base_version}\", f\"G36_{target_version}\")

         e.  Insert warning comment into content (see §4.3)

         f.  IF dry_run:
               Log: \"WOULD WRITE {target_dir / relative_path}\"
             ELSE:
               Write content to target_dir / relative_path
               Log: \"PROPAGATED {relative_path} → G36_{target_version}\"

 4.  HANDLE non-.mo files (package.order, etc.):
       For each package.order file in base_dir:
         Copy to all target versions (with version string replacement)
         No warning comment.

 5.  Log summary.
```

#### 4.2.6 Output

- Updated `.mo` files in all applicable target version directories.
- Warning comments present in all propagated files.
- Console summary report listing every propagated and skipped file with reasons.

---

### 4.3 Warning Comment Specification

#### 4.3.1 Format

```modelica
  // =========================================================================
  // WARNING: DO NOT MODIFY THIS FILE.
  // All changes must be made in the base version (G36_2021) and propagated
  // using the G36 version management tool.
  // =========================================================================
```

- Uses Modelica `//` line comments.
- Indented with **2 spaces** to match typical Modelica formatting.
- References the base version explicitly so developers know where to go.

#### 4.3.2 Insertion Point

> **After the class declaration line and its description string, before any other content.**

**Example — before:**

```modelica
within Buildings.Controls.OBC.G36_2024.AHUs.MultiZone.VAV;
block Controller \"Multi zone VAV AHU controller based on ASHRAE G36\"

  parameter Real VOutMin_flow(
    final unit=\"m3/s\")
    \"Minimum outdoor airflow rate\";
```

**Example — after:**

```modelica
within Buildings.Controls.OBC.G36_2024.AHUs.MultiZone.VAV;
block Controller \"Multi zone VAV AHU controller based on ASHRAE G36\"
  // =========================================================================
  // WARNING: DO NOT MODIFY THIS FILE.
  // All changes must be made in the base version (G36_2021) and propagated
  // using the G36 version management tool.
  // =========================================================================

  parameter Real VOutMin_flow(
    final unit=\"m3/s\")
    \"Minimum outdoor airflow rate\";
```

#### 4.3.3 Insertion Algorithm

```
INSERT-WARNING-COMMENT(file_content, base_version) → modified_content:

  CLASS_KEYWORDS = {\"model\", \"block\", \"package\", \"function\",
                    \"record\", \"connector\", \"class\", \"type\"}

  lines = file_content.split('\
')
  insert_index = None
  found_class_line = False

  For i, line in enumerate(lines):
    stripped = line.strip()
    tokens = stripped.split()

    # Detect class declaration line
    # Handle optional \"partial\", \"expandable\", etc.
    IF any token in tokens matches a CLASS_KEYWORD at expected position:
      found_class_line = True

    IF found_class_line:
      # Check if description string is present and closed on this line
      IF '\"' in line:
        open_quotes  = count unescaped '\"' characters
        IF open_quotes is even (string opened and closed):
          insert_index = i + 1
          BREAK
      ELSE IF found_class_line AND no '\"' found on class line:
        # No description string — insert right after class declaration
        insert_index = i + 1
        BREAK

  IF insert_index is None:
    RAISE ParseError(\"Could not locate class declaration in file\")

  # Build warning block
  warning = [
    \"  // =========================================================================\",
    \"  // WARNING: DO NOT MODIFY THIS FILE.\",
    f\"  // All changes must be made in the base version (G36_{base_version}) and propagated\",
    \"  // using the G36 version management tool.\",
    \"  // =========================================================================\",
    \"\"   # blank line separator
  ]

  lines[insert_index:insert_index] = warning
  RETURN '\
'.join(lines)
```

#### 4.3.4 Idempotency

Before inserting, check whether the warning block **already exists** (e.g., from a previous run). If found, **replace** it rather than duplicating. Detection is based on the sentinel line `// WARNING: DO NOT MODIFY THIS FILE.`.

---

### 4.4 File Type Handling

| File type | Copy? | Path rename? | Warning comment? |
|---|---|---|---|
| `*.mo` (Modelica class) | ✅ | ✅ | ✅ (if not diverged) |
| `package.order` | ✅ | ❌ (contains class names only, no full paths) | ❌ |
| `*.png`, `*.svg`, `*.html` | ✅ | ❌ | ❌ |
| `*.mos` (Modelica script) | ✅ | ✅ (may contain path references) | ❌ |

---

## 5. Script Interface

### 5.1 CLI Design

```
usage: g36_manager.py <command> [options]

commands:
  sequence-update     Create a new G36 version package from the latest existing version.
  propagate-bugfix    Propagate base version files to all later version packages.

common options:
  --library-root PATH    Path to the root of the Buildings library.
  --tracker PATH         Path to the tracker JSON file.
  --dry-run              Show what would be done without writing any files.
  --log-level LEVEL      Logging level: DEBUG, INFO (default), WARNING.
```

### 5.2 Command: `sequence-update`

```
g36_manager.py sequence-update \\
    --library-root /path/to/buildings \\
    --tracker g36_tracker.json \\
    --new-version 2027 \\
    [--dry-run]
```

| Argument | Required | Description |
|---|---|---|
| `--new-version` | Yes | The new G36 version year to create. |

### 5.3 Command: `propagate-bugfix`

```
g36_manager.py propagate-bugfix \\
    --library-root /path/to/buildings \\
    --tracker g36_tracker.json \\
    [--dry-run]
```

No additional arguments required — the base version and target versions are derived from the tracker and filesystem.

---

## 6. Error Handling

All errors cause the script to **fail hard** with a non-zero exit code and a descriptive message.

| Error Condition | Behavior |
|---|---|
| Tracker file not found or invalid JSON | Fail with schema validation error details. |
| `new_version` ≤ `latest_version` | Fail: `\"Version {new_version} must be greater than latest existing version {latest_version}.\"` |
| Target directory already exists (Function 1) | Fail: `\"Directory G36_{new_version} already exists. Aborting.\"` |
| Base directory does not exist | Fail: `\"Base version directory G36_{base_version} not found.\"` |
| Target version directory missing (Function 2) | Fail: `\"Expected directory G36_{version} not found.\"` |
| Tracker module not found on disk | Fail: `\"Module {modelica_path} not found at expected path {file_path}.\"` |
| Cannot parse class declaration for warning insertion | Fail: `\"Could not parse class declaration in {file_path}.\"` |
| `--dry-run` active | No writes occur; all operations logged at INFO level with `\"[DRY RUN]\"` prefix. On success, exit code 0. |

**Rollback (Function 1 only):** If an error occurs after the directory has been created but before completion, the partially created `G36_{new_version}` directory is **deleted** to avoid leaving inconsistent state.

---

## 7. Logging & Reporting

### 7.1 Log Levels

| Level | Content |
|---|---|
| `DEBUG` | File-by-file read/write operations, regex matches. |
| `INFO` | Each file propagated/skipped, with reason. Summaries. |
| `WARNING` | Unusual but non-fatal situations (e.g., empty `package.order`). |
| `ERROR` | Fatal errors (see §6). |

### 7.2 Summary Report

Printed to stdout at the end of each run:

**Sequence Update example:**

```
=================================================================
G36 Version Management — Sequence Update Summary
=================================================================
  Source version   : G36_2024
  Target version   : G36_2027
  Total .mo files  : 142
  Warning inserted : 137
  Diverged (no warning) : 5
      - AHUs/MultiZone/VAV/Controller.mo
      - AHUs/MultiZone/VAV/SetPoints.mo
      - ThermalZones/ZoneStatus.mo
      - Generic/NewSequence.mo
      - Generic/NewHelper.mo
  Dry run          : No
=================================================================
```

**Bug Fix Propagation example:**

```
=================================================================
G36 Version Management — Bug Fix Propagation Summary
=================================================================
  Base version     : G36_2021
  Target versions  : G36_2024, G36_2027
  -----------------------------------------------------------------
  G36_2024:
    Propagated     : 130
    Skipped        :  12
      - AHUs/MultiZone/VAV/Controller.mo  (diverged at 2024)
      - ZoneGroups/ZoneStatus.mo           (diverged at 2021)
      - Legacy/OldController.mo            (obsoleted after 2021)
      ...
  -----------------------------------------------------------------
  G36_2027:
    Propagated     : 128
    Skipped        :  14
      ...
  -----------------------------------------------------------------
  Dry run          : No
=================================================================
```

---

## 8. Edge Cases & Constraints

| # | Edge Case | Handling |
|---|---|---|
| 1 | Module in tracker has `first_appeared` > `base_version` (doesn't exist in base). | Function 2: File not present in base — nothing to propagate. No error. |
| 2 | Module in tracker has `obsoleted_after` < target version. | Function 2: Skip propagation. Log reason as \"obsoleted.\" |
| 3 | `changed_at` list contains `base_version` itself (module diverged at the base version). | Logically means it diverged from its predecessor; base copy is the authoritative diverged copy. Function 2: `first_change = base_version`, so skip all targets (`target > base` ≥ `first_change`). |
| 4 | No modules in tracker for the new version year (Function 1). | All files get warning comments. Valid scenario. |
| 5 | Base version is the *only* version on disk (Function 2). | `target_versions` is empty. Log info message and exit cleanly. |
| 6 | A `.mo` file exists in a target version but NOT in base (version-specific addition). | Function 2: Not touched — we only iterate over base files. |
| 7 | Warning comment already present from a previous run. | Detect and **replace** (idempotent). See §4.3.4. |
| 8 | Version string `G36_2021` appears inside a Modelica string literal or documentation. | Replaced along with all other occurrences. Acceptable — documentation should reflect the version it lives in. |
| 9 | `package.mo` files. | Treated as `.mo` files — get warning comments (they are Modelica classes). |
| 10 | `package.order` files. | Copied/overwritten. No warning comment. No path renaming (contain short class names, not full paths). |

---

## 9. Dependencies

| Dependency | Version | Purpose |
|---|---|---|
| Python | ≥ 3.9 | `str.removesuffix`, type hints, `os.scandir` |
| `buildingspy` | Latest | `write_package_order()` for validation; future `copy_class()` if available. |
| `shutil` | stdlib | `copytree` for package directory copy (Function 1). |
| `json` | stdlib | Tracker read/write. |
| `re` | stdlib | Version directory discovery, class declaration parsing. |
| `argparse` | stdlib | CLI interface. |
| `logging` | stdlib | Structured logging. |

---

## 10. Python Module Structure

```
g36_manager/
├── g36_manager.py              # Entry point, CLI argument parsing
├── tracker.py                  # Tracker loading, validation, lookup
├── version_discovery.py        # Discover G36_XXXX directories
├── path_resolver.py            # Modelica path ↔ file path conversion
├── warning_comment.py          # Warning insertion/detection/replacement
├── sequence_update.py          # Function 1 implementation
├── bugfix_propagation.py       # Function 2 implementation
├── reporting.py                # Summary report generation
└── tests/
    ├── test_tracker.py
    ├── test_path_resolver.py
    ├── test_warning_comment.py
    ├── test_sequence_update.py
    ├── test_bugfix_propagation.py
    └── fixtures/
        ├── sample_tracker.json
        └── sample_library/     # Minimal Buildings library structure for testing
```

---

## 11. Testing Strategy

| Test Type | Scope | Details |
|---|---|---|
| **Unit** | `tracker.py` | Schema validation, lookup by path, edge cases (null `obsoleted_after`, empty `changed_at`). |
| **Unit** | `path_resolver.py` | Modelica path ↔ file path round-tripping, edge cases (deep nesting, single-level). |
| **Unit** | `warning_comment.py` | Insertion after various class declaration styles (`model`, `block`, `package`, `partial model`, multi-line description strings). Idempotency. |
| **Unit** | Skip logic | `SHOULD-PROPAGATE` function against the worked examples in §4.2.4. |
| **Integration** | `sequence_update.py` | Create a minimal fixture library. Run Function 1. Assert: directory created, paths renamed, warnings present/absent per tracker. |
| **Integration** | `bugfix_propagation.py` | Modify a file in base. Run Function 2. Assert: change appears in non-diverged targets, diverged targets unchanged. |
| **Integration** | `--dry-run` | Run both functions with `--dry-run`. Assert: no files written, log output correct. |
| **Integration** | Error cases | Missing directories, invalid tracker, duplicate version — assert hard failures with correct messages. |

---

