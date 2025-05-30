#!/bin/bash
# coding: utf-8

# This script shall be run from `modelica-buildings/Buildings`,
# i.e., where the top-level `package.mo` file can be found.
#
# Command line flags: see the code for argument parsing, case * ).
#
# The script performs the following tasks.
# - Generate checksums for all *.mo files within the Templates package, order them
#   based on the file names, and generates the checksum of those checksums.
# - Compare the resulting checksum with the stored value from previous evaluation.
# - If the values differ: run simulation script (*.py),
#                         otherwise do nothing.
# - If all simulations succeed: overwrite stored checksum with new value,
#                               otherwise do nothing.
#
# To update the checksum and skip all simulations, execute:
# ./Resources/Scripts/travis/templates/checkandrun.sh --checksum --skip
#
# To update the checksum and check that it matches the value from the last commit, execute:
# ./Resources/Scripts/travis/templates/checkandrun.sh --checksum --skip --diffhead
#
# To update the checksums and run simulations, execute:
# ./Resources/Scripts/travis/templates/checkandrun.sh --checksum [--tool SIMULATOR]
#

DIFFHEAD=false
SKIP=false
USE_CHECKSUM=false
SIMULATOR=Dymola
FRACTION_TEST_COVERAGE=1

CGREEN='\033[0;32m'
CRED='\033[0;31m'
CEND='\033[0m'

while [[ "$1" != "" ]]; do
  case $1 in
    --diffhead )
      DIFFHEAD=true
      ;;
    --skip )
      SKIP=true
      ;;
    --checksum )
      USE_CHECKSUM=true
      ;;
    --tool )
      shift
      if [[ "$1" == "Dymola" ]] || [[ "$1" == "Optimica" ]]; then
        SIMULATOR="$1"
      else
        echo "$0: $1 is not a valid Modelica tool, only Dymola and Optimica are allowed." >&2
        exit 1
      fi
      ;;
    --cover )
      shift
      if (( $(echo "$1 > 0.0" | bc -l) )) && (( $(echo "$1 <= 1.0" | bc -l) )); then
        FRACTION_TEST_COVERAGE=$1
      else
        echo "$0: $1 is not a valid fraction of test coverage, it must be within ]0, 1]." >&2
        exit 1
      fi
      ;;
    * )
        echo "Invalid option: $1"
        echo "Usage: checkandrun.sh --checksum [--local] [--skip] [--tool SIMULATOR] [--cover FRACTION_TEST_COVERAGE]"
        echo "     --checksum triggers testing based on checksum verification (only method currently available, mandatory option)."
        echo "     --diffhead is to check that the current checksum matches the value from the last commit."
        echo "     --skip disables all simulations (use this option to simply update the checksums locally)."
        echo "     --tool allows specifying the Modelica tool to be used, defaulting to Dymola."
        echo "     --cover allows specifying the fraction of test coverage, defaulting to 1."
        exit 1
       ;;
  esac
  shift
done

# Declare directories that must be checked (with checksum) for each template package.
# Each key is a Modelica package name under Buildings.Templates (with . as separator).
# Each value is a string containing directory paths (relative to `modelica-buildings/Buildings`).
declare -A checksum_dirs=(
  ["AirHandlersFans"]="Templates/AirHandlersFans
                       Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV"
  ["ZoneEquipment"]="Templates/ZoneEquipment
                     Controls/OBC/ASHRAE/G36/TerminalUnits/CoolingOnly
                     Controls/OBC/ASHRAE/G36/TerminalUnits/Reheat"
  ["Plants.HeatPumps"]="Templates/Plants/HeatPumps
                        Templates/Plants/Controls"
)
# Declare the python script that must be run for each template package.
# Each key is a Modelica package name under Buildings.Templates (with . as separator).
# Each value is a string containing the script path (relative to `modelica-buildings/Buildings`).
declare -A test_script=(
  ["AirHandlersFans"]="./Resources/Scripts/travis/templates/VAVMultiZone.py"
  ["ZoneEquipment"]="./Resources/Scripts/travis/templates/VAVBox.py"
  ["Plants.HeatPumps"]="./Resources/Scripts/travis/templates/Plants.HeatPumps.py"
)

for type in "${!test_script[@]}"; do
  echo "*** Testing ${type} templates. ***"
  if [ "$USE_CHECKSUM" = true ]; then
    # For each system type: compute checksum of checksum of all mo files under corresponding checksum_dirs, and store value.
    checksum="$(
      find ${checksum_dirs[$type]} -type f -name '*.mo' -exec md5sum {} \; \
        | LC_ALL=C sort -f -k 2 \
        | awk '{ print $1; }' \
        | md5sum \
        | awk '{ print $1; }'
    )"
    echo $checksum > "./Resources/Scripts/travis/templates/$type.checksum"

    # Add checksum file to the index so that differences show up in git diff even if file was never added before.
    git add --intent-to-add "./Resources/Scripts/travis/templates/$type.checksum"

    # Diff/HEAD
    if [ "$DIFFHEAD" = true ]; then
      diff_checksum="$(git diff --name-only HEAD | grep Resources/Scripts/travis/templates/$type.checksum)"
      if (( $? == 0 )); then
        printf "${CRED}Computed checksum does not match checksum on HEAD${CEND}: please commit updated checksum for Templates.%s.\n" $type
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
    git fetch origin master
    diff_checksum="$(git diff --name-only origin/master Resources/Scripts/travis/templates | grep Resources/Scripts/travis/templates/$type.checksum)"
    if (( $? == 0 ));  then
      echo "Computed checksum does not match checksum on master."
      if [ "$SKIP" = false ]; then
        echo "Running ${test_script[$type]} with --tool $SIMULATOR."
        python "${test_script[$type]}" --generate --simulate --tool $SIMULATOR --coverage $FRACTION_TEST_COVERAGE
        if (( $? == 0 ));  then
          printf "${CGREEN}All simulations succeeded.${CEND}\n"
        else
          exit 1
        fi
      else
        echo "Simulations are not run because of the --skip argument."
      fi
    else
      echo "Computed checksum matches checksum on master: no further check performed."
    fi
  else
    echo "No --checksum flag is passed, so no test is performed. This is considered improper usage."
    exit 1
  fi
done
