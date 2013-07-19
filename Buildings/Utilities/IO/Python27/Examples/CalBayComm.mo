within Buildings.Utilities.IO.Python27.Examples;
model CalBayComm "Example for testing CalBayComm"
  import Buildings;
  extends Modelica.Icons.Example;

  Buildings.Utilities.IO.Python27.CalBayComm pyt(
    functionName="CalBayComm",
    nDblRea=1,
    moduleName="GeneralCalBayComm",
    Login="P Grant",
    Password="pgrant213",
    Command="GetDAQ:WattStopper.HS1--4126F--Light Level-1",
    samplePeriod=5)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=10)
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
equation
  connect(pyt.yR[1], lessThreshold.u) annotation (Line(
      points={{-59,0},{-48,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lessThreshold.y, booleanToReal.u) annotation (Line(
      points={{-25,0},{-12,0}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end CalBayComm;
