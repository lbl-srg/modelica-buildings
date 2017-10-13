/*
	*
	* @file   sci_reader.h
	*
	* @brief  Read mesh and simulation data defined by SCI
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
	*/

#ifndef _SCI_READER_H
#define _SCI_READER_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _FFD_DATA_READER_H
#define _FFD_DATA_READER_H
#include "ffd_data_reader.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "utility.h"
#endif

FILE *file_params;

/*
* Read the basic index information from input.cfd
*
* Specific method for advection will be selected according to the variable
* type.
*
* @param para Pointer to FFD parameters
* @param var Pointer to FFD simulation variables
*
* @return 0 if no error occurred
*/
int read_sci_max(PARA_DATA *para, REAL **var);

/*
	* Read other information from input.cfd
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param var_type Type of variable
	* @param BINDEX Pointer to boundary index
	*
	* @return 0 if no error occurred
	*/
int read_sci_input(PARA_DATA *para, REAL **var, int **BINDEX);

/*
	* Read the file to identify the block cells in space
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param BINDEX Pointer to boundary index
	*
	* @return 0 if no error occurred
	*/
int read_sci_zeroone(PARA_DATA *para, REAL **var, int **BINDEX);

/*
	* Identify the properties of cells
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	*
	* @return 0 if no error occurred
	*/
void mark_cell(PARA_DATA *para, REAL **var);
