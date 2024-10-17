/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/03/2018
 */

#include "SpawnObjectFree.h"
#include "SpawnFMU.h"

#include <stdlib.h>

void free_Spawn_EnergyPlus_24_2_0(void* object){
  if ( object != NULL ){
    SpawnObject* ptrSpaObj = (SpawnObject*) object;

    /* The building may not have been instantiated yet if there was an error during instantiation */
    if (ptrSpaObj->bui != NULL){
      ptrSpaObj->bui->nExcObj--;
      FMUBuildingFree(ptrSpaObj->bui);
    }
    free(ptrSpaObj);
  }
}
