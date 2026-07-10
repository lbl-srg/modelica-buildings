#ifndef Spawn_declared
#define Spawn_declared

#include "EnergyPlus_24_2_0_Wrapper.h"
#include <stdlib.h>

/* *********************************************************
   Wrapper function that connects to the library which
   generates and loads the EnergyPlus fmu.
  *********************************************************
*/

/* Track freed objects to prevent double-free when OpenModelica calls the
   destructor multiple times for the same external object instance.
   OpenModelica (like Dymola 2019FD01) may call the constructor multiple times
   for the same Modelica object and return the same pointer each time.
   In that case, the destructor is also called multiple times for that pointer.
   We use a simple list to remember which pointers have already been freed. */
static void** EnergyPlus_24_2_0_freed_ptrs = NULL;
static size_t EnergyPlus_24_2_0_freed_count = 0;
static size_t EnergyPlus_24_2_0_freed_capacity = 0;

void Modelica_EnergyPlus_24_2_0_free(void* object){
    size_t i;

    if (object == NULL) return;

    /* Check if this pointer was already freed */
    for (i = 0; i < EnergyPlus_24_2_0_freed_count; i++){
      if (EnergyPlus_24_2_0_freed_ptrs[i] == object){
        /* Already freed - skip to prevent double-free crash */
        return;
      }
    }

    /* Record this pointer as freed */
    if (EnergyPlus_24_2_0_freed_count >= EnergyPlus_24_2_0_freed_capacity){
      void** tmp;
      EnergyPlus_24_2_0_freed_capacity = (EnergyPlus_24_2_0_freed_capacity == 0)
        ? 16 : EnergyPlus_24_2_0_freed_capacity * 2;
      tmp = (void**)realloc(EnergyPlus_24_2_0_freed_ptrs,
        EnergyPlus_24_2_0_freed_capacity * sizeof(void*));
      if (tmp != NULL){
        EnergyPlus_24_2_0_freed_ptrs = tmp;
      }
      else{
        /* realloc failed: proceed without tracking (minor risk of double-free) */
        EnergyPlus_24_2_0_freed_capacity = EnergyPlus_24_2_0_freed_count;
        free_Spawn_EnergyPlus_24_2_0(object);
        return;
      }
    }
    EnergyPlus_24_2_0_freed_ptrs[EnergyPlus_24_2_0_freed_count++] = object;

    free_Spawn_EnergyPlus_24_2_0(object);
}

#endif
