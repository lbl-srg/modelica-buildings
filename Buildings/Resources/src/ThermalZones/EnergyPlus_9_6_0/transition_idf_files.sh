#!/bin/bash
set -e
OLD_VERSION=9-5-0
NEW_VERSION=9-6-0
PRG="Transition-V${OLD_VERSION}-to-V${NEW_VERSION}"
EPLUS_DIR="/usr/local/EnergyPlus-${NEW_VERSION}"
src_dir=`pwd`
file_list=`find ../../../Data/ -name '*.idf'`

tmp_dir=$(mktemp -d -t tmp-$USER-Buildings-ep-conversion-XXXXXXXXXX)
# EnergyPlus 9.6.0 requires the idd files to be copied, otherwise we get
# Fortran runtime error: Cannot open file 'V9-5-0-Energy+.idd': No such file or directory
cp ${EPLUS_DIR}/PreProcess/IDFVersionUpdater/V${OLD_VERSION}-Energy+.idd .
cp ${EPLUS_DIR}/PreProcess/IDFVersionUpdater/V${NEW_VERSION}-Energy+.idd .
cp ${EPLUS_DIR}/PreProcess/IDFVersionUpdater/V*-Energy+.idd .

for ff in ${file_list}; do
    idf=$src_dir/$ff
    echo "*** Converting ${idf}"
    # The EnergyPlus transition program cannot handle very long file names.
    # Hence, we copy the idf file to a temporary directory, convert it there,
    # and then copy the file back to where it belongs to.
    cp ${idf} ${tmp_dir}
    idf_name=`basename ${idf}`
    ${EPLUS_DIR}/PreProcess/IDFVersionUpdater/${PRG} ${tmp_dir}/${idf_name}
    cp ${tmp_dir}/${idf_name} ${idf}
done
rm V${OLD_VERSION}-Energy+.idd
rm V${NEW_VERSION}-Energy+.idd
