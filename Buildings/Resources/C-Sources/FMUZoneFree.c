/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

void FMUZoneFree(void* object){
  if ( object != NULL ){
    FMUZone* zone = (FMUZone*) object;
    free(zone->valueReference);
    free(zone);
  }
}
