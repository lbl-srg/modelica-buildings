/*

  This code implements a weekly schedule.

  Changelog:
    June 15, 2024 by Filip Jorissen, Builtwins
          Revisions for #1891: compliance with Modelica include annotation rules.
    April 9, 2024 by Filip Jorissen, Builtwins
          Revisions for #1869 to remove a header requirement that contains the number of rows/columns.
    March 30, 2024 by Filip Jorissen, Builtwins
          Revisions for #1860 to avoid memory leaks when calling ModelicaFormatError.
    May 25, 2022 by Michael Wetter, LBNL
          Refactored to comply with C89.
    March 9, 2022 by Filip Jorissen, KU Leuven
         Initial version.
    April 10, 2022 by Filip Jorissen, KU Leuven
        Added tableOnFile option.

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "WeeklySchedule.h"
#include "ModelicaUtilities.h"

#ifndef WEEKCAL_c
#define WEEKCAL_c


int cmpfun(const void * tuple1, const void * tuple2) {
  const double time1 = (*(const TimeDataTuple **)tuple1)->time;
  const double time2 = (*(const TimeDataTuple **)tuple2)->time;
  return  (time1 - time2);
}

void* weeklyScheduleInit(const int tableOnFile, const char* name, const double t_offset, const char* stringData) {
  const int bufLen = 255;
  const int allocSize = 50;
  WeeklySchedule* scheduleID = NULL;


  int i = 0;              /* iterator */
  int j = 0;              /* iterator */
  int k = 0;              /* iterator */
  int index = 0;          /* index in the token buffer where we are currently writing */
  int line = 0;           /* number of parsed lines */
  int rule_i = 0;         /* rule index where we are currently writing */
  int foundHeader = 0;    /* indicates whether a header has been found */
  int isHeaderLine = 0;   /* indicates whether we are currently parsing the header line */
  int tokensInLine = 0;   /* keeps track of the number of tokens in the current line: column index and sanity check */
  int tokensInFirstLine = 0;
  int comment = 0;        /* we are parsing a comment */
  int n_reservedRules = 0;/* number of rules for which we have allocated memory */
  int n_reservedColumns = allocSize;/* number of columns for which we have allocated memory */
  int n_rulesInRow = 0;   /* number of rules that exist in the current row */
  int n_newLines = 0;     /* number of newlines */
  int mustHaveNewLine = 0;/* The next character must be a newline */
  char c;                 /* the character that is being parsed in this iteration */


  int parseToken = 0;
  double timeStamp;
  int tokenLen;
  int offset = 0;

  scheduleID = (WeeklySchedule*)calloc(1, sizeof(WeeklySchedule));
  if ( scheduleID == NULL){
    ModelicaFormatError("Failed to allocate memory for scheduleID in WeeklySchedule.c.");
  }

  scheduleID->n_allocatedRules = 0;
  scheduleID->n_allocatedRulesData = 0;
  scheduleID->lastData = NULL;
  scheduleID->token = NULL;
  scheduleID->fp = NULL;
  scheduleID->buff2 = NULL;
  scheduleID->rules = NULL;

  scheduleID->token = (char*)calloc(sizeof(char), bufLen);
  if ( scheduleID->token == NULL){
      weeklyScheduleFreeInit(scheduleID);
      weeklyScheduleFree(scheduleID);
      ModelicaFormatError("Failed to allocate memory for token in WeeklySchedule.c.");
  }

  if (tableOnFile){
      scheduleID->fp = fopen(name, "r");
    if (scheduleID->fp == NULL) {
      weeklyScheduleFreeInit(scheduleID);
      weeklyScheduleFree(scheduleID);
      ModelicaFormatError("Failed to open weekly schedule '%s'.", name);
    }
  }

  scheduleID->buff2 = (char*)calloc(sizeof(char), bufLen);
  if (scheduleID->buff2 == NULL){
      weeklyScheduleFreeInit(scheduleID);
      weeklyScheduleFree(scheduleID);
      ModelicaFormatError("Failed to allocate memory for buff in WeeklySchedule.c.");
  }

  scheduleID->rules = (TimeDataTuple**)calloc(sizeof(TimeDataTuple *), allocSize);
  if ( scheduleID->rules == NULL){
    weeklyScheduleFreeInit(scheduleID);
    weeklyScheduleFree(scheduleID);
    ModelicaFormatError("Failed to allocate memory for rules in WeeklySchedule.c.");
  }
  n_reservedRules = allocSize;

  /* Identify 'tokens' by splitting on (one or more) whitespace characters. */
  /* Each token is parsed and special behaviour is created for comments and the header. */
  /* The first column is analysed and split in (one or more) days (which can be comma separated), and hours, minutes, seconds. */
  /* The format is day1,day2,day3:23:59:59 where day* is one of mon, tue, wed, thu, fri, sat, sun. */
  /* All later columns contain data, where '-' serves as a wildcard, where data from the previous rule is reused. */
  /* Rules are sorted by timestamp and then expanded, where '-' is filled in. */
  while ( 1 ) {
    parseToken = 0;

    if (tableOnFile){
      c = fgetc( scheduleID->fp ); /* read a character from the file */
    }else{
      c = stringData[j]; /* read a character from the string */
      j++;
    }
    if ( c == EOF || c == '\0') {
      if (!tableOnFile && c == '\0'){
        break;
      }else if (tableOnFile && feof(scheduleID->fp)) {
        break; /* exit the while loop */
      } else {
        weeklyScheduleFreeInit(scheduleID);
        weeklyScheduleFree(scheduleID);
        ModelicaFormatError("Error while reading file '%s'.", name);
      }
    }{
      if (index >= bufLen - 2) {
        weeklyScheduleFreeInit(scheduleID);
        weeklyScheduleFree(scheduleID);
        ModelicaFormatError("Buffer overflow when reading weekly schedule '%s'.", name);
      }


      if (c == '\n') { /* Check whether a token ends */
        parseToken = 1;
        mustHaveNewLine = 0;
        n_newLines++;
      } else if (mustHaveNewLine == 1){
        weeklyScheduleFreeInit(scheduleID);
        weeklyScheduleFree(scheduleID);
        ModelicaFormatError("Error while reading weekly schedule '%s'. Inconsistent line endings: \\r must be followed by \\n.", name);
      } else if (c == '\r') { /* Check whether a token ends */
        mustHaveNewLine = 1;
      } else if (comment == 1 || c == '#') {
        comment = 1;
        continue; /* ignore this character and the next characters until a newline is detected, then parse the token */
      } else if ( isHeaderLine == 0 && (c == ' ' || c == '\t' ) && index > 0) { /* parse token when reaching a space or tab, unless buffer is empty */
        parseToken = 1;
      } else if (c != ' ' && c != '\t' ) { /* build up the token by copying a character */
        scheduleID->token[index] = c;
        index++;
      }


      /* Parse a token if needed. */
      if (parseToken == 1 && index > 0) {
        /* shouldn't require an overflow check since token is already checked */

        offset = 0;

        scheduleID->token[index] = '\0';
        index++;
        tokenLen = strlen(scheduleID->token);
        index = 0;

        if (foundHeader == 0 && strcmp("double", scheduleID->token) == 0) {
		  /* we found a header line, we expect a specific format after the whitespace */
          foundHeader = 1; /* Avoid checking header line again */
          comment = 1; /* Ignore the rest of the line */
          ModelicaFormatWarning("Detected header line when reading weekly schedule '%s'. This is deprecated. Consider removing the line that starts with 'double tab1'.", name);
        } else if (tokensInLine == 0) {
          /* 0 tokens have been found on this line, so we're parsing a date/time */
          const int ncharsDays = strcspn(scheduleID->token, ":");
          timeStamp = 0;
          if (tokenLen  != ncharsDays) {
            double val;
            const int ncharsHour = strcspn(scheduleID->token + ncharsDays + 1, ":");

            strncpy(scheduleID->buff2, scheduleID->token + ncharsDays + 1, ncharsHour);
            scheduleID->buff2[ncharsHour] = '\0';
            if (sscanf(scheduleID->buff2, "%lf", &val) != 1) {
              weeklyScheduleFreeInit(scheduleID);
              weeklyScheduleFree(scheduleID);
              ModelicaFormatError("Error in float conversion in hours when reading weekly schedule '%s'. Found token %s with length %i", name, scheduleID->buff2, ncharsHour);
            }
            if (val > 24 || val < 0) {
              weeklyScheduleFreeInit(scheduleID);
              weeklyScheduleFree(scheduleID);
              ModelicaFormatError("Unexpected value for hour: '%f' when reading weekly schedule '%s', should be between 0 and 24.", val, name);
            }
            timeStamp += val * 3600;

            if (tokenLen != ncharsHour + ncharsDays + 1) {
              const int ncharsMinutes = strcspn(scheduleID->token + ncharsDays + ncharsHour + 2, ":");
              strncpy(scheduleID->buff2, scheduleID->token + ncharsDays + ncharsHour + 2, ncharsMinutes);
              scheduleID->buff2[ncharsMinutes] = '\0';
              if (sscanf(scheduleID->buff2, "%lf", &val) != 1) {
                weeklyScheduleFreeInit(scheduleID);
                weeklyScheduleFree(scheduleID);
                ModelicaFormatError("Error in float conversion in minutes when reading weekly schedule '%s'.", name);
              }
              if (val > 60 || val < 0) {
                weeklyScheduleFreeInit(scheduleID);
                weeklyScheduleFree(scheduleID);
                ModelicaFormatError("Unexpected value for minute: '%f' when reading weekly schedule '%s', should be between 0 and 60.", val, name);
              }
              timeStamp += val * 60;

              if (tokenLen != ncharsMinutes + ncharsHour + ncharsDays + 2) {
                const int ncharsSeconds = tokenLen - ncharsMinutes - ncharsHour - ncharsDays - 2;
                strncpy(scheduleID->buff2, scheduleID->token + ncharsDays + ncharsHour + ncharsMinutes + 3, ncharsSeconds);
                scheduleID->buff2[ncharsSeconds] = '\0';
                if (sscanf(scheduleID->buff2, "%lf", &val) != 1) {
                  weeklyScheduleFreeInit(scheduleID);
                  weeklyScheduleFree(scheduleID);
                  ModelicaFormatError("Error in float conversion in seconds when reading weekly schedule '%s'.", name);
                }
                if (val > 60 || val < 0) {
                  weeklyScheduleFreeInit(scheduleID);
                  weeklyScheduleFree(scheduleID);
                  ModelicaFormatError("Unexpected value for seconds: '%f' when reading weekly schedule '%s', should be between 0 and 60.", val, name);
                }
                timeStamp += val;
              }
            }
          }
          strncpy(scheduleID->buff2, scheduleID->token, ncharsDays);
          scheduleID->buff2[ncharsDays] = '\0';


          /* loop over all days (comma separated) and for each date, add a rule */
          while ( 1 ) {
            char * startIndex = scheduleID->buff2 + offset;
            double t_day, time_i;
            int nchars = strcspn(startIndex, ",");

            if (nchars != 3 ) {
              weeklyScheduleFreeInit(scheduleID);
              weeklyScheduleFree(scheduleID);
              ModelicaFormatError("Unexpected day format when reading weekly schedule '%s': %s.", name, startIndex);
            }

            if (strncmp("mon", startIndex, 3) == 0) {
              t_day = 0;
            } else if (strncmp("tue", startIndex, 3) == 0) {
              t_day = 1 * 3600 * 24;
            } else if (strncmp("wed", startIndex, 3) == 0) {
              t_day = 2 * 3600 * 24;
            } else if (strncmp("thu", startIndex, 3) == 0) {
              t_day = 3 * 3600 * 24;
            } else if (strncmp("fri", startIndex, 3) == 0) {
              t_day = 4 * 3600 * 24;
            } else if (strncmp("sat", startIndex, 3) == 0) {
              t_day = 5 * 3600 * 24;
            } else if (strncmp("sun", startIndex, 3) == 0) {
              t_day = 6 * 3600 * 24;
            } else {
              weeklyScheduleFreeInit(scheduleID);
              weeklyScheduleFree(scheduleID);
              ModelicaFormatError("Unexpected day format when parsing weekday '%s': %s.", name, startIndex);
            }

            /* expand the memory if the initially assigned memory block does not suffice*/
            if (rule_i >= n_reservedRules) {
              n_reservedRules += allocSize;
              scheduleID->rules = (TimeDataTuple**)realloc(scheduleID->rules, sizeof(TimeDataTuple*) * n_reservedRules);
              if (scheduleID->rules == NULL) {
                weeklyScheduleFreeInit(scheduleID);
                weeklyScheduleFree(scheduleID);
                ModelicaFormatError("Failed to reallocate memory when reading weekly schedule '%s'.", name);
              }
            }

            time_i = timeStamp + t_day;
            scheduleID->rules[rule_i] = (TimeDataTuple*)calloc(sizeof(TimeDataTuple), 1);
            if ( scheduleID->rules[rule_i] == NULL){
              weeklyScheduleFreeInit(scheduleID);
              weeklyScheduleFree(scheduleID);
              ModelicaFormatError("Failed to allocate memory for rules[rule_i] in WeeklySchedule.c.");
            }
            scheduleID->n_allocatedRules++;

            scheduleID->rules[rule_i]->time = time_i;
            scheduleID->rules[rule_i]->data = (double*)calloc(sizeof(double), n_reservedColumns);
            if ( scheduleID->rules[rule_i]->data == NULL){
              weeklyScheduleFreeInit(scheduleID);
              weeklyScheduleFree(scheduleID);
              ModelicaFormatError("Failed to allocate memory for rules[rule_i]->data in WeeklySchedule.c.");
            }
            scheduleID->n_allocatedRulesData++;

            rule_i++;
            n_rulesInRow++;

            if (strlen(startIndex) == 3) { /*reached the end of the substring*/
              break;
            }
            offset = offset + 4; /* the length of a token and a comma*/
          }

          tokensInLine++;
        } else if (tokensInLine > 0) {
          double val;

          /* a token has been found on this line before, so we're parsing some numerical data*/
          if (tokensInFirstLine != 0 && tokensInLine + 1 > tokensInFirstLine){
              weeklyScheduleFreeInit(scheduleID);
              weeklyScheduleFree(scheduleID);
              ModelicaFormatError("Too many columns on data line %i when reading weekly schedule '%s'. %i instead of %i.", line, name, tokensInLine + 1, tokensInFirstLine);
          }else if (tokensInLine >= n_reservedColumns) { /* This code should only be reached upon passing the first line of data */
            n_reservedColumns += allocSize;
            scheduleID->rules[rule_i-1]->data = (double*)realloc(scheduleID->rules[rule_i-1]->data, sizeof(double)*n_reservedColumns);
            if ( scheduleID->rules[rule_i-1]->data == NULL){
              weeklyScheduleFreeInit(scheduleID);
              weeklyScheduleFree(scheduleID);
              ModelicaFormatError("Failed to reallocate memory for rules[rule_i-1]->data in WeeklySchedule.c.");
            }
          }

          if (sscanf(scheduleID->token, "%lf", &val) != 1) {
            if (scheduleID->token[0] == '-') {
              val = HUGE_VAL; /*convert the wildcard in a double representation*/
            } else {
              weeklyScheduleFreeInit(scheduleID);
              weeklyScheduleFree(scheduleID);
              ModelicaFormatError("Invalid format for float %s  when reading weekly schedule '%s'.", scheduleID->token, name);
            }

          }
          /* Set the data for all rules that result from this row.*/
          for (i = rule_i - n_rulesInRow; i < rule_i; ++i) {
            scheduleID->rules[i]->data[tokensInLine - 1] = val;
          }

          tokensInLine++;
        } else {
          weeklyScheduleFreeInit(scheduleID);
          weeklyScheduleFree(scheduleID);
          ModelicaFormatError("Logic error when reading weekly schedule '%s'.", name); /*should not be able to end up here*/
        }
      }
      if (c == '\n') { 
        if (tokensInFirstLine == 0 && tokensInLine > 0){
          tokensInFirstLine = tokensInLine;
        }else if (tokensInLine > 0 && tokensInLine != tokensInFirstLine) {
          weeklyScheduleFreeInit(scheduleID);
          weeklyScheduleFree(scheduleID);
          ModelicaFormatError("Too few columns on data line %i when reading weekly schedule '%s'. %i instead of %i", line, name, tokensInLine, tokensInFirstLine);
        }

        /*reset some internal variables*/
        line++;
        tokensInLine = 0;
        comment = 0;
        n_rulesInRow = 0;
      }
    }
  }

  if (n_newLines==0){
    weeklyScheduleFreeInit(scheduleID);
    weeklyScheduleFree(scheduleID);
    ModelicaFormatError("In weekly schedule '%s': The provided %s is incorrectly formatted since it does not contain newline characters.", name, tableOnFile ? "file": "string parameter");
  }

  /* sort all data by time stamp*/
  qsort(scheduleID->rules, rule_i, sizeof(TimeDataTuple*), cmpfun);

  {
    /* working vector with zero initial value*/
    scheduleID->lastData = (double*)calloc(sizeof(double), tokensInFirstLine - 1);
    if (scheduleID->lastData == NULL){
      weeklyScheduleFreeInit(scheduleID);
      weeklyScheduleFree(scheduleID);
      ModelicaFormatError("Failed to allocate memory for lastData in WeeklySchedule.c., tokensInFirstLine - 1 = %d", tokensInFirstLine - 1);
    }

    memset(scheduleID->lastData, (char)(double)0, tokensInFirstLine - 1); /* set vector to zero initial guess*/

    /* Loop over all data and fill in wildcards using the last preceeding value.*/
    /* This may wrap back to the end of last week, therefore loop the data twice.*/
    /* If an entire column contains wildcards then use a default value of zero.*/

    for (i = 0; i < 2; ++i) {
      for (j = 0; j < rule_i; ++j) {
        for (k = 0; k < tokensInFirstLine - 1; ++k) {
          if ( scheduleID->rules[j]->data[k] != HUGE_VAL ) {
            scheduleID->lastData[k] = scheduleID->rules[j]->data[k];
          } else if (i > 0) {
            /* only on the second pass, since otherwise the default value is filled in permanently and
               information from the back of the domain can't be recycled */
            scheduleID->rules[j]->data[k] = scheduleID->lastData[k];
          }
        }
      }
    }
  }

  /* store data for later use */
  scheduleID->t_offset = t_offset;
  scheduleID->previousIndex = 0;
  scheduleID->previousTimestamp = HUGE_VAL;
  scheduleID->n_data_cols = tokensInFirstLine - 1;

  weeklyScheduleFreeInit(scheduleID);

  return (void*) scheduleID;
}


void weeklyScheduleFreeInit(void * ID) {
  WeeklySchedule* scheduleID = (WeeklySchedule*)ID;

  if (scheduleID->lastData != NULL)
    free(scheduleID->lastData);

  if (scheduleID->token != NULL)
    free(scheduleID->token);

  if (scheduleID->fp != NULL)
    fclose(scheduleID->fp);

  if (scheduleID->buff2 != NULL)
    free(scheduleID->buff2);

}

#endif
