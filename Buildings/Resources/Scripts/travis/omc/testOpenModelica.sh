# This file translates and simulates all models in FILES with omc
# Upon success, it exits with 0, otherwise it exits with a non-zero value.
#
# This file will eventually be replaced once OpenModelica testing is fully integrated
# in BuildingsPy.
#
# Run this file from a directory that contains the Buildings directory.
FILES="Buildings.Controls.OBC*"

# Delete old files
rm -f Buildings_* Buildings.* Modelica_* 2&> /dev/null
# Write list of models
mosScript=openmod.mos

echo "clearCommandLineOptions();" > $mosScript
echo "setCommandLineOptions(\"--matchingAlgorithm=PFPlusExt -d=initialization,NLSanalyticJacobian,newInst\");" >> $mosScript
echo "setCommandLineOptions(\"+d=nogen,initialization,backenddaeinfo,discreteinfo,stateselection\");" >> $mosScript
echo "setCommandLineOptions(\"--simCodeTarget=C\");" >> $mosScript
echo "setCommandLineOptions(\"--target=gcc\");" >> $mosScript
echo "setCompiler(\"clang\");" >> $mosScript
echo "setCXXCompiler(\"clang++\");" >> $mosScript
echo "setCommandLineOptions(\"+ignoreCommandLineOptionsAnnotation=false\");" >> $mosScript
echo "setCommandLineOptions(\"+ignoreSimulationFlagsAnnotation=false\");" >> $mosScript
echo "setCommandLineOptions(\"-d=nfAPI\");" >> $mosScript
echo "setCommandLineOptions(\"--newBackend\");" >> $mosScript

echo "loadModel(Modelica, {\"3.2.3\"});" >> $mosScript
echo "getErrorString();" >> $mosScript
echo "loadModel(Buildings); getErrorString();" >> $mosScript

fileList=`find Buildings/Resources/Scripts/OpenModelica/compareVars -name $FILES`
for ff in $fileList; do
  fileName=`basename $ff`;
  modelName="${fileName%.*}";
  line="simulate(${modelName});";
  echo $line >> $mosScript
  echo $line
done


export OPENMODELICALIBRARY=`pwd`:/usr/lib/omlibrary
#omc +d=nogen,initialization,backenddaeinfo,discreteinfo,stateselection --newBackend $mosScript
omc $mosScript


# Check for failures
exiFla=0
for ff in $fileList; do
  fileName=`basename $ff`;
  modelName="${fileName%.*}";
  logName="${modelName}.log"
  if [ -f $logName ]; then
    cou=`grep -c "The simulation finished successfully" $logName`
    if [ "${cou}" -ne  "1" ]; then
        echo "$modelName failed."
        exiFla=1
    fi;
   else
        echo "$modelName failed to generate log file."
        exiFla=1
   fi;
done
rm -f Buildings_* Buildings.* Modelica_* 2&> /dev/null
exit $exiFla
