/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "SpawnFMU.h"

#ifndef Buildings_SpawnFMU_c
#define Buildings_SpawnFMU_c

#include <stdlib.h>
#include <string.h>
#ifdef _MSC_VER
#include <windows.h>
#else
#include <unistd.h>
#endif


static size_t Buildings_nFMU = 0;     /* Number of FMUs */
static struct FMUBuilding** Buildings_FMUS; /* Array with pointers to all FMUs */

size_t AllocateBuildingDataStructure(
  double startTime,
  const char* modelicaNameBuilding,
  const char* idfName,
  const char* weaName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int logLevel,
  void (*SpawnMessage)(const char *string),
  void (*SpawnError)(const char *string),
  void (*SpawnFormatMessage)(const char *string, ...),
  void (*SpawnFormatError)(const char *string, ...)){

  const size_t nFMU = getBuildings_nFMU();
  const size_t strLenWea = strlen(weaName);

  if (logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Allocating data structure for building, nFMU=%lu\n", startTime, modelicaNameBuilding, nFMU);

  /* Validate the input data */
  if (access(idfName, R_OK) != 0)
    SpawnFormatError("Cannot read idf file '%s' specified in '%s': %s.", idfName, modelicaNameBuilding, strerror(errno));
  if (access(weaName, R_OK) != 0)
    SpawnFormatError("Cannot read weather file '%s' specified in '%s': %s.", weaName, modelicaNameBuilding, strerror(errno));

  if (strcmp(".mos", strrchr(weaName, '.')) != 0)
    SpawnFormatError("Obtained weather file '%s', but require .mos file rather than %s file to be specified in '%s'.",
      weaName, strrchr(weaName, '.'), modelicaNameBuilding);

  /* Allocate memory */
  if (nFMU == 0)
    Buildings_FMUS = malloc(sizeof(struct FMUBuilding*));
  else
    Buildings_FMUS = realloc(Buildings_FMUS, (nFMU+1) * sizeof(struct FMUBuilding*));
  if ( Buildings_FMUS == NULL )
    SpawnError("Not enough memory in SpawnFMU.c. to allocate array for Buildings_FMU.");

  Buildings_FMUS[nFMU] = malloc(sizeof(FMUBuilding));
  if ( Buildings_FMUS[nFMU] == NULL )
    SpawnError("Not enough memory in SpawnFMU.c. to allocate array for Buildings_FMU[0].");

  Buildings_FMUS[nFMU]->fmu = NULL;
  Buildings_FMUS[nFMU]->context = NULL;
  Buildings_FMUS[nFMU]->GUID = NULL;
  /* Set flag that dll fmu functions are not yet created */
  Buildings_FMUS[nFMU]->dllfmu_created = fmi2_false;

  /* Assign start time */
  Buildings_FMUS[nFMU]->time = startTime;

  /* Assign logging and error functions */
  Buildings_FMUS[nFMU]->logLevel          = logLevel;
  Buildings_FMUS[nFMU]->SpawnMessage       = SpawnMessage;
  Buildings_FMUS[nFMU]->SpawnError         = SpawnError;
  Buildings_FMUS[nFMU]->SpawnFormatMessage = SpawnFormatMessage;
  Buildings_FMUS[nFMU]->SpawnFormatError   = SpawnFormatError;

  /* Assign the modelica name for this building */
  mallocString(
    (strlen(modelicaNameBuilding)+1),
    "Not enough memory in SpawnFMU.c. to allocate modelicaNameBuilding.",
    &(Buildings_FMUS[nFMU]->modelicaNameBuilding),
    SpawnFormatError);
  strcpy(Buildings_FMUS[nFMU]->modelicaNameBuilding, modelicaNameBuilding);

  /* Assign the Buildings library root */
  mallocString(
    (strlen(buildingsLibraryRoot)+1),
    "Not enough memory in SpawnFMU.c. to allocate buildingsLibraryRoot.",
    &(Buildings_FMUS[nFMU]->buildingsLibraryRoot),
    SpawnFormatError);
  strcpy(Buildings_FMUS[nFMU]->buildingsLibraryRoot, buildingsLibraryRoot);

  /* Assign the idfName name */
  if (usePrecompiledFMU){
    mallocString(
      (strlen(fmuName)+1),
      "Not enough memory in SpawnFMU.c. to allocate idfName.",
      &(Buildings_FMUS[nFMU]->idfName),
      SpawnFormatError);
    strcpy(Buildings_FMUS[nFMU]->idfName, fmuName);
  }
  else{
    mallocString(
      (strlen(idfName)+1),
      "Not enough memory in SpawnFMU.c. to allocate idfName.",
      &(Buildings_FMUS[nFMU]->idfName),
      SpawnFormatError);
    strcpy(Buildings_FMUS[nFMU]->idfName, idfName);
  }

  /* Assign the weather name */
  mallocString(
    (strLenWea+1),
    "Not enough memory in SpawnFMU.c. to allocate weather.",
    &(Buildings_FMUS[nFMU]->weather),
    SpawnFormatError);
  strcpy(Buildings_FMUS[nFMU]->weather, weaName);
  /* Change ending from .mos to .epw */
  Buildings_FMUS[nFMU]->weather[strLenWea-3] = 'e';
  Buildings_FMUS[nFMU]->weather[strLenWea-2] = 'p';
  Buildings_FMUS[nFMU]->weather[strLenWea-1] = 'w';

  /* Make sure that .epw file is readable */
  if (access(weaName, R_OK) != 0)
    SpawnFormatError("Cannot read weather file '%s' specified in '%s' through %s (obtained after changing extension): %s.",
      Buildings_FMUS[nFMU]->weather, modelicaNameBuilding, weaName, strerror(errno));

  /* Set the model hash to null */
  Buildings_FMUS[nFMU]->modelHash = NULL;
  /* Set the number of this FMU */
  Buildings_FMUS[nFMU]->iFMU = nFMU;

  getSimulationTemporaryDirectory(modelicaNameBuilding, &(Buildings_FMUS[nFMU]->tmpDir), SpawnFormatError);
  setSimulationFMUName(Buildings_FMUS[nFMU], modelicaNameBuilding);
  if (usePrecompiledFMU){
    Buildings_FMUS[nFMU]->usePrecompiledFMU = usePrecompiledFMU;
    /* Copy name of precompiled FMU */
    mallocString(
      strlen(fmuName)+1,
      "Not enough memory to allocate memory for FMU name.",
      &(Buildings_FMUS[nFMU]->precompiledFMUAbsPat),
      SpawnFormatError);
    memset(Buildings_FMUS[nFMU]->precompiledFMUAbsPat, '\0', strlen(fmuName)+1);
    strcpy(Buildings_FMUS[nFMU]->precompiledFMUAbsPat, fmuName);
  }
  else{
    /* Use actual EnergyPlus */
    Buildings_FMUS[nFMU]->usePrecompiledFMU = usePrecompiledFMU;
    Buildings_FMUS[nFMU]->precompiledFMUAbsPat = NULL;
  }

  /* Initialize exchange object data */
  Buildings_FMUS[nFMU]->nExcObj = 0;
  Buildings_FMUS[nFMU]->exchange = NULL;

  /* Create the temporary directory */
  createDirectory(Buildings_FMUS[nFMU]->tmpDir, SpawnFormatError);

  incrementBuildings_nFMU();

  if (logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: AllocateBuildingDataStructure: Leaving allocating data structure for building number %lu, ptr %p\n",
      startTime,
      modelicaNameBuilding,
      nFMU,
      Buildings_FMUS[nFMU]);

  return nFMU;
}

void AddSpawnObjectToBuilding(SpawnObject* ptrSpaObj, const int logLevel){
  FMUBuilding* bui = ptrSpaObj->bui;
  const size_t nExcObj = bui->nExcObj;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnError)(const char *string) = bui->SpawnError;


  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Adding object %lu with name %s in AddSpawnObjectToBuilding.\n",
      bui->time, bui->modelicaNameBuilding, nExcObj, ptrSpaObj->modelicaName);

  if (nExcObj == 0){
    bui->exchange=malloc(sizeof(SpawnObject *));
    if ( bui->exchange== NULL )
      SpawnError("Not enough memory in SpawnFMU.c. to allocate exc.");
  }
  else{
    /* We already have nExcObj > 0 exc */

    /* Increment size of vector that contains the exc. */
    bui->exchange = realloc(bui->exchange, (nExcObj + 1) * sizeof(SpawnObject*));
    if (bui->exchange == NULL){
      SpawnError("Not enough memory in SpawnFMU.c. to allocate memory for bld->exc.");
    }
  }
  /* Assign the exchange object */
  bui->exchange[nExcObj] = ptrSpaObj;
  /* Increment the count of exchange objects to this building. */
  bui->nExcObj++;

  checkAndSetVerbosity(bui, logLevel);

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Number of exchange objects at end of AddSpawnObjectToBuilding: nExcObj = %d\n",
      bui->time,
      bui->modelicaNameBuilding,
      bui->nExcObj);
}

FMUBuilding* getBuildingsFMU(size_t iFMU){
  return Buildings_FMUS[iFMU];
}

void incrementBuildings_nFMU(){
  Buildings_nFMU++;
  return;
}

void decrementBuildings_nFMU(){
  Buildings_nFMU--;
  return;
}

size_t getBuildings_nFMU(){
  return Buildings_nFMU;
}

void FMUBuildingFree(FMUBuilding* bui){
  fmi2Status status;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;

  if ( bui != NULL ){
    if (bui->logLevel >= MEDIUM){
      SpawnFormatMessage("%.3f %s: Entered FMUBuildingFree.\n", bui->time, bui->modelicaNameBuilding);
      SpawnFormatMessage("%.3f %s: In FMUBuildingFree, %p, nExcObj = %d\n",
      bui->time, bui->modelicaNameBuilding,
      bui, bui->nExcObj);
    }

    /* Make sure no Spawn object uses this building */
    if (bui->nExcObj > 0){
      if (bui->logLevel >= MEDIUM)
        SpawnFormatMessage("%.3f %s: Exiting FMUBuildingFree without changes as building is still used.\n", bui->time, bui->modelicaNameBuilding);
      return;
    }

    /* The call to fmi2_import_terminate causes a seg fault if
       fmi2_import_create_dllfmu was not successful */
    if (bui->dllfmu_created){
      if (bui->logLevel >= MEDIUM)
        SpawnFormatMessage("%.3f %s: Calling fmi2_import_terminate to terminate EnergyPlus.\n", bui->time, bui->modelicaNameBuilding);
      status = fmi2_import_terminate(bui->fmu);
       if (status != fmi2OK){
        SpawnFormatMessage("%.3f %s: fmi2Terminate returned with status %s.\n",
          bui->time, bui->modelicaNameBuilding,
          fmi2_status_to_string(status));
      }
    }
    if (bui->fmu != NULL){
      if (bui->logLevel >= MEDIUM)
        SpawnFormatMessage("%.3f %s: fmi2_import_destroy_dllfmu: destroying dll fmu.\n",
          bui->time,
          bui->modelicaNameBuilding);
      fmi2_import_destroy_dllfmu(bui->fmu);
      fmi2_import_free(bui->fmu);
    }
    if (bui->context != NULL){
      fmi_import_free_context(bui->context);
    }

    if (bui->buildingsLibraryRoot != NULL)
      free(bui->buildingsLibraryRoot);
    if (bui->modelicaNameBuilding != NULL)
      free(bui->modelicaNameBuilding);
    if (bui->idfName != NULL)
      free(bui->idfName);
    if (bui->weather != NULL)
      free(bui->weather);
    if (bui->exchange != NULL)
      free(bui->exchange);
    if (bui->tmpDir != NULL)
      free(bui->tmpDir);
    if (bui->modelHash != NULL)
      free(bui->modelHash);
    free(bui);
  }
  decrementBuildings_nFMU();
  if (getBuildings_nFMU() == 0){
    free(Buildings_FMUS);
  }
}
#endif
