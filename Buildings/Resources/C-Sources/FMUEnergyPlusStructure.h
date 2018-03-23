/*
 * A structure to store the data needed to communicate with EnergyPlus.
 */

#ifndef Buildings_FMUEnergyPlusStructure_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_FMUEnergyPlusStructure_h

#include <stddef.h>  /* stddef defines size_t */

typedef struct FMUBuilding
{
  char* name;
  int nZon; /* Number of zones that use this FMU */
  char** zoneNames; /* Names of zones in this FMU */
  void** zones; /* Pointers to all zones*/
} FMUBuilding;

typedef struct FMUZone
{
  char* name;          /* Name of this zone */
  FMUBuilding* ptrBui; /* Pointer to building with this zone */
  unsigned int* valueReference; /* Value references for this zone */
  size_t nValueReference;
  size_t nInputValueReferences;/* Number of input value references*/
  char** inputVariableNames; /* Names of input variables*/
  int* inputValueReferences; /* Value reference of input variables*/
  size_t nOutputValueReferences;/* Number of output value references*/
  char** outputVariableNames; /* Names of output variables*/
  int* outputValueReferences; /* Value references of output variables*/
} FMUZone;

static struct FMUBuilding** Buildings_FMUS; /* Array with pointers to all FMUs */
static unsigned int Buildings_nFMU = 0;     /* Number of FMUs */
#endif
