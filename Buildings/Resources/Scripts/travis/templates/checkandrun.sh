#!/bin/bash
# coding: utf-8

# This script shall be run from `modelica-buildings/Buildings`,
# i.e., where the top-level `package.mo` file can be found.
#
# Command line flag -l is for a local run of this script to run simulations and update the checksum.
# Without -l TRAVISRUN is set to false which triggers the comparison of the checksum against HEAD.
# The first argument after the optional flag is for the Modelica tool, defaulting to Dymola.
# The second argument after the optional flag is the fraction of test coverage, for testing purposes only
# (the default value of 1 should be for used for PR against master).
#
# The script performs the following tasks.
# - Generate checksums for all *.mo files within the Templates package, order them
#   based on the file names, and generates the checksum of those checksums.
# - Compare the resulting checksum with the stored value from previous evaluation.
# - If the values differ: run simulation script (*.py),
#                         otherwise do nothing.
# - If all simulations succeed: overwrite stored checksum with new value,
#                               otherwise do nothing.

TRAVISRUN=true
OPTIND=1

while getopts 'l' flag; do
  case "${flag}" in
    l) TRAVISRUN=false;;
    *) echo 'Error in command line parsing' >&2
       exit 1
  esac
done

shift "$(( OPTIND - 1 ))"
SIMULATOR=${1:-Dymola}
FRACTION_TEST_COVERAGE=${2:-1}

# Declare directories that must be checked (with checksum) for each template package.
# Each key is a Modelica package name under Buildings.Templates (with . as separator).
# Each value is a string containing directory paths (relative to `modelica-buildings/Buildings`).
declare -A checksum_dirs=(
  # ["AirHandlersFans"]="Templates/AirHandlersFans
  #                      Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV"
  ["ZoneEquipment"]="Templates/ZoneEquipment
                     Controls/OBC/ASHRAE/G36/TerminalUnits/CoolingOnly
                     Controls/OBC/ASHRAE/G36/TerminalUnits/Reheat"
)
# Declare the python script that must be run for each template package.
# Each key is a Modelica package name under Buildings.Templates (with . as separator).
# Each value is a string containing the script path (relative to `modelica-buildings/Buildings`).
declare -A test_script=(
  # ["AirHandlersFans"]="./Resources/Scripts/travis/templates/VAVMultiZone.py"
  ["ZoneEquipment"]="./Resources/Scripts/travis/templates/VAVBox.py"
)

for type in "${!checksum_dirs[@]}"; do
  # For each system type: compute checksum of checksum of all mo files under corresponding checksum_dirs, and store value.
  checksum="$(
    find ${checksum_dirs[$type]} -type f -name '*.mo' -exec md5sum {} \; \
      | LC_ALL=C sort -f -k 2 \
      | awk '{ print $1; }' \
      | md5sum \
      | awk '{ print $1; }'
  )"
  echo $checksum > "./Resources/Scripts/travis/templates/$type.checksum"

  # Diff/HEAD: only for remote testing.
  # Locally, it is expected that there is some diff/HEAD (and we proceed directly to the next step: diff/master).
  if $TRAVISRUN; then
    diff_checksum="$(git diff --name-only HEAD | grep Resources/Scripts/travis/templates/$type.checksum)"
    if (( $? == 0 )); then
      echo "Computed checksum does not match checksum on HEAD: please commit updated checksum for Templates.$type."
      echo "Computed checksum: $checksum"
      checksum_head=$(git show HEAD:Buildings/Resources/Scripts/travis/templates/$type.checksum 2>/dev/null)
      if [[ -z "$checksum_head" ]]; then
        echo "There is no checksum on HEAD for $type."
      else
        echo "Checksum on HEAD: $checksum_head"
      fi
      exit 1
    fi
  fi

  # Diff/master
  diff_checksum="$(git diff --name-only origin/master | grep Resources/Scripts/travis/templates/$type.checksum)"
  if (( $? == 0 ));  then
    echo "Computed checksum does not match checksum on master."
    echo "Running simulations for models in Templates.$type with $SIMULATOR."
    # Launch simulations (typically several thousands).
    python "${test_script[$type]}" $SIMULATOR $FRACTION_TEST_COVERAGE
    if (( $? != 0 )); then
      if [[ -s unitTestsTemplates.log ]]; then
        printf "Below is the error log.\n\n"
        cat unitTestsTemplates.log
      fi
      exit 1
    fi
  else
    echo "Computed checksum matches checksum on master: no further check performed."
  fi
done

exit 0
