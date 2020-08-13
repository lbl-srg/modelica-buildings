/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  5/22/2020
 */

#include "InputVariableAllocate.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

FMUInputVariable* checkForDoubleInputVariableDeclaration(
  const struct FMUBuilding* fmuBld,
  const char* fmiName){
  int iComVar;

  for(iComVar = 0; iComVar < fmuBld->nInputVariables; iComVar++){
    FMUInputVariable* ptrInpVar = (FMUInputVariable*)(fmuBld->inputVariables[iComVar]);
    if (!strcmp(fmiName, ptrInpVar->inputs->fmiNames[0])){
      if (FMU_EP_VERBOSITY >= MEDIUM){
        ModelicaFormatMessage("*** Searched for input variable %s in building and found it.\n", fmiName);
      }
      return ptrInpVar;
    }
  }
  if (FMU_EP_VERBOSITY >= MEDIUM){
     ModelicaFormatMessage("*** Searched for input variable %s in building but did not find it.\n", fmiName);
  }
  return NULL;
}

void setInputVariablePointerIfAlreadyInstanciated(const char* modelicaNameInputVariable, FMUInputVariable** ptrFMUInputVariable){
  int iBui;
  int iCom;
  FMUBuilding* ptrBui;
  FMUInputVariable* ptrInpVar;

  for(iBui = 0; iBui < getBuildings_nFMU(); iBui++){
    ptrBui = getBuildingsFMU(iBui);
    for(iCom = 0; iCom < ptrBui->nInputVariables; iCom++){
      ptrInpVar = (FMUInputVariable*)(ptrBui->inputVariables[iCom]);
      if (strcmp(modelicaNameInputVariable, ptrInpVar->modelicaNameInputVariable) == 0){
        *ptrFMUInputVariable = ptrInpVar;
        return;
      }
    }
  }
  return;
}

/* Create the structure and return a pointer to its address. */
void* InputVariableAllocate(
  const int objectType,
  const char* modelicaNameBuilding,
  const char* modelicaNameInputVariable,
  const char* idfName,
  const char* weaName,
  const char* name,
  const char* componentType,
  const char* controlType,
  const char* unit,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* spawnLinuxExecutable,
  const int verbosity){
  /* Note: The idfName is needed to unpack the fmu so that the valueReference can be obtained */
  unsigned int i;
  FMUInputVariable* comVar = NULL;

  const size_t nFMU = getBuildings_nFMU();
  /* Name used to check for duplicate input variable entry in the same building */
  FMUInputVariable* doubleInpVarSpec = NULL;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Entered InputVariableAllocate for zone %s.\n", modelicaNameInputVariable);

  checkAndSetVerbosity(verbosity);

  if (objectType < 1 || objectType > 2)
    ModelicaFormatError("Object type must be 1 or 2, received invalid value for %s.\n", modelicaNameInputVariable);

  /* Dymola 2019FD01 calls in some cases the allocator twice. In this case, simply return the previously instanciated zone pointer */
  setInputVariablePointerIfAlreadyInstanciated(modelicaNameInputVariable, &comVar);
  if (comVar != NULL){
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("*** InputVariableAllocate called more than once for %s.\n", modelicaNameInputVariable);
    /* Return pointer to this zone */
    return (void*) comVar;
  }
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("*** First call for this instance %s.\n", modelicaNameInputVariable);

  /* ********************************************************************** */
  /* Initialize the input variable */

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("*** Initializing memory for input variable for %s.\n", modelicaNameInputVariable);

  comVar = (FMUInputVariable*) malloc(sizeof(FMUInputVariable));
  if ( comVar == NULL )
    ModelicaError("Not enough memory in InputVariableAllocate.c. to allocate memory for data structure.");

  /* Some tools such as OpenModelica may optimize the code resulting in initialize()
    not being called. Hence, we set a flag so we can force it to be called in exchange()
    in case it is not called in initialize().
    This behavior was observed when simulating Buildings.ThermalZones.EnergyPlus.BaseClasses.Validation.FMUZoneAdapter
  */
  comVar->isInstantiated = fmi2False;
  comVar->isInitialized = fmi2False;

  comVar->valueReferenceIsSet = fmi2False;

  /* Assign the Modelica instance name */
  mallocString(strlen(modelicaNameInputVariable)+1,
    "Not enough memory in InputVariableAllocate.c. to allocate Modelica instance name.", &(comVar->modelicaNameInputVariable));
  strcpy(comVar->modelicaNameInputVariable, modelicaNameInputVariable);

  mallocString(strlen(name)+1, "Not enough memory in InputVariableAllocate.c. to allocate input name.", &(comVar->name));
  strcpy(comVar->name, name);

  /* Assign the name, component type and control type */
  if (objectType == 1){
    /* This is an EMS actuator */
    mallocString(strlen(componentType)+1, "Not enough memory in InputVariableAllocate.c. to allocate component type.", &(comVar->componentType));
    strcpy(comVar->componentType, componentType);

    mallocString(strlen(controlType)+1, "Not enough memory in InputVariableAllocate.c. to allocate control type.", &(comVar->controlType));
    strcpy(comVar->controlType, controlType);
  }
  else{
    /* This is a Schedule */
    comVar->componentType = NULL;
    comVar->controlType = NULL;
  }

  mallocString(strlen(unit)+1, "Not enough memory in InputVariableAllocate.c. to allocate unit.", &(comVar->unit));
  strcpy(comVar->unit, unit);

  mallocSpawnReals(1, &(comVar->inputs));
  /* Assign structural data */

  buildVariableName(
    (const char*)modelicaNameInputVariable,
    (const char*)(comVar->name),
    (const char*)(comVar->componentType),
    &(comVar->inputs->fmiNames[0]));
  /* *************************************************************************** */
  /* Initialize the pointer for the FMU to which this input variable belongs to */

  /* Check if there is already an FMU for the Building to which this input variable belongs to. */
  comVar->ptrBui = NULL;
  for(i = 0; i < nFMU; i++){
    FMUBuilding* fmu = getBuildingsFMU(i);
    if (FMU_EP_VERBOSITY >= MEDIUM){
      ModelicaFormatMessage("*** Testing building %s in FMU %s for %s.\n", modelicaNameBuilding, fmu->fmuAbsPat, modelicaNameInputVariable);
    }

    if (strcmp(modelicaNameBuilding, fmu->modelicaNameBuilding) == 0){
      if (FMU_EP_VERBOSITY >= MEDIUM){
        ModelicaMessage("*** Found a match.\n");
      }
      /* This is the same FMU as before. */
      doubleInpVarSpec = checkForDoubleInputVariableDeclaration(fmu, comVar->inputs->fmiNames[0]);

      if (doubleInpVarSpec != NULL){
        ModelicaFormatError(
          "Modelica model specifies input '%s' twice, once in %s and once in %s, both belonging to building %s. Each input must only be specified once per building.",
        name, modelicaNameInputVariable, doubleInpVarSpec->modelicaNameInputVariable, fmu->modelicaNameBuilding);
      }
      else{
        /* This input variable has not yet been added to this building */
        if (FMU_EP_VERBOSITY >= MEDIUM){
          ModelicaFormatMessage("Assigning comVar->ptrBui = fmu with fmu at %p", fmu);
        }
        comVar->ptrBui = fmu;

        AddInputVariableToBuilding(comVar);
      }
      break;
    } /* end 'if strcmp...' */
  } /* end of 'for(i = 0; i < nFMU; i++)' */

  /* Check if we found an FMU */
  if (comVar->ptrBui == NULL){
    /* Did not find an FMU. */
    i = AllocateBuildingDataStructure(
      modelicaNameBuilding,
      idfName,
      weaName,
      usePrecompiledFMU,
      fmuName,
      spawnLinuxExecutable);
    comVar->ptrBui = getBuildingsFMU(i);
    AddInputVariableToBuilding(comVar);

    if (FMU_EP_VERBOSITY >= MEDIUM){
      for(i = 0; i < getBuildings_nFMU(); i++){
         ModelicaFormatMessage("InputVariableAllocate.c: Building %s is at pointer %p",
           (getBuildingsFMU(i))->modelicaNameBuilding,
           getBuildingsFMU(i));
      }
      ModelicaFormatMessage("Input variable ptr is at %p\n", comVar);
    }
  }

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Exiting allocation for %s with input variable ptr at %p", modelicaNameInputVariable, comVar);
  /* Return a pointer to this input variable */
  return (void*) comVar;
}
