/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  5/22/2020
 */
#ifndef Buildings_InputVariableAllocate_h
#define Buildings_InputVariableAllocate_h

#include "EnergyPlusFMU.h"
#include "EnergyPlusUtil.h"

/* Create the structure and return a pointer to its address. */
void* InputVariableAllocate(
  const int objectType,
  const char* modelicaNameBuilding,
  const char* modelicaNameInputVariable,
  const char* idfName,
  const char* weaName,
  const char* name,
  const char* componentType,
  const char* controlType,
  const char* unit,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* spawnLinuxExecutable,
  const int verbosity);

#endif
