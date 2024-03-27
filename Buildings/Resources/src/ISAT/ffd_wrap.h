/****************************************************************************
|
|  \file   ffd_wrap.h
|
|  \brief  wrapper to call FFD engine to evaluate the input; the function ffd_isat
|          is then called by usrfgh. A important note is that this function call only
|          evaluates f, not g, which is the jacobian matrix.
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
****************************************************************************/
#ifndef FFD_WRAP_H_INCLUDED
#define FFD_WRAP_H_INCLUDED

#ifndef _FFD_H
#define _FFD_H
#include "../FastFluidDynamics/ffd.h"
#endif

#ifndef _COMMON_H
#define _COMMON_H
#include "common.h"
#endif

#ifndef _UTILITY_ISAT_H
#define _UTILITY_ISAT_H
#include "utility_isat.h"
#endif

void ffd_ISAT (int need[], double x[], double f[], double g[][nf_SIZE], void *p);
int read_existing();
int write_existing();
void numericalDifferentiation (double g[][nf_SIZE]);
int read_isat_parameters();

#endif
