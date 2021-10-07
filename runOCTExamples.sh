#!/bin/bash
# Script that simulates all models in OCTExamples/models.txt
set -e

# Models that don't translate with OCT-stable-r19089_JM-r14295
# See https://github.com/lbl-srg/modelica-buildings/issues/2435 and https://github.com/lbl-srg/modelica-buildings/issues/2436
pat="Experimental_DHC_Examples_Combined_Generation5"
excMod=""
while IFS= read -r line; do
    echo "****************************"
    echo "*** Running $line"
    if [[ "$line" == *"$pat"* ]]; then
       excMod="${excMod}\n$line"
    else
       jm_ipython.sh jmodelica.py $line
    fi;
done < OCTExamples/models.txt

if [ "${excMod}x" != "x" ]; then
    echo -e "Excluded the following models from translation:${excMod}"
fi
