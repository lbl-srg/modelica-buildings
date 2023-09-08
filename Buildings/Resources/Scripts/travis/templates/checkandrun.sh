#!/bin/bash
# coding: utf-8

# This script shall be run from `modelica-buildings/Buildings`,
# i.e., where the top-level `package.mo` file can be found.
#
# Command line flag -l is for a local run of this script to run simulations and update the checksum.
# Without -l TRAVISRUN is set to false which triggers the comparison of the checksum against HEAD.
# The first argument after the optional flag is for the Modelica tool, defaulting to Dymola.
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

CHECKSUM="$(find ./Templates/. -type f -name *.mo -exec md5sum {} \; | LC_ALL=C sort -f -k 2 | awk '{ print $1; }' | md5sum | awk '{ print $1; }')"
echo $CHECKSUM > ./Resources/Scripts/travis/templates/checksum

# Diff / HEAD
if $TRAVISRUN; then
    DIFFCHECKSUM="$(git diff --name-only HEAD | grep 'Resources/Scripts/travis/templates/checksum')"
    if [[ $? == 0 ]]; then
        echo "Computed checksum does not match checksum on HEAD: please commit updated checksum for Templates."
        echo "Checksum on HEAD:"
        git show HEAD:Buildings/Resources/Scripts/travis/templates/checksum
        echo "Computed checksum:"
        echo $CHECKSUM
        exit 1
    fi
fi

# Diff / master
DIFFCHECKSUM="$(git diff --name-only origin/master | grep 'Resources/Scripts/travis/templates/checksum')"
if [[ $? == 0 ]];  then
    echo "Computed checksum does not match checksum on master."
    echo "Running simulations for models in Templates with $SIMULATOR."
    # Launch simulations (typically several thousands).
    # FIXME(AntoineGautier): Simulations are run on all subpackages within Templates and the aggregated return code is checked.
    # Need to modify to exit as soon as one execution returns non zero.
    # + Perform checksum check for each subpackage and run tests only for modified subpackages.
    r=
    # ./Resources/Scripts/travis/templates/BoilerPlant.py $SIMULATOR
    ./Resources/Scripts/travis/templates/ChilledWaterPlants.py $SIMULATOR
    r=$r$?
    if [ "$r" = 0 ]; then
        exit 0
    else
        if [[ -s unitTestsTemplates.log ]]; then
            printf "Below is the error log.\n\n"
            cat unitTestsTemplates.log
            exit 1
        fi
    fi
else
    echo "Computed checksum matches checksum on master: no further check performed."
    exit 0
fi
