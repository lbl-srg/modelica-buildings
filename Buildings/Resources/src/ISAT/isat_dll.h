/****************************************************************************
|
|  \file   isat_dll.h
|
|  \brief  functions to call ISAT code as a dll
|
|  \author Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Xu Han
|          Univeristy of Colorado Boulder, xuha3556@colorado.edu
|
|  \date   4/5/2020
|  \This file provides functions as entry for the coupled simulation
|
****************************************************************************/

#ifndef _FFD_ISAT_H
#define _FFD_ISAT_H
#include "ffd_isat.h"
#endif


/* Windows*/
#ifdef _MSC_VER
__declspec(dllexport)
extern int isat_dll(CosimulationData *cosim);
/* Linux*/
#else
#include <pthread.h>
void *isat_dll(CosimulationData *cosim);
#endif


/*
	* Launch the ISAT simulation through a thread
	*
	* @param p Pointer to the coupled simulation data
	*
	* @return 0 if no error occurred
	*/

#ifdef _MSC_VER/* Windows*/
DWORD WINAPI isat_thread(void *p);
#else /*Linux*/
void *isat_thread(void *p);
#endif
