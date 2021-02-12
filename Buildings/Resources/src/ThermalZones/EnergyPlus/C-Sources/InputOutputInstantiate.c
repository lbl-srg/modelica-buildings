/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "EnergyPlusFMU.h"
#include "InputOutputInstantiate.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>


/*
void setParametersInEnergyPlus(FMUInOut* zone, double* parValues){
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
    bui->modelicaNameBuilding, zone->modelicaName);
  }
  return;
}
*/

/* This function is called for each zone in the 'initial equation section'
*/
void EnergyPlusInputOutputInstantiate(
    void* object,
    double startTime,
    double *parOut){
  FMUInOut* zone = (FMUInOut*) object;
  FMUBuilding* bui = zone->bui;
  const char* modelicaName = zone->modelicaName;
  size_t i;

  if (bui->logLevel >= MEDIUM){
    bui->SpawnFormatMessage("%.3f %s: Entered EnergyPlusInputOutputInstantiate.\n", startTime, modelicaName);
  }
  if (bui == NULL){
    bui->SpawnFormatError("Pointer bui is NULL in EnergyPlusInputOutputInstantiate for %s. For Dymola 2020x, make sure you set 'Hidden.AvoidDoubleComputation=true'. See Buildings.ThermalZones.EnergyPlus.UsersGuide.", modelicaName);
  }
  if (bui->fmu == NULL){
    /* EnergyPlus is not yet loaded.
       This section is only executed once if the 'initial equation' section is called multiple times.
       Moreover, it is called from the 'initial equation' section rather than than constructor
       because we only know how many exc and output variables there are after all constructors have been called.
       Hence we cannot construct the FMU in the constructor because we don't know which
       is the last constructor to be called.
    */
    loadFMU_setupExperiment_enterInitializationMode(bui, startTime);
  }

  if (! zone->valueReferenceIsSet){
    bui->SpawnFormatError("Value reference is not set for %s. For Dymola 2020x, make sure you set 'Hidden.AvoidDoubleComputation=true'. See Buildings.ThermalZones.EnergyPlus.UsersGuide.",
      modelicaName);
  }

  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("%.3f %s: Getting parameters from EnergyPlus zone, bui at %p, zone at %p, zone->parameter at %p.\n", startTime, zone->modelicaName,
      bui, zone, zone->parameters);
  getVariables(bui, modelicaName, zone->parameters);

  /* Assign the floor area and the volume of the zone */
  for(i = 0; i < zone->parameters->n; i++){
    *parOut = zone->parameters->valsSI[i];
    parOut++; /* Increment to next element */
  }
  /* Assign dummy value to force initialization. Modelica allocates this array sufficiently large, e.g, nPar+1 */
  *parOut = 1;

  /* Set flag to indicate that this zone has been properly initialized */
  zone->isInstantiated = fmi2True;

  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("%.3f %s: Zone is instantiated.\n", startTime, zone->modelicaName);
}
