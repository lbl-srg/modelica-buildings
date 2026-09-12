# G36 Version Management Tool

This package implements maintenance workflows for versioned `Buildings.Controls.OBC.G36_YYYY` packages.

## Commands

Run from `Buildings/Resources/Scripts/G36Maintenance`.

```bash
python -m g36_manager.g36_manager sequence-update \
  --library-root <path-to-library-root> \
  --tracker <path-to-g36_tracker.json> \
  --new-version 2027 \
  [--dry-run]
```

```bash
python -m g36_manager.g36_manager propagate-bugfix \
  --library-root <path-to-library-root> \
  --tracker <path-to-g36_tracker.json> \
  [--dry-run]
```

## Options

- `--library-root`: Root directory that contains `Buildings/Controls/OBC`.
- `--tracker`: JSON tracker file with divergence metadata.
- `--dry-run`: Logs actions without writing files.
- `--log-level`: `DEBUG`, `INFO` (default), or `WARNING`.

## Module Layout

- `g36_manager.py`: CLI entrypoint and argument parsing.
- `tracker.py`: Tracker loading, validation, and lookup.
- `version_discovery.py`: Detects available `G36_YYYY` packages.
- `path_resolver.py`: Tracker path <-> relative file mapping.
- `warning_comment.py`: Warning insertion/replacement logic.
- `sequence_update.py`: New version creation workflow.
- `bugfix_propagation.py`: Base fix propagation workflow.
- `reporting.py`: Summary report models and rendering.

## Testing

```bash
python -m pytest g36_manager/tests -q
```

The test suite includes unit tests for core logic and integration-style tests using fixture directories.
