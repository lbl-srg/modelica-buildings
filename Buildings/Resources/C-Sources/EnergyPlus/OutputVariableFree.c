/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  10/7/2019
 */

#include "OutputVariableFree.h"
#include "EnergyPlusStructure.c"

#include <stdlib.h>

void OutputVariableFree(void* object){
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaMessage("Entered OutputVariableFree.");
  if ( object != NULL ){
    FMUOutputVariable* outVar = (FMUOutputVariable*) object;

    /* The building may not have been instanciated yet if there was an error during instantiation */
    if (outVar->ptrBui != NULL){
      outVar->ptrBui->nOutputVariables--;
      FMUBuildingFree(outVar->ptrBui);
    }
    free(outVar);
  }
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaMessage("Leaving OutputVariableFree.c.");
}
