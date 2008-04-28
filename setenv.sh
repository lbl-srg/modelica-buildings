#!/bin/bash
########################################################
# This file sets environment variables for the 
# Building Informatics Environment
# 
# To run it, change to the directory of this file and
# type
#  source ./setenv.sh
# To force reseting variables, use
#  source ./setenv.sh -f
#
# MWetter@lbl.gov                             2007-04-05
########################################################


if [ "$1" != "-f" ]; then
    if test ${BIEEnvSet}; then
	echo "BIE environment already set. Doing nothing."
	echo "To set again, use 'source setenv.sh -f'"
	return 1
    fi
else
    echo "Forcing reset of environment variables"
fi

# Test if software is present, and set environment variables
##if test "`which matlab 2> /dev/null`"; then
##    export BIEUseMatlab=true
##    echo "Using matlab"  
##else
##    export BIEUseMatlab=false
##    echo "No matlab found"  
##fi

export BIEDir=`pwd`
export PATH=${BIEDir}/bin:"${PATH}"

export BIEEnvSet="true" # used by Makefile
