within Buildings.Templates.Validation;
package ExternDataEvaluation
  model TestModel
    extends Modelica.Icons.Example;
    parameter String fileName = Modelica.Utilities.Files.loadResource(
      "modelica://ExternData/Resources/Examples/test.json");
    parameter ExternData.JSONFile dat(fileName=fileName);
    parameter Real p_nominal = dat.getReal(varName="set1.gain.k")
      annotation(Evaluate=true);
    parameter Real q_nominal = loadAndGetReal(varName="set1.gain.k", fileName=fileName)
      annotation(Evaluate=true);
    parameter Real r_nominal = getReal(varName="set1.gain.k", json=dat.json)
      annotation(Evaluate=true);
    Real p(nominal=p_nominal) = 1;
    Real q(nominal=q_nominal) = 1;
    Real r(nominal=r_nominal) = 1;
  end TestModel;
  /* 
  Function loadAndGetReal not supported by OCT despite
  https://specification.modelica.org/maint/3.5/functions.html#external-objects
  "External objects may be a protected component (or part of one) in a function."
  And potentially memory-greedy as it loads the external file at each function call.
  */
  function loadAndGetReal
   input String varName "Key";
   input String fileName;
   output Real var "Variable value";
  protected
   ExternData.Types.ExternJSONFile extObj = ExternData.Types.ExternJSONFile(fileName)
     "External file object";
  algorithm
   var := ExternData.Functions.JSON.getReal(varName, extObj);
  annotation(__Dymola_translate=true);
  end loadAndGetReal;
  /* 
  Function getReal supported by OCT but does not trigger evaluation at compile 
  time with Dymola.
  */
  function getReal
    input String varName "Key";
    input ExternData.Types.ExternJSONFile json;
    output Real var "Variable value";
  algorithm
    var := ExternData.Functions.JSON.getReal(varName, json);
  annotation(__Dymola_translate=true);
  end getReal;
end ExternDataEvaluation;
