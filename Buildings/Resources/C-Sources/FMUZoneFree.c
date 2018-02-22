/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

void FMUZoneFree(void* object){
  unsigned int i;
  if ( object != NULL ){
    FMUZone* zone = (FMUZone*) object;
    /* Free the memory for the zone name in the structure
       of the FMU for this building. We simply remove one
       name, which may not be for this zone. But this does not matter
       as anyway all zones will be deconstructed by Modelica. */
    free(zone->ptrBui->zoneNames[zone->ptrBui->nZon - 1]);
    zone->ptrBui->nZon--;
    /* Check if the building FMU can be freed. */
    if (zone->ptrBui->nZon == 0){
      /* There is no more zone that uses this building FMU. */
      free(zone->ptrBui->fmu);
      free(zone->ptrBui->zoneNames);
      free(zone->ptrBui);
      Buildings_nFMU--;
      /* Check if there are any Buildings FMUs left. */
      if (Buildings_nFMU == 0){
        free(Buildings_FMUS);
      }
    }
    free(zone->valueReference);
    free(zone);
  }
}
