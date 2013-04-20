#!/bin/bash
# CONVERSION OF THE MODELS CONTAINED INTO THE OLD ANALOG PACKAGE, NOW NAMED DC
#LIST=(  "Districts.Electrical.Analog.Sources.PVSimple" "Districts.Electrical.DC.Sources.PVSimple" \
#	"Districts.Electrical.Analog.Sources.WindTurbine" "Districts.Electrical.DC.Sources.WindTurbine" \
#	"Districts.Electrical.Analog.Sources.Examples.PVSimple" "Districts.Electrical.DC.Sources.Examples.PVSimple" \
#	"Districts.Electrical.Analog.Sources.Examples.WindTurbine" "Districts.Electrical.DC.Sources.Examples.WindTurbine" \
#	"Districts.Electrical.Analog.Sources.BaseClasses.WindCorrection" "Districts.Electrical.DC.Sources.BaseClasses.WindCorrection" \
#	"Districts.Electrical.Analog.Storage.Battery" "Districts.Electrical.DC.Storage.Battery" \
#	"Districts.Electrical.Analog.Storage.Examples.Battery" "Districts.Electrical.DC.Storage.Examples.Battery" \
#	"Districts.Electrical.Analog.Storage.BaseClasses.Charge" "Districts.Electrical.DC.Storage.BaseClasses.Charge" \
#	"Districts.Electrical.Analog.Loads.Conductor" "Districts.Electrical.DC.Loads.Conductor" \
#	"Districts.Electrical.Analog.Loads.VariableConductor" "Districts.Electrical.DC.Loads.VariableConductor" \
#	"Districts.Electrical.Analog.Conversion.DCDCConverter" "Districts.Electrical.DC.Conversion.DCDCConverter" \
#	"Districts.Electrical.Analog.Conversion.Examples.DCDCConverter" "Districts.Electrical.DC.Conversion.Examples.DCDCConverter")

LIST=(	"Districts.Electrical.QuasiStationary.SinglePhase.Loads.CapacitorResistor" "Districts.Electrical.AC.Loads.CapacitorResistor" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Loads.Resistor" "Districts.Electrical.AC.Loads.Resistor" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Loads.InductorResistor" "Districts.Electrical.AC.Loads.InductorResistor" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Loads.VariableCapacitorResistor" "Districts.Electrical.AC.Loads.VariableCapacitorResistor" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Loads.VariableResistor" "Districts.Electrical.AC.Loads.VariableResistor" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Loads.VariableInductorResistor" "Districts.Electrical.AC.Loads.VariableInductorResistor" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Loads.Examples.ParallelLoads" "Districts.Electrical.AC.Loads.Examples.ParallelLoads" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Loads.Examples.SeriesLoads" "Districts.Electrical.AC.Loads.Examples.SeriesLoads" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Loads.BaseClasses.InductorResistor" "Districts.Electrical.AC.Loads.BaseClasses.InductorResistor" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Loads.BaseClasses.VariableInductorResistor" "Districts.Electrical.AC.Loads.BaseClasses.VariableInductorResistor" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Sensors.PowerSensor" "Districts.Electrical.AC.Sensors.PowerSensor" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Sources.Grid" "Districts.Electrical.AC.Sources.Grid" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Sources.Generator" "Districts.Electrical.AC.Sources.Generator" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Examples.GeneratorLoadGrid" "Districts.Electrical.AC.Examples.GeneratorLoadGrid" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Examples.GridInductiveLoad" "Districts.Electrical.AC.Examples.GridInductiveLoad" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Examples.GridDCLoad" "Districts.Electrical.AC.Examples.GridDCLoad" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Interfaces.PowerOutput" "Districts.Electrical.AC.Interfaces.PowerOutput" \
	"Districts.Electrical.QuasiStationary.SinglePhase.BaseClasses.powerFactor" "Districts.Electrical.AC.BaseClasses.powerFactor" \
	"Districts.Electrical.QuasiStationary.SinglePhase.BaseClasses.PowerConversion" "Districts.Electrical.AC.BaseClasses.PowerConversion" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Conversion.ACACConverter" "Districts.Electrical.AC.Conversion.ACACConverter" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Conversion.ACDCConverter" "Districts.Electrical.AC.Conversion.ACDCConverter" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Conversion.Examples.ACACConverter" "Districts.Electrical.AC.Conversion.Examples.ACACConverter" \
	"Districts.Electrical.QuasiStationary.SinglePhase.Conversion.Examples.ACDCConverter" "Districts.Electrical.AC.Conversion.Examples.ACDCConverter" \
	"Districts.Electrical.QuasiStationary" "Districts.Electrical.AC" )

i=0
while [ $i -le 48 ]; do
 OLD=${LIST[$i]}
 NEW=${LIST[$i+1]}
 i=$[ i + 2 ]

OLDFIL=`echo $OLD | sed -e 's|\.|/|g' -`
OLDMO=${OLDFIL}.mo
OLDMS=${OLDFIL}.mos
NEWFIL=`echo $NEW | sed -e 's|\.|/|g' -`
NEWMO=${NEWFIL}.mo
NEWMS=${NEWFIL}.mos
echo "Processing $OLD $NEW"
#echo $OLDFIL $NEWFIL
#echo $OLDMO $NEWMO
#echo $OLDMS $NEWMS

# replace string in files
fl=`find . \( -name '*.mos' -or -name '*.mo' \)`
for ff in $fl; do
    egrep $OLD $ff > /dev/null
    if [ $? == 0 ]; then
	echo "Found string in file $ff"
#        emacs $ff
	sed "s/${OLD}/AAABBAAA/g" -i $ff
	sed "s/AAABBAAA/${NEW}/g" -i $ff
    fi
done

# move file name in svn
##if [ -f $OLDMO ]; then
##    svn mv $OLDMO $NEWMO
##fi
##if [ -f $OLDMS ]; then
##    svn mv $OLDMS $NEWMS
##fi

done
