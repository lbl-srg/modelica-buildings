/*
	*
	* @file   ffd_data_reader.h
	*
	* @brief  Read the previous FFD result file (Tecplot format)
	*
	* @author Wangda Zuo
	*         University of Miami
	*         W.Zuo@miami.edu
	*         Mingang Jin, Qingyan Chen
	*         Purdue University
	*         Jin55@purdue.edu, YanChen@purdue.edu
	*
	* @date   8/3/2013
	*
	*/

#ifndef _FFD_DATA_READER_H
#define _FFD_DATA_READER_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#include "utility.h"

FILE *file_old_ffd;

/*
	* Read the previous FFD simulation data in a format of standard output
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	*
	* @return 0 if no error occurred
	*/
int read_ffd_data(PARA_DATA *para, REAL **var);
