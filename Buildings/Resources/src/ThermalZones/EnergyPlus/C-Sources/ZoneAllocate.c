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

void checkForDoubleExchangeDeclaration(const struct FMUBuilding* fmuBld, const char* epName, char** doubleSpec){
  size_t iZ;
  FMUExchange** exc = (FMUExchange**)(fmuBld->exchange);
  for(iZ = 0; iZ < fmuBld->nZon; iZ++){
    if (!strcmp(epName, exc[iZ]->name)){
      *doubleSpec = exc[iZ]->modelicaName;
      break;
    }
  }
  return;
}

void setExchangePointerIfAlreadyInstanciated(const char* modelicaName, FMUExchange** ptrFMUExchange){
  size_t iBui;
  size_t iZon;
  FMUBuilding* ptrBui;
  FMUExchange* zon;
  *ptrFMUExchange = NULL;

  for(iBui = 0; iBui < getBuildings_nFMU(); iBui++){
    ptrBui = getBuildingsFMU(iBui);
    for(iZon = 0; iZon < ptrBui->nZon; iZon++){
      zon = (FMUExchange*)(ptrBui->exchange[iZon]);
      if (strcmp(modelicaName, zon->modelicaName) == 0){
        *ptrFMUExchange = zon;
        return;
      }
    }
  }
  return;
}

/* Create the structure and return a pointer to its address. */
void* EnergyPlusExchangeAllocate(
  const char* modelicaNameBuilding,
  const char* modelicaName,
  const char* idfName,
  const char* weaName,
  const char* epName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int logLevel,
  const char* parOutNames[],
  const char* inpNames[],
  const char* outNames[],
  void (*SpawnMessage)(const char *string),
  void (*SpawnError)(const char *string),
  void (*SpawnFormatMessage)(const char *string, ...),
  void (*SpawnFormatError)(const char *string, ...)){
  /* Note: The idfName is needed to unpack the fmu so that the valueReference
     for the zone with epName can be obtained */
  size_t i;
  FMUExchange* exc;
  const size_t nFMU = getBuildings_nFMU();
  /* Name used to check for duplicate zone entries in the same building */
  char* doubleZoneSpec;

  if (logLevel >= MEDIUM){
    SpawnFormatMessage("---- %s: Entered EnergyPlusExchangeAllocate%s.\n", modelicaName);
    SpawnFormatMessage("---- %s: Buildings library root is at %s\n", modelicaName, buildingsLibraryRoot);
  }

  /* Dymola 2019FD01 calls in some cases the allocator twice. In this case, simply return the previously instanciated zone pointer */
  setExchangePointerIfAlreadyInstanciated(modelicaName, &exc);
  if (exc != NULL){
    if (logLevel >= MEDIUM)
      SpawnFormatMessage("---- %s: EnergyPlusExchangeAllocate called more than once for this zone.\n", modelicaName);
    /* Return pointer to this zone */
    return (void*) exc;
  }
  if (logLevel >= MEDIUM)
    SpawnFormatMessage("---- %s: First call for this instance.\n", modelicaName);

  /* ********************************************************************** */
  /* Initialize the zone */

  if (logLevel >= MEDIUM)
    SpawnFormatMessage("---- %s: Initializing memory for zone.\n", modelicaName);

  exc = (FMUExchange*) malloc(sizeof(FMUExchange));
  if ( exc == NULL )
    SpawnError("Not enough memory in EnergyPlusExchangeAllocate.c. to allocate zone.");

  /* Some tools such as OpenModelica may optimize the code resulting in initialize()
     not being called. Hence, we set a flag so we can force it to be called in exchange()
     in case it is not called in initialize().
     This behavior was observed when simulating Buildings.ThermalZones.EnergyPlus.BaseClasses.Validation.FMUExchangeAdapter
  */
  exc->isInstantiated = fmi2False;
  exc->isInitialized = fmi2False;

  /* Assign the Modelica instance name */
  mallocString(
    strlen(modelicaName)+1,
    "Not enough memory in EnergyPlusExchangeAllocate.c. to allocate Modelica instance name.",
    &(exc->modelicaName),
    SpawnFormatError);
  strcpy(exc->modelicaName, modelicaName);

  /* Assign the zone name */
  mallocString(
    strlen(epName)+1,
    "Not enough memory in EnergyPlusExchangeAllocate.c. to allocate zone name.",
    &(exc->name),
    SpawnFormatError);
  strcpy(exc->name, epName);

  /* Allocate parameters, inputs and outputs */
  mallocSpawnReals(3, &(exc->parameters), SpawnFormatError);
  mallocSpawnReals(5, &(exc->inputs), SpawnFormatError);
  mallocSpawnReals(4, &(exc->outputs), SpawnFormatError);

  if (logLevel >= MEDIUM)
    SpawnFormatMessage("---- %s: Allocated parameters %p\n", modelicaName, exc->parameters);
  /* Assign structural data */
  buildVariableNames(
    exc->name,
    parOutNames,
    exc->parameters->n,
    &(exc->parOutNames),
    &(exc->parameters->fmiNames),
    SpawnFormatError);

  buildVariableNames(
    exc->name,
    inpNames,
    exc->inputs->n,
    &(exc->inpNames),
    &(exc->inputs->fmiNames),
    SpawnFormatError);

  buildVariableNames(
    exc->name,
    outNames,
    exc->outputs->n,
    &(exc->outNames),
    &(exc->outputs->fmiNames),
    SpawnFormatError);

  /* ********************************************************************** */
  /* Initialize the pointer for the FMU to which this zone belongs */

  /* Check if there is already an FMU for the Building to which this zone belongs to. */
  exc->bui = NULL;
  for(i = 0; i < nFMU; i++){
    FMUBuilding* fmu = getBuildingsFMU(i);
    if (logLevel >= MEDIUM){
      SpawnFormatMessage("---- %s: Testing FMU %s for %s.\n", modelicaName, fmu->fmuAbsPat, modelicaNameBuilding);
    }

    if (strcmp(modelicaNameBuilding, fmu->modelicaNameBuilding) == 0){
      if (logLevel >= MEDIUM){
        SpawnFormatMessage("---- %s: FMU %s for %s contains this zone.\n",
          modelicaName, fmu->fmuAbsPat, modelicaNameBuilding);
      }
      /* This is the same FMU as before. */
      doubleZoneSpec = NULL;
      checkForDoubleExchangeDeclaration(fmu, epName, &doubleZoneSpec);
      if (doubleZoneSpec != NULL){
        SpawnFormatError(
          "Modelica model specifies zone '%s' twice, once in %s and once in %s, both belonging to building %s. Each zone must only be specified once per building.",
        epName, modelicaName, doubleZoneSpec, fmu->modelicaNameBuilding);
      }

      if (usePrecompiledFMU){
        if (strlen(fmuName) > 0 && strcmp(fmuName, fmu->precompiledFMUAbsPat) != 0){
          SpawnFormatError("Modelica model specifies two different FMU names for the same building, Check parameter fmuName = %s and fmuName = %s.",
            fmuName, fmu->precompiledFMUAbsPat);
        }
      }

      if (logLevel >= MEDIUM){
        SpawnFormatMessage("---- %s: Assigning zone to building with building at %p\n", modelicaName, fmu);
      }
      exc->bui = fmu;
      AddZoneToBuilding(exc, logLevel);

      break;
    }
  }
  /* Check if we found an FMU */
  if (exc->bui == NULL){
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
    exc->bui = getBuildingsFMU(i);

    AddZoneToBuilding(exc, logLevel);

    if (logLevel >= MEDIUM){
      for(i = 0; i < getBuildings_nFMU(); i++){
         SpawnFormatMessage("---- %s: Building %s is at address %p\n",
           modelicaName,
           (getBuildingsFMU(i))->modelicaNameBuilding,
           getBuildingsFMU(i));
      }
      SpawnFormatMessage("---- %s: Exchange ptr is at %p\n", modelicaName, exc);
    }
  }

  if (logLevel >= MEDIUM)
    SpawnFormatMessage("---- %s: Exiting allocation with zone ptr at %p and building ptr at %p\n", modelicaName, exc, exc->bui);
  /* Return a pointer to this zone */
  return (void*) exc;
}

