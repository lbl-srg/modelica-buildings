/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

double FMUZoneExchange(void* object, double T, double Q_flow){
  char msg[100];

  FMUZone* zone = (FMUZone*) object;

  snprintf(msg, 100,
    "*** In exchange for %s:%s, n = %d, pointer is %p.\n",
    zone->fmu,
    zone->name,
    zone->nValueReference,
    ptrToFmu);
  ModelicaMessage(msg);
  return 2.;
}
