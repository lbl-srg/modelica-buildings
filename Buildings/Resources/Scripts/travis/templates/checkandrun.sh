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

CHECKSUM="$(find ./Buildings/Templates/. -type f -name *.mo -exec md5sum {} \; | sort -k 2 | md5sum | awk '{ print $1; }')"

if [[ $CHECKSUM == $(cat ./Buildings/Resources/Scripts/travis/templates/checksum) ]]; then
    echo "Computed checksum matches stored checksum: no further check performed."
    exit 0
else
    echo "Computed checksum does not match stored checksum: running further checks."
    # Launch simulations (typically several thousands).
    ./Buildings/Resources/Scripts/travis/templates/ChilledWaterPlants.py $1
    if [[ $? == 0 ]]; then
        echo "Simulations succeded: overwriting stored checksum with computed checksum."
        find ./Buildings/Templates/. -type f -name *.mo -exec md5sum {} \; | sort -k 2 | md5sum | awk '{ print $1; }' > \
        ./Buildings/Resources/Scripts/travis/templates/checksum
        exit 0
    else
        echo "Some simulations failed: stored checksum unchanged."
        exit 1
    fi
fi
