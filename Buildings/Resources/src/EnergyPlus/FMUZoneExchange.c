/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/16/2018
 */

#include "EnergyPlusModelicaUtilities.h"
#include "FMUEnergyPlusStructure.h"

#include <stdlib.h>
#include <math.h>

void setGetVariables(
  FMUZone* fmuZon,
  fmi2ValueReference inputValueReferences[],
  fmi2Real inputValues[],
  size_t nInp,
  fmi2ValueReference outputValueReferences[],
  fmi2Real outputValues[],
  size_t nOut)
  {
    int result = fmuZon->ptrBui->fmu->setVariables(inputValueReferences, inputValues, nInp, NULL);
    if(result < 0){
      EnergyPlusFormatError("Failed to set variables for building FMU with name %s\n", fmuZon->ptrBui->name);
    }
    result = fmuZon->ptrBui->fmu->getVariables(outputValueReferences, outputValues, 1, NULL);
    if(result < 0){
      EnergyPlusFormatError("Failed to get variables for building FMU with name %s\n", fmuZon->ptrBui->name);
    }
  }

void FMUZoneExchange(
  void* object,
  double T,
  double X,
  double mInlets_flow,
  double TAveInlet,
  double QGaiRad_flow,
  double time,
  double* TRad,
  double* QConSen_flow,
  double* dQConSen_flow,
  double* QLat_flow,
  double* QPeo_flow,
  double* tNext){

  FMUZone* zone = (FMUZone*) object;
  double inputValues[1];
  double outputValues[1];
  fmi2EventInfo eventInfo;
  int result;

  /* Emulate heat transfer to a surface at constant T=18 degC */
  /* *QConSen_flow = 10*((273.15+18)-T);*/
  /* snprintf(msg, 200, "local is %f\n", *QConSen_flow); */
  const double dT = 0.01; /* Increment for derivative approximation */
  double QConSenPer_flow;

  /* EnergyPlusFormatMessage("*** Entered FMUZoneExchange at t = %f  ", time); */


  FMUZone* tmpZon = malloc(sizeof(FMUZone));
  if ( tmpZon == NULL )
    EnergyPlusError("Not enough memory in FMUZoneExchange.c. to allocate memory for zone.");
  tmpZon=(FMUZone*)zone->ptrBui->zones[zone->index-1];
  /* Time need to be guarded against rounding error */
  /* *tNext = round((floor(time/3600.0)+1) * 3600.0); */
  result=zone->ptrBui->fmu->setTime(time, NULL);
  if(result<0){
    EnergyPlusFormatError("Failed to set time in building FMU with name %s.",
    zone->ptrBui->name);
  }

  /* Forward difference for QConSen_flow */
  inputValues[0] = T - 273.15 + dT;
  setGetVariables(zone, tmpZon->inputValueReferences, inputValues, 1, tmpZon->outputValueReferences, outputValues, 1);
  QConSenPer_flow=outputValues[0];
  inputValues[0] = T - 273.15;
  setGetVariables(zone, tmpZon->inputValueReferences, inputValues, 1, tmpZon->outputValueReferences, outputValues, 1);
  *QConSen_flow=outputValues[0];
  *dQConSen_flow = (QConSenPer_flow-*QConSen_flow)/dT;

  /* Get next event time */
  result = zone->ptrBui->fmu->getNextEventTime(&eventInfo, NULL);
  if(result<0){
    EnergyPlusFormatError("Failed to get next event time for building FMU with name %s.",
    zone->ptrBui->name);
  }
  if(eventInfo.terminateSimulation == fmi2True){
    EnergyPlusFormatError("EnergyPlus requested to terminate the simulation for building = %s, zone = %s, time = %f.",
    zone->ptrBui->name, zone->name, time);
  }
  if(eventInfo.nextEventTimeDefined == fmi2False){
    EnergyPlusFormatError("EnergyPlus failed to declare the next event time for building = %s, zone = %s, time = %f. Check with support.",
    zone->ptrBui->name, zone->name, time);
  }
  *tNext = eventInfo.nextEventTime;
  /* result = zone->ptrBui->fmu->setTime(*tNext, NULL); */
  if(result<0){
    EnergyPlusFormatError("Failed to set time for building FMU with name %s.",
    zone->ptrBui->name);
  }

  *TRad = 293.15;
  *QLat_flow = 0;
  *QPeo_flow = 0;

  return;
}
