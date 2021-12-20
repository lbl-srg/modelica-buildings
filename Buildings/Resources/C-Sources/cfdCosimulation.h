/*
 *
 * @file   cfdCosimulation.h
 *
 * @brief  Header file for coupled simulation with CFD
 *
 * @author Wangda Zuo
 *         University of Miami
 *         W.Zuo@miami.edu
 *
 *         Tian Wei
 *         University of Miami
 *         W.tian@miami.edu
 *
 * @date   2/14/2017
 *
 */

#include <stdio.h>

#if defined(_MSC_VER) || defined(__WIN32__) /* Windows */
#include <windows.h>
#else /* Linux*/
#include <dlfcn.h>  /*For load shared library*/
#include <unistd.h> /*For Linux function*/
#define Sleep(x) sleep(ceil(x/1000.))
#endif

#ifndef _MODELICA_FFD_COMMON_H
#define _MODELICA_FFD_COMMON_H
#include "../src/FastFluidDynamics/modelica_ffd_common.h"
#include <stdint.h> /* Needed to detect 32 vs. 64 bit using UINTPTR_MAX*/
#endif

CosimulationData *cosim;

/*declare the ffd_dll function in DLL*/
void *ffd_dll(CosimulationData *cosim);
