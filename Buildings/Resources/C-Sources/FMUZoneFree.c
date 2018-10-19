/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/03/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

void FMUBuildingFree(void* object){
  if ( object != NULL ){
    FMUBuilding* bld = (FMUBuilding*) object;
    dlclose(bld->fmu->dllHandle);
    free(bld);
  }
}

void FMUZoneFree(void* object){
  int i;
  ModelicaMessage("Enter FMUZoneFree.\n");

  if ( object != NULL ){
    FMUZone* zone = (FMUZone*) object;
    /* Free the memory for the zone name in the structure
       of the FMU for this building. We simply remove one
       name, which may not be for this zone. But this does not matter
       as anyway all zones will be deconstructed by Modelica. */
    free(zone->ptrBui->zoneNames[zone->ptrBui->nZon - 1]);
    /* free(zone->ptrBui->zones[zone->ptrBui->nZon - 1]); */
    zone->ptrBui->nZon--;
    /* Check if the building FMU can be freed. */
    if (zone->ptrBui->nZon == 0){
      /* There is no more zone that uses this building FMU. */
      free(zone->ptrBui->name);
      free(zone->ptrBui->weather);
      free(zone->ptrBui->idd);
      free(zone->ptrBui->epLib);
      free(zone->ptrBui->zoneNames);
      free(zone->ptrBui->zones);
      free(zone->ptrBui);
      ModelicaMessage("Calling FMUBuildingFree.\n");
      FMUBuildingFree(zone->ptrBui);
      ModelicaMessage("Returned from FMUBuildingFree.\n");
      Buildings_nFMU--;
      /* Check if there are any Buildings FMUs left. */
      if (Buildings_nFMU == 0){
        free(Buildings_FMUS);
      }
    }
    free(zone);
  }
  ModelicaMessage("Leaving FMUZoneFree.\n");
}
