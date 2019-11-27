/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "ZoneAllocate.h"
#include "EnergyPlusStructure.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

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

void setPointerIfAlreadyInstanciated(const char* modelicaInstanceName, FMUZone** ptrFMUZone){
  int iBui;
  int iZon;
  FMUBuilding* ptrBui;
  FMUZone* ptrZon;
  *ptrFMUZone = NULL;

  for(iBui = 0; iBui < getBuildings_nFMU(); iBui++){
    ptrBui = getBuildingsFMU(iBui);
    for(iZon = 0; iZon < ptrBui->nZon; iZon++){
      ptrZon = (FMUZone*)(ptrBui->zones[iZon]);
      if (strcmp(modelicaInstanceName, ptrZon->modelicaInstanceName) == 0){
        *ptrFMUZone = ptrZon;
        return;
      }
    }
  }
  return;
}

/* Create the structure and return a pointer to its address. */
void* ZoneAllocate(
  const char* idfName,
  const char* weaName,
  const char* iddName,
  const char* zoneName,
  const char* modelicaInstanceName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int verbosity){
  /* Note: The idfName is needed to unpack the fmu so that the valueReference
     for the zone with zoneName can be obtained */
  unsigned int i;
  FMUZone* zone;
  size_t nFMU;
  /*const char* parInpNames[] = {"T_start"};*/
  const char* parOutNames[] = {"V", "AFlo", "mSenFac"};
  const char* inpNames[] = {"T", "X", "mInlets_flow", "TAveInlet", "QGaiRad_flow"};
  const char* outNames[] = {"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"};

  nFMU = getBuildings_nFMU();
  if (nFMU == 0){
    FMU_EP_VERBOSITY = verbosity;
  }
  else{
    if (FMU_EP_VERBOSITY != verbosity){
        ModelicaFormatMessage("Warning: Thermal zones declare different verbosity. Check parameter verbosity. Using highest declared value.\n");
    }
    if (verbosity > FMU_EP_VERBOSITY){
      FMU_EP_VERBOSITY = verbosity;
    }
  }

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Entered ZoneAllocate for zone %s.\n", modelicaInstanceName);

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Buildings library root is at %s\n", buildingsLibraryRoot);

  /* Dymola 2019FD01 calls in some cases the allocator twice. In this case, simply return the previously instanciated zone pointer */
  setPointerIfAlreadyInstanciated(modelicaInstanceName, &zone);
  if (zone != NULL){
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("*** ZoneAllocate called more than once for %s.\n", modelicaInstanceName);
    /* Return pointer to this zone */
    return (void*) zone;
  }
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("*** First call for this instance %s.\n", modelicaInstanceName);

  /* ********************************************************************** */
  /* Initialize the zone */

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("*** Initializing memory for zone for %s.\n", modelicaInstanceName);

  zone = (FMUZone*) malloc(sizeof(FMUZone));
  if ( zone == NULL )
    ModelicaError("Not enough memory in ZoneAllocate.c. to allocate zone.");
  /* Assign the zone name */
  zone->name = malloc((strlen(zoneName)+1) * sizeof(char));
  if ( zone->name == NULL )
    ModelicaError("Not enough memory in ZoneAllocate.c. to allocate zone name.");
  strcpy(zone->name, zoneName);

  /* Assign the Modelica instance name */
  zone->modelicaInstanceName = malloc((strlen(modelicaInstanceName)+1) * sizeof(char));
  if ( zone->modelicaInstanceName == NULL )
    ModelicaError("Not enough memory in ZoneAllocate.c. to allocate Modelica instance name.");
  strcpy(zone->modelicaInstanceName, modelicaInstanceName);
  /* Assign structural data */
  buildVariableNames(
    zone->name,
    parOutNames,
    ZONE_N_PAR_OUT,
    &zone->parOutNames,
    &zone->parOutVarNames);

  buildVariableNames(
    zone->name,
    inpNames,
    ZONE_N_INP,
    &zone->inpNames,
    &zone->inpVarNames);

  buildVariableNames(
    zone->name,
    outNames,
    ZONE_N_OUT,
    &zone->outNames,
    &zone->outVarNames);

  zone->parOutValReferences = NULL;
  zone->parOutValReferences = (fmi2ValueReference*)malloc(ZONE_N_PAR_OUT * sizeof(fmi2ValueReference));
  if ( zone->parOutValReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for parOutValReferences in ZoneAllocate.c.");

  zone->inpValReferences = NULL;
  zone->inpValReferences = (fmi2ValueReference*)malloc(ZONE_N_INP * sizeof(fmi2ValueReference));
  if ( zone->inpValReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for inpValReferences in ZoneAllocate.c.");

  zone->outValReferences = NULL;
  zone->outValReferences = (fmi2ValueReference*)malloc(ZONE_N_OUT * sizeof(fmi2ValueReference));
  if ( zone->outValReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for outValReferences in ZoneAllocate.c.");

  /* ********************************************************************** */
  /* Initialize the pointer for the FMU to which this zone belongs */
  /* Check if there are any zones */
  if (nFMU == 0){
    /* No FMUs exist. Instantiate an FMU and */
    /* assign this fmu pointer to the zone that will invoke its setXXX and getXXX */
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("*** nFMU == 0, allocating building structure while instantiating %s.\n", zone->name);
    i = ZoneAllocateBuildingDataStructure(idfName, weaName, iddName, zoneName, zone, usePrecompiledFMU, fmuName, buildingsLibraryRoot);
    zone->ptrBui = getBuildingsFMU(i);
    /*zone->index = 1;*/
  } else {
    /* There is already a Buildings FMU allocated.
       Check if the current zone is for this FMU. */
      zone->ptrBui = NULL;
      for(i = 0; i < nFMU; i++){
        FMUBuilding* fmu = getBuildingsFMU(i);
        if (FMU_EP_VERBOSITY >= MEDIUM)
          ModelicaFormatMessage("*** Testing idf name %s in FMU %s.\n", idfName, fmu->name);

        if ((usePrecompiledFMU && strcmp(fmuName, fmu->name) == 0) ||
          (! usePrecompiledFMU && strcmp(idfName, fmu->name) == 0)){

          if (FMU_EP_VERBOSITY >= MEDIUM)
            ModelicaMessage("*** Found a match.\n");
          /* This is the same FMU as before. */
          if (! zoneIsUnique(fmu, zoneName)){
            ModelicaFormatError("Modelica model specifies zone %s twice for the building %s. Each zone must only be specified once per building.",
            zoneName, fmu->name);
          }

          if (usePrecompiledFMU){
            if (strlen(fmuName) > 0 && strcmp(fmuName, fmu->precompiledFMUAbsPat) != 0){
              ModelicaFormatError("Modelica model specifies two different FMU names for the same building, Check parameter fmuName = %s and fmuName = %s.",
                fmuName, fmu->precompiledFMUAbsPat);
            }
          }

          ModelicaFormatMessage("Assigning zone->ptrBui = fmu with fmu at %p", fmu);
          zone->ptrBui = fmu;
          /* Increment size of vector that contains the zone names. */
          fmu->zoneNames = realloc(fmu->zoneNames, (fmu->nZon + 1) * sizeof(char*));
          fmu->zones = realloc(fmu->zones, (fmu->nZon + 1) * sizeof(FMUZone*));
          if (fmu->zoneNames == NULL){
            ModelicaError("Not enough memory in ZoneAllocate.c. to allocate memory for bld->zoneNames.");
          }
          /* Add storage for new zone name, and copy the zone name */
          fmu->zoneNames[fmu->nZon] = malloc((strlen(zoneName)+1) * sizeof(char));
          if ( fmu->zoneNames[fmu->nZon] == NULL )
            ModelicaError("Not enough memory in ZoneAllocate.c. to allocate zone name.");
          fmu->zones[fmu->nZon] = zone;
          strcpy(fmu->zoneNames[fmu->nZon], zoneName);
          /* Increment the count of zones to this building. */
          fmu->nZon++;
          /*zone->index = fmu->nZon;*/
          break;
        }
      }
      /* Check if we found an FMU */
      if (zone->ptrBui == NULL){
        /* Did not find an FMU. */
        i = ZoneAllocateBuildingDataStructure(idfName, weaName, iddName, zoneName, zone, usePrecompiledFMU, fmuName, buildingsLibraryRoot);
        zone->ptrBui = getBuildingsFMU(i);

        if (FMU_EP_VERBOSITY >= MEDIUM){
          for(i = 0; i < getBuildings_nFMU(); i++){
             ModelicaFormatMessage("ZoneAllocate: Building %s is at pointer %p", (getBuildingsFMU(i))->name, getBuildingsFMU(i));
          }
          ModelicaFormatMessage("Zone ptr is at %p\n", zone);
        }

      }
  }

  /* Some tools such as OpenModelica may optimize the code resulting in initialize()
     not being called. Hence, we set a flag so we can force it to be called in exchange()
     in case it is not called in initialize().
     This behavior was observed when simulating Buildings.Experimental.EnergyPlus.BaseClasses.Validation.FMUZoneAdapter
  */
  zone->isInstantiated = fmi2False;
  zone->isInitialized = fmi2False;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Exiting allocation for %s with building ptr at %p", modelicaInstanceName, zone->ptrBui);
  /* Return a pointer to this zone */
  return (void*) zone;
}
