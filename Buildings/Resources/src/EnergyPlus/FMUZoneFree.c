/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/03/2018
 */

#include "FMUEnergyPlusStructure.h"
#include "ModelicaUtilities.h"

#include <stdlib.h>

void FMUBuildingFree(FMUBuilding* ptrBui){
  if ( ptrBui != NULL ){
    free(ptrBui->name);
    free(ptrBui->weather);
    free(ptrBui->idd);
    free(ptrBui->epLib);
    free(ptrBui->zoneNames);
    free(ptrBui->zones);
    ModelicaMessage("Attempting to close EnergyPlus library.\n");
#ifdef _MSC_VER
    if (!FreeLibrary(ptrBui->fmu->dllHandle)){
      ModelicaMessage("Warning: Failed to free EnergyPlus library.");
    }
#else
    if (0 != dlclose(ptrBui->fmu->dllHandle)){
      ModelicaMessage("Warning: Failed to free EnergyPlus library.");
    }
#endif
    ModelicaMessage("Closed EnergyPlus library.\n");
    free(ptrBui);
  }
}

void FMUZoneFree(void* object){
  ModelicaMessage("*** Entered FMUZoneFree.");
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
      FMUBuildingFree(zone->ptrBui);
      decrementBuildings_nFMU();
    }
    free(zone);
    ModelicaMessage("Freed zone.\n");
  }
}
