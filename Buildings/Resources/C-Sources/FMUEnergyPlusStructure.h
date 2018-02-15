/*
 * A structure to store the data needed to communicate with EnergyPlus.
 */

#ifndef Buildings_FMUEnergyPlusStructure_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_FMUEnergyPlusStructure_h

static void* ptrToFmu = 0;

typedef struct FMUBuilding
{
  /* array where the data are stored during the simulation */
  char* fmu;
} FMUBuilding;

typedef struct FMUZone
{
  /* array where the data are stored during the simulation */
  char* name;
  char* fmu; /* Name of the fmu that contains this zone. For reporting only */
  unsigned int* valueReference;
  size_t nValueReference;
} FMUZone;

#endif
