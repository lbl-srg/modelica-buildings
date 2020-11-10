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

#ifndef JM_CALLBACKS_H
#define JM_CALLBACKS_H
#include <stddef.h>
#include <stdarg.h>

#include <fmilib_config.h>

#include "jm_types.h"

#ifdef __cplusplus
extern "C" {
#endif
/** \file jm_callbacks.h Definition of ::jm_callbacks and supporting functions
	*
	* \addtogroup jm_utils
	* @{
		\addtogroup jm_callbacks
	* @}
*/
/** \addtogroup jm_callbacks Definition of callbacks struct and supporting functions
* @{  */
typedef struct jm_callbacks jm_callbacks;

/** \name Memory management callbacks
* jm_malloc_f, jm_realloc_f, jm_calloc_f, jm_free_f function 
* types correspond to the standard C memory management functions
* @{ 
*/
/** \brief Allocation function type. */
typedef jm_voidp (*jm_malloc_f)(size_t size);

/** \brief Re-allocation function type. */
typedef jm_voidp (*jm_realloc_f)(void *ptr, size_t size);

/** \brief Zero-initialized allocation function type. */
typedef jm_voidp (*jm_calloc_f)(size_t numitems, size_t itemsize);

/** \brief Free memory function type. */
typedef void (*jm_free_f)(jm_voidp p);
/** @}
*/

/**
*  
* \brief Logger callback type.
*
* The logger callback is used to report errors. Note that this function is
* by default only used in FMI standard intependent code (e.g., fmi_import_get_fmi_version()).
* Since logging functions are different between different standard versions separate
* logging functions are necessary for each fmi implementation.\n
* Defaults are provided for each standard. 
*/
typedef void (*jm_logger_f)(jm_callbacks* c, jm_string module, jm_log_level_enu_t log_level, jm_string message);

/** \brief Maximum message size that can be stored in the ::jm_callbacks struct */
#define JM_MAX_ERROR_MESSAGE_SIZE 2000

/** \brief The callbacks struct is sent to all the modules in the library */
struct jm_callbacks {
	/** \brief Allocate non-initialized memory */
	jm_malloc_f malloc; 
	/** \brief Allocate zero initialized memory */
	jm_calloc_f calloc; 
	/** \brief Re-allocate memory */
	jm_realloc_f realloc; 
	/** \brief Free-allocated memory */
	jm_free_f free;        
	/** \brief Logging callback */
	jm_logger_f logger;		
	/** \brief Logging level */
	jm_log_level_enu_t log_level; 
	/** \brief Arbitrary context pointer passed to the logger function  */
	jm_voidp context;	
	/** \brief The buffer used along with jm_get_last_error() */
	char errMessageBuffer[JM_MAX_ERROR_MESSAGE_SIZE]; 
};

/**
* \brief Get the last log message produced by the library.
*
* An alternative way to get error information is to use jm_get_last_error(). This is only meaningful
* if logger function is not present.
*/
static jm_string jm_get_last_error(jm_callbacks* cb) {return cb->errMessageBuffer; }

/**
 \brief Clear the last generated log message.
*/
static void jm_clear_last_error(jm_callbacks* cb) { cb->errMessageBuffer[0] = 0; }

/**
\brief Set the structure to be returned by jm_get_default_callbacks().

@param c - a pointer to initialized struct to be used as default later on. If this is NULL
	library default implementation will be used.
*/
FMILIB_EXPORT
void jm_set_default_callbacks(jm_callbacks* c);

/**
\brief Get default callbacks. The function never returns NULL.
\return Default ::jm_callbacks struture. Either the one supplied by the library of the one set with jm_set_default_callbacks().
*/
FMILIB_EXPORT
jm_callbacks* jm_get_default_callbacks(void);

/**
\brief The default logger implementation prints messages to stderr.
*/
FMILIB_EXPORT
void jm_default_logger(jm_callbacks* c, jm_string module, jm_log_level_enu_t log_level, jm_string message);

/**
\brief Send a message to the logger function.
	@param cb - callbacks to be used for reporting;
	@param module - a name of reporting module;
	@param log_level - message kind;
	@param fmt - "printf" type of format followed by the arguments.
*/
FMILIB_EXPORT
void jm_log(jm_callbacks* cb, const char* module, jm_log_level_enu_t log_level, const char* fmt, ...);

/** \copydoc jm_log()
	@param ap - variable size argument list.
*/
FMILIB_EXPORT
void jm_log_v(jm_callbacks* cb, const char* module, jm_log_level_enu_t log_level, const char* fmt, va_list ap);

/** \brief Send a fatal error message to the logger function. See jm_log() for details.
*/
FMILIB_EXPORT
void jm_log_fatal_v(jm_callbacks* cb, const char* module, const char* fmt, va_list ap);
/** \brief Send a fatal error message to the logger function. See jm_log() for details.
*/
FMILIB_EXPORT
void jm_log_fatal(jm_callbacks* cb, const char* module, const char* fmt, ...);

/** \brief Send a error message to the logger function. See jm_log() for details.
*/
FMILIB_EXPORT
void jm_log_error_v(jm_callbacks* cb, const char* module, const char* fmt, va_list ap);

/** \brief Send a error message to the logger function. See jm_log() for details.
*/
FMILIB_EXPORT
void jm_log_error(jm_callbacks* cb, const char* module, const char* fmt, ...);

/** \brief Send a warning message to the logger function. See jm_log() for details.
*/
FMILIB_EXPORT
void jm_log_warning_v(jm_callbacks* cb, const char* module, const char* fmt, va_list ap);

/** \brief Send a warning message to the logger function. See jm_log() for details.
*/
FMILIB_EXPORT
void jm_log_warning(jm_callbacks* cb, const char* module, const char* fmt, ...);

/** \brief Send an info message to the logger function. See jm_log() for details.
*/
FMILIB_EXPORT
void jm_log_info_v(jm_callbacks* cb, const char* module, const char* fmt, va_list ap);
/** \brief Send an info message to the logger function. See jm_log() for details.
*/
FMILIB_EXPORT
void jm_log_info(jm_callbacks* cb, const char* module, const char* fmt, ...);

/** \brief Send a verbose message to the logger function. See jm_log() for details.
*/
FMILIB_EXPORT
void jm_log_verbose_v(jm_callbacks* cb, const char* module, const char* fmt, va_list ap);
/** \brief Send a verbose message to the logger function. See jm_log() for details.
*/
FMILIB_EXPORT
void jm_log_verbose(jm_callbacks* cb, const char* module, const char* fmt, ...);

#ifdef FMILIB_ENABLE_LOG_LEVEL_DEBUG
/** \brief Send a debug message to the logger function. See jm_log() for details.

	Note that the function is only active if the library is configure with FMILIB_ENABLE_LOG_LEVEL_DEBUG=ON
*/
FMILIB_EXPORT
void jm_log_debug_v(jm_callbacks* cb, const char* module, const char* fmt, va_list ap);
/** \brief Send a debug message to the logger function. See jm_log() for details.

	Note that the function is only active if the library is configure with FMILIB_ENABLE_LOG_LEVEL_DEBUG=ON
*/
FMILIB_EXPORT
void jm_log_debug(jm_callbacks* cb, const char* module, const char* fmt, ...);
#else
/** \brief Send a debug message to the logger function. See jm_log() for details.

	Note that the function is only active if the library is configure with FMILIB_ENABLE_LOG_LEVEL_DEBUG=ON
*/
static void jm_log_debug_v(jm_callbacks* cb, const char* module, const char* fmt, va_list ap) {}
/** \brief Send a debug message to the logger function. See jm_log() for details.

	Note that the function is only active if the library is configure with FMILIB_ENABLE_LOG_LEVEL_DEBUG=ON
*/
static void jm_log_debug(jm_callbacks* cb, const char* module, const char* fmt, ...) {}
#endif


/* @}
*/

#ifdef __cplusplus
}
#endif
/* JM_CONTEXT_H */
#endif
