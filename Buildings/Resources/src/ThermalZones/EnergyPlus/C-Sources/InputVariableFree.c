/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  5/22/2020
 */

#include "InputVariableFree.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>

void InputVariableFree(void* object){
  if (FMU_EP_VERBOSITY >= MEDIUM)
    SpawnMessage("Entered InputVariableFree.\n");
  if ( object != NULL ){
    FMUInputVariable* com = (FMUInputVariable*) object;

    /* The building may not have been instanciated yet if there was an error during instantiation */
    if (com->ptrBui != NULL){
      com->ptrBui->nInputVariables--;
      FMUBuildingFree(com->ptrBui);
    }
    if (FMU_EP_VERBOSITY >= MEDIUM)
      SpawnMessage("Calling free in InputVariableFree.\n");
    free(com);
  }
  if (FMU_EP_VERBOSITY >= MEDIUM)
    SpawnMessage("Leaving InputVariableFree.c.\n");
}
