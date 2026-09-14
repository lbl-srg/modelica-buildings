/*
 *
 * @file   isatCosimulation.h
 *
 * @brief  Header file for coupled simulation with ISAT based on cfdCosimulation.h
 *
 * @author
 *         Xu Han
 *         University of Colorado Boulder
 *         xuha3556@colorado.edu
 *
 *         Wangda Zuo
 *         University of Miami
 *         W.Zuo@miami.edu
 *
 * \date   9/21/2019
 *
 */

#if defined(_MSC_VER) || defined(__WIN32__) /* Windows */
#include <windows.h>
#else /* Linux*/
#include <dlfcn.h>  /*For load shared library*/
#include <unistd.h> /*For Linux function*/
#define Sleep(x) sleep(x/1000)
#endif

#ifndef _MODELICA_FFD_COMMON_H
#define _MODELICA_FFD_COMMON_H
#include "../src/FastFluidDynamics/modelica_ffd_common.h"
#include <stdint.h> /* Needed to detect 32 vs. 64 bit using UINTPTR_MAX*/
#endif

#if UINTPTR_MAX == 0xffffffff
/* 32-bit */
#error "*** ISAT is not available on Windows 32 bit."
#endif

CosimulationData *cosim;

/*declare the isat_dll function in DLL*/
void *isat_dll(CosimulationData *cosim);
