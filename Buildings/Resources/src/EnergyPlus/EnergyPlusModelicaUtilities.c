#include <stdio.h>
#include <stdarg.h>

void EnergyPlusFormatError(const char * message, ...) { va_list args; printf(message,args); }

void EnergyPlusFormatMessage(const char * message, ...) { va_list args; printf(message,args); }

void EnergyPlusError(const char * message) { printf("%s\n", message); }

void EnergyPlusMessage(const char * message) { printf("%s\n", message); }

