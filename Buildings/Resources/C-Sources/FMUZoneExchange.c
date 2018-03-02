/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>
#include <math.h>

void FMUZoneExchange(
  void* object,
  double T,
  double X,
  double* m_flow, /* size is nFluPor */
  double* TInlet, /* size is nFluPor */
  double QGaiRad_flow,
  double time,
  double* TRad,
  double* QConSen_flow,
  double* QLat_flow,
  double* QPeo_flow,
  double* tNext){
//  char msg[200];

  FMUZone* zone = (FMUZone*) object;

  *TRad = 293.15;
  /* Emulate heat transfer to a surface at constant T=18 degC */
  *QConSen_flow = 10*((273.15+18)-T);
  *QLat_flow = 0;
  *QPeo_flow = 0;
  /* Time need to be guarded against rounding error */
  *tNext = round((floor(time/3600.0)+1) * 3600.0);
//  snprintf(msg, 200,
//    "*** In exchange for bldg: %s; zone: %s, time = %f, tNext = %f, pointer to fmu %p.\n",
//    zone->ptrBui->name,
//    zone->name,
//    time,
//    *tNext,
//    zone->ptrBui);
//  ModelicaMessage(msg);

  return;
}
