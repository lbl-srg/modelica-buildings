/****************************************************************************
|
|  \file   chen_zero_equ_model.h
|
|  \brief  Computes turbulent viscosity using Chen's zero equ model
|
|  \author Mingang Jin, Qingyan Chen
|          Purdue University
|          Jin55@purdue.edu, YanChen@purdue.edu
|          Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Xu Han
|          University of Colorado Boulder
|          xuha3556@colorado.edu
|
|  \date   4/5/2020
|
|  This file provides function that computes the turbulent viscosity using
|  Chen's zero equation model
|
****************************************************************************/
#ifndef _CHEN_ZERO_EQU_MODEL_H_
#define _CHEN_ZERO_EQU_MODEL_H_
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif


/****************************************************************************
|  Computes turbulent viscosity using Chen's zero equation model
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param i I-index of the control volume
| \param j J-index of the control volume
| \param k K-index of the control volume
|
| \return Turbulent Kinematic viscosity
****************************************************************************/
REAL nu_t_chen_zero_equ(PARA_DATA* para, REAL** var, int i, int j, int k);

/****************************************************************************
|  Computes turbulent thermal diffusivity using Chen's zero equation model
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| \Author: Wei Tian @ Schneider Electric, Andover, MA
| 
| \Initial Implementation: 7/11/2017
| \return Turbulent Kinematic viscosity
| 
| \ This is to reimplement the turbulent thermal diffusivity for FFD using Chen's
|   zero equation model. Theoretically, by diving the turbulent viscosity over the 
|   Pr number, we can easily get the turbulent themal diffusivity coefficients. However,
|   according to our test, that could cause severe energy imblance for the whole space.
|   The root reason to explain that is not fully identified yet. However, we presumably beleive that
|   the dramatically (over 100) spatial difference of the thermal diffusivity coefficient may lead 
|   to energy imbalance, happening in the diffusion term. We also tried using constant turbulence  
|   model, which essentially multiplies 100 to the lamninar one. Applying that in the FFD, we did 
|   not see the deterioration of energy balance, at any level.
|
| \ Inspired by this, we propose to uniformly disseminate the turbulent thermal diffusivity over 
|   the whole fluid space. According to our test, this method can perfectly achieve energy balance 
|   for the room space, while keeping the turbulent features in some extent of the thermal 
|   environment.
| 
| \ Last update: 7/11/2017
****************************************************************************/
REAL alpha_t_chen_zero_equ(PARA_DATA* para, REAL** var);


