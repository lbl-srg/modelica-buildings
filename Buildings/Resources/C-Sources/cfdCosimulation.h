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
 * @date   8/3/2013
 *
 */

#include <stdio.h>

#if defined(_MSC_VER) || defined(__WIN32__) /* Windows */
#include <windows.h>
#define sleep(x) Sleep(1000*x)
#else /* Linux*/
#include <dlfcn.h>  /*For load shared library*/
#include <unistd.h> /*For Linux function*/
#endif

#ifndef _MODELICA_FFD_COMMON_H
#define _MODELICA_FFD_COMMON_H
#include "../src/FastFluidDynamics/modelica_ffd_common.h"
#include <stdint.h> /* Needed to detect 32 vs. 64 bit using UINTPTR_MAX*/
#endif

#pragma comment(lib, "user32.lib")

CosimulationData *cosim;
char msg[1000];
