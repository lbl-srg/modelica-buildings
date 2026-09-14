/****************************************************************************
|  
| \file   common.h
|
| \brief  data structure for the ffd_isat program
|
| \author Wei Tian
|         University of Miami, Schneider Electric
|         w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
|         Dan Li
|         University of Miami
|
| \date   10/18/2018
|
| \ All RIGHTS RESERVED.
****************************************************************************/
#ifndef COMMON_H_INCLUDED

#include<stdio.h>
#include <stdlib.h>

#include <time.h>
#include <math.h>
#include <string.h>
#include "uthash.h"

/* Windows*/
#ifdef _MSC_VER
#include <windows.h>
#else
/* Linux*/
#include <unistd.h>
#endif

/******************************************************************************
| Global constants
******************************************************************************/
#define READ_FFD_RESULT 1

#define nx_SIZE 10                  /* Dimension of x */
#define nf_SIZE 10                   /* Dimension of f */ 
#define nh_SIZE 1                   /* Dimension of h, Set to 1 if h(x) is not required to initialize pointer ha */

/****************************************************************************
| Output types for logging information
****************************************************************************/
typedef enum{MPC_WARNING, MPC_ERROR, MPC_NORMAL, MPC_NEW} MPC_MSG_TYPE;

/****************************************************************************
| Hash Table struct to reduce redundency of calling FFD
****************************************************************************/
typedef struct {
  double x[nx_SIZE];
} hashKey; /* hash key */

typedef struct {
  hashKey key; /* we'll use this field as the key */
  /* ... other data ... */
  UT_hash_handle hh; /* makes this structure hashable */
} hashStruct; /* hash unit */

/****************************************************************************
| Parameters used in isat
****************************************************************************/
typedef struct{
  const int *nx;
  const int *nf;
  const int *ng;
  double *x;
  double *f;
  double *g;
} ffdIO;

/****************************************************************************
| pointer to write log information
****************************************************************************/
char logMsg[1000];

#define COMMON_H_INCLUDED
#endif




