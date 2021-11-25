within Buildings.Templates.Validation;
model ExternDataEvaluation
  extends Modelica.Icons.Example;

  Real p(nominal=dat.getReal(varName="set1.gain.k")) = 1;

  parameter ExternData.JSONFile dat(
    fileName=Modelica.Utilities.Files.loadResource("modelica://ExternData/Resources/Examples/test.json"));

end ExternDataEvaluation;
