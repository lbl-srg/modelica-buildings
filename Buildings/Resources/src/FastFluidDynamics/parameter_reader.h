/*
	*
	* @file   parameter_reader.c
	*
	* @brief  Read the FFD parameter file
	*
	* @author Wangda Zuo
	*         University of Miami
	*         W.Zuo@miami.edu
	*
	* @date   8/3/2013
	*
	*/

#ifndef _PARAMETER_READER_H
#define _PARAMETER_READER_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#include "utility.h"

extern FILE *file_para;
extern FILE *file_log;

/*
	* Assign the FFD parameters
	*
	* @param para Pointer to FFD parameters
	* @param string Pointer to data read from the parameter file
	*
	* @return 0 if no error occurred
	*/
int assign_parameter(PARA_DATA *para, char *string);

/*
	* Read the FFD parameter file input.ffd
	*
	* @param para Pointer to FFD parameters
	*
	* @return 0 if no error occurred
	*/
int read_parameter(PARA_DATA *para);
