#ifndef ENERGYPLUS_MODELICA_UTILITIES_H
#define ENERGYPLUS_MODELICA_UTILITIES_H

//#include <stdio.h>
#include <stdarg.h>

void EnergyPlusFormatError(const char * message, ...);

void EnergyPlusFormatMessage(const char * message, ...);

void EnergyPlusError(const char * message);

void EnergyPlusMessage(const char * message);

#endif
