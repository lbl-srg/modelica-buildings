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

/** \file fmi3_import_type.h
*  \brief Public interface to the FMI XML C-library: variable types handling.
*/

#ifndef FMI3_IMPORT_TYPE_H_
#define FMI3_IMPORT_TYPE_H_

#include "fmi3_import_unit.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
    \addtogroup fmi3_import
    @{
    \addtogroup fmi3_import_typedef Support for processing variable types
    @}
    \addtogroup fmi3_import_typedef Support for processing variable types
  @{
*/
/**@name   Type definitions supporting structures*/
/**@{ */
/** \brief Opaque float definition object. */
typedef struct fmi3_xml_float_typedef_t fmi3_import_float_typedef_t;
/** \brief Opaque integer type definition object. */
typedef struct fmi3_xml_int_typedef_t fmi3_import_int_typedef_t;
/** \brief Opaque enumeration type definition object. */
typedef struct fmi3_xml_enumeration_typedef_t fmi3_import_enumeration_typedef_t;
/** \brief Opaque binary type definition object. */
typedef struct fmi3_xml_binary_typedef_t fmi3_import_binary_typedef_t;
/** \brief Opaque clock type definition object. */
typedef struct fmi3_xml_clock_typedef_t fmi3_import_clock_typedef_t;
/** \brief Opaque general variable type definition object. */
typedef struct fmi3_xml_variable_typedef_t fmi3_import_variable_typedef_t;
/** \brief Opaque list of the type definitions in the model */
typedef struct fmi3_xml_type_definition_list_t fmi3_import_type_definition_list_t;
/**@} */

/** \brief Get the number of available type definitions */
FMILIB_EXPORT size_t fmi3_import_get_type_definition_list_size(fmi3_import_type_definition_list_t* td);

/** \brief Get a type definition specified by the index. Parameter 'index' does not reflect the index in the XML, but the
        index in an internal list of type definitions.
    @param td the type definition list object
    @param index the index of type definition. Must be less than the number returned by # fmi3_import_get_type_definition_list
    @return A type definition object or NULL if index is out of range.
*/
FMILIB_EXPORT fmi3_import_variable_typedef_t* fmi3_import_get_typedef(fmi3_import_type_definition_list_t* td, size_t index);

/** \brief Get the type name*/
FMILIB_EXPORT const char* fmi3_import_get_type_name(fmi3_import_variable_typedef_t* td);

/**\brief Get type description.

   Note that an empty string is returned if the attribute is not present in the XML.*/
FMILIB_EXPORT const char* fmi3_import_get_type_description(fmi3_import_variable_typedef_t* td);

/** \brief Get base type used for the type definition */
FMILIB_EXPORT fmi3_base_type_enu_t fmi3_import_get_base_type(fmi3_import_variable_typedef_t* td);

/* Boolean and String has no extra attributes -> not needed*/

/** \brief Cast the general type definition object to an object with a specific base type 
    @return Pointer to the specific type object or NULL if base type does not match.
*/
FMILIB_EXPORT fmi3_import_float_typedef_t* fmi3_import_get_type_as_float(fmi3_import_variable_typedef_t* td);

/** \brief Cast the general type definition object to an object with a specific base type 
    @return Pointer to the specific type object or NULL if base type does not match.
*/
FMILIB_EXPORT fmi3_import_int_typedef_t* fmi3_import_get_type_as_int(fmi3_import_variable_typedef_t* td);

/** \brief Cast the general type definition object to an object with a specific base type 
    @return Pointer to the specific type object or NULL if base type does not match.
*/
FMILIB_EXPORT fmi3_import_enumeration_typedef_t* fmi3_import_get_type_as_enum(fmi3_import_variable_typedef_t* td);

/** \brief Cast the general type definition object to an object with a specific base type 
    @return Pointer to the specific type object or NULL if base type does not match.
*/
FMILIB_EXPORT fmi3_import_binary_typedef_t* fmi3_import_get_type_as_binary(fmi3_import_variable_typedef_t* td);

/** \brief Cast the general type definition object to an object with a specific base type 
    @return Pointer to the specific type object or NULL if base type does not match.
*/
FMILIB_EXPORT fmi3_import_clock_typedef_t* fmi3_import_get_type_as_clock(fmi3_import_variable_typedef_t* td);

/** \brief Get the quantity associated with the type definition.

    @return The quantity, or NULL-pointer if quantity is not defined (NULL-pointer is always returned for strings and
      booleans).
*/
FMILIB_EXPORT const char* fmi3_import_get_type_quantity(fmi3_import_variable_typedef_t* td);

/** \brief Get minimal value for the type.

    @return Either the value specified in the XML file or negated DBL_MAX as defined in <float.h>
*/
FMILIB_EXPORT fmi3_float64_t fmi3_import_get_float64_type_min(fmi3_import_float_typedef_t* td);

/** \brief Get maximum value for the type

    @return Either the value specified in the XML file or DBL_MAX as defined in <float.h>
*/
FMILIB_EXPORT fmi3_float64_t fmi3_import_get_float64_type_max(fmi3_import_float_typedef_t* td);

/** \brief Get the nominal value associated with the type definition */
FMILIB_EXPORT fmi3_float64_t fmi3_import_get_float64_type_nominal(fmi3_import_float_typedef_t* td);

/** \brief Get the unit object associated with the type definition if any*/
FMILIB_EXPORT fmi3_import_unit_t* fmi3_import_get_float64_type_unit(fmi3_import_float_typedef_t* td);

/** \brief Get the 'relativeQuantity' flag */
FMILIB_EXPORT int fmi3_import_get_float64_type_is_relative_quantity(fmi3_import_float_typedef_t* td);

/** \brief Get the 'unbounded' flag */
FMILIB_EXPORT int fmi3_import_get_float64_type_is_unbounded(fmi3_import_float_typedef_t* td);

/**
    \brief Get display unit associated with a type definition.
    @return Display unit object of NULL if none was given.
*/
FMILIB_EXPORT fmi3_import_display_unit_t* fmi3_import_get_float64_type_display_unit(fmi3_import_float_typedef_t* td);

/** \brief Get minimal value for the type.

    @return Either the value specified in the XML file or negated FLT_MAX as defined in <float.h>
*/
FMILIB_EXPORT fmi3_float32_t fmi3_import_get_float32_type_min(fmi3_import_float_typedef_t* td);

/** \brief Get maximum value for the type

    @return Either the value specified in the XML file or FLT_MAX as defined in <float.h>
*/
FMILIB_EXPORT fmi3_float32_t fmi3_import_get_float32_type_max(fmi3_import_float_typedef_t* td);

/** \brief Get the nominal value associated with the type definition */
FMILIB_EXPORT fmi3_float32_t fmi3_import_get_float32_type_nominal(fmi3_import_float_typedef_t* td);

/** \brief Get the unit object associated with the type definition if any*/
FMILIB_EXPORT fmi3_import_unit_t* fmi3_import_get_float32_type_unit(fmi3_import_float_typedef_t* td);

/** \brief Get the 'relativeQuantity' flag */
FMILIB_EXPORT int fmi3_import_get_float32_type_is_relative_quantity(fmi3_import_float_typedef_t* td);

/** \brief Get the 'unbounded' flag */
FMILIB_EXPORT int fmi3_import_get_float32_type_is_unbounded(fmi3_import_float_typedef_t* td);

/**
    \brief Get display unit associated with a type definition.
    @return Display unit object of NULL if none was given.
*/
FMILIB_EXPORT fmi3_import_display_unit_t* fmi3_import_get_float32_type_display_unit(fmi3_import_float_typedef_t* td);

/** \brief Get maximum value for the type
    @return Either the value specified in the XML file or INT64_MAX as defined in <limits.h>
*/
FMILIB_EXPORT fmi3_int64_t fmi3_import_get_int64_type_max(fmi3_import_int_typedef_t* td);

/** \brief Get minimal value for the type.
    @return Either the value specified in the XML file or INT64_MIN as defined in <limits.h>
*/
FMILIB_EXPORT fmi3_int64_t fmi3_import_get_int64_type_min(fmi3_import_int_typedef_t* td);

/** \brief Get maximum value for the type
    @return Either the value specified in the XML file or INT32_MAX as defined in <limits.h>
*/
FMILIB_EXPORT fmi3_int32_t fmi3_import_get_int32_type_max(fmi3_import_int_typedef_t* td);

/** \brief Get minimal value for the type.
    @return Either the value specified in the XML file or INT32_MIN as defined in <limits.h>
*/
FMILIB_EXPORT fmi3_int32_t fmi3_import_get_int32_type_min(fmi3_import_int_typedef_t* td);

/** \brief Get maximum value for the type
    @return Either the value specified in the XML file or INT16_MAX as defined in <limits.h>
*/
FMILIB_EXPORT fmi3_int16_t fmi3_import_get_int16_type_max(fmi3_import_int_typedef_t* td);

/** \brief Get minimal value for the type.
    @return Either the value specified in the XML file or INT16_MIN as defined in <limits.h>
*/
FMILIB_EXPORT fmi3_int16_t fmi3_import_get_int16_type_min(fmi3_import_int_typedef_t* td);

/** \brief Get maximum value for the type
    @return Either the value specified in the XML file or INT8_MAX as defined in <limits.h>
*/
FMILIB_EXPORT fmi3_int8_t fmi3_import_get_int8_type_max(fmi3_import_int_typedef_t* td);

/** \brief Get minimal value for the type.
    @return Either the value specified in the XML file or INT8_MIN as defined in <limits.h>
*/
FMILIB_EXPORT fmi3_int8_t fmi3_import_get_int8_type_min(fmi3_import_int_typedef_t* td);

/** \brief Get maximum value for the type
    @return Either the value specified in the XML file or UINT64_MAX as defined in <limits.h>
*/
FMILIB_EXPORT fmi3_uint64_t fmi3_import_get_uint64_type_max(fmi3_import_int_typedef_t* td);

/** \brief Get minimal value for the type.
    @return Either the value specified in the XML file or 0
*/
FMILIB_EXPORT fmi3_uint64_t fmi3_import_get_uint64_type_min(fmi3_import_int_typedef_t* td);

/** \brief Get maximum value for the type
    @return Either the value specified in the XML file or UINT32_MAX as defined in <limits.h>
*/
FMILIB_EXPORT fmi3_uint32_t fmi3_import_get_uint32_type_max(fmi3_import_int_typedef_t* td);

/** \brief Get minimal value for the type.
    @return Either the value specified in the XML file or 0
*/
FMILIB_EXPORT fmi3_uint32_t fmi3_import_get_uint32_type_min(fmi3_import_int_typedef_t* td);

/** \brief Get maximum value for the type
    @return Either the value specified in the XML file or UINT16_MAX as defined in <limits.h>
*/
FMILIB_EXPORT fmi3_uint16_t fmi3_import_get_uint16_type_max(fmi3_import_int_typedef_t* td);

/** \brief Get minimal value for the type.
    @return Either the value specified in the XML file or 0
*/
FMILIB_EXPORT fmi3_uint16_t fmi3_import_get_uint16_type_min(fmi3_import_int_typedef_t* td);

/** \brief Get maximum value for the type
    @return Either the value specified in the XML file or UINT8_MAX as defined in <limits.h>
*/
FMILIB_EXPORT fmi3_uint8_t fmi3_import_get_uint8_type_max(fmi3_import_int_typedef_t* td);

/** \brief Get minimal value for the type.
    @return Either the value specified in the XML file or 0
*/
FMILIB_EXPORT fmi3_uint8_t fmi3_import_get_uint8_type_min(fmi3_import_int_typedef_t* td);

/** \brief Get minimal value for the type.

    @return Either the value specified in the XML file or 0
*/
FMILIB_EXPORT unsigned int fmi3_import_get_enum_type_min(fmi3_import_enumeration_typedef_t* td);

/** \brief Get maximum value for the type.

    @return Either the value specified in the XML file or INT_MAX as defined in <limits.h>
*/
FMILIB_EXPORT unsigned int fmi3_import_get_enum_type_max(fmi3_import_enumeration_typedef_t* td);

/** \brief Get the number of elements in the enum */
FMILIB_EXPORT size_t fmi3_import_get_enum_type_size(fmi3_import_enumeration_typedef_t* td);

/** \brief Get an enumeration item name by index */
FMILIB_EXPORT const char* fmi3_import_get_enum_type_item_name(fmi3_import_enumeration_typedef_t* td, size_t item);

/** \brief Get an enumeration item value by index */
FMILIB_EXPORT int fmi3_import_get_enum_type_item_value(fmi3_import_enumeration_typedef_t* td, size_t item);

/** \brief Get an enumeration item description by index */
FMILIB_EXPORT const char* fmi3_import_get_enum_type_item_description(fmi3_import_enumeration_typedef_t* td, size_t item);

/** \brief Get an enumeration item name for the given value */
FMILIB_EXPORT const char* fmi3_import_get_enum_type_value_name(fmi3_import_enumeration_typedef_t* t, int value);

/** \brief Get mimeType for the type */
FMILIB_EXPORT fmi3_string_t fmi3_import_get_binary_type_mime_type(fmi3_import_binary_typedef_t* t);
/** \brief Check if the type has the "maxSize" attribute */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_binary_type_has_max_size(fmi3_import_binary_typedef_t* t);
/** \brief Get maxSize for the type */
FMILIB_EXPORT size_t fmi3_import_get_binary_type_max_size(fmi3_import_binary_typedef_t* t);


/** \brief Get canBeDeactivated for the type */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_clock_type_can_be_deactivated(fmi3_import_clock_typedef_t* t);
/** \brief Check if the type has the "priority" attribute */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_clock_type_has_priority(fmi3_import_clock_typedef_t* t);
/** \brief Get priority for the type */
FMILIB_EXPORT fmi3_uint32_t fmi3_import_get_clock_type_priority(fmi3_import_clock_typedef_t* t);
/** \brief Get intervalVariability for the type */
FMILIB_EXPORT fmi3_interval_variability_enu_t fmi3_import_get_clock_type_interval_variability(fmi3_import_clock_typedef_t* t);
/** \brief Check if the type has the "intervalDecimal" attribute */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_clock_type_has_interval_decimal(fmi3_import_clock_typedef_t* t);
/** \brief Get intervalDecimal for the type */
FMILIB_EXPORT fmi3_float64_t fmi3_import_get_clock_type_interval_decimal(fmi3_import_clock_typedef_t* t);
/** \brief Get shiftDecimal for the type */
FMILIB_EXPORT fmi3_float64_t fmi3_import_get_clock_type_shift_decimal(fmi3_import_clock_typedef_t* t);
/** \brief Get supportsFraction for the type */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_clock_type_supports_fraction(fmi3_import_clock_typedef_t* t);
/** \brief Check if the type has the "resolution" attribute */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_clock_type_has_resolution(fmi3_import_clock_typedef_t* t);
/** \brief Get resolution for the type */
FMILIB_EXPORT fmi3_uint64_t fmi3_import_get_clock_type_resolution(fmi3_import_clock_typedef_t* t);
/** \brief Check if the type has the "intervalCounter" attribute */
FMILIB_EXPORT fmi3_boolean_t fmi3_import_get_clock_type_has_interval_counter(fmi3_import_clock_typedef_t* t);
/** \brief Get intervalCounter for the type */
FMILIB_EXPORT fmi3_uint64_t fmi3_import_get_clock_type_interval_counter(fmi3_import_clock_typedef_t* t);
/** \brief Get shiftCounter for the type */
FMILIB_EXPORT fmi3_uint64_t fmi3_import_get_clock_type_shift_counter(fmi3_import_clock_typedef_t* t);

/**
*  @}
*/
#ifdef __cplusplus
}
#endif
#endif

