/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/03/2018
 */

#include "FMUZoneFree.h"
#include "FMUEnergyPlusStructure.c"

#include <stdlib.h>

void FMUBuildingFree(FMUBuilding* ptrBui){
  fmi2Status status;
  const char * log = NULL;
  if ( ptrBui != NULL ){
  /*  printf("Closing EnergyPlus library for %s.\n", ptrBui->name); */
  /*  ModelicaFormatMessage("Closing EnergyPlus library for %s.\n", ptrBui->name); */
    writeLog(2, "Calling terminate on EnergyPlus library.");
    status = ptrBui->fmu->terminateSim(ptrBui->fmuCom);
    if (status != fmi2OK){
      ModelicaFormatMessage("fmi2Terminate returned with non-OK status for building %s.", ptrBui->name);
    }
    ptrBui->fmu->freeInstance(ptrBui->fmuCom);
    free(ptrBui->fmuCom);
    free(ptrBui->name);
    free(ptrBui->weather);
    free(ptrBui->idd);
    free(ptrBui->epLib);
    free(ptrBui->zoneNames);
    free(ptrBui->zones);
    free(ptrBui->tmpDir);
    writeLog(2, "Freed pointers.");

#ifdef _MSC_VER
    if (!FreeLibrary(ptrBui->fmu->dllHandle)){
      ModelicaMessage("Warning: Failed to free EnergyPlus library.");
    }
#else
    writeLog(2, "Calling dlclose.");
   if (0 != dlclose(ptrBui->fmu->dllHandle)){
      ModelicaMessage("Warning: Failed to free EnergyPlus library.");
    }
#endif
    writeLog(2, "Closing EnergyPlus library.");
    free(ptrBui);
    writeLog(2, "Closed EnergyPlus library.");

  }
}

void FMUZoneFree(void* object){
  writeLog(2, "*** Entered FMUZoneFree.");
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
    writeLog(2, "*** Freed zone.");
  }
  writeLog(2, "*** Leaving FMUZoneFree.");
}
