/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

double FMUZoneExchange(void* object, double T, double Q_flow){
//  char msg[200];

  FMUZone* zone = (FMUZone*) object;

//  snprintf(msg, 200,
//    "*** In exchange for bldg: %s; zone: %s, n = %d, pointer to fmu %p.\n",
//    zone->ptrBui->fmu,
//    zone->name,
//    zone->nValueReference,
//    zone->ptrBui);
//  ModelicaMessage(msg);
  return 2.;
}
