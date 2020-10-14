#!/bin/bash
##########################################
# This script searches for files with
# modifications in the svn status.
# It then converts the file between 
# dos and unix (and vice versa) to
# see what file format has the smallest
# differences.
# This allows avoiding large commits just
# because of a change in the line termination
# character that Dymola 7.4 inserts.
#
# MWetter@lbl.gov          May 26, 2011
##########################################
set -e
# Test for installed programs
function testForProgram(){
    if [ "x`which $1`" == "x" ]; then
	echo "This program requires '$1' to be installed."
	echo "Did not make any changes to files."
	echo "Exit with error."
	exit 1
    fi
}
testForProgram dos2unix
testForProgram unix2dos
testForProgram wc
testForProgram git
testForProgram cut

# Search for git files with modifications

TEMDIR="/tmp/tmp-$USER-$(basename $0).$$.tmp"
mkdir -p $TEMDIR
convert=false

curDir=`pwd`

for ff in `git status --porcelain .`; do 
    if [ $ff == "M" ]; then
	convert=true
    else
	if [ $convert == "true" ]; then
	    echo "Converting $ff"
            fil=`basename $ff`
	    cp -p $curDir/$fil $TEMDIR/$fil
	    dos2unix --quiet -k $fil
	    git diff $fil > $TEMDIR/temp1.txt
	    s1=`wc -l $TEMDIR/temp1.txt | cut -d ' ' -f 1,1`
	    # Copy original file back
	    cp -p $TEMDIR/$fil $curDir/$fil 
	    unix2dos --quiet -k $fil
	    git diff $fil > $TEMDIR/temp2.txt
	    s2=`wc -l $TEMDIR/temp2.txt | cut -d ' ' -f 1,1`
#	    echo "Sizes are $s1 $s2"
	    if [ $s1 -ge $s2 ]; then
		echo "$s1 >= $s2"
	    else
		echo "$s1 < $s2"
		# Since s1 < s2, we rerun dos2unix to get the file
		# with the smaller difference
		dos2unix --quiet -k $fil
	    fi
	    convert=false
	fi
    fi

done
rm -rf $TEMDIR