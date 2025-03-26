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
  double t_offset;      /* Time offset for monday, midnight. */
  int n_data_cols;      /* Number of used input columns */
  int n_allocatedRules; /* Number rules for which a struct was allocated */
  int n_allocatedRulesData; /* Number rules for which a data vector was allocated */

  double previousTimestamp; /* Time where the schedule was called the previous time */
  int previousIndex;        /* Index where the schedule was called the previous time */


  double * lastData;    /* A work vector */
  char * token;         /* A piece of input string that is being parsed */
  FILE* fp;             /* A file pointer */
  char* buff2;          /* A text buffer */
  struct TimeDataTuple **rules; /* An array of rule pointers */

} WeeklySchedule;



void* weeklyScheduleInit(const int tableOnFile, const char* name, const double t_offset, const char* stringData);

void weeklyScheduleFree(void * ID);

void weeklyScheduleFreeInit(void * ID);

double getScheduleValue(void * ID, const int column, const double time);

#endif
