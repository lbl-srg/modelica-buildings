// Exchange values with Python.
// Any argument that starts with 'n', such as nDblWri, may be zero.
// If there is an error, then this function calls
// ModelicaFormatError(...) which terminates the computation.
// The arguments are as follows:
//  moduleName - Name of the Python module.
//  functionName - Name of the Python function.
//  dblValWri    - Double values to write.
//  nDblWri      - Number of doubles to write.
//  dblValRea    - Double values to read.
//  nDblRea      - Number of double values to read.
//  intValWri    - Integer values to write.
//  nIntWri      - Number of integers to write.
//  intValRea    - Integer values to read.
//  nIntRea      - Number of integers to read.
//  strValWri    - String values to write.
//  nStrWri      - Number of strings to write.
#include <ModelicaUtilities.h>

void pythonExchangeValues(const char * moduleName,
                          const char * functionName,
                          const double * dblValWri, int nDblWri,
                          double * dblValRea, int nDblRea,
                          const int * intValWri, int nIntWri,
                          int * intValRea, int nIntRea,
                          const char ** strValWri, int nStrWri)
{
  pythonExchangeValuesNoModelica(
   moduleName,
   functionName,
   dblValWri, nDblWri,
   dblValRea, nDblRea,
   intValWri, nIntWri,
   intValRea, nIntRea,
   strValWri, nStrWri,
   ModelicaFormatError
  );
}
