/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

void FMUZoneInitialize(void* object, double* AFlo, double* V){
//  char msg[200];

  FMUZone* zone = (FMUZone*) object;
// Obtain the floor area and the volume of the zone
  *AFlo = 30;
  *V = 2.7*30;
//  snprintf(msg, 200,
//    "*** In exchange for bldg: %s; zone: %s, n = %d, pointer to fmu %p.\n",
//    zone->ptrBui->name,
//    zone->name,
//    zone->nValueReference,
//    zone->ptrBui);
//  ModelicaMessage(msg);
  return;
}
