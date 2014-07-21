///////////////////////////////////////////////////////////////////////////////
///
/// \file   cfdCosimulation.h
///
/// \brief  Header file for coupled simulation with CFD
///
/// \author Wangda Zuo
///         University of Miami
///         W.Zuo@miami.edu
///
/// \date   8/3/2013
///
///////////////////////////////////////////////////////////////////////////////

#include <stdio.h>

#ifdef _MSC_VER //Windows
  #include <windows.h>
#else // Linux
  #include <dlfcn.h>  //For load shared library
  #include <unistd.h> //For Linux function
  #define Sleep(x) sleep(x/1000) //Define Sleep() as Linux function
#endif

#ifndef _MODELICA_FFD_COMMON_H
#define _MODELICA_FFD_COMMON_H
#include "../src/FastFluidDynamics/modelica_ffd_common.h"
#endif

#pragma comment(lib, "user32.lib")

CosimulationData *cosim;

