#!/bin/bash
#####################################################################
# This script checks mo and mos files for invalid syntax.
# Run this file before checking changes into the trunk.
#
# MWetter@lbl.gov                                          2009-09-29
#####################################################################

# Find all *.mo and *.mos files, then replace the strings
for ff in `find . \( -name '*.mo' \)`; do
        # Check for import
    for item in "import \"" "<h1" "<h2" "<h3" fixme FIXME todo xxx XXX; do
	co=`grep -c "${item}" $ff`;
	if [ $co -ge 1 ]; then
            # Found a string. Replace it.
	    echo "File $ff contains invalid statement $item:"
	    grep "${item}" $ff 
	fi;
	done
done

for ff in `find . \( -name '*.mos' \)`; do
        # Check for import
    for item in "=false" "= false"; do
	co=`grep -c "${item}" $ff`;
	if [ $co -ge 1 ]; then
            # Found a string. Replace it.
	    echo "File $ff contains invalid statement $item:"
	    grep "${item}" $ff 
	fi;
	done
done
