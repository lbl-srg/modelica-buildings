/*
	*
	* @file   utility.h
	*
	* @brief  Some frequently used functions for FFD
	*
	* @author Wangda Zuo, Ana Cohen
	*         University of Miami
	*         W.Zuo@miami.edu
	*         Purdue University
	*         Mingang Jin, Qingyan Chen
	*         Jin55@purdue.edu, YanChen@purdue.edu
	*
	* @date   8/3/2013
	*
	*/

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


extern FILE *file_log;

/*
	* Check the residual of equation
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param psi Pointer to the variable
	*
	* @return 0 if no error occurred
	*/
REAL check_residual(PARA_DATA *para, REAL **var, REAL *x);

/*
	* Write the log file
	*
	* @param message Pointer the message
	* @param msg_type Type of message
	*
	* @return 0 if no error occurred
	*/
void ffd_log(char *message, FFD_MSG_TYPE msg_type);

/*
	* Check the outflow rate of the scalar psi
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param psi Pointer to the variable
	* @param BINDEX Pointer to the boundary index
	*
	* @return 0 if no error occurred
	*/
REAL outflow(PARA_DATA *para, REAL **var, REAL *psi, int **BINDEX);

/*
	* Check the inflow rate of the scalar psi
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param psi Pointer to the variable
	* @param BINDEX Pointer to the boundary index
	*
	* @return 0 if no error occurred
	*/
REAL inflow(PARA_DATA *para, REAL **var, REAL *psi, int **BINDEX);

/*
	* Check the minimum value of the scalar psi at (ci,cj,ck) and its surrounding
	* cells
	*
	* @param para Pointer to FFD parameters
	* @param psi Pointer to the variable
	* @param ci Index in x direction
	* @param cj Index in y direction
	* @param ck Index in z direction
	*
	* @return 0 if no error occurred
	*/
REAL check_min(PARA_DATA *para, REAL *psi, int ci,int cj,int ck);

/*
	* Check the maximum value of the scalar psi at (ci,cj,ck) and its surrounding
	* cells
	*
	* @param para Pointer to FFD parameters
	* @param psi Pointer to the variable
	* @param ci Index in x direction
	* @param cj Index in y direction
	* @param ck Index in z direction
	*
	* @return 0 if no error occurred
	*/
REAL check_max( PARA_DATA *para, REAL *psi, int ci,int cj,int ck);

/*
	* Calculate averaged value of psi
	*
	* @param para Pointer to FFD parameters
	* @param psi Pointer to the variable
	*
	*/
REAL average(PARA_DATA *para, REAL *psi);


/*
	* Calculate volume weighted averaged value of psi in a space
	*
	* The average is weighted by volume of each cell
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param psi Pointer to the variable
	*
	* @return Volume weighted average
	*/
REAL average_volume(PARA_DATA *para, REAL **var, REAL *psi);

/*
	* Calcuate time averaged value
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	*
	*
	* @return 0 if no error occurred
	*/
int average_time(PARA_DATA *para, REAL **var);

/*
	* Reset time averaged value to 0
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	*
	*
	* @return 0 if no error occurred
	*/
int reset_time_averaged_data (PARA_DATA *para, REAL **var);

/*
	* Add time averaged value for the time average later on
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	*
	*
	* @return 0 if no error occurred
	*/
int add_time_averaged_data (PARA_DATA *para, REAL **var);

/*
	* Check the energy transfer rate through the wall to the air
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param BINDEX Pointer to the boundary index
	*
	* @return 0 if no error occurred
	*/
REAL qwall(PARA_DATA *para, REAL **var,int **BINDEX);

/*
	* Free memory for BINDEX
	*
	* @param BINDEX Pointer to the boundary index
	*
	* @return 0 if no error occurred
	*/
void free_index(int **BINDEX);

/*
	* Free memory for FFD simulation variables
	*
	* @param var Pointer to FFD simulation variables
	*
	* @return 0 if no error occurred
	*/
void free_data(REAL **var);

/*
	* Determine the maximum value of given scalar variable
	*
	* @param para Pointer to FFD parameters
	* @param dat Pointer to scalar variable
	*
	* @return Smax Maximum value of the scalar variable
	*/
REAL scalar_global_max(PARA_DATA *para, REAL *dat);

/*
	* Determine the minimum value of given scalar variable
	*
	* @param para Pointer to FFD parameters
	* @param dat Pointer to scalar variable
	*
	* @return Smin Minimum value of the scalar variable
	*/
REAL scalar_global_min(PARA_DATA *para, REAL *dat);

/*
	* Determine the maximum velocity
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	*
	* @return Vmax Maximum velocity in the simulated domain
	*/
REAL V_global_max(PARA_DATA *para, REAL **var);

/*
	* Determine the minimum velocity
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	*
	* @return Vmin Minimum velocity in the simulated domain
	*/
REAL V_global_min(PARA_DATA *para, REAL **var);
