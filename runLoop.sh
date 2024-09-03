#!/bin/bash
LOGFILE=Buildings_ThermalZones_EnergyPlus_9_6_0_Examples_SmallOffice_IdealHeatingCoolingSpring_log.txt
MODEL=Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice.IdealHeatingCoolingSpring
jm_ipython.sh jmodelica.py ${MODEL}

cp ${LOGFILE} log.txt
md5Ori=`md5sum ${LOGFILE}`

for i in `seq 1 50`; do
  echo "*** Run $i"
  jm_ipython.sh jmodelica.py ${MODEL}
  md5=`md5sum ${LOGFILE}`
  if [ "${md5Ori}" != "${md5}" ]; then
      echo "Log files ${LOGFILE} and log.txt differ with i = ${i}"
      exit 1
  fi
done
exit 0
