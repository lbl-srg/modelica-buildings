/*
   The file fmilib_config.h from the fmi-library is platform specific.
   This file is a wrapper that includes the correct file.
*/

#ifndef CONFIG_FMILIB_PORATABLE_H_
#define CONFIG_FMILIB_PORATABLE_H_

#include <stdint.h>
#if UINTPTR_MAX == 0xffffffff
#error "32 bit compilation is not supported."
#endif

#ifdef __linux__
#include <fmilib_config-linux64.h>
#elif _WIN32
#include <fmilib_config-win64.h>
#else
#include <fmilib_config-darwin64.h>
#endif

#endif
