/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/03/2018
 */

#include "ZoneFree.h"
#include "EnergyPlusFMU.c"

#include <stdlib.h>

void ZoneFree(void* object){
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaMessage("Entered ZoneFree.");
  if ( object != NULL ){
    FMUZone* zone = (FMUZone*) object;

    /* The building may not have been instanciated yet if there was an error during instantiation */
    if (zone->ptrBui != NULL){
      zone->ptrBui->nZon--;
      FMUBuildingFree(zone->ptrBui);
    }
    free(zone);
  }
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaMessage("Leaving ZoneFree.");
}
