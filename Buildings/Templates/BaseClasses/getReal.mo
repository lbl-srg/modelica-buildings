within Buildings.Templates.BaseClasses;
function getReal
  input String varName "Key";
  input String fileName "File name";
  output Real var "Variable value";
protected
  ExternData.Types.ExternJSONFile extObj=
      ExternData.Types.ExternJSONFile(fileName, verboseRead=true)
    "External file object";
algorithm
  var :=ExternData.Functions.JSON.getReal(varName, extObj);
annotation(__Dymola_translate=true);
end getReal;
