/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  10/7/19
 */

#include "OutputVariableAllocate.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

FMUOutputVariable* checkForDoubleOutputVariableDeclaration(
  const struct FMUBuilding* fmuBld,
  const char* fmiName){
  int iComVar;

  for(iComVar = 0; iComVar < fmuBld->nOutputVariables; iComVar++){
    FMUOutputVariable* ptrOutVar = (FMUOutputVariable*)(fmuBld->outputVariables[iComVar]);
    if (!strcmp(fmiName, ptrOutVar->outputs->fmiNames[0])){
      if (FMU_EP_VERBOSITY >= MEDIUM){
        ModelicaFormatMessage("*** Searched for output variable %s in building and found it.\n", fmiName);
      }
      return ptrOutVar;
    }
  }
  if (FMU_EP_VERBOSITY >= MEDIUM){
     ModelicaFormatMessage("*** Searched for output variable %s in building but did not find it.\n", fmiName);
  }
  return NULL;
}

void setOutputVariablePointerIfAlreadyInstantiated(const char* modelicaNameOutputVariable, FMUOutputVariable** ptrFMUOutputVariable){
  int iBui;
  int iCom;
  FMUBuilding* ptrBui;
  FMUOutputVariable* ptrOutVar;

  for(iBui = 0; iBui < getBuildings_nFMU(); iBui++){
    ptrBui = getBuildingsFMU(iBui);
    for(iCom = 0; iCom < ptrBui->nOutputVariables; iCom++){
      ptrOutVar = (FMUOutputVariable*)(ptrBui->outputVariables[iCom]);
      if (strcmp(modelicaNameOutputVariable, ptrOutVar->modelicaNameOutputVariable) == 0){
        *ptrFMUOutputVariable = ptrOutVar;
        return;
      }
    }
  }
  return;
}

/* Create the structure and return a pointer to its address. */
void* OutputVariableAllocate(
  const char* modelicaNameBuilding,
  const char* modelicaNameOutputVariable,
  const char* idfName,
  const char* weaName,
  const char* variableName,
  const char* componentKey,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int verbosity,
  int printUnit){
  /* Note: The idfName is needed to unpack the fmu so that the valueReference can be obtained */
  unsigned int i;
  FMUOutputVariable* comVar = NULL;

  const size_t nFMU = getBuildings_nFMU();
  /* Name used to check for duplicate output variable entry in the same building */
  FMUOutputVariable* doubleOutVarSpec = NULL;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Entered OutputVariableAllocate for zone %s.\n", modelicaNameOutputVariable);

  checkAndSetVerbosity(verbosity);

  /* Dymola 2019FD01 calls in some cases the allocator twice. In this case, simply return the previously instanciated zone pointer */
  setOutputVariablePointerIfAlreadyInstantiated(modelicaNameOutputVariable, &comVar);
  if (comVar != NULL){
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("*** OutputVariableAllocate called more than once for %s.\n", modelicaNameOutputVariable);
    /* Return pointer to this zone */
    return (void*) comVar;
  }
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("*** First call for this instance %s.\n", modelicaNameOutputVariable);

  /* ********************************************************************** */
  /* Initialize the output variable */

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("*** Initializing memory for output variable for %s.\n", modelicaNameOutputVariable);

  comVar = (FMUOutputVariable*) malloc(sizeof(FMUOutputVariable));
  if ( comVar == NULL )
    ModelicaError("Not enough memory in OutputVariableAllocate.c. to allocate memory for data structure.");

  /* Some tools such as OpenModelica may optimize the code resulting in initialize()
    not being called. Hence, we set a flag so we can force it to be called in exchange()
    in case it is not called in initialize().
    This behavior was observed when simulating Buildings.ThermalZones.EnergyPlus.BaseClasses.Validation.FMUZoneAdapter
  */
  comVar->isInstantiated = fmi2False;
  comVar->isInitialized = fmi2False;

  comVar->valueReferenceIsSet = fmi2False;

  /* Assign the Modelica instance name */
  mallocString(strlen(modelicaNameOutputVariable)+1,
    "Not enough memory in OutputVariableAllocate.c. to allocate Modelica instance name.", &(comVar->modelicaNameOutputVariable));
  strcpy(comVar->modelicaNameOutputVariable, modelicaNameOutputVariable);

  /* Assign the name and key */
  mallocString(strlen(variableName)+1, "Not enough memory in OutputVariableAllocate.c. to allocate output name.", &(comVar->name));
  strcpy(comVar->name, variableName);

  mallocString(strlen(componentKey)+1, "Not enough memory in OutputVariableAllocate.c. to allocate output key.", &(comVar->key));
  strcpy(comVar->key, componentKey);

  comVar->printUnit = printUnit;
  comVar->count = 1;

  mallocSpawnReals(1, &(comVar->outputs));
  /* Assign structural data */
  buildVariableName(
    (const char*)modelicaNameOutputVariable,
    (const char*)(comVar->name),
    (const char*)(comVar->key),
    &(comVar->outputs->fmiNames[0]));

  /* *************************************************************************** */
  /* Initialize the pointer for the FMU to which this output variable belongs to */

  /* Check if there is already an FMU for the Building to which this output variable belongs to. */
  comVar->ptrBui = NULL;
  for(i = 0; i < nFMU; i++){
    FMUBuilding* fmu = getBuildingsFMU(i);
    if (FMU_EP_VERBOSITY >= MEDIUM){
      ModelicaFormatMessage("*** Testing building %s in FMU %s for %s.\n", modelicaNameBuilding, fmu->fmuAbsPat, modelicaNameOutputVariable);
    }

    if (strcmp(modelicaNameBuilding, fmu->modelicaNameBuilding) == 0){
      if (FMU_EP_VERBOSITY >= MEDIUM){
        ModelicaMessage("*** Found a match.\n");
      }
      /* This is the same FMU as before. */
      doubleOutVarSpec = checkForDoubleOutputVariableDeclaration(fmu, comVar->outputs->fmiNames[0]);

      if (doubleOutVarSpec != NULL){
        /* This output variable has already been specified. We can just point to the same
           data structure */
        if (FMU_EP_VERBOSITY >= MEDIUM){
          ModelicaFormatMessage("Assigning comVar '%s' to previously used outvar at %p",
          comVar->outputs->fmiNames[0],
          comVar);
        }
        /* Assign by reference */
        comVar = doubleOutVarSpec;
        /* Increase counter for how many Modelica instances use this output variable */
        comVar->count = comVar->count + 1;
      }
      else{
        /* This output variable has not yet been added to this building */
        if (FMU_EP_VERBOSITY >= MEDIUM){
          ModelicaFormatMessage("Assigning comVar->ptrBui = fmu with fmu at %p", fmu);
        }
        comVar->ptrBui = fmu;

        AddOutputVariableToBuilding(comVar);
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
      buildingsLibraryRoot);
    comVar->ptrBui = getBuildingsFMU(i);
    AddOutputVariableToBuilding(comVar);

    if (FMU_EP_VERBOSITY >= MEDIUM){
      for(i = 0; i < getBuildings_nFMU(); i++){
         ModelicaFormatMessage("OutputVariableAllocate.c: Building %s is at pointer %p",
           (getBuildingsFMU(i))->modelicaNameBuilding,
           getBuildingsFMU(i));
      }
      ModelicaFormatMessage("Output variable ptr is at %p\n", comVar);
    }
  }

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Exiting allocation for %s with output variable ptr at %p", modelicaNameOutputVariable, comVar);
  /* Return a pointer to this output variable */
  return (void*) comVar;
}
