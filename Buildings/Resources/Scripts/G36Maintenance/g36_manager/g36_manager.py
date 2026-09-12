from __future__ import annotations

import argparse
import logging
from pathlib import Path

from .bugfix_propagation import BugfixPropagationError, run_bugfix_propagation
from .sequence_update import SequenceUpdateError, run_sequence_update
from .tracker import TrackerValidationError, load_tracker


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="g36_manager.py",
        description="Manage versioned ASHRAE G36 packages in Buildings.Controls.OBC.",
    )
    parser.add_argument("--library-root", required=True, help="Path to Buildings library root")
    parser.add_argument("--tracker", required=True, help="Path to tracker JSON file")
    parser.add_argument("--dry-run", action="store_true", help="Show actions without writes")
    parser.add_argument(
        "--log-level",
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING"],
        help="Logging verbosity",
    )

    subparsers = parser.add_subparsers(dest="command", required=True)

    seq = subparsers.add_parser(
        "sequence-update",
        help="Create a new G36 version package from the latest existing version.",
    )
    seq.add_argument("--new-version", type=int, required=True, help="New version year")

    subparsers.add_parser(
        "propagate-bugfix",
        help="Propagate base-version fixes to all later version packages.",
    )

    return parser


def _configure_logging(level: str) -> None:
    logging.basicConfig(level=getattr(logging, level), format="%(levelname)s: %(message)s")


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)
    _configure_logging(args.log_level)

    try:
        tracker = load_tracker(Path(args.tracker))

        if args.command == "sequence-update":
            report = run_sequence_update(
                library_root=Path(args.library_root),
                tracker=tracker,
                new_version=args.new_version,
                dry_run=args.dry_run,
            )
            print(report.render())
            return 0

        if args.command == "propagate-bugfix":
            report = run_bugfix_propagation(
                library_root=Path(args.library_root),
                tracker=tracker,
                dry_run=args.dry_run,
            )
            print(report.render())
            return 0

        parser.error(f"Unknown command: {args.command}")
        return 2

    except (TrackerValidationError, SequenceUpdateError, BugfixPropagationError) as err:
        logging.error("%s", err)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
