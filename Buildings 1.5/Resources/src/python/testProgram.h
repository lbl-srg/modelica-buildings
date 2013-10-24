#ifndef _TESTPROGRAM_H_
#define _TESTPROGRAM_H_

#include "pythonInterpreter.h"
#include <stddef.h>  /* stddef defines size_t */

void ModelicaFormatError(const char* string, const char* fmt, const char* val);

int main(int nArgs, char ** args);

#endif /* _TESTPROGRAM_H_ */
