/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  10/7/2019
 */

#include "OutputVariableFree.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>

void EnergyPlusOutputVariableFree(void* object){
  if ( object != NULL ){
    FMUOutputVariable* com = (FMUOutputVariable*) object;

    /* Check if there in another Modelica instance that uses this output variable */
    com->count = com->count - 1;
    if (com->count > 0){
      return;
    }

    /* The building may not have been instanciated yet if there was an error during instantiation */
    if (com->bui != NULL){
      com->bui->nOutputVariables--;
      FMUBuildingFree(com->bui);
    }
    free(com);
  }
}
