/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUZoneInit.h"
#include "FMUEnergyPlusStructure.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#if defined _WIN32
#include <windows.h>
#else
#include <dlfcn.h>
#endif

int zoneIsUnique(const struct FMUBuilding* fmuBld, const char* zoneName){
  int iZ;
  int isUnique = 1;
  for(iZ = 0; iZ < fmuBld->nZon; iZ++){
    if (!strcmp(zoneName, fmuBld->zoneNames[iZ])){
      isUnique = 0;
      break;
    }
  }
  return isUnique;
}

/* Create the structure and return a pointer to its address. */
void* FMUZoneInit(const char* idfName, const char* weaName, const char* iddName, const char* zoneName)
{
  /* Note: The idfName is needed to unpack the fmu so that the valueReference
     for the zone with zoneName can be obtained */
  unsigned int i;
  FMUZone* zone;
  size_t nFMU;
  const char* parNames[] = {"V", "AFlo", "mSenFac"};
  const char* inpNames[] = {"T", "X", "mInlets_flow", "TAveInlet", "QGaiRad_flow"};
  const char* outNames[] = {"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"};

  nFMU = getBuildings_nFMU();

  /* ModelicaMessage("*** Entered FMUZoneInit."); */

  /* ModelicaFormatMessage("****** Initializing zone %s, fmu = %s****** \n", zoneName, idfName); */

  /* ********************************************************************** */
  /* Initialize the zone */
  writeLog(3, "Initializing zone.");

  zone = (FMUZone*) malloc(sizeof(FMUZone));
  if ( zone == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone.");
  /* Assign the zone name */
  zone->name = malloc((strlen(zoneName)+1) * sizeof(char));
  if ( zone->name == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone name.");
  strcpy(zone->name, zoneName);

  /* Assign structural data */

  buildVariableNames(
    zone->name,
    parNames,
    ZONE_N_PAR,
    &zone->parameterNames,
    &zone->parameterVariableNames);

  buildVariableNames(
    zone->name,
    inpNames,
    ZONE_N_INP,
    &zone->inputNames,
    &zone->inputVariableNames);

  buildVariableNames(
    zone->name,
    outNames,
    ZONE_N_OUT,
    &zone->outputNames,
    &zone->outputVariableNames);

  zone->parameterValueReferences = NULL;
  zone->parameterValueReferences = (fmi2ValueReference*)malloc(ZONE_N_PAR * sizeof(fmi2ValueReference));
  if ( zone->parameterValueReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for parameterValueReferences in FMUZoneInit.c.");

  zone->inputValueReferences = NULL;
  zone->inputValueReferences = (fmi2ValueReference*)malloc(ZONE_N_INP * sizeof(fmi2ValueReference));
  if ( zone->inputValueReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for inputValueReferences in FMUZoneInit.c.");

  zone->outputValueReferences = NULL;
  zone->outputValueReferences = (fmi2ValueReference*)malloc(ZONE_N_OUT * sizeof(fmi2ValueReference));
  if ( zone->outputValueReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for outputValueReferences in FMUZoneInit.c.");

  /* ********************************************************************** */
  /* Initialize the pointer for the FMU to which this zone belongs */
  /* Check if there are any zones */
  if (nFMU == 0){
    /* No FMUs exist. Instantiate an FMU and */
    /* assign this fmu pointer to the zone that will invoke its setXXX and getXXX */
    zone->ptrBui = FMUZoneAllocateBuildingDataStructure(idfName, weaName, iddName, zoneName, zone);
    zone->index = 1;
  } else {
    /* There is already a Buildings FMU allocated.
       Check if the current zone is for this FMU. */
      zone->ptrBui = NULL;
      for(i = 0; i < nFMU; i++){
        FMUBuilding* fmu = getBuildingsFMU(i);
        if (strcmp(idfName, fmu->name) == 0){
          /* This is the same FMU as before. */
          if (! zoneIsUnique(fmu, zoneName)){
            ModelicaFormatError("Modelica model specifies zone %s twice for the FMU %s. Each zone must only be specified once.",
            zoneName, fmu->name);
          }

          zone->ptrBui = fmu;
          /* Increment size of vector that contains the zone names. */
          fmu->zoneNames = realloc(fmu->zoneNames, (fmu->nZon + 1) * sizeof(char*));
          fmu->zones = realloc(fmu->zones, (fmu->nZon + 1) * sizeof(FMUZone*));
          if (fmu->zoneNames == NULL){
            ModelicaError("Not enough memory in FMUZoneInit.c. to allocate memory for bld->zoneNames.");
          }
          /* Add storage for new zone name, and copy the zone name */
          fmu->zoneNames[fmu->nZon] = malloc((strlen(zoneName)+1) * sizeof(char));
          if ( fmu->zoneNames[fmu->nZon] == NULL )
            ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone name.");
          fmu->zones[fmu->nZon] = zone;
          strcpy(fmu->zoneNames[fmu->nZon], zoneName);
          /* Increment the count of zones to this building. */
          fmu->nZon++;
          zone->index = fmu->nZon;
          break;
        }
      }
      /* Check if we found an FMU */
      if (zone->ptrBui == NULL){
        /* Did not find an FMU. */
        zone->ptrBui = FMUZoneAllocateBuildingDataStructure(idfName, weaName, iddName, zoneName, zone);
      }
  }
  /*Set the fmu to null to control execution
  zone->ptrBui->fmu=NULL;
  */

  /* Some tools such as OpenModelica may optimize the code resulting in initialize()
     not being called. Hence, we set a flag so we can force it to be called in exchange()
     in case it is not called in initialize().
     This behavior was observed when simulating Buildings.Experimental.EnergyPlus.BaseClasses.Validation.FMUZoneAdapter
  */
  zone->isInstantiated = fmi2False;

  /* Return a pointer to this zone */
  return (void*) zone;
}
