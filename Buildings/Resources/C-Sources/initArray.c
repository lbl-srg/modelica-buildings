/////////////////////////////////////////////////////
// Modelica external function that generates a
// structure to store an increasing number of double
// values.
//
/////////////////////////////////////////////////////
// When called by the Modelica function "initArray", 
// this function creates a structure for an array whose
// number of elements can be enlarged.
//
// Pierre Vigouroux, LBNL                  7/18/2011 
// svn-id=$Id$
/////////////////////////////////////////////////////

typedef struct ExternalObjectStructure
{
  // array where the data are stored during the simulation
  double* x;
  // Number of element in the array
  int n;
} ExternalObjectStructure;

// Create the structure "table" and return pointer to "table".
void* initArray()
{
  ExternalObjectStructure* table = malloc(sizeof(ExternalObjectStructure));
  if ( table == NULL ) 
    ModelicaError("Not enough memory in initArray.c.");
  // Number of elements in the array
  table->n=0;   // initialise nEle to 0
  table->x=NULL;   // set the pointer to null

  return (void*) table;
};
