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

#ifndef FMI2_TYPES_H_
#define FMI2_TYPES_H_
/** \file fmi2_types.h
	Transformation of the standard FMI type names into fmi2_ prefixed.
*/
/**
	\addtogroup jm_utils
	@{
		\addtogroup fmi2_utils
	@}
*/

/**	\addtogroup fmi2_utils Functions and types supporting FMI 2.0 processing.
	@{
*/
/** \name Renaming of typedefs 
@{*/
#define fmi2Component fmi2_component_t
#define fmi2ComponentEnvironment fmi2_component_environment_t
#define fmi2FMUstate fmi2_FMU_state_t
#define fmi2ValueReference fmi2_value_reference_t
#define fmi2Real fmi2_real_t
#define fmi2Integer fmi2_integer_t
#define fmi2Boolean fmi2_boolean_t
#define fmi2Char fmi2_char_t
#define fmi2String fmi2_string_t
#define fmi2Byte fmi2_byte_t

/** @}*/
/* Standard FMI 2.0 types */
#ifdef fmi2TypesPlatform_h
#undef fmi2TypesPlatform_h
#endif
#include <FMI2/fmi2TypesPlatform.h>
#undef fmi2TypesPlatform_h

/** FMI platform name constant string.*/
static const char * fmi2_get_types_platform(void) {
	return fmi2TypesPlatform;
}

#undef fmi2TypesPlatform

/** FMI boolean constants.*/
typedef enum {
	fmi2_true=fmi2True,
	fmi2_false=fmi2False
} fmi2_boolean_enu_t;

#undef fmi2True
#undef fmi2False

/**	
	@}
*/

#undef fmi2Component
#undef fmi2ValueReference
#undef fmi2Real
#undef fmi2Integer
#undef fmi2Boolean
#undef fmi2String
#undef fmi2UndefinedValueReference

#endif /* End of header file FMI2_TYPES_H_ */
