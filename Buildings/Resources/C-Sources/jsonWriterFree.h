/* Function that frees the memory for the FileWriter.
 *
 * Michael Wetter, LBNL                     2018-05-12
 */

#ifndef IBPSA_JSONRITERSFree_h
#define IBPSA_JSONRITERSFree_h

#include <stdlib.h>
#include <stdio.h>

#include "fileWriterStructure.h"
#include "jsonWriterInit.h"

void jsonWriterFree(void* ptrFileWriter);

#endif
