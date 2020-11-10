/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  5/22/2020
 */

#include "InputVariableFree.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>

void EnergyPlusInputVariableFree(void* object){
  if ( object != NULL ){
    FMUInputVariable* com = (FMUInputVariable*) object;

    /* The building may not have been instanciated yet if there was an error during instantiation */
    if (com->bui != NULL){
      com->bui->nInputVariables--;
      FMUBuildingFree(com->bui);
    }
    free(com);
  }
}
