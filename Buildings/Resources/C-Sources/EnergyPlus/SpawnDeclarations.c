/*
  Implementation of definitions needed for
  Spawn of EnergyPlus coupling.
 */
#ifndef _Spawn_declared
#define _Spawn_declared

#include <ModelicaUtilities.h>

void (*SpawnMessage)(const char *string)            = ModelicaMessage      ;
void (*SpawnError)(const char *string)              = ModelicaError        ;
void (*SpawnFormatMessage)(const char *string, ...) = ModelicaFormatMessage;
void (*SpawnFormatError)(const char *string, ...)   = ModelicaFormatError  ;

int getOS(){
  return 1;
}

#endif
