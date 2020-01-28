/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  10/7/2019
 */

#include "OutputVariableFree.h"
#include "EnergyPlusFMU.c"

#include <stdlib.h>

void OutputVariableFree(void* object){
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaMessage("Entered OutputVariableFree.\n");
  if ( object != NULL ){
    FMUOutputVariable* outVar = (FMUOutputVariable*) object;

    /* Check if there in another Modelica instance that uses this output variable */
    outVar->count = outVar->count - 1;
    if (outVar->count > 0){
      return;
    }

    /* The building may not have been instanciated yet if there was an error during instantiation */
    if (outVar->ptrBui != NULL){
      outVar->ptrBui->nOutputVariables--;
      FMUBuildingFree(outVar->ptrBui);
    }
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaMessage("Calling free in OutputVariableFree.\n");
    free(outVar);
  }
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaMessage("Leaving OutputVariableFree.c.\n");
}
