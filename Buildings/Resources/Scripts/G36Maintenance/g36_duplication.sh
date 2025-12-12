#!/usr/bin/env sh
set -eu

# Usage: ./copy_do_not_change.sh DEST_DIR EXCLUDE_LIST
# - Run this from your "base" directory
# - Recursively copies only files/dirs not listed in EXCLUDE_LIST to DEST_DIR
# - For each copied text file:
#     - Finds the first "..." in the file
#     - Appends " DO NOT CHANGE" inside that first pair of quotes
# - Entries in EXCLUDE_LIST are paths relative to this base directory and are NOT copied.

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 DEST_DIR EXCLUDE_LIST" >&2
  exit 1
fi

DEST="$1"
EXCLUDE_LIST="$2"

if [ ! -f "$EXCLUDE_LIST" ]; then
  echo "Exclude list not found: $EXCLUDE_LIST" >&2
  exit 1
fi

TMP_EXCL="$(mktemp)"
trap 'rm -f -- "$TMP_EXCL"' EXIT

# Normalize exclude entries: strip empty lines and comment lines.
# Paths are interpreted relative to the current base directory.
awk '
  NF == 0       { next }      # skip empty lines
  $1 ~ /^#/     { next }      # skip comment lines
  { print $1 }
' "$EXCLUDE_LIST" > "$TMP_EXCL"

# Check if a *source-relative* path is in the exclude list.
# Example: "config/app.json" or "docs/file.txt".
is_excluded() {
  grep -Fxq -- "$1" "$TMP_EXCL"
}

# Treat as text if grep -Iq sees text
is_text_file() {
  grep -Iq . -- "$1" 2>/dev/null
}

# Append " DO NOT CHANGE" to the first "..." occurrence in a file
add_do_not_change() {
  # $1: file path in DEST tree
  awk '
    BEGIN { done = 0 }
    {
      if (!done) {
        line = $0
        # find first double quote
        pos = index(line, "\"")
        if (pos > 0) {
          rest = substr(line, pos + 1)    # after first quote
          pos2 = index(rest, "\"")        # next quote
          if (pos2 > 0) {
            before = substr(line, 1, pos)         # including first quote
            inside = substr(rest, 1, pos2 - 1)    # between quotes
            after  = substr(rest, pos2 + 1)       # after closing quote

            inside = inside " DO NOT CHANGE"
            $0 = before inside "\"" after
            done = 1
          }
        }
      }
      print
    }
  ' "$1" > "$1.tmp" && mv -- "$1.tmp" "$1"
}

SRC_ROOT=$(cd "./Controls/OBC/ASHRAE/G36-2018/" && pwd)
mkdir -p -- "$SRC_ROOT/../$DEST"
DEST_ROOT=$(cd "$SRC_ROOT/../$DEST" && pwd)


# First: create all necessary directories under DEST, skipping excluded ones
# We treat directories as excluded if they themselves are listed.
find . -type d | while IFS= read -r SRC_DIR; do
  # Remove leading "./"
  REL_DIR=${SRC_DIR#./}

  # Skip base "." directory
  if [ -z "$REL_DIR" ]; then
    continue
  fi

  # If directory itself is excluded, skip creating it and its contents
  if is_excluded "$REL_DIR"; then
    continue
  fi

  mkdir -p -- "$DEST_ROOT/$REL_DIR"
done

# Then: copy files that are not excluded and modify them if text
find . -type f | while IFS= read -r SRC_FILE; do
  # Remove leading "./"
  REL_PATH=${SRC_FILE#./}

  # Skip if this file is in the exclusion list
  if is_excluded "$REL_PATH"; then
    continue
  fi

  DEST_FILE="$DEST_ROOT/$REL_PATH"

  # Ensure destination directory exists (defensive; should already from dir step)
  DEST_DIR=$(dirname "$DEST_FILE")
  mkdir -p -- "$DEST_DIR"

  # Copy file
  cp -p -- "$SRC_FILE" "$DEST_FILE"

  # Only modify text files
  if ! is_text_file "$DEST_FILE"; then
    continue
  fi

  add_do_not_change "$DEST_FILE" || {
    echo "Warning: failed to modify $DEST_FILE" >&2
  }
done
