/*
 * Type definitions for EnergyPlus.
 */

#ifndef Buildings_SpawnTypes_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_SpawnTypes_h

#include <stdbool.h>
#include <stdio.h>

#include "fmilib.h"
#include "FMI2/fmi2FunctionTypes.h"

#ifndef _WIN32
#include <errno.h>
extern int errno;
#endif

#ifdef _WIN32
#include <windows.h>
#include <io.h>
#define WINDOWS 1
#else
#define WINDOWS 0
#define HANDLE void *
/* See http://www.yolinux.com/TUTORIALS/LibraryArchives-StaticAndDynamic.html */

#ifndef  _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <dlfcn.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif
#ifdef _MSC_VER
#ifdef EXTERNAL_FUNCTION_EXPORT
# define LBNL_Spawn_EXPORT __declspec( dllexport )
#else
# define LBNL_Spawn_EXPORT __declspec( dllimport )
#endif
#elif __GNUC__ >= 4
/* In gnuc, all symbols are by default exported. It is still often useful,
to not export all symbols but only the needed ones */
# define LBNL_Spawn_EXPORT __attribute__ ((visibility("default")))
#else
# define LBNL_Spawn_EXPORT
#endif

#ifndef max
  #define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
#endif

#ifdef _WIN32 /* Win32 or Win64 */
#define access(a, b) (_access_s(a, b))
#endif

#ifndef SEPARATOR
#define SEPARATOR "/"
#endif

#include "../../../../C-Sources/Modelica_EnergyPlus_24_2_0_Types.h"

#endif

