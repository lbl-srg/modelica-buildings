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
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("AllocateBuildingDataStructure: Allocating data structure for building %lu with name %s", nFMU, modelicaNameBuilding);

  /* Validate the input date */
  if (access(idfName, R_OK) != 0)
    ModelicaFormatError("Cannot read idf file '%s' specified in '%s': %s.", idfName, modelicaNameBuilding, strerror(errno));
  if (access(weaName, R_OK) != 0)
    ModelicaFormatError("Cannot read weather file '%s' specified in '%s': %s.", weaName, modelicaNameBuilding, strerror(errno));

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
  mallocString((strlen(weaName)+1), "Not enough memory in EnergyPlusFMU.c. to allocate weather.", &(Buildings_FMUS[nFMU]->weather));
  strcpy(Buildings_FMUS[nFMU]->weather, weaName);

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

  /* Initialize output variable data */
  Buildings_FMUS[nFMU]->nOutputVariables = 0;
  Buildings_FMUS[nFMU]->outputVariables = NULL;

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
}

void AddOutputVariableToBuilding(FMUOutputVariable* ptrOutVar){
  FMUBuilding* fmu = ptrOutVar->ptrBui;
  const size_t nOutputVariables = fmu->nOutputVariables;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("EnergyPlusFMU.c: Adding output variable %lu with name %s", nOutputVariables+1, ptrOutVar->modelicaNameOutputVariable);

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
  fmu->outputVariables[nOutputVariables] = ptrOutVar;
  /* Increment the count of output variables of this building. */
  fmu->nOutputVariables++;
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
      ModelicaFormatMessage("In FMUBuildingFree, %p, nZon = %d, nOutVar = %d", ptrBui, ptrBui->nZon, ptrBui->nOutputVariables);

    /* Make sure no thermal zone or output variable uses this building */
    if (ptrBui->nZon > 0 || ptrBui->nOutputVariables > 0){
      if (FMU_EP_VERBOSITY >= MEDIUM)
        ModelicaMessage("Exiting FMUBuildingFree without changes as zones or outputs uses this building.");
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