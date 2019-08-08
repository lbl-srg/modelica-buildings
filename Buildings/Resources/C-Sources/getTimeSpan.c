/*
 * getTimeSpan.c
 *
 *  Created on: Apr 16, 2019
 *      Author: jianjun
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "getTimeSpan.h"

/*
 * Function: getLine
 * -----------------
 * Reimplement the getline() function as getline() is not supported on Windows. This
 * implementation is based on:
 * web.mit.edu/freebsd/head/contrib/file/src/getline.c
 * with the following copyright notice:

   * Copyright (c) 2011 The NetBSD Foundation, Inc.
   * All rights reserved.
   *
   * This code is derived from software contributed to The NetBSD Foundation
   * by Christos Zoulas.
   *
   * Redistribution and use in source and binary forms, with or without
   * modification, are permitted provided that the following conditions
   * are met:
   * 1. Redistributions of source code must retain the above copyright
   *    notice, this list of conditions and the following disclaimer.
   * 2. Redistributions in binary form must reproduce the above copyright
   *    notice, this list of conditions and the following disclaimer in the
   *    documentation and/or other materials provided with the distribution.
   *
   * THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND CONTRIBUTORS
   * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
   * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
   * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS
   * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGE.

 */
int getDelim(char **buf, size_t *bufsiz, int delimiter, FILE *fp) {
  char *ptr, *eptr, *nbuf;
  int c;
  size_t nbufsiz;
  size_t d;

  if (*buf == NULL || *bufsiz == 0) {
    *bufsiz = BUFSIZ;
    if ((*buf = malloc(*bufsiz)) == NULL) {
      ModelicaError("Failed to allocate memory in getTimeSpan.c");
    }
  }
  for (ptr = *buf, eptr = *buf + *bufsiz;;) {
    c = fgetc(fp);
    if (c == -1) {
      if (feof(fp)) {
        return ptr == *buf ? -1 : ptr - *buf;
      } else {
        ModelicaFormatError("Received unexpected EOF in getTimeSpan.c when searching lines.");
      }
    }
    *ptr++ = c;
    if (c == delimiter) {
      *ptr = '\0';
      return ptr - *buf;
    }
    if (ptr + 2 >= eptr) {
      nbufsiz = *bufsiz * 2;
      d = ptr - *buf;
      if ((nbuf = realloc(*buf, nbufsiz)) == NULL) {
        ModelicaError("Failed to allocate memory in getTimeSpan.c");
      }
      *buf = nbuf;
      *bufsiz = nbufsiz;
      eptr = nbuf + nbufsiz;
      ptr = nbuf + d;
      free(nbuf);
    }
  }
}

int getLine(char **buf, size_t *bufsiz, FILE *fp)
{
  return getDelim(buf, bufsiz, '\n', fp);
}

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
 * Function: getTimeSpan
 * ---------------------
 * Get start and end time of weather data.
 *
 * fileName: weather data file path
 * tabName: name of table on weather file
 * timeSpan: vector [start time, end time]
 */
int getTimeSpan(const char * fileName, const char * tabName, double* timeSpan) {
  double firstTimeStamp, lastTimeStamp, interval;
  int rowCount, columnCount;
  int rowIndex=0;
  int tempInd=0;
  char *line = NULL;
  int retVal;
  size_t len = 0;

  FILE *fp;

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
    rowIndex++;
    if (fscanf(fp, formatString, &rowCount, &columnCount) == 2) {
      break;
    }
  }
  free(formatString);

  getLine(&line, &len, fp); /* finish the line */
  getLine(&line, &len, fp); /* keep reading next line */
  rowIndex++;

   /* find the end of file head */
  while(strstr(line,"#")) {
    getLine(&line, &len, fp);
    rowIndex++;
  }

  /* find first time stamp */
  retVal = sscanf(line, "%lf", &firstTimeStamp);
  if (retVal == EOF){
    ModelicaFormatError("Received unexpected EOF in getTimeSpan.c when searching for first time stamp in %s.",
    fileName);
  }

  /* scan to file end, to find the last time stamp */
  tempInd = rowIndex;
  while (rowIndex < (rowCount+tempInd-2)) {
    getLine(&line, &len, fp);
    rowIndex++;
  }
  retVal = fscanf(fp, "%lf", &lastTimeStamp);
  if (retVal == EOF){
    ModelicaFormatError("Received unexpected EOF in getTimeSpan.c when searching last time stamp in %s.",
    fileName);
  }
  free(line);
  fclose(fp);

  /* find average time interval */
  if (rowCount < 2){
    ModelicaFormatError("Expected rowCount larger than 2 when reading %s.", fileName);
  }
  interval = (lastTimeStamp - firstTimeStamp) / (rowCount - 1);

  timeSpan[0] = firstTimeStamp;
  timeSpan[1] = lastTimeStamp + interval;

  return(0);
}
