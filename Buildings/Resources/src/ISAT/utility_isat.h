/******************************************************************************
|
|  \file   utility_isat.h
|
|  \brief  define utility functions for isat_ffd
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


#ifndef UTILITY_IAST_H_INCLUDED
#define UTILITY_IAST_H_INCLUDED

#ifndef _COMMON_H
#define _COMMON_H
#include "common.h"
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "../FastFluidDynamics/data_structure.h"
#endif

#ifndef _GEOMETRY_H
#define _GEOMETRY_H
#include "../FastFluidDynamics/geometry.h"
#endif

FILE *file_log;
FILE *file_params;

void mpc_log(char *message, MPC_MSG_TYPE msg_type);
int write_output_data(PARA_DATA *para, REAL **var, int **BINDEX);
REAL average_room_temp(PARA_DATA *para, REAL **var);
REAL average_volume_temp(PARA_DATA *para, REAL **var);
REAL average_volume_vel(PARA_DATA *para, REAL **var);
REAL sensor_temp(PARA_DATA *para, REAL **var);
REAL sensor_vel(PARA_DATA *para, REAL **var);
REAL maximum_rack_temp(PARA_DATA *para, REAL **var);

#endif




