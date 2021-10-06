#!/bin/bash
# Script that simulates all models in OCTExamples/models.txt
set -e
while IFS= read -r line; do
    echo "****************************"
    echo "*** Simulating $line"
    jm_ipython.sh jmodelica.py $line
done < OCTExamples/models.txt
