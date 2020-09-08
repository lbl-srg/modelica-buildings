/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_ZoneExchange_h
#define Buildings_ZoneExchange_h

#include "EnergyPlusTypes.h"
#include "EnergyPlusFMU.h"
#include "ZoneInstantiate.h"
#include "FMI2/fmi2_import_capi.h"


LBNL_EnergyPlus_EXPORT void EnergyPlusZoneExchange(
  void* object,
  int initialCall,
  double T,
  double X,
  double mInlets_flow,
  double TAveInlet,
  double QGaiRad_flow,
  double AFlo,
  double time,
  double* TRad,
  double* QConSen_flow,
  double* dQConSen_flow,
  double* QLat_flow,
  double* QPeo_flow,
  double* tNext);

#endif
