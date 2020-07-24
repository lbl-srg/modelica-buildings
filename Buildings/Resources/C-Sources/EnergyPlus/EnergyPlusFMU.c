/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "EnergyPlusFMU.h"

#ifndef Buildings_EnergyPlusFMU_c
#define Buildings_EnergyPlusFMU_c

#include "EnergyPlusUtil.c"

#include <stdlib.h>
#include <string.h>
#include <unistd.h>


static unsigned int Buildings_nFMU = 0;     /* Number of FMUs */
static struct FMUBuilding** Buildings_FMUS; /* Array with pointers to all FMUs */


size_t AllocateBuildingDataStructure(
  const char* modelicaNameBuilding,
  const char* idfName,
  const char* weaName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot){

  const size_t nFMU = getBuildings_nFMU();
  const size_t strLenWea = strlen(weaName);

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("AllocateBuildingDataStructure: Allocating data structure for building %lu with name %s", nFMU, modelicaNameBuilding);

  /* Validate the input data */
  if (access(idfName, R_OK) != 0)
    ModelicaFormatError("Cannot read idf file '%s' specified in '%s': %s.", idfName, modelicaNameBuilding, strerror(errno));
  if (access(weaName, R_OK) != 0)
    ModelicaFormatError("Cannot read weather file '%s' specified in '%s': %s.", weaName, modelicaNameBuilding, strerror(errno));

  if (strcmp(".mos", strrchr(weaName, '.')) != 0)
    ModelicaFormatError("Obtained weather file '%s', but require .mos file rather than %s file to be specified in '%s'.",
      weaName, strrchr(weaName, '.'), modelicaNameBuilding);

  /* Allocate memory */
  if (nFMU == 0)
    Buildings_FMUS = malloc(sizeof(struct FMUBuilding*));
  else
    Buildings_FMUS = realloc(Buildings_FMUS, (nFMU+1) * sizeof(struct FMUBuilding*));
  if ( Buildings_FMUS == NULL )
    ModelicaError("Not enough memory in EnergyPlusFMU.c. to allocate array for Buildings_FMU.");

  Buildings_FMUS[nFMU] = malloc(sizeof(FMUBuilding));
  if ( Buildings_FMUS[nFMU] == NULL )
    ModelicaError("Not enough memory in EnergyPlusFMU.c. to allocate array for Buildings_FMU[0].");

  Buildings_FMUS[nFMU]->fmu = NULL;
  Buildings_FMUS[nFMU]->context = NULL;
  Buildings_FMUS[nFMU]->GUID = NULL;
  /* Set flag that dll fmu functions are not yet created */
  Buildings_FMUS[nFMU]->dllfmu_created = fmi2_false;

  /* Assign the modelica name for this building */
  mallocString((strlen(modelicaNameBuilding)+1), "Not enough memory in EnergyPlusFMU.c. to allocate modelicaNameBuilding.", &(Buildings_FMUS[nFMU]->modelicaNameBuilding));
  strcpy(Buildings_FMUS[nFMU]->modelicaNameBuilding, modelicaNameBuilding);

  /* Assign the Buildings library root */
  mallocString((strlen(buildingsLibraryRoot)+1), "Not enough memory in EnergyPlusFMU.c. to allocate buildingsLibraryRoot.", &(Buildings_FMUS[nFMU]->buildingsLibraryRoot));
  strcpy(Buildings_FMUS[nFMU]->buildingsLibraryRoot, buildingsLibraryRoot);

  /* Assign the idfName name */
  if (usePrecompiledFMU){
    mallocString((strlen(fmuName)+1), "Not enough memory in EnergyPlusFMU.c. to allocate idfName.", &(Buildings_FMUS[nFMU]->idfName));
    strcpy(Buildings_FMUS[nFMU]->idfName, fmuName);
  }
  else{
    mallocString((strlen(idfName)+1), "Not enough memory in EnergyPlusFMU.c. to allocate idfName.", &(Buildings_FMUS[nFMU]->idfName));
    strcpy(Buildings_FMUS[nFMU]->idfName, idfName);
  }

  /* Assign the weather name */
  mallocString((strLenWea+1), "Not enough memory in EnergyPlusFMU.c. to allocate weather.", &(Buildings_FMUS[nFMU]->weather));
  strcpy(Buildings_FMUS[nFMU]->weather, weaName);
  /* Change ending from .mos to .epw */
  Buildings_FMUS[nFMU]->weather[strLenWea-3] = 'e';
  Buildings_FMUS[nFMU]->weather[strLenWea-2] = 'p';
  Buildings_FMUS[nFMU]->weather[strLenWea-1] = 'w';

  /* Make sure that .epw file is readable */
  if (access(weaName, R_OK) != 0)
    ModelicaFormatError("Cannot read weather file '%s' specified in '%s' through %s (obtained after changing extension): %s.",
      Buildings_FMUS[nFMU]->weather, modelicaNameBuilding, weaName, strerror(errno));

  /* Set the model hash to null */
  Buildings_FMUS[nFMU]->modelHash = NULL;
  /* Set the number of this FMU */
  Buildings_FMUS[nFMU]->iFMU = nFMU;

  getSimulationTemporaryDirectory(modelicaNameBuilding, &(Buildings_FMUS[nFMU]->tmpDir));
  getSimulationFMUName(modelicaNameBuilding, Buildings_FMUS[nFMU]->tmpDir, &(Buildings_FMUS[nFMU]->fmuAbsPat));
  if (usePrecompiledFMU){
    Buildings_FMUS[nFMU]->usePrecompiledFMU = usePrecompiledFMU;
    /* Copy name of precompiled FMU */
    mallocString(strlen(fmuName)+1, "Not enough memory to allocate memory for FMU name.", &(Buildings_FMUS[nFMU]->precompiledFMUAbsPat));
    memset(Buildings_FMUS[nFMU]->precompiledFMUAbsPat, '\0', strlen(fmuName)+1);
    strcpy(Buildings_FMUS[nFMU]->precompiledFMUAbsPat, fmuName);
  }
  else{
    /* Use actual EnergyPlus */
    Buildings_FMUS[nFMU]->usePrecompiledFMU = usePrecompiledFMU;
    Buildings_FMUS[nFMU]->precompiledFMUAbsPat = NULL;
  }

  /* Initialize thermal zone data */
  Buildings_FMUS[nFMU]->nZon = 0;
  Buildings_FMUS[nFMU]->zones = NULL;

  /* Initialize input variable data */
  Buildings_FMUS[nFMU]->nInputVariables = 0;
  Buildings_FMUS[nFMU]->inputVariables = NULL;

  /* Initialize output variable data */
  Buildings_FMUS[nFMU]->nOutputVariables = 0;
  Buildings_FMUS[nFMU]->outputVariables = NULL;

  /* Set pointer to Modelica reporting functions */
  Buildings_FMUS[nFMU]->modelica_message = &ModelicaMessage;
  printf("*** ModelicaMessage is at %p!\n", &ModelicaMessage);


  /* Create the temporary directory */
  createDirectory(Buildings_FMUS[nFMU]->tmpDir);

  incrementBuildings_nFMU();

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("AllocateBuildingDataStructure: Leaving allocating data structure for building number %lu, name %s, ptr %p",
      nFMU, modelicaNameBuilding, Buildings_FMUS[nFMU]);

  return nFMU;
}

void AddZoneToBuilding(FMUZone* ptrZone){
  FMUBuilding* fmu = ptrZone->ptrBui;
  const size_t nZon = fmu->nZon;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("EnergyPlusFMU.c: Adding zone %lu with name %s", nZon, ptrZone->modelicaNameThermalZone);

  if (nZon == 0){
    fmu->zones=malloc(sizeof(FMUZone *));
    if ( fmu->zones== NULL )
      ModelicaError("Not enough memory in EnergyPlusFMU.c. to allocate zones.");
  }
  else{
    /* We already have nZon > 0 zones */

    /* Increment size of vector that contains the zones. */
    fmu->zones = realloc(fmu->zones, (nZon + 1) * sizeof(FMUZone*));
    if (fmu->zones == NULL){
      ModelicaError("Not enough memory in EnergyPlusFMU.c. to allocate memory for bld->zones.");
    }
  }
  /* Assign the zone */
  fmu->zones[nZon] = ptrZone;
  /* Increment the count of zones to this building. */
  fmu->nZon++;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("EnergyPlusFMU.c: nZon = %d, nInp = %d, nOut = %d",
      fmu->nZon, fmu->nInputVariables, fmu->nOutputVariables);
}

void AddInputVariableToBuilding(FMUInputVariable* ptrVar){
  FMUBuilding* fmu = ptrVar->ptrBui;
  const size_t nInputVariables = fmu->nInputVariables;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("EnergyPlusFMU.c: Adding input variable %lu with name %s",
      nInputVariables+1,
      ptrVar->modelicaNameInputVariable);

  if (nInputVariables == 0){
    fmu->inputVariables=malloc(sizeof(FMUInputVariable *));
    if ( fmu->inputVariables== NULL )
      ModelicaError("Not enough memory in EnergyPlusFMU.c. to allocate input variables.");
  }
  else{
    /* We already have nInputVariables > 0 input variables. */

    /* Increment size of vector that contains the input variables. */
    fmu->inputVariables = realloc(fmu->inputVariables, (nInputVariables + 1) * sizeof(FMUInputVariable*));
    if (fmu->inputVariables == NULL){
      ModelicaError("Not enough memory in EnergyPlusFMU.c. to allocate memory for fmu->inputVariables.");
    }
  }
  /* Assign the input variable */
  fmu->inputVariables[nInputVariables] = ptrVar;
  /* Increment the count of input variables of this building. */
  fmu->nInputVariables++;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("EnergyPlusFMU.c: nZon = %d, nInp = %d, nOut = %d",
      fmu->nZon, fmu->nInputVariables, fmu->nOutputVariables);
}

void AddOutputVariableToBuilding(FMUOutputVariable* ptrVar){
  FMUBuilding* fmu = ptrVar->ptrBui;
  const size_t nOutputVariables = fmu->nOutputVariables;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("EnergyPlusFMU.c: Adding output variable %lu with name %s",
      nOutputVariables+1,
      ptrVar->modelicaNameOutputVariable);

  if (nOutputVariables == 0){
    fmu->outputVariables=malloc(sizeof(FMUOutputVariable *));
    if ( fmu->outputVariables== NULL )
      ModelicaError("Not enough memory in EnergyPlusFMU.c. to allocate output variables.");
  }
  else{
    /* We already have nOutputVariables > 0 output variables. */

    /* Increment size of vector that contains the output variables. */
    fmu->outputVariables = realloc(fmu->outputVariables, (nOutputVariables + 1) * sizeof(FMUOutputVariable*));
    if (fmu->outputVariables == NULL){
      ModelicaError("Not enough memory in EnergyPlusFMU.c. to allocate memory for fmu->outputVariables.");
    }
  }
  /* Assign the output variable */
  fmu->outputVariables[nOutputVariables] = ptrVar;
  /* Increment the count of output variables of this building. */
  fmu->nOutputVariables++;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("EnergyPlusFMU.c: nZon = %d, nInp = %d, nOut = %d",
      fmu->nZon, fmu->nInputVariables, fmu->nOutputVariables);
}

FMUBuilding* getBuildingsFMU(size_t iFMU){
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("In getBuildingsFMU, returning pointer to building number %lu at %p", iFMU, Buildings_FMUS[iFMU]);
  return Buildings_FMUS[iFMU];
}

void incrementBuildings_nFMU(){
  Buildings_nFMU++;
  /* ModelicaFormatMessage("*** Increased Buildings_nFMU to %zu.", Buildings_nFMU); */
  return;
}

void decrementBuildings_nFMU(){
  Buildings_nFMU--;
  /* ModelicaFormatMessage("*** Decreased Buildings_nFMU to %zu.", Buildings_nFMU); */
  return;
}

unsigned int getBuildings_nFMU(){
  return Buildings_nFMU;
}

void FMUBuildingFree(FMUBuilding* ptrBui){
  fmi2Status status;
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaMessage("Entered FMUBuildingFree.");

  if ( ptrBui != NULL ){
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("In FMUBuildingFree, %p, nZon = %d, nInpVar = %d, nOutVar = %d",
      ptrBui, ptrBui->nZon, ptrBui->nInputVariables, ptrBui->nOutputVariables);

    /* Make sure no thermal zone or output variable uses this building */
    if (ptrBui->nZon > 0 || ptrBui->nInputVariables > 0 || ptrBui->nOutputVariables > 0){
      if (FMU_EP_VERBOSITY >= MEDIUM)
        ModelicaMessage("Exiting FMUBuildingFree without changes as building is still used.");
      return;
    }

    /* The call to fmi2_import_terminate causes a seg fault if
       fmi2_import_create_dllfmu was not successful */
    if (ptrBui->dllfmu_created){
      if (FMU_EP_VERBOSITY >= MEDIUM)
        ModelicaMessage("fmi2_import_terminate: terminating EnergyPlus.\n");
      status = fmi2_import_terminate(ptrBui->fmu);
      if (status != fmi2OK){
        ModelicaFormatMessage(
          "fmi2Terminate returned with non-OK status for building %s.",
          ptrBui->modelicaNameBuilding);
      }
    }
    if (ptrBui->fmu != NULL){
      if (FMU_EP_VERBOSITY >= MEDIUM)
        ModelicaFormatMessage(
          "fmi2_import_destroy_dllfmu: destroying dll fmu. for %s",
          ptrBui->modelicaNameBuilding);
      fmi2_import_destroy_dllfmu(ptrBui->fmu);
      fmi2_import_free(ptrBui->fmu);
    }
    if (ptrBui->context != NULL){
      fmi_import_free_context(ptrBui->context);
    }

    if (ptrBui->buildingsLibraryRoot != NULL)
      free(ptrBui->buildingsLibraryRoot);
    if (ptrBui->modelicaNameBuilding != NULL)
      free(ptrBui->modelicaNameBuilding);
    if (ptrBui->idfName != NULL)
      free(ptrBui->idfName);
    if (ptrBui->weather != NULL)
      free(ptrBui->weather);
    if (ptrBui->zones != NULL)
      free(ptrBui->zones);
    if (ptrBui->outputVariables != NULL)
      free(ptrBui->outputVariables);
    if (ptrBui->tmpDir != NULL)
      free(ptrBui->tmpDir);
    if (ptrBui->modelHash != NULL)
      free(ptrBui->modelHash);
    free(ptrBui);
  }
  decrementBuildings_nFMU();
  if (getBuildings_nFMU() == 0){
    free(Buildings_FMUS);
  }
}
#endif
