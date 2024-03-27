/******************************************************************************
| 
|  \file   usrfgh.c
| 
|  \brief  user-define function (FFD call) requested by isat
| 
|  \author Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
|          Dan Li
|          University of Miami
| 
|  \date   10/18/2018
| 
| \  All RIGHTS RESERVED.
******************************************************************************/


#ifndef USRFGH_H_INCLUDED
#define USRFGH_H_INCLUDED
#include"ffd_wrap.h"
#include "utility_isat.h"

void USRFGH(int need[], int *nx, double x[], int *nf, int *nh, int iusr[], double rusr[], double f[], double** g, double h[]);

#endif