/****************************************************************************
|
|  \file   utility.h
|
|  \brief  Some frequently used functions for FFD
|
|  \author Wangda Zuo, Ana Cohen
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Purdue University
|          Mingang Jin, Qingyan Chen
|          Jin55@purdue.edu, YanChen@purdue.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
|          Xu Han
|          University of Colorado Boulder
|          xuha3556@colorado.edu
|
|  \date   4/5/2020
|
****************************************************************************/

#ifndef _UTILITY_H
#define _UTILITY_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _FFD_H
#define _FFD_H
#include "ffd.h"
#endif

#ifndef _GEOMETRY_H
#define _GEOMETRY_H
#include "geometry.h"
#endif

/****************************************************************************
|  Check the residual of equation
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable
|
| \return 0 if no error occurred
****************************************************************************/
REAL check_residual(PARA_DATA* para, REAL** var, REAL* x, REAL* flag);

/****************************************************************************
|  Write the log file
|
| \param message Pointer the message
| \param msg_type Type of message
|
| \return 0 if no error occurred
****************************************************************************/
void ffd_log(char* message, FFD_MSG_TYPE msg_type);

/****************************************************************************
|  Check the outflow rate of the scalar psi
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable
| \param BINDEX Pointer to the boundary index
|
| \return 0 if no error occurred
****************************************************************************/
REAL outflow(PARA_DATA* para, REAL** var, REAL* psi, int** BINDEX);

/****************************************************************************
|  Check the inflow rate of the scalar psi
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable
| \param BINDEX Pointer to the boundary index
|
| \return 0 if no error occurred
****************************************************************************/
REAL inflow(PARA_DATA* para, REAL** var, REAL* psi, int** BINDEX);

/****************************************************************************
|  Check the minimum value of the scalar psi at (ci,cj,ck) and its surrounding
|  cells
|
| \param para Pointer to FFD parameters
| \param psi Pointer to the variable
| \param ci Index in x direction
| \param cj Index in y direction
| \param ck Index in z direction
|
| \return 0 if no error occurred
****************************************************************************/
REAL check_min(PARA_DATA* para, REAL* psi, int ci, int cj, int ck);

/****************************************************************************
|  Check the maximum value of the scalar psi at (ci,cj,ck) and its surrounding
|  cells
|
| \param para Pointer to FFD parameters
| \param psi Pointer to the variable
| \param ci Index in x direction
| \param cj Index in y direction
| \param ck Index in z direction
|
| \return 0 if no error occurred
****************************************************************************/
REAL check_max(PARA_DATA* para, REAL* psi, int ci, int cj, int ck);

/****************************************************************************
|  Calculate averaged value of psi
|
| \param para Pointer to FFD parameters
| \param psi Pointer to the variable
|
****************************************************************************/
REAL average(PARA_DATA* para, REAL* psi);


/****************************************************************************
|  Calculate volume weighted averaged value of psi in a space
|
|  The average is weighted by volume of each cell
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable
|
| \return Volume weighted average
****************************************************************************/
REAL average_volume(PARA_DATA* para, REAL** var, REAL* psi);

/****************************************************************************
|  Calcuate time averaged value
|
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
|
|
| \return 0 if no error occurred
****************************************************************************/
int average_time(PARA_DATA* para, REAL** var);

/****************************************************************************
|  Reset time averaged value to 0
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
|
|
| \return 0 if no error occurred
****************************************************************************/
int reset_time_averaged_data(PARA_DATA* para, REAL** var);

/****************************************************************************
|  Add time averaged value for the time average later on
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
|
|
| \return 0 if no error occurred
****************************************************************************/
int add_time_averaged_data(PARA_DATA* para, REAL** var);

/****************************************************************************
|  Check the energy transfer rate through the wall to the air
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to the boundary index
|
| \return 0 if no error occurred
****************************************************************************/
REAL qwall(PARA_DATA* para, REAL** var, int** BINDEX);

/****************************************************************************
|  Free memory for BINDEX
|
| \param BINDEX Pointer to the boundary index
|
| \return 0 if no error occurred
****************************************************************************/
void free_index(int** BINDEX);

/****************************************************************************
|  Free memory for FFD simulation variables
|
| \param var Pointer to FFD simulation variables
|
| \return 0 if no error occurred
****************************************************************************/
void free_data(REAL** var);

/****************************************************************************
|  Determine the maximum value of given scalar variable
|
| \param para Pointer to FFD parameters
| \param dat Pointer to scalar variable
|
| \return Smax Maximum value of the scalar variable
****************************************************************************/
REAL scalar_global_max(PARA_DATA* para, REAL* dat);

/****************************************************************************
|  Determine the minimum value of given scalar variable
|
| \param para Pointer to FFD parameters
| \param dat Pointer to scalar variable
|
| \return Smin Minimum value of the scalar variable
****************************************************************************/
REAL scalar_global_min(PARA_DATA* para, REAL* dat);

/****************************************************************************
|  Determine the maximum velocity
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
|
| \return Vmax Maximum velocity in the simulated domain
****************************************************************************/
REAL V_global_max(PARA_DATA* para, REAL** var);

/****************************************************************************
|  Determine the minimum velocity
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
|
| \return Vmin Minimum velocity in the simulated domain
****************************************************************************/
REAL V_global_min(PARA_DATA* para, REAL** var);

/****************************************************************************
|  Check the minimum to the solid boudaries
|  cells used in calculation of zero equation tuebulence model
|
| \param para Pointer to FFD parameters
| \param var Pointer to the variable
| \param
|
| \return 0 if no error occurred
****************************************************************************/
int min_distance(PARA_DATA* para, REAL** var, int** BINDEX);

/****************************************************************************
|  Check the volumetric inflow rate
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable
| \param BINDEX Pointer to the boundary index
|
| \return 0 if no error occurred
****************************************************************************/
REAL vol_inflow(PARA_DATA* para, REAL** var, int** BINDEX);

/****************************************************************************
|  Check the volumetric inflow rate
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable
| \param BINDEX Pointer to the boundary index
|
| \return 0 if no error occurred
****************************************************************************/
REAL vol_outflow(PARA_DATA* para, REAL** var, int** BINDEX);

/****************************************************************************
|  Check flow rates through all the tiles
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to the boundary index
|
| \return 0 if no error occurred
****************************************************************************/
int check_tile_flowrate(PARA_DATA* para, REAL** var, int** BINDEX);

/****************************************************************************
|  Check flow rates at inlets when t=0
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to the boundary index
|
| \return 0 if no error occurred
****************************************************************************/
REAL initial_inflows(PARA_DATA* para, REAL** var, int** BINDEX);

/****************************************************************************
|  Parse the command-line argument
|
| \param argc number of argument
| \param argv command-line argument
|
| \return 0 if no error occurred
****************************************************************************/
int parse_argument(int argc, char** argv, int* platform_device);

/****************************************************************************
|  calculate momentum kick: 1/rho*S
|  1/rho*S = V_dot*(V1-V2)/V = A*V2*(V2/beta-V2)/A*h = V2*(V2/beta-V2)/h
|  where: V1 and V2 are the velocities supposing that tiles are partially or fully open
|         A is tha area of tile, h is the height of the space, beta is open-area-ratio
****************************************************************************/
REAL get_momentum_kick(REAL V2, REAL beta, REAL h);

/****************************************************************************
|  find the monitoring points in front of each rack
|  return 0 if all points are found
****************************************************************************/
int get_monitor_points(PARA_DATA* para, REAL** var, int SI, int SJ, int SK, int EI, int EJ, int EK, int rack_flow_direction, int id_rack);

/****************************************************************************
|  find the indexes of the monitoring points
|  monitors are 6 inch (0.1524 m) in front of rack
|  FIXME: ONLY ABLE TO HANDLE RACK WHOSE AIRLOW IS IN X DIRECTION!
|  return 0 if all points are found
****************************************************************************/
int get_monitor_index(PARA_DATA* para, REAL** var);

/****************************************************************************
|  write temperature at monitoring points
|  monitors are 6 inch (0.1524 m) in front of rack
|  FIXME: ONLY ABLE TO HANDLE RACK WHOSE AIRLOW IS IN X DIRECTION!
|  return 0 if all points are found
****************************************************************************/
int write_monitor_data(PARA_DATA *para, REAL **var);


