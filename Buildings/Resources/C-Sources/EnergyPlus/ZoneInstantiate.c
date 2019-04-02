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

void getParametersFromEnergyPlus(
  FMUZone* zone,
  double* parValues)
  {
  fmi2Status status;

  writeLog(2, "Getting parameters from EnergyPlus.");
  status = fmi2_import_get_real(
    zone->ptrBui->fmu,
    zone->parameterValueReferences,
    ZONE_N_PAR,
    parValues);
  /* writeLog(1, "end getVariables"); */
  if (status != fmi2OK ){
    ModelicaFormatError("Failed to get parameters for building %s, zone %s.",
    zone->ptrBui->name, zone->name);
  }
  return;
}


/* This function is called for each zone in the 'initial equation section'
*/
void ZoneInstantiate(void* object, double startTime, double* AFlo, double* V, double* mSenFac){
  fmi2_status_t status;
  FMUZone* zone = (FMUZone*) object;

  double outputValues[ZONE_N_OUT];

  writeLog(3, "Entered ZoneInstantiate.");

  if (zone->ptrBui->fmu == NULL){
    /* EnergyPlus is not yet loaded.
       This section is only executed once if the 'initial equation' section is called multiple times.
       Moreover, it is called from the 'initial equation' section rather than than constructor
       because we only know how many zones there are after all constructors have been called.
       Hence we cannot construct the FMU in the constructor because we don't know which
       is the last constructor to be called.
    */

    /* Instantiate the FMU for this building */
    generateAndInstantiateBuilding(zone->ptrBui);

    writeLog(3, "Setting up experiment.");
    zone->ptrBui->time = startTime;
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
  }

    writeLog(0, "Getting parameters from EnergyPlus.");
    getParametersFromEnergyPlus(zone, outputValues);

   /* Assign the floor area and the volume of the zone */
    *V = outputValues[0];
    *AFlo = outputValues[1];
    *mSenFac = outputValues[2];

  /* Set flag to indicate that this zone has been properly initialized */
  zone->isInstantiated = fmi2True;
}
