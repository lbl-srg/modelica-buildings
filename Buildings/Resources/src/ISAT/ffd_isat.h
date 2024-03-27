/******************************************************************************
|
| \file   ffd_isat.h
|
| \brief  define function to perform ffd_isat training and testing
|
|  \author Xu Han
|          Univeristy of Colorado Boulder, xuha3556@colorado.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
|          Dan Li
|          University of Miami
|
|  \date   4/5/2020
|
| \  All RIGHTS RESERVED.
******************************************************************************/
#ifndef FFD_ISAT_H_INCLUDED
#define FFD_ISAT_H_INCLUDED
#endif

#ifndef _COMMON_H
#define _COMMON_H
#include "common.h"
#endif

#ifndef _UTILITY_ISAT_H
#define _UTILITY_ISAT_H
#include "utility_isat.h"
#endif

#ifndef _FFD_WRAP_H
#define _FFD_WRAP_H
#include "ffd_wrap.h"
#endif

#ifndef _COSIMULATION_H
#define _COSIMULATION_H
#include "cosimulation.h"
#endif

void update_digit();
void nDemArrEva(int dimension, double xStep[]);
void evaluate ();
void randomCall (int nCall, int useNormalDistribution, int useUnboundedTest);
void accuracyTest ();
void writeRecord ();
double getRandom (int dimension, int useNormalDistribution, int useUnboundedTest);
double randNormal (double mu, double sigma);
void binaryTrain ();
double my_round(double x, int digits);
void findHash();
void addHash();
										 
						 



