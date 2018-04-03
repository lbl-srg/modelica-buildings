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
  double *m_flow, /* size is nFluPor */
  double *TInlet, /* size is nFluPor */
  double QGaiRad_flow,
  double time,
  double* TRad,
  double* QConSen_flow,
  double* QLat_flow,
  double* QPeo_flow,
  double* tNext){
  char msg[200];

  FMUZone* zone = (FMUZone*) object;
  double inputValues[1] = {T};
  double outputValues[4];
  fmi2EventInfo eventInfo;
  int result, i;

  *TRad = 293.15;
  /* Emulate heat transfer to a surface at constant T=18 degC */
  *QConSen_flow = 10*((273.15+18)-T);
  // snprintf(msg, 200, "local is %f\n", *QConSen_flow);
  // ModelicaMessage(msg);
  *QLat_flow = 0;
  *QPeo_flow = 0;
  FMUZone* tmpZon = malloc(sizeof(FMUZone));
  tmpZon=(FMUZone*)zone->ptrBui->zones[zone->index-1];
  /* Time need to be guarded against rounding error */
  //*tNext = round((floor(time/3600.0)+1) * 3600.0);
  result = zone->ptrBui->fmu->setTime(time, NULL);
  result = zone->ptrBui->fmu->setVariables(tmpZon->inputValueReferences, inputValues, 1, NULL);
  result = zone->ptrBui->fmu->getVariables(tmpZon->outputValueReferences, outputValues, 4, NULL);
  // snprintf(msg, 200, "e+ is %f\n", outputValues[0]);
  // ModelicaMessage(msg);
  *QConSen_flow=outputValues[0];
  result = zone->ptrBui->fmu->getNextEventTime(&eventInfo, NULL);
  *tNext = eventInfo.nextEventTime;
/*  snprintf(msg, 200,
    "*** In exchange for bldg: %s; zone: %s, time = %f, tNext = %f, pointer to fmu %p.\n",
    zone->ptrBui->name,
    zone->name,
    time,
    *tNext,
    zone->ptrBui);
  ModelicaMessage(msg);
*/
  return;
}
