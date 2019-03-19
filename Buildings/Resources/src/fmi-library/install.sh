# This script installs the binaries and header files
# of the fmi library that is used to link to EnergyPlus.
# This file should be replaced with a cmake file that builds the binaries
# and copies the files as below.

FMILIB_INST=../../../../../../../svn-fmi-library/trunk/install
# Make sure we are in right directory
CURDIR=`pwd`
DIR=`basename $CURDIR`
echo $DIR
if [ $DIR != "fmi-library" ]; then
    echo "Error: This script needs to be run from the Resources/src/fmi-library"
    exit 1
fi
if [ ! -d $FMILIB_INST ]; then
    echo "Error: Directory $FMILIB_INST does not exist"
    exit 1
fi

# Resource directory
RESDIR=`dirname $CURDIR`
RESDIR=`dirname $RESDIR`

# Copy headers
rm -rf $RESDIR/Include/fmi-library
mkdir -p $RESDIR/Include/fmi-library/FMI2
cp -rp $FMILIB_INST/include/FMI2/*.h $RESDIR/Include/fmi-library/FMI2/

# Copy .so
cp $FMILIB_INST/lib/libfmilib_shared.so $RESDIR/Library/linux64/
