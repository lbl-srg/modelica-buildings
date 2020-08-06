/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "ZoneAllocate.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void checkForDoubleZoneDeclaration(const struct FMUBuilding* fmuBld, const char* zoneName, char** doubleSpec){
  int iZ;
  FMUZone** ptrZones = (FMUZone**)(fmuBld->zones);
  for(iZ = 0; iZ < fmuBld->nZon; iZ++){
    FMUZone* zonToChe = (FMUZone*)(fmuBld->zones[iZ]);
    if (!strcmp(zoneName, ptrZones[iZ]->name)){
      *doubleSpec = ptrZones[iZ]->modelicaNameThermalZone;
      break;
    }
  }
  return;
}

void setZonePointerIfAlreadyInstanciated(const char* modelicaNameThermalZone, FMUZone** ptrFMUZone){
  int iBui;
  int iZon;
  FMUBuilding* ptrBui;
  FMUZone* ptrZon;
  *ptrFMUZone = NULL;

  for(iBui = 0; iBui < getBuildings_nFMU(); iBui++){
    ptrBui = getBuildingsFMU(iBui);
    for(iZon = 0; iZon < ptrBui->nZon; iZon++){
      ptrZon = (FMUZone*)(ptrBui->zones[iZon]);
      if (strcmp(modelicaNameThermalZone, ptrZon->modelicaNameThermalZone) == 0){
        *ptrFMUZone = ptrZon;
        return;
      }
    }
  }
  return;
}

/* Create the structure and return a pointer to its address. */
void* ZoneAllocate(
  const char* modelicaNameBuilding,
  const char* modelicaNameThermalZone,
  const char* idfName,
  const char* weaName,
  const char* zoneName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int verbosity){
  /* Note: The idfName is needed to unpack the fmu so that the valueReference
     for the zone with zoneName can be obtained */
  unsigned int i;
  FMUZone* zone;
  const size_t nFMU = getBuildings_nFMU();
  /* Name used to check for duplicate zone entries in the same building */
  char* doubleZoneSpec;
  const char* parOutNames[] = {"V", "AFlo", "mSenFac"};
  const char* inpNames[] = {"T", "X", "mInlets_flow", "TAveInlet", "QGaiRad_flow"};
  const char* outNames[] = {"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"};

  checkAndSetVerbosity(verbosity);

  if (FMU_EP_VERBOSITY >= MEDIUM){
    ModelicaFormatMessage("Entered ZoneAllocate for zone %s.\n", modelicaNameThermalZone);
    ModelicaFormatMessage("Buildings library root is at %s\n", buildingsLibraryRoot);
  }

  /* Dymola 2019FD01 calls in some cases the allocator twice. In this case, simply return the previously instanciated zone pointer */
  setZonePointerIfAlreadyInstanciated(modelicaNameThermalZone, &zone);
  if (zone != NULL){
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("*** ZoneAllocate called more than once for %s.\n", modelicaNameThermalZone);
    /* Return pointer to this zone */
    return (void*) zone;
  }
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("*** First call for this instance %s.\n", modelicaNameThermalZone);

  /* ********************************************************************** */
  /* Initialize the zone */

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("*** Initializing memory for zone for %s.\n", modelicaNameThermalZone);

  zone = (FMUZone*) malloc(sizeof(FMUZone));
  if ( zone == NULL )
    ModelicaError("Not enough memory in ZoneAllocate.c. to allocate zone.");

  /* Assign the Modelica instance name */
  mallocString(strlen(modelicaNameThermalZone)+1, "Not enough memory in ZoneAllocate.c. to allocate Modelica instance name.", &(zone->modelicaNameThermalZone));
  strcpy(zone->modelicaNameThermalZone, modelicaNameThermalZone);

  /* Assign the zone name */
  mallocString(strlen(zoneName)+1, "Not enough memory in ZoneAllocate.c. to allocate zone name.", &(zone->name));
  strcpy(zone->name, zoneName);

  /* Allocate parameters, inputs and outputs */
  mallocSpawnReals(3, &(zone->parameters));
  mallocSpawnReals(5, &(zone->inputs));
  mallocSpawnReals(4, &(zone->outputs));

  /* Assign structural data */
  buildVariableNames(
    zone->name,
    parOutNames,
    zone->parameters->n,
    &(zone->parOutNames),
    &(zone->parameters->fmiNames));

  buildVariableNames(
    zone->name,
    inpNames,
    zone->inputs->n,
    &(zone->inpNames),
    &(zone->inputs->fmiNames));

  buildVariableNames(
    zone->name,
    outNames,
    zone->outputs->n,
    &(zone->outNames),
    &(zone->outputs->fmiNames));

  /* ********************************************************************** */
  /* Initialize the pointer for the FMU to which this zone belongs */

  /* Check if there is already an FMU for the Building to which this zone belongs to. */
  zone->ptrBui = NULL;
  for(i = 0; i < nFMU; i++){
    FMUBuilding* fmu = getBuildingsFMU(i);
    if (FMU_EP_VERBOSITY >= MEDIUM){
      ModelicaFormatMessage("*** Testing building %s in FMU %s for %s.\n", modelicaNameBuilding, fmu->fmuAbsPat, modelicaNameThermalZone);
    }

    if (strcmp(modelicaNameBuilding, fmu->modelicaNameBuilding) == 0){
      if (FMU_EP_VERBOSITY >= MEDIUM){
        ModelicaMessage("*** Found a match.\n");
      }
      /* This is the same FMU as before. */
      doubleZoneSpec = NULL;
      checkForDoubleZoneDeclaration(fmu, zoneName, &doubleZoneSpec);
      if (doubleZoneSpec != NULL){
        ModelicaFormatError(
          "Modelica model specifies zone '%s' twice, once in %s and once in %s, both belonging to building %s. Each zone must only be specified once per building.",
        zoneName, modelicaNameThermalZone, doubleZoneSpec, fmu->modelicaNameBuilding);
      }

      if (usePrecompiledFMU){
        if (strlen(fmuName) > 0 && strcmp(fmuName, fmu->precompiledFMUAbsPat) != 0){
          ModelicaFormatError("Modelica model specifies two different FMU names for the same building, Check parameter fmuName = %s and fmuName = %s.",
            fmuName, fmu->precompiledFMUAbsPat);
        }
      }

      if (FMU_EP_VERBOSITY >= MEDIUM){
        ModelicaFormatMessage("Assigning zone->ptrBui = fmu with fmu at %p", fmu);
      }
      zone->ptrBui = fmu;
      AddZoneToBuilding(zone);

      break;
    }
  }
  /* Check if we found an FMU */
  if (zone->ptrBui == NULL){
    /* Did not find an FMU. */
    i = AllocateBuildingDataStructure(
      modelicaNameBuilding,
      idfName,
      weaName,
      usePrecompiledFMU,
      fmuName,
      buildingsLibraryRoot);
    zone->ptrBui = getBuildingsFMU(i);

    AddZoneToBuilding(zone);

    if (FMU_EP_VERBOSITY >= MEDIUM){
      for(i = 0; i < getBuildings_nFMU(); i++){
         ModelicaFormatMessage("ZoneAllocate: Building %s is at pointer %p",
           (getBuildingsFMU(i))->modelicaNameBuilding,
           getBuildingsFMU(i));
      }
      ModelicaFormatMessage("Zone ptr is at %p\n", zone);
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
    ModelicaFormatMessage("Exiting allocation for %s with zone ptr at %p and building ptr at %p", modelicaNameThermalZone, zone, zone->ptrBui);
  /* Return a pointer to this zone */
  return (void*) zone;
}
