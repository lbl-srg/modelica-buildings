///////////////////////////////////////////////////////////////////////////////
///
/// \file   interpolation.h
///
/// \brief  Interpolate the data for advection step
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
///////////////////////////////////////////////////////////////////////////////

#ifndef _INTERPOLATION_H
#define _INTERPOLATION_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#include "utility.h"

///////////////////////////////////////////////////////////////////////////////
/// Entrance of interpolation
///
///\param para Pointer to FFD parameters
///\param d0 Pointer to the variable for interpolation
///\param p I-index of the control volume
///\param q J-index of the control volume
///\param r K-index of the control volume
///\param x_1 Reciprocal of X-length
///\param y_1 Reciprocal of Y-length
///\param z_1 Reciprocal of Z-length
///
///\return Interpolated value
///////////////////////////////////////////////////////////////////////////////
REAL interpolation(PARA_DATA *para, REAL *d0, REAL x_1, REAL y_1, REAL z_1,
                   int p, int q, int r);

///////////////////////////////////////////////////////////////////////////////
/// Bilinear interpolation
///
///\param x_1 Reciprocal of X-length
///\param y_1 Reciprocal of Y-length
///\param z_1 Reciprocal of Z-length
///\param d000 parameter for interpolation
///\param d010 parameter for interpolation
///\param d100 parameter for interpolation
///\param d110 parameter for interpolation
///\param d001 parameter for interpolation
///\param d011 parameter for interpolation
///\param d101 parameter for interpolation
///\param d111 parameter for interpolation
//
///\return Interpolated value
///////////////////////////////////////////////////////////////////////////////
REAL interpolation_bilinear(REAL x_1, REAL y_1, REAL z_1,
                            REAL d000, REAL d010, REAL d100, REAL d110,
                            REAL d001, REAL d011, REAL d101, REAL d111);
