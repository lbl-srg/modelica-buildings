/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/03/2018
 */

#include "ZoneFree.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>

void EnergyPlusZoneFree(void* object){
  if ( object != NULL ){
    FMUZone* zone = (FMUZone*) object;

    /* The building may not have been instanciated yet if there was an error during instantiation */
    if (zone->bui != NULL){
      zone->bui->nZon--;
      FMUBuildingFree(zone->bui);
    }
    free(zone);
  }
}
