/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "SpawnObjectAllocate.h"
#include "SpawnFMU.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void initializeDerivativeStructure(
  spawnDerivatives** r,
  const int* derivatives_structure,
  const double* derivatives_delta)
  {
    size_t i;

    for(i = 0; i < (*r)->n; i++){
      /* Below, we subtract 1 because Modelica uses 1-based index, but in C, we use
         0-based index.
         derivatives_structure[i][0] is the index for y
         derivatives_structure[i][1] is the index for u

         Also note that Modelica passes a 1-d array, see
         Modelica Language Specification 3.4, p. 168
      */
      (*r)->structure[i][0] = (size_t)(derivatives_structure[2*i]  ) - 1;
      (*r)->structure[i][1] = (size_t)(derivatives_structure[2*i+1]) - 1;
      (*r)->delta[i] = derivatives_delta[i];
      (*r)->vals[i] = 0;
    }
  }

void initializeUnitsModelica(
  spawnReals** ptrReals,
  const char** vals,
  const char* errMsg,
  void (*SpawnFormatError)(const char *string, ...))
  {
    size_t i;
    if ( *ptrReals != NULL){
      /* Only execute if this Modelica object has parameters, inputs or outputs. */
      for(i = 0; i < (*ptrReals)->n; i++){
        mallocString(
          strlen(vals[i])+1,
          errMsg,
          &( (*ptrReals)->unitsModelica[i] ), SpawnFormatError);
        strcpy( (*ptrReals)->unitsModelica[i], vals[i]);
      }
    }
  }

void checkForDoubleDeclaration(const struct FMUBuilding* fmuBld, const int objectType, const char* jsonKeysValues, char** doubleSpec){
  size_t iExcObj;
  SpawnObject** ptrSpaObj = (SpawnObject**)(fmuBld->exchange);
  for(iExcObj = 0; iExcObj < fmuBld->nExcObj; iExcObj++){
    if (((objectType == ptrSpaObj[iExcObj]->objectType)) && (strcmp(jsonKeysValues, ptrSpaObj[iExcObj]->jsonKeysValues) == 0)){
      *doubleSpec = ptrSpaObj[iExcObj]->modelicaName;
      break;
    }
  }
  return;
}

void setExchangePointerIfAlreadyInstanciated(const char* modelicaName, const int objectType, SpawnObject** ptrSpawnObject){
  size_t iBui;
  size_t iExcObj;
  FMUBuilding* ptrBui;
  SpawnObject* ptrSpaObj;
  *ptrSpawnObject = NULL;

  for(iBui = 0; iBui < getBuildings_nFMU(); iBui++){
    ptrBui = getBuildingsFMU(iBui);
    for(iExcObj = 0; iExcObj < ptrBui->nExcObj; iExcObj++){
      ptrSpaObj = (SpawnObject*)(ptrBui->exchange[iExcObj]);
      if ((objectType == ptrSpaObj->objectType) && (strcmp(modelicaName, ptrSpaObj->modelicaName) == 0)){
        *ptrSpawnObject = ptrSpaObj;
        return;
      }
    }
  }
  return;
}

/* Create the structure and return a pointer to its address. */
void* allocate_Spawn_EnergyPlus_24_2_0(
  const int objectType,
  double startTime,
  const char* modelicaNameBuilding,
  const char* modelicaName,
  const char* spawnExe,
  const char* idfVersion,
  const char* idfName,
  const char* epwName,
  const runPeriod* runPer,
  double relativeSurfaceTolerance,
  const char* epName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsRootFileLocation,
  const int logLevel,
  const int printUnit,
  const char* jsonName,
  const char* jsonKeysValues,
  const char** parOutNames,
  const size_t nParOut,
  const char** parOutUnits,
  const size_t nParOutUni,
  const char** inpNames,
  const size_t nInp,
  const char** inpUnits,
  const size_t nInpUni,
  const char** outNames,
  const size_t nOut,
  const char** outUnits,
  const size_t nOutUni,
  const int* derivatives_structure,
  const size_t k,
  const size_t n,
  const double* derivatives_delta,
  const size_t nDer,
  void (*SpawnMessage)(const char *string),
  void (*SpawnError)(const char *string),
  void (*SpawnFormatMessage)(const char *string, ...),
  void (*SpawnFormatError)(const char *string, ...)){
  /* Note: The idfName is needed to unpack the fmu so that the valueReference can be obtained */
  size_t i;
  SpawnObject* ptrSpaObj;
  const size_t nFMU = getBuildings_nFMU();
  /* Name used to check for duplicate entries of the same object in the same building */
  char* doubleObjectSpec;

  if (logLevel >= MEDIUM){
    SpawnFormatMessage("%.3f %s: Entered allocate_Spawn_EnergyPlus_24_2_0.\n", startTime, modelicaName);
    SpawnFormatMessage("%.3f %s: Buildings library legal.html file is at %s\n", startTime, modelicaName, buildingsRootFileLocation);
  }

  /* Check arguments */
  if (nParOut != nParOutUni){
    SpawnFormatMessage("%.3f %s: Require arguments nParOut and nParOutUni to be equal.\n", startTime, modelicaName);
  }
  if (nInp != nInpUni){
    SpawnFormatMessage("%.3f %s: Require arguments nInp and nInpUni to be equal.\n", startTime, modelicaName);
  }
  if (nOut != nOutUni){
    SpawnFormatMessage("%.3f %s: Require arguments nOut and nOutUni to be equal.\n", startTime, modelicaName);
  }
  if (k != 2){
    SpawnFormatMessage("%.3f %s: Require argument k = 2, obtained k = %i.\n", startTime, modelicaName, k);
  }
  if (n != nDer){
    SpawnFormatMessage("%.3f %s: Require arguments n = nDer, obtained n = %i, nDer = %i.\n",
      modelicaName, n, nDer);
  }

  /* Dymola 2019FD01 calls in some cases the allocator twice. In this case, simply return the previously instanciated Spawn object pointer */
  setExchangePointerIfAlreadyInstanciated(modelicaName, objectType, &ptrSpaObj);
  if (ptrSpaObj != NULL){
    if (logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: allocate_Spawn_EnergyPlus_24_2_0 called more than once for this object.\n", startTime, modelicaName);
    /* Return pointer to this Spawn object */
    return (void*) ptrSpaObj;
  }
  if (logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: First call for this instance.\n", startTime, modelicaName);

  /* ********************************************************************** */
  /* Initialize the Spawn object */

  if (logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Initializing memory for object.\n", startTime, modelicaName);

  ptrSpaObj = (SpawnObject*) malloc(sizeof(SpawnObject));
  if ( ptrSpaObj == NULL )
    SpawnError("Not enough memory in allocate_Spawn_EnergyPlus_24_2_0.c. to allocate Spawn object.");

  ptrSpaObj->printUnit = printUnit;
  ptrSpaObj->unitPrinted = fmi2False;
  /* Some tools such as OpenModelica may optimize the code resulting in initialize()
     not being called. Hence, we set a flag so we can force it to be called in exchange()
     in case it is not called in initialize().
     This behavior was observed when simulating Buildings.ThermalZones.EnergyPlus.BaseClasses.Validation.SpawnObjectAdapter
  */
  ptrSpaObj->isInstantiated = fmi2False;
  ptrSpaObj->isInitialized = fmi2False;

  ptrSpaObj->valueReferenceIsSet = fmi2False;

  /* Assign the object type */
  ptrSpaObj->objectType = objectType;

  /* Assign the Modelica instance name */
  mallocString(
    strlen(modelicaName)+1,
    "Not enough memory in allocate_Spawn_EnergyPlus_24_2_0.c. to allocate Modelica instance name.",
    &(ptrSpaObj->modelicaName),
    SpawnFormatError);
  strcpy(ptrSpaObj->modelicaName, modelicaName);

  /* Assign the json name */
  mallocString(
    strlen(jsonName)+1,
    "Not enough memory in allocate_Spawn_EnergyPlus_24_2_0.c. to allocate json name.",
    &(ptrSpaObj->jsonName),
    SpawnFormatError);
  strcpy(ptrSpaObj->jsonName, jsonName);

  /* Assign the json keys and values string */
  mallocString(
    strlen(jsonKeysValues)+1,
    "Not enough memory in allocate_Spawn_EnergyPlus_24_2_0.c. to allocate the json keys and values string.",
    &(ptrSpaObj->jsonKeysValues),
    SpawnFormatError);
  strcpy(ptrSpaObj->jsonKeysValues, jsonKeysValues);

  /* Allocate parameters, inputs and outputs */
  mallocSpawnReals((size_t)nParOut, &(ptrSpaObj->parameters), SpawnFormatError);
  mallocSpawnReals((size_t)nInp, &(ptrSpaObj->inputs), SpawnFormatError);
  mallocSpawnReals((size_t)nOut, &(ptrSpaObj->outputs), SpawnFormatError);

  /* Allocate derivatives */
  mallocSpawnDerivatives((size_t)nDer, &(ptrSpaObj->derivatives), SpawnFormatError);

  /* Initialize derivative structure */
  initializeDerivativeStructure(&(ptrSpaObj->derivatives), derivatives_structure, derivatives_delta);

  /* Initialize units */
  initializeUnitsModelica(
    &(ptrSpaObj->parameters), parOutUnits, "Failed to allocate memory for Modelica units of parameters", SpawnFormatError);
  initializeUnitsModelica(
    &(ptrSpaObj->inputs), inpUnits, "Failed to allocate memory for Modelica units of inputs", SpawnFormatError);
  initializeUnitsModelica(
    &(ptrSpaObj->outputs), outUnits, "Failed to allocate memory for Modelica units of outputs", SpawnFormatError);

  if (logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Allocated parameters %p\n", startTime, modelicaName, ptrSpaObj->parameters);
  /* Assign structural data */

  buildVariableNames(
    epName,
    parOutNames,
    (size_t)nParOut,
    &(ptrSpaObj->parOutNames),
    &(ptrSpaObj->parameters->fmiNames),
    SpawnFormatError);

  buildVariableNames(
    epName,
    inpNames,
    (size_t)nInp,
    &(ptrSpaObj->inpNames),
    &(ptrSpaObj->inputs->fmiNames),
    SpawnFormatError);

  buildVariableNames(
    epName,
    outNames,
    (size_t)nOut,
    &(ptrSpaObj->outNames),
    &(ptrSpaObj->outputs->fmiNames),
    SpawnFormatError);

  /* ********************************************************************** */
  /* Initialize the pointer for the FMU to which this Spawn object belongs */

  /* Check if there is already an FMU for the Building to which this Spawn object belongs to. */
  ptrSpaObj->bui = NULL;
  for(i = 0; i < nFMU; i++){
    FMUBuilding* fmu = getBuildingsFMU(i);
    if (logLevel >= MEDIUM){
      SpawnFormatMessage("%.3f %s: Testing FMU %s for %s.\n", startTime, modelicaName, fmu->fmuAbsPat, modelicaNameBuilding);
    }

    if (strcmp(modelicaNameBuilding, fmu->modelicaNameBuilding) == 0){
      if (logLevel >= MEDIUM){
        SpawnFormatMessage("%.3f %s: FMU %s for %s contains this exchange object.\n",
          startTime, modelicaName, fmu->fmuAbsPat, modelicaNameBuilding);
      }
      /* This is the same FMU as before. Check for double declaration of objects that set inputs to EnergyPlus */
      doubleObjectSpec = NULL;
      checkForDoubleDeclaration(fmu, THERMALZONE, jsonKeysValues, &doubleObjectSpec);
      if (doubleObjectSpec != NULL){
        SpawnFormatError(
          "Modelica model specifies zone '%s' twice, once in %s and once in %s, both belonging to building %s. Each zone must only be specified once per building.",
        jsonKeysValues, modelicaName, doubleObjectSpec, fmu->modelicaNameBuilding);
      }
      checkForDoubleDeclaration(fmu, SCHEDULE, jsonKeysValues, &doubleObjectSpec);
      if (doubleObjectSpec != NULL){
        SpawnFormatError(
          "Modelica model specifies schedule '%s' twice, once in %s and once in %s, both belonging to building %s. Each schedule must only be specified once per building.",
        jsonKeysValues, modelicaName, doubleObjectSpec, fmu->modelicaNameBuilding);
      }
      checkForDoubleDeclaration(fmu, ACTUATOR, jsonKeysValues, &doubleObjectSpec);
      if (doubleObjectSpec != NULL){
        SpawnFormatError(
          "Modelica model specifies actuator '%s' twice, once in %s and once in %s, both belonging to building %s. Each actuator must only be specified once per building.",
        jsonKeysValues, modelicaName, doubleObjectSpec, fmu->modelicaNameBuilding);
      }

      if (usePrecompiledFMU){
        if (strlen(fmuName) > 0 && strcmp(fmuName, fmu->precompiledFMUAbsPat) != 0){
          SpawnFormatError("Modelica model specifies two different FMU names for the same building, Check parameter fmuName = %s and fmuName = %s.",
            fmuName, fmu->precompiledFMUAbsPat);
        }
      }

      if (logLevel >= MEDIUM){
        SpawnFormatMessage("%.3f %s: Assigning Spawn object to building with building at %p\n", startTime, modelicaName, fmu);
      }
      ptrSpaObj->bui = fmu;
      AddSpawnObjectToBuilding(ptrSpaObj, logLevel);

      break;
    }
  }
  /* Check if we found an FMU */
  if (ptrSpaObj->bui == NULL){
    /* Did not find an FMU. */
    i = AllocateBuildingDataStructure(
      startTime,
      modelicaNameBuilding,
      spawnExe,
      idfVersion,
      idfName,
      epwName,
      runPer,
      relativeSurfaceTolerance,
      usePrecompiledFMU,
      fmuName,
      buildingsRootFileLocation,
      logLevel,
      SpawnMessage,
      SpawnError,
      SpawnFormatMessage,
      SpawnFormatError);
    ptrSpaObj->bui = getBuildingsFMU(i);

    AddSpawnObjectToBuilding(ptrSpaObj, logLevel);

    if (logLevel >= MEDIUM){
      for(i = 0; i < getBuildings_nFMU(); i++){
         SpawnFormatMessage("%.3f %s: Building %s is at address %p\n",
           startTime,
           modelicaName,
           (getBuildingsFMU(i))->modelicaNameBuilding,
           getBuildingsFMU(i));
      }
      SpawnFormatMessage("%.3f %s: Exchange ptr is at %p\n", startTime, modelicaName, ptrSpaObj);
    }
  }

  if (logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Exiting allocation with Spawn object ptr at %p and building ptr at %p\n", startTime, modelicaName, ptrSpaObj, ptrSpaObj->bui);
  /* Return a pointer to this Spawn object */
  return (void*) ptrSpaObj;
}

