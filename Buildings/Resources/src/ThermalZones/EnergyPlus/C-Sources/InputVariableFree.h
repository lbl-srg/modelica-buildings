/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  5/22/2020
 */
#ifndef Buildings_InputVariableFree_h
#define Buildings_InputVariableFree_h

#include "EnergyPlusTypes.h"
#include "EnergyPlusFMU.h"
#include "FMI2/fmi2_import.h"

LBNL_EnergyPlus_EXPORT void EnergyPlusInputVariableFree(void* object);

#endif
