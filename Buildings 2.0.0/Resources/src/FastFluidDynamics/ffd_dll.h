///////////////////////////////////////////////////////////////////////////////
///
/// \file   ffd_dll.h
///
/// \brief  functions to call ffd code as a dll
///
/// \author Wangda Zuo, Dan Li
///         University of Miami
///         W.Zuo@miami.edu
///
/// \date   8/3/2013
///
/// This file provides functions as entry for the coupled simulation
///
///////////////////////////////////////////////////////////////////////////////
#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _FFD_H
#define _FFD_H
#include "ffd.h"
#endif



//static PARA_DATA para;

// Windows
#ifdef _MSC_VER
__declspec(dllexport)
extern int ffd_dll(CosimulationData *cosim);
// Linux
#else
#include <pthread.h>
int ffd_dll(CosimulationData *cosim);
#endif


///////////////////////////////////////////////////////////////////////////////
/// Launch the FFD simulation through a thread
///
///\param p Pointer to the coupled simulation data
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
#ifdef _MSC_VER //Windows
DWORD WINAPI ffd_thread(void *p);
#else //Linux
void *ffd_thread(void *p);
#endif
