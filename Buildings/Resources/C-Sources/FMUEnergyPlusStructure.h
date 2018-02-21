/*
 * A structure to store the data needed to communicate with EnergyPlus.
 */

#ifndef Buildings_FMUEnergyPlusStructure_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_FMUEnergyPlusStructure_h

typedef struct FMUBuilding
{
  /* array where the data are stored during the simulation */
  char* fmu;
  void* ptrToFmu;
  int nZon; /* Number of zones that use this FMU */
} FMUBuilding;

typedef struct FMUZone
{
  /* array where the data are stored during the simulation */
  char* name;
  FMUBuilding* ptrBui; /* Pointer to building with this zone */
  unsigned int* valueReference;
  size_t nValueReference;
} FMUZone;

static struct FMUBuilding* Buildings_FMUS[10];
static unsigned int Buildings_nFMU = 0; /* Number of FMUs */
#endif
