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



/** \file fmi2_import_variable.h
*  \brief Public interface to the FMI import C-library. Handling of model variables.
*/

#ifndef FMI2_IMPORT_VARIABLE_H_
#define FMI2_IMPORT_VARIABLE_H_

#include <FMI/fmi_import_context.h>

#include "fmi2_import_type.h"
#include "fmi2_import_unit.h"

#ifdef __cplusplus
extern "C" {
#endif
		/**
	\addtogroup fmi2_import
	@{
	\addtogroup fmi2_import_variables Functions for handling variable definitions.
	@}
	\addtogroup fmi2_import_variables Functions for handling variable definitions.
	\brief All the functions in this group take a pointer to ::fmi2_import_variable_t as a parameter.
	A variable pointer may be obtained via a \ref fmi2_import_varlist module or via functions
	fmi2_import_get_variable_by_name() and fmi2_import_get_variable_by_vr().
	@{
	*/
	/**@name Scalar variable types */
/**@{ */
/** \brief General variable type. 
*
* This type is convenient to unify all the variable list operations. 
* 	However, typed variables are needed to support specific attributes.
*/
typedef struct fmi2_xml_variable_t fmi2_import_variable_t;
/** \brief  Opaque real variable */
typedef struct fmi2_xml_real_variable_t fmi2_import_real_variable_t;
/** \brief Opaque integer variable */
typedef struct fmi2_xml_integer_variable_t fmi2_import_integer_variable_t;
/** \brief Opaque string variable */
typedef struct fmi2_xml_string_variable_t fmi2_import_string_variable_t;
/** \brief Opaque enumeration variable */
typedef struct fmi2_xml_enum_variable_t fmi2_import_enum_variable_t;
/** \brief Opaque boolean variable */
typedef struct fmi2_xml_bool_variable_t fmi2_import_bool_variable_t;
/** \brief List of variables */
typedef struct fmi2_import_variable_list_t fmi2_import_variable_list_t;
/**@} */


/** \brief Get the variable name */
FMILIB_EXPORT const char* fmi2_import_get_variable_name(fmi2_import_variable_t*);

/** \brief Get variable description. 
	@return Description string or empty string ("") if no description in the XML file was given.
*/
FMILIB_EXPORT const char* fmi2_import_get_variable_description(fmi2_import_variable_t*);

/** \brief Get variable value reference */
FMILIB_EXPORT fmi2_value_reference_t fmi2_import_get_variable_vr(fmi2_import_variable_t*);

/**   \brief For scalar variable gives the type definition is present
	@return Pointer of a type #fmi2_import_variable_typedef_t object or NULL of not present.
*/
FMILIB_EXPORT fmi2_import_variable_typedef_t* fmi2_import_get_variable_declared_type(fmi2_import_variable_t*);

/** \brief Get variable base type */
FMILIB_EXPORT fmi2_base_type_enu_t fmi2_import_get_variable_base_type(fmi2_import_variable_t*);

/** \brief Check if the variable has "start" attribute */
FMILIB_EXPORT int   fmi2_import_get_variable_has_start(fmi2_import_variable_t*);

/** \brief Get variability attribute */
FMILIB_EXPORT fmi2_variability_enu_t fmi2_import_get_variability(fmi2_import_variable_t*);

/** \brief Get causality attribute */
FMILIB_EXPORT fmi2_causality_enu_t fmi2_import_get_causality(fmi2_import_variable_t*);

/** \brief Get initial attribute */
FMILIB_EXPORT fmi2_initial_enu_t fmi2_import_get_initial(fmi2_import_variable_t* );

/** 
    \brief Get the variable that holds the previous value of this variable, if defined.

    @return If this variable is a discrete-time state, return the variable holds its previous value;
            NULL otherwise.
*/
FMILIB_EXPORT fmi2_import_variable_t* fmi2_import_get_previous(fmi2_import_variable_t* v);

/** \brief Get the canHandleMultipleSetPerTimeInstant flag for a variable.

	@return For inputs: If false, then only one fmiSetXXX call is allowed at
    one super dense time instant. In other words, this input is not allowed to
    appear in an algebraic loop.
*/
FMILIB_EXPORT fmi2_boolean_t fmi2_import_get_canHandleMultipleSetPerTimeInstant(fmi2_import_variable_t* v);

/** \brief Cast general variable to a one with the specific type 
	
	@return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi2_import_real_variable_t* fmi2_import_get_variable_as_real(fmi2_import_variable_t*);

/** \brief Cast general variable to a one with the specific type 
	
	@return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi2_import_integer_variable_t* fmi2_import_get_variable_as_integer(fmi2_import_variable_t*);
/** \brief Cast general variable to a one with the specific type 
	
	@return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi2_import_enum_variable_t* fmi2_import_get_variable_as_enum(fmi2_import_variable_t*);
/** \brief Cast general variable to a one with the specific type 
	
	@return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi2_import_string_variable_t* fmi2_import_get_variable_as_string(fmi2_import_variable_t*);
/** \brief Cast general variable to a one with the specific type 
	
	@return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi2_import_bool_variable_t* fmi2_import_get_variable_as_boolean(fmi2_import_variable_t*);

/** 
	\brief Get the variable start attribute. 

	@return The "start" attribute as specified in the XML file or variable nominal value.
*/
FMILIB_EXPORT fmi2_real_t fmi2_import_get_real_variable_start(fmi2_import_real_variable_t* v);

/** 
    \brief Get the variable that this is a derivative of, if defined.

    @return If this variable is a derivative, return the variable that it is a derivative of;
            NULL otherwise.
*/
FMILIB_EXPORT fmi2_import_real_variable_t* fmi2_import_get_real_variable_derivative_of(fmi2_import_real_variable_t* v);

/** \brief Get the reinit flag for a real variable.

	@return True if the real variable may change value at events.
*/
FMILIB_EXPORT fmi2_boolean_t fmi2_import_get_real_variable_reinit(fmi2_import_real_variable_t* v);

/** \brief Get maximum value for the variable

	@return Either the value specified in the XML file or DBL_MAX as defined in <float.h>
*/
FMILIB_EXPORT fmi2_real_t fmi2_import_get_real_variable_max(fmi2_import_real_variable_t* v);

/** \brief Get minimal value for the variable.

	@return Either the value specified in the XML file or negated DBL_MAX as defined in <float.h>
*/
FMILIB_EXPORT fmi2_real_t fmi2_import_get_real_variable_min(fmi2_import_real_variable_t* v);

/** \brief Get nominal value for the variable*/
FMILIB_EXPORT fmi2_real_t fmi2_import_get_real_variable_nominal(fmi2_import_real_variable_t* v);

/** \brief Get associated "unit" object if any */
FMILIB_EXPORT fmi2_import_unit_t* fmi2_import_get_real_variable_unit(fmi2_import_real_variable_t* v);

/** \brief Get associated "display unit" object if any */
FMILIB_EXPORT fmi2_import_display_unit_t* fmi2_import_get_real_variable_display_unit(fmi2_import_real_variable_t* v);

/** \brief Get start value for the variable */
FMILIB_EXPORT const char* fmi2_import_get_string_variable_start(fmi2_import_string_variable_t* v);

/** \brief Get start value for the variable */
FMILIB_EXPORT fmi2_boolean_t fmi2_import_get_boolean_variable_start(fmi2_import_bool_variable_t* v);

/** \brief Get start value for the variable*/
FMILIB_EXPORT int fmi2_import_get_integer_variable_start(fmi2_import_integer_variable_t* v);
/** \brief Get minimal value for the variable */
FMILIB_EXPORT int fmi2_import_get_integer_variable_min(fmi2_import_integer_variable_t* v);
/** \brief Get max value for the variable */
FMILIB_EXPORT int fmi2_import_get_integer_variable_max(fmi2_import_integer_variable_t* v);

/** \brief Get start value for the variable*/
FMILIB_EXPORT int fmi2_import_get_enum_variable_start(fmi2_import_enum_variable_t* v);
/** \brief Get minimal value for the variable */
FMILIB_EXPORT int fmi2_import_get_enum_variable_min(fmi2_import_enum_variable_t* v);
/** \brief Get max value for the variable */
FMILIB_EXPORT int fmi2_import_get_enum_variable_max(fmi2_import_enum_variable_t* v);

/** \brief Get the variable alias kind*/
FMILIB_EXPORT fmi2_variable_alias_kind_enu_t fmi2_import_get_variable_alias_kind(fmi2_import_variable_t*);

/** \brief Get the original index in xml of the variable */
FMILIB_EXPORT size_t fmi2_import_get_variable_original_order(fmi2_import_variable_t* v);

/** @} */

#ifdef __cplusplus
}
#endif
#endif
