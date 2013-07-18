within Buildings.Utilities.IO.Python27.Examples;
model CalBayComm "Example for testing CalBayComm"
  import Buildings;
  extends Modelica.Icons.Example;

  Buildings.Utilities.IO.Python27.CalBayComm pyt(
    functionName="CalBayComm",
    nDblRea=1,
    moduleName="Temp")
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
end CalBayComm;
