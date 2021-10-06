#!/bin/bash
# Script that writes a list of models that can be simulated
# to the file models.txt
#
rm -f models.txt
for ff in `find . -name '*.mo'`; do
  cou=`grep -c StopTime $ff`
  if [ "${cou}" != "0" ]; then
    # Get name of Modelica class
    modNam="${ff/.mo/}"
    modNam="${modNam//\//\.}"
    modNam="${modNam/../OCTExamples.}"
    echo $modNam >> models.txt
  fi;
done
