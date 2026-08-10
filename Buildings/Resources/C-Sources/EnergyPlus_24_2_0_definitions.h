#ifndef EnergyPlus_24_2_0_definitions_h
#define EnergyPlus_24_2_0_definitions_h

#include <stdint.h>


/* Check for 64 bit */
/* Windows */
#if _WIN32 || _WIN64
#if _WIN64
#define ENVIRONMENT64
#else
#define ENVIRONMENT32
#endif
#endif

/* gcc */
#if __GNUC__
#if __x86_64__ || __ppc64__
#define ENVIRONMENT64
#else
#define ENVIRONMENT32
#endif
#endif

#ifndef ENVIRONMENT64
#error Modelica Spawn coupling is only supported for Windows and Linux 64 bit. Your operating system is not 64 bit.
#endif

#include "ModelicaUtilities.h"

typedef struct {
  int dayOfWeekForStartDay; /* Day of week from Buildings.ThermalZones.EnergyPlus_24_2_0.Types.WeekDays */
  int applyWeekEndHolidayRule;
  int use_weatherFileDaylightSavingPeriod;
  int use_weatherFileHolidaysAndSpecialDays;
  int use_weatherFileRainIndicators;
  int use_weatherFileSnowIndicators;
} runPeriod;

#endif
