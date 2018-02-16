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
    /* Check if the building FMU can be freed */
    zone->ptrBui->nZon--;
    if (zone->ptrBui->nZon == 0){
      /* There is no more zone that uses this building fmu */
      free(zone->ptrBui);
      Buildings_nFMU--;
      /* Check if there are any Buildings FMUs left */
      if (Buildings_nFMU == 0){
        free(Buildings_FMUS);
      }
    }

    free(zone->valueReference);
    free(zone);
  }
}
