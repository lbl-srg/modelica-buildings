/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_InputOutputFree_h
#define Buildings_InputOutputFree_h

#include "EnergyPlusTypes.h"
#include "EnergyPlusFMU.h"
#include "FMI2/fmi2_import.h"

LBNL_EnergyPlus_EXPORT void EnergyPlusInputOutputFree(void* object);

#endif
