/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/03/2018
 */

#include "SpawnObjectFree.h"
#include "SpawnFMU.h"

#include <stdlib.h>
#include <stdbool.h>

void free_Spawn_EnergyPlus_24_2_0(void* object){
  if ( object != NULL ){
    SpawnObject* ptrSpaObj = (SpawnObject*) object;
    size_t iBui;
    size_t iExcObj;
    FMUBuilding* ptrBui = NULL;
    size_t foundIdx = 0;
    bool found = false;

    /* Search for this SpawnObject in all buildings' exchange arrays by comparing
       pointer addresses, without dereferencing ptrSpaObj.
       OpenModelica (like Dymola 2019FD01) may call the constructor multiple times
       for the same Modelica instance, and the allocator returns the same pointer
       each time (see setExchangePointerIfAlreadyInstanciated in SpawnObjectAllocate.c).
       In that case, the destructor is also called multiple times for the same pointer.
       The first destructor call frees the SpawnObject, making any subsequent
       dereference of ptrSpaObj undefined behavior and causing a double-free crash.
       By searching the exchange array first (without touching ptrSpaObj's fields),
       we can detect and skip repeated destructor calls safely.
       Note: If the building was not instantiated due to an error (bui == NULL),
       the SpawnObject will not be in any exchange array and will not be freed here.
       This is a minor memory leak in the error path which is acceptable since
       the simulation will abort anyway. */
    for(iBui = 0; iBui < getBuildings_nFMU(); iBui++){
      ptrBui = getBuildingsFMU(iBui);
      for(iExcObj = 0; iExcObj < ptrBui->nExcObj; iExcObj++){
        if (ptrBui->exchange[iExcObj] == object){
          foundIdx = iExcObj;
          found = true;
          break;
        }
      }
      if (found) break;
    }

    if (found){
      /* The SpawnObject is registered in a building's exchange array.
         Remove it from the array and perform cleanup. */

      /* Remove this SpawnObject from the exchange array by shifting elements */
      ptrBui->nExcObj--;
      for(iExcObj = foundIdx; iExcObj < ptrBui->nExcObj; iExcObj++){
        ptrBui->exchange[iExcObj] = ptrBui->exchange[iExcObj + 1];
      }

      /* Free the building if no more SpawnObjects reference it */
      FMUBuildingFree(ptrBui);

      /* Free the SpawnObject itself */
      free(ptrSpaObj);
    }
    /* else: The SpawnObject was not found in any building's exchange array.
       This happens when the destructor is called a second time for the same pointer
       (double-destructor scenario) - the object was already removed from the
       exchange array and freed in the first destructor call. Skip to avoid
       a double-free crash.
       It can also happen if there was an error during instantiation before
       AddSpawnObjectToBuilding was called (bui == NULL). In that case the
       SpawnObject is not freed, which is a minor memory leak in an error path
       where the simulation would abort anyway. */
  }
}