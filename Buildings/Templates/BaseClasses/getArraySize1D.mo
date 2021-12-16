within Buildings.Templates.BaseClasses;
function getArraySize1D
  input String varName "Key";
  input String fileName "File name";
  output Integer n "Number of elements in array";
protected
  ExternData.Types.ExternJSONFile extObj=
      ExternData.Types.ExternJSONFile(fileName, verboseRead=true)
    "External file object";
algorithm
  n :=ExternData.Functions.JSON.getArraySize1D(varName, extObj);
annotation(__Dymola_translate=true);
end getArraySize1D;
