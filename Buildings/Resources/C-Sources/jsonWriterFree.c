/* Function that frees the memory for the FileWriter.
 *
 * Michael Wetter, LBNL                     2018-05-12
 */
#include <stdlib.h>
#include <stdio.h>

#include "jsonWriterFree.h"
#include "fileWriterStructure.h"
#include "jsonWriterInit.h"

void jsonWriterFree(void* ptrFileWriter){
  FileWriter *ID = (FileWriter*)ptrFileWriter;
  int i;

  /* If this FileWriter writes output at terminal(), dump data upon destruction. */
  if (ID->dumpAtDestruction){
    writeJson(ptrFileWriter,  ID->varVals, ID->numKeys);
  }

  free(ID->varVals);

  for (i = 0; i < ID->numKeys; ++i)
  {
    free(ID->varKeys[i]);
  }
  free(ID->varKeys);

  freeBase(ptrFileWriter);

  return;
}
