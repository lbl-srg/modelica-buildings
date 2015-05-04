///////////////////////////////////////////////////////////////////////////////
///
/// \file   chen_zero_equ_model.h
///
/// \brief  Computes turbulent viscosity using Chen's zero equ model
///
/// \author Mingang Jin, Qingyan Chen
///         Purdue University
///         Jin55@purdue.edu, YanChen@purdue.edu
///         Wangda Zuo
///         University of Miami
///         W.Zuo@miami.edu
///
/// \date   8/3/2013
///
/// This file provides function that computes the turbulent viscosity using
/// Chen's zero equation model
///
///////////////////////////////////////////////////////////////////////////////
#ifndef _CHEN_ZERO_EQU_MODEL_H_
#define _CHEN_ZERO_EQU_MODEL_H_
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

///////////////////////////////////////////////////////////////////////////////
/// Computes turbulent viscosity using Chen's zero equation model
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param i I-index of the control volume
///\param j J-index of the control volume
///\param k K-index of the control volume
///
///\return Turbulent Kinematic viscosity
///////////////////////////////////////////////////////////////////////////////
REAL nu_t_chen_zero_equ(PARA_DATA *para, REAL **var, int i, int j, int k);
