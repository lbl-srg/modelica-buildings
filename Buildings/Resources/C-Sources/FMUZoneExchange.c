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
  double inputValues[1] = {T-273.15};
  double outputValues[1];
  fmi2EventInfo eventInfo;
  int result, i;

  *TRad = 293.15;
  /* Emulate heat transfer to a surface at constant T=18 degC */
  //*QConSen_flow = 10*((273.15+18)-T);
  // snprintf(msg, 200, "local is %f\n", *QConSen_flow);
  // ModelicaMessage(msg);
  *QLat_flow = 0;
  *QPeo_flow = 0;
  FMUZone* tmpZon = malloc(sizeof(FMUZone));
  tmpZon=(FMUZone*)zone->ptrBui->zones[zone->index-1];
  /* Time need to be guarded against rounding error */
  //*tNext = round((floor(time/3600.0)+1) * 3600.0);

  ModelicaFormatMessage("The input value reference for zone %s is %d\n", tmpZon->name, tmpZon->inputValueReferences[0]);
  ModelicaFormatMessage("The output value reference for zone %s is %d\n", tmpZon->name, tmpZon->outputValueReferences[0]);

  result = zone->ptrBui->fmu->setVariables(tmpZon->inputValueReferences, inputValues, 1, NULL);
  if(result<0){
    ModelicaFormatMessage("Failed to set setup variables for building FMU with name %s\n",
    zone->ptrBui->name);
  }
  result = zone->ptrBui->fmu->getVariables(tmpZon->outputValueReferences, outputValues, 1, NULL);
  if(result<0){
    ModelicaFormatMessage("Failed to get setup variables for building FMU with name %s\n",
    zone->ptrBui->name);
  }
  ModelicaFormatMessage("The sensible cooling computed by E+ at time %f for zone %s is %f\n", time, tmpZon->name, outputValues[0]);

  *QConSen_flow=outputValues[0];
  result = zone->ptrBui->fmu->getNextEventTime(&eventInfo, NULL);
  if(result<0){
    ModelicaFormatMessage("Failed to get next event time for building FMU with name %s\n",
    zone->ptrBui->name);
  }
  *tNext = eventInfo.nextEventTime;
  result = zone->ptrBui->fmu->setTime(*tNext, NULL);
  if(result<0){
    ModelicaFormatMessage("Failed to set time for building FMU with name %s\n",
    zone->ptrBui->name);
  }
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
