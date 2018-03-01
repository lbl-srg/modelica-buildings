/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

void FMUZoneExchange(
  void* object,
  double T,
  double X,
  double[] m_flow, /* size is nFluPor */
  double[] TInlet, /* size is nFluPor */
  double QRadGai_flow,
  double time,
  double* TRad,
  double* QGaiCon_flow,
  double* QGaiLat_flow,
  double* QPeo_flow,
  double* tNext){
//  char msg[200];

  FMUZone* zone = (FMUZone*) object;

//  snprintf(msg, 200,
//    "*** In exchange for bldg: %s; zone: %s, n = %d, pointer to fmu %p.\n",
//    zone->ptrBui->name,
//    zone->name,
//    zone->nValueReference,
//    zone->ptrBui);
//  ModelicaMessage(msg);
  zone->TRad = 293.15;
  zone->QGaiCon_flow = 0;
  zone->QGaiLat_flow = 0;
  zone->QPeo_flow = 0;
  /* Time need to be guarded against rounding error */
  zone->tNext = (double(int(zone->time + 15*3600));
  return;
}
