/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "ZoneInstantiate.h"
#include "BuildingInstantiate.c" /* Include c file, otherwise Modelica won't compile it */
#include "EnergyPlusStructure.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* Returns the value references in selectedValueReferences
*/
void getValueReferences(
    char** requiredVars,
    const size_t nReqVar,
    char** variableNames,
    fmi2ValueReference* valueReferences,
    size_t nValRef,
    fmi2ValueReference* selectedValueReferences){
    int i;
    int j;
    for (i = 0; i < nReqVar; i++){
      for (j = 0; j < nValRef; j++){
         if ( strstr(requiredVars[i], variableNames[j]) != NULL ){
           /* Found the variable */
           selectedValueReferences[i] = valueReferences[j];
           break;
         }
      }
    }
  }

/*
void setParametersInEnergyPlus(FMUZone* zone, double* parValues){
  fmi2Status status;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("fmi2_import_set_real: Setting parameters in EnergyPlus zone %s.\n", zone->name);
  status = fmi2_import_set_real(
    zone->ptrBui->fmu,
    zone->parInpValReferences,
    ZONE_N_PAR_INP,
    parValues);
  if (status != fmi2OK ){
    ModelicaFormatError("Failed to set parameters for building %s, zone %s.",
    zone->ptrBui->name, zone->name);
  }
  return;
}
*/
void getParametersFromEnergyPlus(FMUZone* zone, double* parValues){
  fmi2Status status;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("fmi2_import_get_real: Getting parameters from EnergyPlus zone %s.\n", zone->name);
  status = fmi2_import_get_real(
    zone->ptrBui->fmu,
    zone->parOutValReferences,
    ZONE_N_PAR_OUT,
    parValues);
  if (status != fmi2OK ){
    ModelicaFormatError("Failed to get parameters for building %s, zone %s.",
    zone->ptrBui->name, zone->name);
  }
  return;
}


void loadFMU_setupExperiment_enterInitializationMode(FMUZone* zone, double startTime){
  fmi2_status_t status;

  /* Instantiate the FMU for this building */
  generateAndInstantiateBuilding(zone->ptrBui);

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("fmi2_import_setup_experiment: Setting up experiment.\n");
  zone->ptrBui->time = startTime;
  setFMUMode(zone->ptrBui, instantiationMode);

  /* This function can only be called once per building FMU */
  status = fmi2_import_setup_experiment(
      zone->ptrBui->fmu,    /* fmu */
      fmi2False,            /* toleranceDefined */
      0.0,                  /* tolerance */
      startTime,            /* startTime */
      fmi2False,            /* stopTimeDefined */
      0);                   /* stopTime */
  if( status != fmi2_status_ok ){
    ModelicaFormatError("Failed to setup experiment for FMU with name %s.",  zone->ptrBui->fmuAbsPat);
  }

  /* Enter initialization mode, because getting parameters is only
     allowed in the initialization mode, see FMU state diagram in standard */
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("fmi2_import_enter_initialization_mode: Enter initialization mode of FMU with name %s.\n",
      zone->ptrBui->fmuAbsPat);
  status = fmi2_import_enter_initialization_mode(zone->ptrBui->fmu);
  if( status != fmi2_status_ok ){
    ModelicaFormatError("Failed to enter initialization mode for FMU with name %s for zone %s.",
    zone->ptrBui->fmuAbsPat, zone->name);
  }
  setFMUMode(zone->ptrBui, initializationMode);

  return;
}

/* This function is called for each zone in the 'initial equation section'
*/
void ZoneInstantiate(
    void* object,
    double startTime,
    double* AFlo,
    double* V,
    double* mSenFac){
  fmi2_status_t status;
  FMUZone* zone = (FMUZone*) object;
  /*double parValToSet[ZONE_N_PAR_INP];*/
  double outputValues[ZONE_N_PAR_OUT];

  if (FMU_EP_VERBOSITY >= MEDIUM){
    ModelicaFormatMessage("Entered ZoneInstantiate for zone %s.\n", zone->modelicaInstanceName);
  }
  /* Fixme: Here, in Dymola, zone->ptrBui is NULL for FMUZoneAdapterZones2, but it was not NULL
     when leaving ZoneAllocate */
  /* if (zone->ptrBui->nZon == 1)
    ModelicaFormatError("*** Entering loadFMU_setupExperiment_enterInitializationMode, ptrBui=%p", zone->ptrBui);// with nZon=%d", zone->ptrBui->nZon); */
  if (zone->ptrBui == NULL){
    ModelicaFormatError("Pointer zone->ptrBui is NULL in ZoneInstantiate for zone %s.", zone->modelicaInstanceName);
  }
  if (zone->ptrBui->fmu == NULL){
    /* EnergyPlus is not yet loaded.
       This section is only executed once if the 'initial equation' section is called multiple times.
       Moreover, it is called from the 'initial equation' section rather than than constructor
       because we only know how many zones there are after all constructors have been called.
       Hence we cannot construct the FMU in the constructor because we don't know which
       is the last constructor to be called.
    */
    loadFMU_setupExperiment_enterInitializationMode(zone, startTime);
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("FMU for zone %s is now allocated at %p.\n", zone->modelicaInstanceName, zone->ptrBui->fmu);

  }

  getParametersFromEnergyPlus(zone, outputValues);

  /* Assign the floor area and the volume of the zone */
  *V = outputValues[0];
  *AFlo = outputValues[1];
  *mSenFac = outputValues[2];

  /* Set flag to indicate that this zone has been properly initialized */
  zone->isInstantiated = fmi2True;
}
