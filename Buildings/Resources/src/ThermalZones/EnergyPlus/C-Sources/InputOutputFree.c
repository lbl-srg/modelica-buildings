/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/03/2018
 */

#include "InputOutputFree.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>

void EnergyPlusInputOutputFree(void* object){
  if ( object != NULL ){
    FMUInOut* ptrInOut = (FMUInOut*) object;

    /* The building may not have been instanciated yet if there was an error during instantiation */
    if (ptrInOut->bui != NULL){
      ptrInOut->bui->nExcObj--;
      FMUBuildingFree(ptrInOut->bui);
    }
    free(ptrInOut);
  }
}
