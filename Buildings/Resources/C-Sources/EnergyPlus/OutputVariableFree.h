/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_OutputVariableFree_h
#define Buildings_OutputVariableFree_h

#include "EnergyPlusFMU.h"
#include "FMI2/fmi2_import.h"

void OutputVariableFree(void* object);

#endif
