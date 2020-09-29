/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_BuildingInstantiate_h
#define Buildings_BuildingInstantiate_h

#include "EnergyPlusTypes.h"
#include "EnergyPlusFMU.h"
#include "EnergyPlusUtil.h"
#include "cryptographicsHash.h"

#include <stdio.h>
#ifdef _MSC_VER
#include <windows.h>
#else
#include <unistd.h>
#endif


#include "fmilib.h"
#include "JM/jm_portability.h"

void buildJSONKeyValue(
    char* *buffer, size_t level, const char* key, const char* value, bool addComma, size_t* size,
    void (*SpawnFormatError)(const char *string, ...));

void generateAndInstantiateBuilding(FMUBuilding* bui);

#endif
