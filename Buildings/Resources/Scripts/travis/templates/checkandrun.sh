#!/bin/bash
# coding: utf-8

# This script shall be run from the top level directory within `modelica-buildings`,
# i.e., where `./Buildings` can be found.
# The script performs the following tasks.
# - Generate checksums for all *.mo files within Buildings/Templates, order them
#   based on the file names, and generates the checksum of those checksums.
# - Compare the resulting checksum with the stored value from previous evaluation.
# - If the values differ: run simulation script (*.py),
#                         otherwise do nothing.
# - If all simulations succeed: overwrite stored checksum with new value,
#                               otherwise do nothing.

# Command line flag -t sets TRAVISRUN=true which triggers the comparison of the checksum against HEAD.
# Not using -t is for a local run of this script to run simulations and update the checksum.
TRAVISRUN=false
OPTIND=1

while getopts 't' flag; do
    case "${flag}" in
        t) TRAVISRUN=true;;
        *) echo 'Error in command line parsing' >&2
            exit 1
    esac
done

shift "$(( OPTIND - 1 ))"
SIMULATOR=${1:-Dymola}

DEBUG="$(find ./Buildings/Templates/. -type f -name *.mo -exec md5sum {} \; | env -i LC_COLLATE=C sort -f -k 2)"
echo $DEBUG

CHECKSUM="$(find ./Buildings/Templates/. -type f -name *.mo -exec md5sum {} \; | env -i LC_COLLATE=C sort -f -k 2 | awk '{ print $1; }' | md5sum | awk '{ print $1; }')"
echo $CHECKSUM > ./Buildings/Resources/Scripts/travis/templates/checksum

# Diff / HEAD
if $TRAVISRUN; then
    DIFFCHECKSUM="$(git diff --name-only HEAD | grep 'Buildings/Resources/Scripts/travis/templates/checksum')"

    if [[ $? == 0 ]]; then
        echo "Computed checksum does not match checksum on HEAD: please commit updated checksum for Buildings/Templates."
        echo "Checksum on HEAD:"
        git show HEAD:Buildings/Resources/Scripts/travis/templates/checksum
        echo "Computed checksum:"
        echo $CHECKSUM
        exit 1
    fi
fi

# Diff / master
DIFFCHECKSUM="$(git diff --name-only origin/master | grep 'Buildings/Resources/Scripts/travis/templates/checksum')"

if [[ $? == 0 ]]; then
    echo "Computed checksum does not match checksum on master: running simulations for models in Buildings/Templates."
    # Launch simulations (typically several thousands).
    r=
    ./Buildings/Resources/Scripts/travis/templates/BoilerPlant.py $SIMULATOR
    r=$r$?
    (($r==0))
    if [[ $? == 0 ]]; then
        echo "Simulations succeded."
        exit 0
    else
        echo "Some simulations failed."
        exit 1
    fi
else
    echo "Computed checksum matches checksum on master: no further check performed."
    exit 0
fi
