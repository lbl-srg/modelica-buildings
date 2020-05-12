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
  int iOutVar;

  for(iOutVar = 0; iOutVar < fmuBld->nOutputVariables; iOutVar++){
    FMUOutputVariable* ptrOutVar = (FMUOutputVariable*)(fmuBld->outputVariables[iOutVar]);
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

void setOutputVariablePointerIfAlreadyInstanciated(const char* modelicaNameOutputVariable, FMUOutputVariable** ptrFMUOutputVariable){
  int iBui;
  int iOut;
  FMUBuilding* ptrBui;
  FMUOutputVariable* ptrOutVar;

  for(iBui = 0; iBui < getBuildings_nFMU(); iBui++){
    ptrBui = getBuildingsFMU(iBui);
    for(iOut = 0; iOut < ptrBui->nOutputVariables; iOut++){
      ptrOutVar = (FMUOutputVariable*)(ptrBui->outputVariables[iOut]);
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
  const char* outputKey,
  const char* outputName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int verbosity,
  int printUnit){
  /* Note: The idfName is needed to unpack the fmu so that the valueReference can be obtained */
  unsigned int i;
  FMUOutputVariable* outVar = NULL;

  const size_t nFMU = getBuildings_nFMU();
  /* Name used to check for duplicate output variable entry in the same building */
  FMUOutputVariable* doubleOutVarSpec = NULL;

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Entered OutputVariableAllocate for zone %s.\n", modelicaNameOutputVariable);

  checkAndSetVerbosity(verbosity);

  /* Dymola 2019FD01 calls in some cases the allocator twice. In this case, simply return the previously instanciated zone pointer */
  setOutputVariablePointerIfAlreadyInstanciated(modelicaNameOutputVariable, &outVar);
  if (outVar != NULL){
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("*** OutputVariableAllocate called more than once for %s.\n", modelicaNameOutputVariable);
    /* Return pointer to this zone */
    return (void*) outVar;
  }
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("*** First call for this instance %s.\n", modelicaNameOutputVariable);

  /* ********************************************************************** */
  /* Initialize the output variable */

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("*** Initializing memory for output variable for %s.\n", modelicaNameOutputVariable);

  outVar = (FMUOutputVariable*) malloc(sizeof(FMUOutputVariable));
  if ( outVar == NULL )
    ModelicaError("Not enough memory in OutputVariableAllocate.c. to allocate memory for data structure.");

  /* Assign the Modelica instance name */
  mallocString(strlen(modelicaNameOutputVariable)+1, "Not enough memory in OutputVariableAllocate.c. to allocate Modelica instance name.", &(outVar->modelicaNameOutputVariable));
  strcpy(outVar->modelicaNameOutputVariable, modelicaNameOutputVariable);

  /* Assign the key and name */
  mallocString(strlen(outputKey)+1, "Not enough memory in OutputVariableAllocate.c. to allocate output key.", &(outVar->key));
  strcpy(outVar->key, outputKey);

  mallocString(strlen(outputName)+1, "Not enough memory in OutputVariableAllocate.c. to allocate output name.", &(outVar->name));
  strcpy(outVar->name, outputName);

  outVar->printUnit = printUnit;
  outVar->count = 1;

  mallocSpawnReals(1, &(outVar->outputs));
  /* Assign structural data */
  buildVariableName(
    (const char*)(outVar->key),
    (const char*)(outVar->name),
    &(outVar->outputs->fmiNames[0]));

  /* *************************************************************************** */
  /* Initialize the pointer for the FMU to which this output variable belongs to */

  /* Check if there is already an FMU for the Building to which this output variable belongs to. */
  outVar->ptrBui = NULL;
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
      doubleOutVarSpec = checkForDoubleOutputVariableDeclaration(fmu, outVar->outputs->fmiNames[0]);

      if (doubleOutVarSpec != NULL){
        /* This output variable has already been specified. We can just point to the same
           data structure */
        if (FMU_EP_VERBOSITY >= MEDIUM){
          ModelicaFormatMessage("Assigning outVar '%s' to previously used outvar at %p",
          outVar->outputs->fmiNames[0],
          outVar);
        }
        /* Assign by reference */
        outVar = doubleOutVarSpec;
        /* Increase counter for how many Modelica instances use this output variable */
        outVar->count = outVar->count + 1;
      }
      else{
        /* This output variable has not yet been added to this building */
        if (FMU_EP_VERBOSITY >= MEDIUM){
          ModelicaFormatMessage("Assigning outVar->ptrBui = fmu with fmu at %p", fmu);
        }
        outVar->ptrBui = fmu;

        /* Some tools such as OpenModelica may optimize the code resulting in initialize()
           not being called. Hence, we set a flag so we can force it to be called in exchange()
          in case it is not called in initialize().
          This behavior was observed when simulating Buildings.Experimental.EnergyPlus.BaseClasses.Validation.FMUZoneAdapter
        */
        outVar->isInstantiated = fmi2False;
        outVar->isInitialized = fmi2False;

        AddOutputVariableToBuilding(outVar);
      }
      break;
    } /* end 'if strcmp...' */
  } /* end of 'for(i = 0; i < nFMU; i++)' */

  /* Check if we found an FMU */
  if (outVar->ptrBui == NULL){
    /* Did not find an FMU. */
    i = AllocateBuildingDataStructure(
      modelicaNameBuilding,
      idfName,
      weaName,
      usePrecompiledFMU,
      fmuName,
      buildingsLibraryRoot);
    outVar->ptrBui = getBuildingsFMU(i);
    AddOutputVariableToBuilding(outVar);

    if (FMU_EP_VERBOSITY >= MEDIUM){
      for(i = 0; i < getBuildings_nFMU(); i++){
         ModelicaFormatMessage("OutputVariableAllocate.c: Building %s is at pointer %p",
           (getBuildingsFMU(i))->modelicaNameBuilding,
           getBuildingsFMU(i));
      }
      ModelicaFormatMessage("Output variable ptr is at %p\n", outVar);
    }
  }

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Exiting allocation for %s with output variable ptr at %p", modelicaNameOutputVariable, outVar);
  /* Return a pointer to this output variable */
  return (void*) outVar;
}
