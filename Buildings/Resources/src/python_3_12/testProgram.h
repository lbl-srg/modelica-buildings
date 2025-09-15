#ifndef _TESTPROGRAM_H_
#define _TESTPROGRAM_H_

#include <stddef.h>  /* stddef defines size_t */
#include <stdio.h>
#include <stdlib.h>

#include "pythonInterpreter.h"

void ModelicaFormatError(const char* string, const char* fmt, const char* val);

int main(int nArgs, char ** args);

#endif /* _TESTPROGRAM_H_ */
