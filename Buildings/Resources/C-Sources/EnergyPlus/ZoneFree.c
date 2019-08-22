/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/03/2018
 */

#include "ZoneFree.h"
#include "EnergyPlusStructure.c"

#include <stdlib.h>

void FMUBuildingFree(FMUBuilding* ptrBui){
  fmi2Status status;
  const char * log = NULL;
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaMessage("Entered FMUBuildingFree.");

  if ( ptrBui != NULL ){
    /* The call to fmi2_import_terminate causes a seg fault if
       fmi2_import_create_dllfmu was not successful */
    if (ptrBui->dllfmu_created){
      if (FMU_EP_VERBOSITY >= MEDIUM)
        ModelicaMessage("fmi2_import_terminate: terminating EnergyPlus.\n");
      status = fmi2_import_terminate(ptrBui->fmu);
      if (status != fmi2OK){
        ModelicaFormatMessage("fmi2Terminate returned with non-OK status for building %s.", ptrBui->name);
      }
    }
    if (ptrBui->fmu != NULL){
      if (FMU_EP_VERBOSITY >= MEDIUM)
        ModelicaMessage("fmi2_import_destroy_dllfmu: destroying dll fmu.");
      fmi2_import_destroy_dllfmu(ptrBui->fmu);
      fmi2_import_free(ptrBui->fmu);
    }
    if (ptrBui->context != NULL){
      fmi_import_free_context(ptrBui->context);
    }

    if (ptrBui->buildingsLibraryRoot != NULL)
      free(ptrBui->buildingsLibraryRoot);
    if (ptrBui->name != NULL)
      free(ptrBui->name);
    if (ptrBui->weather != NULL)
      free(ptrBui->weather);
    if (ptrBui->idd != NULL)
      free(ptrBui->idd);
    if (ptrBui->zoneNames != NULL)
      free(ptrBui->zoneNames);
    if (ptrBui->zones != NULL)
      free(ptrBui->zones);
    if (ptrBui->tmpDir != NULL)
      free(ptrBui->tmpDir);
    free(ptrBui);
  }
}

void ZoneFree(void* object){
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaMessage("Entered ZoneFree.");
  if ( object != NULL ){
    FMUZone* zone = (FMUZone*) object;
    /* Free the memory for the zone name in the structure
       of the FMU for this building. We simply remove one
       name, which may not be for this zone. But this does not matter
       as anyway all zones will be deconstructed by Modelica. */
    if (zone->ptrBui != NULL && zone->ptrBui->zoneNames != NULL){
      free(zone->ptrBui->zoneNames[zone->ptrBui->nZon - 1]);
    }

    /* The building may not have been instanciated yet if there was an error during instantiation */
    if (zone->ptrBui != NULL){
      zone->ptrBui->nZon--;

      /* Check if the building FMU can be freed. */
      if (zone->ptrBui->nZon == 0){
        /* There is no more zone that uses this building FMU. */
        FMUBuildingFree(zone->ptrBui);
        decrementBuildings_nFMU();
        if (getBuildings_nFMU() == 0){
         free(Buildings_FMUS);
        }
      }
    }
    free(zone);
  }
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaMessage("Leaving ZoneFree.");
}
