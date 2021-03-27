/*
 * getTimeSpan.c
 */

#include <stdio.h>
#include <ModelicaUtilities.h>
#include "getTimeSpan.h"

/*
 * Function: concat
 * -----------------
 *  Concatenate two strings. This function calls malloc and hence
 *  the caller must call free when the returned string is no longer used.
 *
 *  s1: string one
 *  s2: string two
 *
 *  returns: concatenate strings (s1 + s2)
 */
char *concat(const char *s1, const char *s2) {
  const size_t len1 = strlen(s1);
  const size_t len2 = strlen(s2);
  char *result = malloc(len1 + len2 + 1);
  if (result == NULL) {
    ModelicaError("Failed to allocate memory in getTimeSpan.c");
  }
  strcpy(result, s1);
  strcat(result, s2);
  return result;
}

/*
 * Move the file pointer to the first character of the next line
 */
void advanceToNextLine(const char * fileName, FILE *fp, unsigned int* iLin, unsigned int* iCol){
  int c;
  while(1){
    c = fgetc(fp);
    (*iCol)++;
    if (c == EOF) {
       ModelicaFormatError("%s:%u,%u: Received unexpected EOF when searching for new line.",
         fileName, *iLin, *iCol);
    }
    if (c == '\n'){
      (*iLin)++;
      *iCol = 1;
      /* Found the end of the line */
      return;
    }
  }
}

/*
 * Function: getTimeSpan
 * ---------------------
 * Get start and end time of weather data.
 *
 * fileName: weather data file path
 * tabName: name of table on weather file
 * timeSpan: vector [start time, end time]
 */
void getTimeSpan(const char * fileName, const char * tabName, double* timeSpan) {
  double firstTimeStamp, lastTimeStamp, interval;
  int rowCount;
  int columnCount;
  int retVal;

  FILE *fp;
  int c;
  int i = 0;
  unsigned int iLin = 1;
  unsigned int iCol = 1;

  /* create format string: "%*s tab1(rowCount, columnCount)" */
  char *tempString = concat("%*s ", tabName);
  char *formatString = concat(tempString, "(%d,%d)");
  free(tempString);

  fp = fopen(fileName, "r");
  if (fp == NULL){
    ModelicaFormatError("Failed to open file %s", fileName);
  }

  /* find rowCount and columnCount */
  while (1) {
    if (fscanf(fp, formatString, &rowCount, &columnCount) == 2){
      break;
    }
  }
  free(formatString);

   /* find the end of file header */
  while(1){
    advanceToNextLine(fileName, fp, &iLin, &iCol);
    c = getc(fp);
    if (c == EOF) {
       ModelicaFormatError("%s:%u,%u: Received unexpected EOF when searching for first character of line.",
       fileName, iLin, iCol);
    }
    if ( ungetc(c, fp) == EOF ){
      ModelicaError("Unexpected EOF when putting character back.");
    }
    /* Don't advance iCol because of the ungetc above */
    if ( c != '#'){
      /* This not a header line.*/
      break;
    }
  }

  /* find first time stamp */
  retVal = fscanf(fp, "%lf", &firstTimeStamp);
  if (retVal == EOF){
    ModelicaFormatError("%s:%u,%u: Received unexpected EOF when searching for first time stamp.",
    fileName, iLin, iCol);
  }

  /* scan to file end, to find the last time stamp */
  for(i = 0; i < rowCount-1; i++) {
    advanceToNextLine(fileName, fp, &iLin, &iCol);
  }
  retVal = fscanf(fp, "%lf", &lastTimeStamp);
  if (retVal == EOF){
    ModelicaFormatError("%s:%u,%u: Received unexpected EOF when searching last time stamp.",
    fileName, iLin, iCol);
  }
  fclose(fp);

  /* find average time interval */
  if (rowCount < 2){
    ModelicaFormatError("Expected rowCount larger than 2 when reading %s.", fileName);
  }
  interval = (lastTimeStamp - firstTimeStamp) / (rowCount - 1);

  timeSpan[0] = firstTimeStamp;
  timeSpan[1] = lastTimeStamp + interval;

  return;
}
