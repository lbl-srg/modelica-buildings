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

#ifndef JM_PORTABILITY_H_
#define JM_PORTABILITY_H_
#include <fmilib_config.h>
#include "jm_callbacks.h"

/* Include platform dependent headers */
#if defined(_MSC_VER) || defined(WIN32) || defined(__MINGW32__)
#include <windows.h> /* Microsoft Windows API */
#define DLL_HANDLE HANDLE
#else
#define DLL_HANDLE void*
#include <dlfcn.h>  /* Standard POSIX/UNIX API */
#endif

#include "jm_types.h"
/** \file jm_portability.h
	Handling platform specific defines and functions.
*/
/**
	\addtogroup jm_utils
	@{
		\addtogroup jm_portability
	@}
*/
/** \addtogroup jm_portability Handling platform specific defines and functions
@{*/
/** \brief Load a dll/so library into the process and return a handle. */
DLL_HANDLE		jm_portability_load_dll_handle		(const char* dll_file_path);

/** \brief Unload a Dll and release the handle*/
jm_status_enu_t jm_portability_free_dll_handle		(DLL_HANDLE dll_handle);

/** \brief A function pointer as returned when DLL symbol is loaded.*/
#ifdef WIN32
#define jm_dll_function_ptr FARPROC
#else
typedef void* jm_dll_function_ptr; 
#endif

/** \brief Find a function in the Dll and return a function pointer */
jm_status_enu_t jm_portability_load_dll_function	(DLL_HANDLE dll_handle, char* dll_function_name, jm_dll_function_ptr* dll_function_ptrptr);

/** \brief Return error associated with Dll handling */
char* jm_portability_get_last_dll_error	(void);

/** \brief Get current working directory name */
jm_status_enu_t jm_portability_get_current_working_directory(char* buffer, size_t len);

/** \brief Set current working directory*/
jm_status_enu_t jm_portability_set_current_working_directory(const char* cwd);

/** \brief Get system-wide temporary directory */
const char* jm_get_system_temp_dir();

/**
    \brief Create a uniquely named temporary directory.
    \param cb - callbacks for memory allocation and logging. Default callbacks
            are used if this parameter is NULL.
    \param tmplt Directory name template ending with XXXXXX. The template is
            modified by the call.
    \return A pointer to the modified template. The function returns NULL if
            the template does not end with XXXXXX, or if the directory could
            not be created.
*/
char *jm_mkdtemp(jm_callbacks *cb, char *tmplt);


/** 
	\brief Get absolute path to an existing directory
	\param cb - callbacks for memory allocation and logging. Default callbacks are used if this parameter is NULL.
	\param dir - path to a directory (relative or absolute).
	\param outPath - buffer for storing the directory
	\param len - of the buffer (if size is larger than FILENAME_MAX + 1 then the path will always fit in)
	\return Pointer to outPath on success, 0 - on error in which case a message is send to the logger.	
*/
char* jm_get_dir_abspath(jm_callbacks* cb, const char* dir, char* outPath, size_t len);

/** 
	\brief Create a unique temporary directory
	\param cb - callbacks for memory allocation and logging. Default callbacks are used if this parameter is NULL.
	\param systemTempDir - directory where the temp dir should be located both absolute and relative path are accepted.
				System-wide directory is used if this parameter is NULL.
	\param tempPrefix - File name template prefix used when creating temporaty directories. "jm" is used if this is NULL.
	\return A pointer to the temporary directory name (absolute path, no terminating '/'). Caller is responsible for freeing the memory.
		The function returns NULL if there were errors in which case a message is send to the logger.	
*/
char* jm_mk_temp_dir(jm_callbacks* cb, const char* systemTempDir, const char* tempPrefix);

/** 
	\brief Create a file:// URL from absolute path
	\param cb - callbacks for memory allocation and logging. Default callbacks are used if this parameter is NULL.
	\param absPath - absolute path to be converted into the URL
	\return A pointer to the URL. Caller is responsible for freeing the memory.
		The function returns NULL if there were errors in which case a message is send to the logger.	
*/
char* jm_create_URL_from_abs_path(jm_callbacks* cb, const char* absPath);

/**
	\brief Make a directory.
*/
jm_status_enu_t jm_mkdir(jm_callbacks* cb, const char* dir);

/**
\brief Remove directory and all it contents.
*/
jm_status_enu_t jm_rmdir(jm_callbacks* cb, const char* dir);

/**
\brief C89 compatible implementation of C99 vsnprintf. 
*/
FMILIB_EXPORT
int jm_vsnprintf(char * str, size_t size, const char * fmt, va_list al);

/**
\brief C89 compatible implementation of C99 snprintf. 
*/
FMILIB_EXPORT
int jm_snprintf(char * str, size_t size, const char * fmt, ...);

#ifdef HAVE_VA_COPY
#define JM_VA_COPY va_copy
#elif defined(HAVE___VA_COPY)
#define JM_VA_COPY __va_copy
#elif defined(WIN32)
#define JM_VA_COPY(dest,src) dest=src
#endif

/*@}*/
#endif /* End of header file JM_PORTABILITY_H_ */
