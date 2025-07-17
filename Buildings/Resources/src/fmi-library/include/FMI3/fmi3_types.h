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

#ifndef FMI3_TYPES_H_
#define FMI3_TYPES_H_
/** \file fmi3_types.h
    Transformation of the standard FMI type names into fmi3_ prefixed.
*/
/**
    \addtogroup jm_utils
    @{
        \addtogroup fmi3_utils
    @}
*/

/**    \addtogroup fmi3_utils Functions and types supporting FMI 3.0 processing
    @{
*/
/** \name Renaming of typedefs 
@{*/
#define fmi3Instance            fmi3_instance_t
#define fmi3InstanceEnvironment fmi3_instance_environment_t
#define fmi3FMUState            fmi3_FMU_state_t
#define fmi3ValueReference      fmi3_value_reference_t
#define fmi3Float32             fmi3_float32_t
#define fmi3Float64             fmi3_float64_t
#define fmi3UInt8               fmi3_uint8_t
#define fmi3Int8                fmi3_int8_t
#define fmi3UInt16              fmi3_uint16_t
#define fmi3Int16               fmi3_int16_t
#define fmi3UInt32              fmi3_uint32_t
#define fmi3Int32               fmi3_int32_t
#define fmi3Int64               fmi3_int64_t
#define fmi3UInt64              fmi3_uint64_t
#define fmi3Boolean             fmi3_boolean_t
#define fmi3Char                fmi3_char_t
#define fmi3String              fmi3_string_t
#define fmi3Byte                fmi3_byte_t
#define fmi3Binary              fmi3_binary_t
#define fmi3Clock               fmi3_clock_t

/** @}*/
/* Standard FMI 3.0 types */
#ifdef fmi3PlatformTypes_h
#undef fmi3PlatformTypes_h
#endif
#include <FMI3/fmi3PlatformTypes.h>
#undef fmi3PlatformTypes_h

/** FMI boolean constants.*/
typedef enum {
    fmi3_true  = fmi3True,
    fmi3_false = fmi3False
} fmi3_boolean_enu_t;

#undef fmi3True
#undef fmi3False

/** FMI clock constants. */
typedef enum {
    fmi3_clock_active   = fmi3ClockActive,
    fmi3_clock_inactive = fmi3ClockInactive
} fmi3_clock_enu_t;

#undef fmi3ClockActive
#undef fmi3ClockInActive

/**
    @}
*/

#undef fmi3Instance
#undef fmi3ValueReference
#undef fmi3Boolean
#undef fmi3String
#undef fmi3UndefinedValueReference

#endif /* End of header file FMI3_TYPES_H_ */
