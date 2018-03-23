/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

void FMUZoneInitialize(void* object, double* AFlo, double* V, double* mSenFac){
   char msg[200]; 
   FMUZone* zone = (FMUZone*) object; 

   snprintf(msg, 200, "The number of zones of the building is %d\n.", zone->ptrBui->nZon);
   ModelicaMessage(msg);

   snprintf(msg, 200, "The name of the building is %s\n.", zone->ptrBui->name);
   ModelicaMessage(msg);

   snprintf(msg, 200, "The name of the zone[0] for this building is %s\n.", ((FMUZone*)(zone->ptrBui->zones[0]))->name);
   ModelicaMessage(msg);

/* Obtain the floor area and the volume of the zone */
  *AFlo = 30;
  *V = 2.7*30;
  *mSenFac = 1;
/*  snprintf(msg, 200,
    "*** In exchange for bldg: %s; zone: %s, n = %d, pointer to fmu %p.\n",
    zone->ptrBui->name,
    zone->name,
    zone->nValueReference,
    zone->ptrBui);
  ModelicaMessage(msg);
*/
  return;
}
