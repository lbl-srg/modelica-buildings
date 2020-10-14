#!/bin/bash
################################################################
# This script reverts changes in white space characters for
# files that are in svn.
#
# The script runs 'svn status' in the current directory.
# If a file has been modified, it displays the changes (except
# for changes in white space characters), and it asks the user
# whether the file should be reverted.
# If the user answers with 'r', then the script runs 'svn revert'
# for this file, otherwise the file remains unchanged.
#
# MWetter@lbl.gov                                     2010-07-16
################################################################
status=true
for ff  in `svn status`; do
    if [ "$status" == "true" ]; then
	if [ "$ff" == "M" ]; then
	# file has been modified. Set flag
	    modified=true
	else
	    modified=false
	fi
	status=false
    else
	if [ "$modified" == "true" ]; then
	    clear
	    svn diff --diff-cmd diff -x -B $ff | colordiff
	    echo "====== type 'r' to revert changes, or any other character to keep file"
	    read -n 1 ans
	    if [ "$ans" == "r" ]; then
		echo "*** Reverting $ff"
		svn revert $ff
	    fi
	else
	    echo "File $ff has no modification or is not in svn"
	fi
	# The next loop will have a status again
	status=true
    fi
done