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

#ifndef WEEKCALGET_c
#define WEEKCALGET_c


/* Get a column value. Cache the last used row internally to speed up lookup. */
double getScheduleValue(void * ID, const int column, const double modelicaTime) {
  WeeklySchedule* scheduleID = (WeeklySchedule*)ID;
  /* extrapolation for weeks that are outside of the user-defined range */
  double t = modelicaTime - scheduleID->t_offset;
  const double weekLen = 7 * 24 * 3600;
  double time = fmod(t - weekLen * floor(t / weekLen), weekLen);
  int i;
  const int columnIndex = column - 1; /* Since we do not store the time indices in the data table */

  /* Not calling weeklyScheduleFreeInit() or weeklyScheduleFree() since weeklyScheduleFreeInit() has already been called at the end of the
  initialization and Modelica will call weeklyScheduleFree() upon a call of ModelicaFormatError) */
  if (column < 0 || column > scheduleID->n_data_cols) {
    ModelicaFormatError("The requested column index '%i' is outside of the table range '%i'.", column + 1, scheduleID->n_data_cols);
  }
  if (column == 0 ) {
    ModelicaFormatError("The column index 1 is not a data column and is reserved for 'time'. It should not be read.");
  }


  if (time == scheduleID->previousTimestamp) {
    i = scheduleID->previousIndex;
  } else if (time > scheduleID->rules[scheduleID->previousIndex]->time) {
    for (i = scheduleID->previousIndex; i < scheduleID->n_allocatedRules - 1; i ++) {
      if (scheduleID->rules[i + 1]->time > time) {
        break;
      }
    }
  } else {
    for (i = scheduleID->previousIndex; i > 0; i--) {
      if (scheduleID->rules[i - 1]->time < time) {
        i = i - 1;
        break;
      }
    }
    /* if time is smaller than the first row, wrap back to the end of the week */
    if (i == 0 && scheduleID->rules[0]->time > time) {
      i = scheduleID->n_allocatedRules - 1;
    }
  }
  scheduleID->previousIndex = i;
  scheduleID->previousTimestamp = time;

  return scheduleID->rules[i]->data[columnIndex];
}

#endif
