/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_ZoneExchange_h
#define Buildings_ZoneExchange_h

#include "EnergyPlusStructure.h"
#include "ZoneInstantiate.h"
#include "FMI2/fmi2_import_capi.h"


void ZoneExchange(
  void* object,
  int initialCall,
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
  double* tNext);

fmi2Status do_event_iteration(FMUZone* zone, fmi2_event_info_t *eventInfo);

#endif
