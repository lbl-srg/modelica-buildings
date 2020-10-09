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
  FMUZone** zones = (FMUZone**)(fmuBld->zones);
  for(iZ = 0; iZ < fmuBld->nZon; iZ++){
    if (!strcmp(zoneName, zones[iZ]->name)){
      *doubleSpec = zones[iZ]->modelicaNameThermalZone;
      break;
    }
  }
  return;
}

void setZonePointerIfAlreadyInstanciated(const char* modelicaNameThermalZone, FMUZone** ptrFMUZone){
  int iBui;
  int iZon;
  FMUBuilding* ptrBui;
  FMUZone* zon;
  *ptrFMUZone = NULL;

  for(iBui = 0; iBui < getBuildings_nFMU(); iBui++){
    ptrBui = getBuildingsFMU(iBui);
    for(iZon = 0; iZon < ptrBui->nZon; iZon++){
      zon = (FMUZone*)(ptrBui->zones[iZon]);
      if (strcmp(modelicaNameThermalZone, zon->modelicaNameThermalZone) == 0){
        *ptrFMUZone = zon;
        return;
      }
    }
  }
  return;
}

/* Create the structure and return a pointer to its address. */
void* EnergyPlusZoneAllocate(
  const char* modelicaNameBuilding,
  const char* modelicaNameThermalZone,
  const char* idfName,
  const char* weaName,
  const char* zoneName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int logLevel,
  void (*SpawnMessage)(const char *string),
  void (*SpawnError)(const char *string),
  void (*SpawnFormatMessage)(const char *string, ...),
  void (*SpawnFormatError)(const char *string, ...)){
  /* Note: The idfName is needed to unpack the fmu so that the valueReference
     for the zone with zoneName can be obtained */
  size_t i;
  FMUZone* zone;
  const size_t nFMU = getBuildings_nFMU();
  /* Name used to check for duplicate zone entries in the same building */
  char* doubleZoneSpec;
  const char* parOutNames[] = {"V", "AFlo", "mSenFac"};
  const char* inpNames[] = {"T", "X", "mInlets_flow", "TAveInlet", "QGaiRad_flow"};
  const char* outNames[] = {"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"};

  if (logLevel >= MEDIUM){
    SpawnFormatMessage("Entered EnergyPlusZoneAllocate for zone %s.\n", modelicaNameThermalZone);
    SpawnFormatMessage("Buildings library root is at %s\n", buildingsLibraryRoot);
  }

  /* Dymola 2019FD01 calls in some cases the allocator twice. In this case, simply return the previously instanciated zone pointer */
  setZonePointerIfAlreadyInstanciated(modelicaNameThermalZone, &zone);
  if (zone != NULL){
    if (logLevel >= MEDIUM)
      SpawnFormatMessage("*** EnergyPlusZoneAllocate called more than once for %s.\n", modelicaNameThermalZone);
    /* Return pointer to this zone */
    return (void*) zone;
  }
  if (logLevel >= MEDIUM)
    SpawnFormatMessage("*** First call for this instance %s.\n", modelicaNameThermalZone);

  /* ********************************************************************** */
  /* Initialize the zone */

  if (logLevel >= MEDIUM)
    SpawnFormatMessage("*** Initializing memory for zone for %s.\n", modelicaNameThermalZone);

  zone = (FMUZone*) malloc(sizeof(FMUZone));
  if ( zone == NULL )
    SpawnError("Not enough memory in EnergyPlusZoneAllocate.c. to allocate zone.");

  /* Some tools such as OpenModelica may optimize the code resulting in initialize()
     not being called. Hence, we set a flag so we can force it to be called in exchange()
     in case it is not called in initialize().
     This behavior was observed when simulating Buildings.ThermalZones.EnergyPlus.BaseClasses.Validation.FMUZoneAdapter
  */
  zone->isInstantiated = fmi2False;
  zone->isInitialized = fmi2False;

  /* Assign the Modelica instance name */
  mallocString(
    strlen(modelicaNameThermalZone)+1,
    "Not enough memory in EnergyPlusZoneAllocate.c. to allocate Modelica instance name.",
    &(zone->modelicaNameThermalZone),
    SpawnFormatError);
  strcpy(zone->modelicaNameThermalZone, modelicaNameThermalZone);

  /* Assign the zone name */
  mallocString(
    strlen(zoneName)+1,
    "Not enough memory in EnergyPlusZoneAllocate.c. to allocate zone name.",
    &(zone->name),
    SpawnFormatError);
  strcpy(zone->name, zoneName);

  /* Allocate parameters, inputs and outputs */
  mallocSpawnReals(3, &(zone->parameters), SpawnFormatError);
  mallocSpawnReals(5, &(zone->inputs), SpawnFormatError);
  mallocSpawnReals(4, &(zone->outputs), SpawnFormatError);

  /* Assign structural data */
  buildVariableNames(
    zone->name,
    parOutNames,
    zone->parameters->n,
    &(zone->parOutNames),
    &(zone->parameters->fmiNames),
    SpawnFormatError);

  buildVariableNames(
    zone->name,
    inpNames,
    zone->inputs->n,
    &(zone->inpNames),
    &(zone->inputs->fmiNames),
    SpawnFormatError);

  buildVariableNames(
    zone->name,
    outNames,
    zone->outputs->n,
    &(zone->outNames),
    &(zone->outputs->fmiNames),
    SpawnFormatError);

  /* ********************************************************************** */
  /* Initialize the pointer for the FMU to which this zone belongs */

  /* Check if there is already an FMU for the Building to which this zone belongs to. */
  zone->bui = NULL;
  for(i = 0; i < nFMU; i++){
    FMUBuilding* fmu = getBuildingsFMU(i);
    if (logLevel >= MEDIUM){
      SpawnFormatMessage("*** Testing building %s in FMU %s for %s.\n", modelicaNameBuilding, fmu->fmuAbsPat, modelicaNameThermalZone);
    }

    if (strcmp(modelicaNameBuilding, fmu->modelicaNameBuilding) == 0){
      if (logLevel >= MEDIUM){
        SpawnMessage("*** Found a match.\n");
      }
      /* This is the same FMU as before. */
      doubleZoneSpec = NULL;
      checkForDoubleZoneDeclaration(fmu, zoneName, &doubleZoneSpec);
      if (doubleZoneSpec != NULL){
        SpawnFormatError(
          "Modelica model specifies zone '%s' twice, once in %s and once in %s, both belonging to building %s. Each zone must only be specified once per building.",
        zoneName, modelicaNameThermalZone, doubleZoneSpec, fmu->modelicaNameBuilding);
      }

      if (usePrecompiledFMU){
        if (strlen(fmuName) > 0 && strcmp(fmuName, fmu->precompiledFMUAbsPat) != 0){
          SpawnFormatError("Modelica model specifies two different FMU names for the same building, Check parameter fmuName = %s and fmuName = %s.",
            fmuName, fmu->precompiledFMUAbsPat);
        }
      }

      if (logLevel >= MEDIUM){
        SpawnFormatMessage("Assigning zone->bui = fmu with fmu at %p", fmu);
      }
      zone->bui = fmu;
      AddZoneToBuilding(zone, logLevel);

      break;
    }
  }
  /* Check if we found an FMU */
  if (zone->bui == NULL){
    /* Did not find an FMU. */
    i = AllocateBuildingDataStructure(
      modelicaNameBuilding,
      idfName,
      weaName,
      usePrecompiledFMU,
      fmuName,
      buildingsLibraryRoot,
      logLevel,
      SpawnMessage,
      SpawnError,
      SpawnFormatMessage,
      SpawnFormatError);
    zone->bui = getBuildingsFMU(i);

    AddZoneToBuilding(zone, logLevel);

    if (logLevel >= MEDIUM){
      for(i = 0; i < getBuildings_nFMU(); i++){
         SpawnFormatMessage("ZoneAllocate: Building %s is at pointer %p",
           (getBuildingsFMU(i))->modelicaNameBuilding,
           getBuildingsFMU(i));
      }
      SpawnFormatMessage("Zone ptr is at %p\n", zone);
    }
  }

  if (logLevel >= MEDIUM)
    SpawnFormatMessage("Exiting allocation for %s with zone ptr at %p and building ptr at %p", modelicaNameThermalZone, zone, zone->bui);
  /* Return a pointer to this zone */
  return (void*) zone;
}

