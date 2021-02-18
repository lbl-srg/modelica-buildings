/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "SpawnFMU.h"
#include "SpawnObjectInstantiate.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>


/* This function is called for each Spawn object in the 'initial equation section'
*/
void EnergyPlusSpawnInstantiate(
    void* object,
    int *nObj){
  SpawnObject* zone = (SpawnObject*) object;
  FMUBuilding* bui = zone->bui;
  const char* modelicaName = zone->modelicaName;

  if (bui->logLevel >= MEDIUM){
    bui->SpawnFormatMessage("%.3f %s: Entered EnergyPlusSpawnInstantiate.\n", bui->time, modelicaName);
  }
  if (bui == NULL){
    bui->SpawnFormatError("Pointer bui is NULL in EnergyPlusSpawnInstantiate for %s. For Dymola 2020x, make sure you set 'Hidden.AvoidDoubleComputation=true'. See Buildings.ThermalZones.EnergyPlus.UsersGuide.", modelicaName);
  }
  if (bui->fmu == NULL){
    /* EnergyPlus is not yet loaded.
       This section is only executed once if the 'initial equation' section is called multiple times.
       Moreover, it is called from the 'initial equation' section rather than than constructor
       because we only know how many exc and output variables there are after all constructors have been called.
       Hence we cannot construct the FMU in the constructor because we don't know which
       is the last constructor to be called.
    */
    loadFMU_setupExperiment_enterInitializationMode(bui, bui->time);
  }

  if (! zone->valueReferenceIsSet){
    bui->SpawnFormatError("Value reference is not set for %s. For Dymola 2020x, make sure you set 'Hidden.AvoidDoubleComputation=true'. See Buildings.ThermalZones.EnergyPlus.UsersGuide.",
      modelicaName);
  }

  /* Get parameter values from EnergyPlus */
  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("%.3f %s: Getting parameters from EnergyPlus zone, bui at %p, zone at %p, zone->parameter at %p.\n", bui->time, zone->modelicaName,
      bui, zone, zone->parameters);
  getVariables(bui, modelicaName, zone->parameters);

  /* Assign nObj to synchronize all Spawn objects of this building */
  *nObj = 1;

  /* Set flag to indicate that this zone has been properly initialized */
  zone->isInstantiated = fmi2True;

  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("%.3f %s: Zone is instantiated.\n", bui->time, zone->modelicaName);
}


/* Returns the parameter values for this Spawn object
*/
void EnergyPlusSpawnGetParameters(
    void* object,
    double *parOut){
  SpawnObject* zone = (SpawnObject*) object;
  FMUBuilding* bui = zone->bui;
  const char* modelicaName = zone->modelicaName;
  size_t i;

  if (bui->logLevel >= MEDIUM){
    bui->SpawnFormatMessage("%.3f %s: Entered EnergyPlusSpawnGetParameters.\n", bui->time, modelicaName);
  }

  /* Assign the parameters for this object */
  for(i = 0; i < zone->parameters->n; i++){
    *parOut = zone->parameters->valsSI[i];
    parOut++; /* Increment to next element */
  }
  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("%.3f %s: Leaving EnergyPlusSpawnGetParameters.\n", bui->time, zone->modelicaName);
}