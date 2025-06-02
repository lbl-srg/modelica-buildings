/*
    Copyright (C) 2023 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the BSD style license.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    FMILIB_License.txt file for more details.

    You should have received a copy of the FMILIB_License.txt file
    along with this program. If not, contact Modelon AB <http://www.modelon.com>.
*/

/**
 * \file fmi3_import_variable.h
 * \brief Public interface to the FMI import C-library. Handling of model variables.
 */

#ifndef FMI3_IMPORT_VARIABLE_H_
#define FMI3_IMPORT_VARIABLE_H_

#include <FMI/fmi_import_context.h>

#include "fmi3_import_type.h"
#include "fmi3_import_unit.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * \addtogroup fmi3_import
 * @{
 * \addtogroup fmi3_import_variables Functions for handling variable definitions
 * @}
 *
 * \addtogroup fmi3_import_variables Functions for handling variable definitions
 * \brief All the functions in this group take a pointer to ::fmi3_import_variable_t as a parameter.
 * A variable pointer may be obtained via a \ref fmi3_import_varlist module or via functions
 * fmi3_import_get_variable_by_name() and fmi3_import_get_variable_by_vr().
 * @{
 */

/**
 * @name Scalar variable types
 * @{
 */

/** \brief General variable type.
 *
 * This type is convenient to unify all the variable list operations.
 * However, typed variables are needed to support specific attributes.
 */
typedef struct fmi3_xml_variable_t fmi3_import_variable_t;
/** \brief Opaque float32 variable */
typedef struct fmi3_xml_float32_variable_t fmi3_import_float32_variable_t;
/** \brief Opaque float64 variable */
typedef struct fmi3_xml_float64_variable_t fmi3_import_float64_variable_t;
/** \brief Opaque int64 variable */
typedef struct fmi3_xml_int64_variable_t fmi3_import_int64_variable_t;
/** \brief Opaque int32 variable */
typedef struct fmi3_xml_int32_variable_t fmi3_import_int32_variable_t;
/** \brief Opaque int16 variable */
typedef struct fmi3_xml_int16_variable_t fmi3_import_int16_variable_t;
/** \brief Opaque int8 variable */
typedef struct fmi3_xml_int8_variable_t fmi3_import_int8_variable_t;
/** \brief Opaque uint64 variable */
typedef struct fmi3_xml_uint64_variable_t fmi3_import_uint64_variable_t;
/** \brief Opaque uint32 variable */
typedef struct fmi3_xml_uint32_variable_t fmi3_import_uint32_variable_t;
/** \brief Opaque uint16 variable */
typedef struct fmi3_xml_uint16_variable_t fmi3_import_uint16_variable_t;
/** \brief Opaque uint8 variable */
typedef struct fmi3_xml_uint8_variable_t fmi3_import_uint8_variable_t;
/** \brief Opaque string variable */
typedef struct fmi3_xml_string_variable_t fmi3_import_string_variable_t;
/** \brief Opaque enumeration variable */
typedef struct fmi3_xml_enum_variable_t fmi3_import_enum_variable_t;
/** \brief Opaque boolean variable */
typedef struct fmi3_xml_bool_variable_t fmi3_import_bool_variable_t;
/** \brief Opaque binary variable */
typedef struct fmi3_xml_binary_variable_t fmi3_import_binary_variable_t;
/** \brief Opaque clock variable */
typedef struct fmi3_xml_clock_variable_t fmi3_import_clock_variable_t;
/** \brief List of variables */
typedef struct fmi3_import_variable_list_t fmi3_import_variable_list_t;
/**@} */

/**
 * @name Types encapsulating alias information
 * @{
 */
/** \brief List of the alias variables for a non-alias variable */
typedef struct fmi3_xml_alias_variable_list_t fmi3_import_alias_variable_list_t;
/** \brief Opaque alias variable. Only contains the alias-specific information. */
typedef struct fmi3_xml_alias_variable_t fmi3_import_alias_variable_t;
/** @} */

/**
 * @name Types encapsulating variable dimension information
 * @{
 */
/** \brief Opaque data type for dimension handling */
typedef struct fmi3_xml_dimension_t fmi3_import_dimension_t;
/** \brief Opaque data type for dimension list handling*/
typedef struct fmi3_xml_dimension_list_t fmi3_import_dimension_list_t;
/** @} */


/** \brief Get the variable name */
FMILIB_EXPORT const char* fmi3_import_get_variable_name(fmi3_import_variable_t* v);

/** \brief Get variable description.
    @return Description string or empty string ("") if no description in the XML file was given.
*/
FMILIB_EXPORT const char* fmi3_import_get_variable_description(fmi3_import_variable_t* v);

/** \brief Get variable value reference */
FMILIB_EXPORT fmi3_value_reference_t fmi3_import_get_variable_vr(fmi3_import_variable_t* v);

/** \brief For scalar variable gives the type definition is present
    @return Pointer of a type #fmi3_import_variable_typedef_t object or NULL of not present.
*/
FMILIB_EXPORT fmi3_import_variable_typedef_t* fmi3_import_get_variable_declared_type(fmi3_import_variable_t* v);

/** \brief Get variable base type */
FMILIB_EXPORT fmi3_base_type_enu_t fmi3_import_get_variable_base_type(fmi3_import_variable_t* v);

/** \brief Get the start values of an array variable
 * @return Pointer to array with start values. Total length of array is given by array dimensions.
 */
FMILIB_EXPORT fmi3_float64_t* fmi3_import_get_float64_variable_start_array(fmi3_import_float64_variable_t* v);

/** \brief Get the start values of an array variable.
 * @return Pointer to array with start values. Total length of array is given by array dimensions.
 */
FMILIB_EXPORT fmi3_float32_t* fmi3_import_get_float32_variable_start_array(fmi3_import_float32_variable_t* v);

/** \brief Get the reinit values of a variable. */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_float64_variable_reinit(fmi3_import_float64_variable_t* v);

/** \brief Get the reinit values of a variable. */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_float32_variable_reinit(fmi3_import_float32_variable_t* v);

/** \brief Get the start values of an array variable
 * @return Pointer to array with start values. Total length of array is given by array dimensions.
 */
FMILIB_EXPORT fmi3_int64_t* fmi3_import_get_int64_variable_start_array(fmi3_import_int64_variable_t* v);

/** \brief Get the start values of an array variable
 * @return Pointer to array with start values. Total length of array is given by array dimensions.
 */
FMILIB_EXPORT fmi3_int32_t* fmi3_import_get_int32_variable_start_array(fmi3_import_int32_variable_t* v);

/** \brief Get the start values of an array variable
 * @return Pointer to array with start values. Total length of array is given by array dimensions.
 */
FMILIB_EXPORT fmi3_int16_t* fmi3_import_get_int16_variable_start_array(fmi3_import_int16_variable_t* v);

/** \brief Get the start values of an array variable
 * @return Pointer to array with start values. Total length of array is given by array dimensions.
 */
FMILIB_EXPORT fmi3_int8_t* fmi3_import_get_int8_variable_start_array(fmi3_import_int8_variable_t* v);

/** \brief Get the start values of an array variable
 * @return Pointer to array with start values. Total length of array is given by array dimensions.
 */
FMILIB_EXPORT fmi3_uint64_t* fmi3_import_get_uint64_variable_start_array(fmi3_import_uint64_variable_t* v);

/** \brief Get the start values of an array variable
 * @return Pointer to array with start values. Total length of array is given by array dimensions.
 */
FMILIB_EXPORT fmi3_uint32_t* fmi3_import_get_uint32_variable_start_array(fmi3_import_uint32_variable_t* v);

/** \brief Get the start values of an array variable
 * @return Pointer to array with start values. Total length of array is given by array dimensions.
 */
FMILIB_EXPORT fmi3_uint16_t* fmi3_import_get_uint16_variable_start_array(fmi3_import_uint16_variable_t* v);

/** \brief Get the start values of an array variable
 * @return Pointer to array with start values. Total length of array is given by array dimensions.
 */
FMILIB_EXPORT fmi3_uint8_t* fmi3_import_get_uint8_variable_start_array(fmi3_import_uint8_variable_t* v);

/**   \brief Check if the variable is an array.
    @return True if array, false if scalar.
*/
FMILIB_EXPORT int fmi3_import_variable_is_array(fmi3_import_variable_t* v);

/** \brief Check if the variable has "start" attribute */
FMILIB_EXPORT int fmi3_import_get_variable_has_start(fmi3_import_variable_t* v);

/** \brief Get variability attribute */
FMILIB_EXPORT fmi3_variability_enu_t fmi3_import_get_variable_variability(fmi3_import_variable_t* v);

/** \brief Get causality attribute */
FMILIB_EXPORT fmi3_causality_enu_t fmi3_import_get_variable_causality(fmi3_import_variable_t* v);

/** \brief Get initial attribute */
FMILIB_EXPORT fmi3_initial_enu_t fmi3_import_get_variable_initial(fmi3_import_variable_t* );

/**
    \brief Get the variable that holds the previous value of this variable, if defined.

    @return If this variable is a discrete-time state, return the variable holds its previous value;
            NULL otherwise.
*/
FMILIB_EXPORT fmi3_import_variable_t* fmi3_import_get_variable_previous(fmi3_import_variable_t* v);

/** \brief Get the canHandleMultipleSetPerTimeInstant flag for a variable.

    @return For inputs: If false, then only one fmiSetXXX call is allowed at
    one super dense time instant. In other words, this input is not allowed to
    appear in an algebraic loop.
*/
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_variable_can_handle_multiple_set_per_time_instant(fmi3_import_variable_t* v);

/** \brief Get the intermediateUpdate flag for a variable.

    @return If true, the variable can be accessed in Intermediate Update Mode
*/
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_variable_intermediate_update(fmi3_import_variable_t* v);

/** \brief Get a list of variables referenced in the 'clock' attribute.
 *  Note that the caller is responsible for deallocating the list.
 *
 *  @return The array of value references.
 */
FMILIB_EXPORT fmi3_import_variable_list_t* fmi3_import_get_variable_clocks(fmi3_import_t* fmu, fmi3_import_variable_t* v);

/** \brief Cast general variable to a one with the specific type

    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_float64_variable_t* fmi3_import_get_variable_as_float64(fmi3_import_variable_t* v);

/** \brief Cast general variable to a one with the specific type

    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_float32_variable_t* fmi3_import_get_variable_as_float32(fmi3_import_variable_t* v);

/** \brief Cast general variable to a one with the specific type
    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_int64_variable_t* fmi3_import_get_variable_as_int64(fmi3_import_variable_t* v);

/** \brief Cast general variable to a one with the specific type
    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_int32_variable_t* fmi3_import_get_variable_as_int32(fmi3_import_variable_t* v);

/** \brief Cast general variable to a one with the specific type
    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_int16_variable_t* fmi3_import_get_variable_as_int16(fmi3_import_variable_t* v);

/** \brief Cast general variable to a one with the specific type
    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_int8_variable_t* fmi3_import_get_variable_as_int8(fmi3_import_variable_t* v);

/** \brief Cast general variable to a one with the specific type
    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_uint64_variable_t* fmi3_import_get_variable_as_uint64(fmi3_import_variable_t* v);

/** \brief Cast general variable to a one with the specific type
    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_uint32_variable_t* fmi3_import_get_variable_as_uint32(fmi3_import_variable_t* v);

/** \brief Cast general variable to a one with the specific type
    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_uint16_variable_t* fmi3_import_get_variable_as_uint16(fmi3_import_variable_t* v);

/** \brief Cast general variable to a one with the specific type
    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_uint8_variable_t* fmi3_import_get_variable_as_uint8(fmi3_import_variable_t* v);

/** \brief Cast general variable to a one with the specific type

    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_enum_variable_t* fmi3_import_get_variable_as_enum(fmi3_import_variable_t* v);
/** \brief Cast general variable to a one with the specific type

    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_string_variable_t* fmi3_import_get_variable_as_string(fmi3_import_variable_t* v);
/** \brief Cast general variable to a one with the specific type

    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_bool_variable_t* fmi3_import_get_variable_as_boolean(fmi3_import_variable_t* v);
/** \brief Cast general variable to a one with the specific type

    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_binary_variable_t* fmi3_import_get_variable_as_binary(fmi3_import_variable_t* v);
/** \brief Cast general variable to a one with the specific type

    @return Typed object or NULL if base type does not match
*/
FMILIB_EXPORT fmi3_import_clock_variable_t* fmi3_import_get_variable_as_clock(fmi3_import_variable_t* v);

/** \brief Get minimal value for the variable.

    @return Either the value specified in the XML file or negated FLT_MAX as defined in <float.h>
*/
FMILIB_EXPORT fmi3_float32_t fmi3_import_get_float32_variable_min(fmi3_import_float32_variable_t* v);

/** \brief Get maximum value for the variable.

    @return Either the value specified in the XML file or FLT_MAX as defined in <float.h>
*/
FMILIB_EXPORT fmi3_float32_t fmi3_import_get_float32_variable_max(fmi3_import_float32_variable_t* v);

/** \brief Get nominal value for the variable.

    @return The "start" attribute as specified in the XML file or variable nominal value.
*/
FMILIB_EXPORT fmi3_float32_t fmi3_import_get_float32_variable_nominal(fmi3_import_float32_variable_t* v);

/** \brief Get "quantity" attribute if defined, else NULL-pointer. */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_float32_variable_quantity(fmi3_import_float32_variable_t* v);

/** \brief Get associated "unit" object if any */
FMILIB_EXPORT fmi3_import_unit_t* fmi3_import_get_float32_variable_unit(fmi3_import_float32_variable_t* v);

/** \brief Get associated "display unit" object if any */
FMILIB_EXPORT fmi3_import_display_unit_t* fmi3_import_get_float32_variable_display_unit(fmi3_import_float32_variable_t* v);

/**
    \brief Get the variable that this is a derivative of, if defined.

    @return If this variable is a derivative, return the variable that it is a derivative of;
            NULL otherwise.
*/
FMILIB_EXPORT fmi3_import_float32_variable_t* fmi3_import_get_float32_variable_derivative_of(fmi3_import_float32_variable_t* v);

/**
    \brief Get the variable start attribute.

    @return The "start" attribute as specified in the XML file or variable nominal value.
*/
FMILIB_EXPORT fmi3_float32_t fmi3_import_get_float32_variable_start(fmi3_import_float32_variable_t* v);

/** \brief Get the variable "relativeQuantity" attribute.
    @return The "relativeQuantity" attribute as specified in the XML file. False if undefined.
*/
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_float32_variable_relative_quantity(fmi3_import_float32_variable_t* v);

/** \brief Get the variable "unbounded" attribute.
    @return The "unbounded" attribute as specified in the XML file. False if undefined.
*/
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_float32_variable_unbounded(fmi3_import_float32_variable_t* v);

/** \brief Get minimal value for the variable.

    @return Either the value specified in the XML file or negated DBL_MAX as defined in <float.h>
*/
FMILIB_EXPORT fmi3_float64_t fmi3_import_get_float64_variable_min(fmi3_import_float64_variable_t* v);

/** \brief Get maximum value for the variable.

    @return Either the value specified in the XML file or DBL_MAX as defined in <float.h>
*/
FMILIB_EXPORT fmi3_float64_t fmi3_import_get_float64_variable_max(fmi3_import_float64_variable_t* v);

/** \brief Get nominal value for the variable.

    @return The "start" attribute as specified in the XML file or variable nominal value.
*/
FMILIB_EXPORT fmi3_float64_t fmi3_import_get_float64_variable_nominal(fmi3_import_float64_variable_t* v);

/** \brief Get "quantity" attribute if defined, else NULL-pointer. */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_float64_variable_quantity(fmi3_import_float64_variable_t* v);

/**
    \brief Get the variable start attribute.

    @return The "start" attribute as specified in the XML file or variable nominal value.
*/
FMILIB_EXPORT fmi3_float64_t fmi3_import_get_float64_variable_start(fmi3_import_float64_variable_t* v);

/** \brief Get associated "unit" object if any */
FMILIB_EXPORT fmi3_import_unit_t* fmi3_import_get_float64_variable_unit(fmi3_import_float64_variable_t* v);

/** \brief Get associated "display unit" object if any */
FMILIB_EXPORT fmi3_import_display_unit_t* fmi3_import_get_float64_variable_display_unit(fmi3_import_float64_variable_t* v);

/**
    \brief Get the variable that this is a derivative of, if defined.

    @return If this variable is a derivative, return the variable that it is a derivative of;
            NULL otherwise.
*/
FMILIB_EXPORT fmi3_import_float64_variable_t* fmi3_import_get_float64_variable_derivative_of(fmi3_import_float64_variable_t* v);

/** \brief Get the variable "relativeQuantity" attribute.
    @return The "relativeQuantity" attribute as specified in the XML file. False if undefined.
*/
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_float64_variable_relative_quantity(fmi3_import_float64_variable_t* v);

/** \brief Get the variable "unbounded" attribute.
    @return The "unbounded" attribute as specified in the XML file. False if undefined.
*/
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_float64_variable_unbounded(fmi3_import_float64_variable_t* v);

/** \brief Get start value for the variable */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_string_variable_start(fmi3_import_string_variable_t* v);

/** \brief Get start values for the array variable */
FMILIB_EXPORT fmi3_string_t* fmi3_import_get_string_variable_start_array(fmi3_import_string_variable_t* v);

/** \brief Get start value for the variable */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_boolean_variable_start(fmi3_import_bool_variable_t* v);

/** \brief Get the start values of an array variable
    @return Pointer to array with start values. Total length of array is given by product of the dimensions given by
        #fmi3_import_get_variable_dimension_list. FMI Library handles memory for the array.
*/
FMILIB_EXPORT fmi3_boolean_t* fmi3_import_get_boolean_variable_start_array(fmi3_import_bool_variable_t* v);

/** \brief Get "quantity" attribute if defined, else NULL-pointer. */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_int64_variable_quantity(fmi3_import_int64_variable_t* v);
/** \brief Get "quantity" attribute if defined, else NULL-pointer. */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_int32_variable_quantity(fmi3_import_int32_variable_t* v);
/** \brief Get "quantity" attribute if defined, else NULL-pointer. */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_int16_variable_quantity(fmi3_import_int16_variable_t* v);
/** \brief Get "quantity" attribute if defined, else NULL-pointer. */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_int8_variable_quantity(fmi3_import_int8_variable_t* v);
/** \brief Get "quantity" attribute if defined, else NULL-pointer. */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_uint64_variable_quantity(fmi3_import_uint64_variable_t* v);
/** \brief Get "quantity" attribute if defined, else NULL-pointer. */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_uint32_variable_quantity(fmi3_import_uint32_variable_t* v);
/** \brief Get "quantity" attribute if defined, else NULL-pointer. */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_uint16_variable_quantity(fmi3_import_uint16_variable_t* v);
/** \brief Get "quantity" attribute if defined, else NULL-pointer. */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_uint8_variable_quantity(fmi3_import_uint8_variable_t* v);

/** \brief Get minimal value for the variable */
FMILIB_EXPORT fmi3_int64_t fmi3_import_get_int64_variable_min(fmi3_import_int64_variable_t* v);
/** \brief Get minimal value for the variable */
FMILIB_EXPORT fmi3_int32_t fmi3_import_get_int32_variable_min(fmi3_import_int32_variable_t* v);
/** \brief Get minimal value for the variable */
FMILIB_EXPORT fmi3_int16_t fmi3_import_get_int16_variable_min(fmi3_import_int16_variable_t* v);
/** \brief Get minimal value for the variable */
FMILIB_EXPORT fmi3_int8_t fmi3_import_get_int8_variable_min(fmi3_import_int8_variable_t* v);
/** \brief Get minimal value for the variable */
FMILIB_EXPORT fmi3_uint64_t fmi3_import_get_uint64_variable_min(fmi3_import_uint64_variable_t* v);
/** \brief Get minimal value for the variable */
FMILIB_EXPORT fmi3_uint32_t fmi3_import_get_uint32_variable_min(fmi3_import_uint32_variable_t* v);
/** \brief Get minimal value for the variable */
FMILIB_EXPORT fmi3_uint16_t fmi3_import_get_uint16_variable_min(fmi3_import_uint16_variable_t* v);
/** \brief Get minimal value for the variable */
FMILIB_EXPORT fmi3_uint8_t fmi3_import_get_uint8_variable_min(fmi3_import_uint8_variable_t* v);

/** \brief Get max value for the variable */
FMILIB_EXPORT fmi3_int64_t fmi3_import_get_int64_variable_max(fmi3_import_int64_variable_t* v);
/** \brief Get max value for the variable */
FMILIB_EXPORT fmi3_int32_t fmi3_import_get_int32_variable_max(fmi3_import_int32_variable_t* v);
/** \brief Get max value for the variable */
FMILIB_EXPORT fmi3_int16_t fmi3_import_get_int16_variable_max(fmi3_import_int16_variable_t* v);
/** \brief Get max value for the variable */
FMILIB_EXPORT fmi3_int8_t fmi3_import_get_int8_variable_max(fmi3_import_int8_variable_t* v);
/** \brief Get max value for the variable */
FMILIB_EXPORT fmi3_uint64_t fmi3_import_get_uint64_variable_max(fmi3_import_uint64_variable_t* v);
/** \brief Get max value for the variable */
FMILIB_EXPORT fmi3_uint32_t fmi3_import_get_uint32_variable_max(fmi3_import_uint32_variable_t* v);
/** \brief Get max value for the variable */
FMILIB_EXPORT fmi3_uint16_t fmi3_import_get_uint16_variable_max(fmi3_import_uint16_variable_t* v);
/** \brief Get max value for the variable */
FMILIB_EXPORT fmi3_uint8_t fmi3_import_get_uint8_variable_max(fmi3_import_uint8_variable_t* v);

/** \brief Get start value for the variable */
FMILIB_EXPORT fmi3_int64_t fmi3_import_get_int64_variable_start(fmi3_import_int64_variable_t* v);
/** \brief Get start value for the variable */
FMILIB_EXPORT fmi3_int32_t fmi3_import_get_int32_variable_start(fmi3_import_int32_variable_t* v);
/** \brief Get start value for the variable */
FMILIB_EXPORT fmi3_int16_t fmi3_import_get_int16_variable_start(fmi3_import_int16_variable_t* v);
/** \brief Get start value for the variable */
FMILIB_EXPORT fmi3_int8_t fmi3_import_get_int8_variable_start(fmi3_import_int8_variable_t* v);
/** \brief Get start value for the variable */
FMILIB_EXPORT fmi3_uint64_t fmi3_import_get_uint64_variable_start(fmi3_import_uint64_variable_t* v);
/** \brief Get start value for the variable */
FMILIB_EXPORT fmi3_uint32_t fmi3_import_get_uint32_variable_start(fmi3_import_uint32_variable_t* v);
/** \brief Get start value for the variable */
FMILIB_EXPORT fmi3_uint16_t fmi3_import_get_uint16_variable_start(fmi3_import_uint16_variable_t* v);
/** \brief Get start value for the variable */
FMILIB_EXPORT fmi3_uint8_t fmi3_import_get_uint8_variable_start(fmi3_import_uint8_variable_t* v);

/** \brief Get "quantity" attribute if defined, else NULL-pointer. */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_enum_variable_quantity(fmi3_import_enum_variable_t* v);
/** \brief Get start value for the variable*/
FMILIB_EXPORT fmi3_int64_t fmi3_import_get_enum_variable_start(fmi3_import_enum_variable_t* v);
/** \brief Get start value for the array variable*/
FMILIB_EXPORT fmi3_int64_t* fmi3_import_get_enum_variable_start_array(fmi3_import_enum_variable_t* v);
/** \brief Get minimal value for the variable */
FMILIB_EXPORT fmi3_int64_t fmi3_import_get_enum_variable_min(fmi3_import_enum_variable_t* v);
/** \brief Get max value for the variable */
FMILIB_EXPORT fmi3_int64_t fmi3_import_get_enum_variable_max(fmi3_import_enum_variable_t* v);

/** \brief Get the length of the binary variable's start value (which is an array). */
FMILIB_EXPORT size_t fmi3_import_get_binary_variable_start_size(fmi3_import_binary_variable_t* v);
/** \brief Get start value for the variable */
FMILIB_EXPORT fmi3_binary_t fmi3_import_get_binary_variable_start(fmi3_import_binary_variable_t* v);
/** \brief Get start value for the variable */
FMILIB_EXPORT fmi3_binary_t* fmi3_import_get_binary_variable_start_array(fmi3_import_binary_variable_t* v);
/** \brief Get the size of each start value for the variable */
FMILIB_EXPORT size_t* fmi3_import_get_binary_variable_start_array_sizes(fmi3_import_binary_variable_t* v);
/** \brief Get the number of values in the start array for the variable */
FMILIB_EXPORT size_t fmi3_import_get_binary_variable_start_array_size(fmi3_import_binary_variable_t* v);
/** \brief Get mimeType for the variable */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_binary_variable_mime_type(fmi3_import_binary_variable_t* v);
/** \brief Check if the variable has the "maxSize" attribute */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_binary_variable_has_max_size(fmi3_import_binary_variable_t* v);
/** \brief Get maxSize for the variable */
FMILIB_EXPORT size_t fmi3_import_get_binary_variable_max_size(fmi3_import_binary_variable_t* v);

/** \brief Get canBeDeactivated for the variable */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_clock_variable_can_be_deactivated(fmi3_import_clock_variable_t* v);
/** \brief Check if the variable has the "priority" attribute */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_clock_variable_has_priority(fmi3_import_clock_variable_t* v);
/** \brief Get priority for the variable */
FMILIB_EXPORT fmi3_uint32_t fmi3_import_get_clock_variable_priority(fmi3_import_clock_variable_t* v);
/** \brief Get intervalVariability for the variable */
FMILIB_EXPORT fmi3_interval_variability_enu_t fmi3_import_get_clock_variable_interval_variability(fmi3_import_clock_variable_t* v);
/** \brief Check if the variable has the "intervalDecimal" attribute */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_clock_variable_has_interval_decimal(fmi3_import_clock_variable_t* v);
/** \brief Get intervalDecimal for the variable */
FMILIB_EXPORT fmi3_float64_t fmi3_import_get_clock_variable_interval_decimal(fmi3_import_clock_variable_t* v);
/** \brief Get shiftDecimal for the variable */
FMILIB_EXPORT fmi3_float64_t fmi3_import_get_clock_variable_shift_decimal(fmi3_import_clock_variable_t* v);
/** \brief Get supportsFraction for the variable */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_clock_variable_supports_fraction(fmi3_import_clock_variable_t* v);
/** \brief Check if the variable has the "resolution" attribute */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_clock_variable_has_resolution(fmi3_import_clock_variable_t* v);
/** \brief Get resolution for the variable */
FMILIB_EXPORT fmi3_uint64_t fmi3_import_get_clock_variable_resolution(fmi3_import_clock_variable_t* v);
/** \brief Check if the variable has the "intervalCounter" attribute */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_clock_variable_has_interval_counter(fmi3_import_clock_variable_t* v);
/** \brief Get intervalCounter for the variable */
FMILIB_EXPORT fmi3_uint64_t fmi3_import_get_clock_variable_interval_counter(fmi3_import_clock_variable_t* v);
/** \brief Get shiftCounter for the variable */
FMILIB_EXPORT fmi3_uint64_t fmi3_import_get_clock_variable_shift_counter(fmi3_import_clock_variable_t* v);

/** \brief Get the original index in xml of the variable */
FMILIB_EXPORT size_t fmi3_import_get_variable_original_order(fmi3_import_variable_t* v);

/** \brief Get the alias variables. */
FMILIB_EXPORT fmi3_import_alias_variable_list_t* fmi3_import_get_variable_alias_list(fmi3_import_variable_t* v);
/** \brief Get the number of alias variables. */
FMILIB_EXPORT size_t fmi3_import_get_alias_variable_list_size(fmi3_import_alias_variable_list_t* aliases);
/** \brief Get the alias from the list at the given index. */
FMILIB_EXPORT fmi3_import_alias_variable_t* fmi3_import_get_alias(fmi3_import_alias_variable_list_t* aliases, size_t index);

/** \brief Get name for the alias variable. */
FMILIB_EXPORT const char* fmi3_import_get_alias_variable_name(fmi3_import_alias_variable_t* alias);
/** \brief Get the description for the alias variable */
FMILIB_EXPORT const char* fmi3_import_get_alias_variable_description(fmi3_import_alias_variable_t* alias);
/** \brief Get the displayUnit for the alias variable, or NULL if not defined. */
FMILIB_EXPORT fmi3_import_display_unit_t* fmi3_import_get_alias_variable_display_unit(fmi3_import_alias_variable_t* alias);

/** @} */

/**
    \addtogroup fmi3_import 
    @{
       \defgroup fmi3_import_dim Handling of dimensions
    @}
 */

/**
    \addtogroup fmi3_import_dim
    \brief Handling of dimensions for array variables.
    @{ 
 */

/** \brief Get a list of the variable's array dimensions.
    @return list of array dimensions for a variable.
*/
FMILIB_EXPORT fmi3_import_dimension_list_t* fmi3_import_get_variable_dimension_list(fmi3_import_variable_t* v);

/** \brief  Get number of dimensions in a list */
FMILIB_EXPORT size_t fmi3_import_get_dimension_list_size(fmi3_import_dimension_list_t* dl);

/** \brief Get a single dimension from a list */
FMILIB_EXPORT fmi3_import_dimension_t* fmi3_import_get_dimension(fmi3_import_dimension_list_t* dl, size_t index);

/** \brief Checks if the dimension contains the valueReference attribute */
FMILIB_EXPORT int fmi3_import_get_dimension_has_vr(fmi3_import_dimension_t* dim);

/** \brief Checks if the dimension contains the start attribute */
FMILIB_EXPORT int fmi3_import_get_dimension_has_start(fmi3_import_dimension_t* dim);

/** \brief Get the start value of the dimension */
FMILIB_EXPORT fmi3_uint64_t fmi3_import_get_dimension_start(fmi3_import_dimension_t* dim);

/** \brief Get the valueReference of the dimension */
FMILIB_EXPORT fmi3_value_reference_t fmi3_import_get_dimension_vr(fmi3_import_dimension_t* dim);

/** @}
 */

#ifdef __cplusplus
}
#endif
#endif
