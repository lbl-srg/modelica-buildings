/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "EnergyPlusFMU.h"
#include "ZoneInstantiate.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>


/*
void setParametersInEnergyPlus(FMUZone* zone, double* parValues){
  fmi2Status status;

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("fmi2_import_set_real: Setting parameters in EnergyPlus zone %s.\n", zone->name);
  status = fmi2_import_set_real(
    bui->fmu,
    zone->parInpValReferences,
    ZONE_N_PAR_INP,
    parValues);
  if (status != fmi2OK ){
    SpawnFormatError("Failed to set parameters for building %s, zone %s.",
    bui->modelicaNameBuilding, zone->modelicaNameThermalZone);
  }
  return;
}
*/

/* This function is called for each zone in the 'initial equation section'
*/
void EnergyPlusZoneInstantiate(
    void* object,
    double startTime,
    double* AFlo,
    double* V,
    double* mSenFac){
  FMUZone* zone = (FMUZone*) object;
  FMUBuilding* bui = zone->bui;
  const char* modelicaName = zone->modelicaNameThermalZone;

  if (bui->logLevel >= MEDIUM){
    bui->SpawnFormatMessage("Entered EnergyPlusZoneInstantiate for %s.\n", modelicaName);
  }
  /* Fixme: Here, in Dymola, bui is NULL for FMUZoneAdapterZones2, but it was not NULL
     when leaving EnergyPlusZoneAllocate */
  /* if (bui->nZon == 1)
    SpawnFormatError("*** Entering loadFMU_setupExperiment_enterInitializationMode, ptrBui=%p", bui);// with nZon=%d", bui->nZon); */
  if (bui == NULL){
    bui->SpawnFormatError("Pointer bui is NULL in EnergyPlusZoneInstantiate for %s. For Dymola 2020x, make sure you set 'Hidden.AvoidDoubleComputation=true'. See Buildings.ThermalZones.EnergyPlus.UsersGuide.", modelicaName);
  }
  if (bui->fmu == NULL){
    /* EnergyPlus is not yet loaded.
       This section is only executed once if the 'initial equation' section is called multiple times.
       Moreover, it is called from the 'initial equation' section rather than than constructor
       because we only know how many zones and output variables there are after all constructors have been called.
       Hence we cannot construct the FMU in the constructor because we don't know which
       is the last constructor to be called.
    */
    loadFMU_setupExperiment_enterInitializationMode(bui, startTime);
  }
  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage(
      "fmi2_import_get_real: Getting parameters from EnergyPlus zone %s.\n",
      zone->modelicaNameThermalZone);
  getVariables(bui, modelicaName, zone->parameters);

  /* Assign the floor area and the volume of the zone */
  *V = zone->parameters->valsSI[0];
  *AFlo = zone->parameters->valsSI[1];
  *mSenFac = zone->parameters->valsSI[2];

  /* Set flag to indicate that this zone has been properly initialized */
  zone->isInstantiated = fmi2True;
}
