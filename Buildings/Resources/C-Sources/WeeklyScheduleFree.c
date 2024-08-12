/*

  This code implements a weekly schedule.

  Changelog:
    June 15, 2024 by Filip Jorissen, Builtwins
          Initial version for #1891: compliance with Modelica include annotation rules.

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "WeeklySchedule.h"
#include "ModelicaUtilities.h"

#ifndef WEEKCALFREE_c
#define WEEKCALFREE_c


void weeklyScheduleFree(void * ID) {
  int i;
  WeeklySchedule* scheduleID = (WeeklySchedule*)ID;

  if (ID == NULL) /* Otherwise OM segfaults when IBPSA.Utilities.IO.Files.Examples.WeeklySchedule triggers an error */
    return;

  for (i = 0; i < scheduleID->n_allocatedRulesData; ++i) {
    free(scheduleID->rules[i]->data);
  }
 
  for (i = 0; i < scheduleID->n_allocatedRules; ++i) {
    free(scheduleID->rules[i]);
  }

  if (scheduleID->rules != NULL)
    free(scheduleID->rules);

  free(ID);
  ID = NULL;
}

#endif
