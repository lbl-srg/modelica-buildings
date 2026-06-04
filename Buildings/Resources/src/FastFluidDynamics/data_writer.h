/*
	*
	* @file   data_write.h
	*
	* @brief  Write the simulation data
	*
	* @author Mingang Jin, Qingyan Chen
	*         Purdue University
	*         Jin55@purdue.edu, YanChen@purdue.edu
	*         Wangda Zuo
	*         University of Miami
	*         W.Zuo@miami.edu
	*
	* @date   8/3/2013
	*
	* This file provides functions that write the data file in different formats.
	*
	*/
#ifndef _DATA_WRITER_H
#define _DATA_WRITER_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "utility.h"
#endif

extern FILE *file1;

/*
	* Write standard output data in a format for tecplot
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param name Pointer to file name
	*
	* @return 0 if no error occurred
	*/
int write_tecplot_data(PARA_DATA *para, REAL **var, char *name);

/*
	* Write all available data in a format for tecplot
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param name Pointer to file name
	*
	* @return 0 if no error occurred
	*/
int write_tecplot_all_data(PARA_DATA *para, REAL **var, char *name);

/*
	* Convert the data to the format for Tecplot
	*
	* FFD uses staggered grid and Tecplot data is for collocated grid.
	* This subroutine transfers the data from FFD format to Tecplot format.
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	*
	* @return no return
	*/
void convert_to_tecplot(PARA_DATA *para, REAL **var);

/*
	* Convert the data at 8 corners to the format for Tecplot
	*
	* FFD uses staggered grid and Tecplot data is for collocated grid.
	* This subroutine transfers the data from FFD format to Tecplot format.
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param psi Pointer to variable to be converted
	*
	* @return no return
	*/
void convert_to_tecplot_corners(PARA_DATA *para, REAL **var, REAL *psi);

/*
	* Write the instantaneous value of variables in Tecplot format
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param name Pointer to the filename
	*
	* @return 0 if no error occurred
	*/
int write_unsteady(PARA_DATA *para, REAL **var, char *name);

/*
	* Write the data in a format for SCI program
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param name Pointer to the filename
	*
	* @return 0 if no error occurred
	*/
int write_SCI(PARA_DATA *para, REAL **var, char *name);
