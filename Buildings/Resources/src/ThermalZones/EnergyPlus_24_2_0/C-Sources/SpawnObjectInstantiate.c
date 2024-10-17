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


/* This function is called for each Spawn object in the 'initial equation' section
*/
void initialize_Spawn_EnergyPlus_24_2_0(
    void* object,
    int *nObj){
  SpawnObject* ptrSpaObj = (SpawnObject*) object;
  FMUBuilding* bui = ptrSpaObj->bui;
  const char* modelicaName = ptrSpaObj->modelicaName;

  if (bui->logLevel >= MEDIUM){
    bui->SpawnFormatMessage("%.3f %s: Entered initialize_Spawn_EnergyPlus_24_2_0.\n", bui->time, modelicaName);
  }
  if (bui == NULL){
    bui->SpawnFormatError("Pointer bui is NULL in initialize_Spawn_EnergyPlus_24_2_0 for %s. For Dymola 2020x, make sure you set 'Hidden.AvoidDoubleComputation=true'. See Buildings.ThermalZones.EnergyPlus.UsersGuide.", modelicaName);
  }
  if (bui->fmu == NULL){
    /* EnergyPlus is not yet loaded.
       This section is only executed once if the 'initial equation' section is called multiple times.
       Moreover, it is called from the 'initial equation' section rather than than constructor
       because we only know how many exc and output variables there are after all constructors have been called.
       Hence we cannot construct the FMU in the constructor because we don't know which
       is the last constructor to be called.
    */

    /* Delete old files that were extracted from the FMU, if present */
    delete_extracted_fmu_files(bui);

    loadFMU_setupExperiment_enterInitializationMode(bui, bui->time);
  }

  if (! ptrSpaObj->valueReferenceIsSet){
    bui->SpawnFormatError("Value reference is not set for %s. For Dymola 2020x, make sure you set 'Hidden.AvoidDoubleComputation=true'. See Buildings.ThermalZones.EnergyPlus.UsersGuide.",
      modelicaName);
  }

  /* Get parameter values from EnergyPlus */
  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("%.3f %s: Getting parameters from EnergyPlus, bui at %p, Spawn object at %p, parameter at %p.\n", bui->time, ptrSpaObj->modelicaName,
      bui, ptrSpaObj, ptrSpaObj->parameters);
  getVariables(bui, modelicaName, ptrSpaObj->parameters);

  /* Assign nObj to synchronize all Spawn objects of this building */
  *nObj = (int)bui->nExcObj;

  /* Set flag to indicate that this Spawn object has been properly initialized */
  ptrSpaObj->isInstantiated = fmi2True;

  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("%.3f %s: Spawn object is instantiated.\n", bui->time, ptrSpaObj->modelicaName);
}


/* Returns the parameter values for this Spawn object
*/
void getParameters_Spawn_EnergyPlus_24_2_0(
    void* object,
    double *parOut){
  SpawnObject* ptrSpaObj = (SpawnObject*) object;
  FMUBuilding* bui = ptrSpaObj->bui;
  const char* modelicaName = ptrSpaObj->modelicaName;
  size_t i;

  if (bui->logLevel >= MEDIUM){
    bui->SpawnFormatMessage("%.3f %s: Entered getParameters_Spawn_EnergyPlus_24_2_0.\n", bui->time, modelicaName);
  }

  /* Assign the parameters for this object */
  for(i = 0; i < ptrSpaObj->parameters->n; i++){
    *parOut = ptrSpaObj->parameters->valsSI[i];
    parOut++; /* Increment to next element */
  }
  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("%.3f %s: Leaving getParameters_Spawn_EnergyPlus_24_2_0.\n", bui->time, ptrSpaObj->modelicaName);
}
