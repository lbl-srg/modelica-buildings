/****************************************************************************
|
|  \file   cosimulation.h
|
|  \brief  Functions for cosimulation
|
|  \author Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Xu Han
|          Univeristy of Colorado Boulder, xuha3556@colorado.edu
|          
|
|  \date   4/5/2020
|  \This file provides functions that are used for conducting the coupled simulation
|  \with Modelica
|
****************************************************************************/

#ifndef _COSIMULATION_H
#define _COSIMULATION_H
#endif

#ifdef _MSC_VER
#include <windows.h>
#elif defined __GNUC__
#ifdef _WIN64
#include <windows.h>
#elif _WIN32
#include <windows.h>
#elif __APPLE__
#include <unistd.h>
#elif __linux__
#include <unistd.h>
#else
#include <unistd.h>
#endif
#else
#include <unistd.h>
#endif

#include <stdio.h>

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "../FastFluidDynamics/data_structure.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "../FastFluidDynamics/utility.h"
#endif

#ifndef _GEOMETRY_H
#define _GEOMETRY_H
#include "../FastFluidDynamics/geometry.h"
#endif


#ifndef _MSC_VER /*Linux*/
#define Sleep(x) sleep(x/1000)
#endif


FILE *file_log;

int read_cosim_parameter(PARA_DATA *para);
/*
	* Read the data from Modelica
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param BINDEX pointer to boundary index
	*
	* @return 0 if no error occurred
	*/

int read_cosim_data(PARA_DATA *para);

void cosim_log(char *message, COSIM_MSG_TYPE msg_type);

int write_cosim_data(PARA_DATA *para);
