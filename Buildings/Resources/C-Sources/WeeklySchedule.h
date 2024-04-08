/*

  This code implements a weekly schedule.
  See modelica model for documentation.


  Changelog:
    March 9, 2022 by Filip Jorissen, KU Leuven
        Initial version.
    April 10, 2022 by Filip Jorissen, KU Leuven
        Added tableOnFile option.

*/


#ifndef WEEKCAL_h
#define WEEKCAL_h


typedef struct TimeDataTuple {
  double time;	/* Time relative to monday midnight. */
  double *data; /* Corresponding column data */
} TimeDataTuple;


typedef struct WeeklySchedule {
  double t_offset;    /* Time offset for monday, midnight. */
  int n_rows_in;      /* Number of input rows */
  int n_cols_in;      /* Number of input columns */

  double previousTimestamp; /* Time where the schedule was called the previous time */
  int previousIndex;        /* Index where the schedule was called the previous time */

  int n_allocatedRules;
  int n_allocatedRulesData;
  double * lastData;
  char * token;
  FILE* fp;
  char* buff2;
  struct TimeDataTuple **rules;

} WeeklySchedule;



void* weeklyScheduleInit(const int tableOnFile, const char* name, const double t_offset, const char* stringData);

void weeklyScheduleFree(void * ID);

void weeklyScheduleFreeInit(void * ID);

double getScheduleValue(void * ID, const int column, const double time);

#endif
