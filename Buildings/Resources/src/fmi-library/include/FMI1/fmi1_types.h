/*
    Copyright (C) 2012 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the BSD style license.

     This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    FMILIB_License.txt file for more details.

    You should have received a copy of the FMILIB_License.txt file
    along with this program. If not, contact Modelon AB <http://www.modelon.com>.
*/

#ifndef FMI1_TYPES_H_
#define FMI1_TYPES_H_
/** \file fmi1_types.h
	Transformation of the standard FMI type names into fmi1_ prefixed.
*/
/**
	\addtogroup jm_utils
	@{
		\addtogroup fmi1_utils
	@}
*/

/**	\addtogroup fmi1_utils Functions and types supporting FMI 1.0 processing.
	@{
*/
/** \name Renaming of typedefs 
@{*/
#define fmiComponent fmi1_component_t
#define fmiValueReference fmi1_value_reference_t
#define fmiReal fmi1_real_t
#define fmiInteger fmi1_integer_t
#define fmiBoolean fmi1_boolean_t
#define fmiString fmi1_string_t
/** @}*/
/* Standard FMI 1.0 ME and CS types */
#ifdef fmiPlatformTypes_h
#undef fmiPlatformTypes_h
#endif
#include <FMI1/fmiPlatformTypes.h>
#undef fmiPlatformTypes_h

/** FMI platform name constant string.*/
static const char * fmi1_get_platform(void) {
	return fmiPlatform;
}

#undef fmiPlatform

/** FMI boolean constants.*/
typedef enum {
	fmi1_true=fmiTrue,
	fmi1_false=fmiFalse
} fmi1_boolean_enu_t;

#undef fmiTrue
#undef fmiFalse

/** Undefined value for fmiValueReference (largest unsigned int value) */
typedef enum fmi1_value_reference_enu_t {
	fmi1_undefined_value_reference = (int)fmiUndefinedValueReference
} fmi1_value_reference_enu_t;

/**	
	@}
*/

#undef fmiComponent
#undef fmiValueReference
#undef fmiReal
#undef fmiInteger
#undef fmiBoolean
#undef fmiString
#undef fmiUndefinedValueReference

#endif /* End of header file FMI1_TYPES_H_ */
