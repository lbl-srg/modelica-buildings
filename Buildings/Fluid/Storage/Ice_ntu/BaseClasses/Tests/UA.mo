within Buildings.Fluid.Storage.Ice_ntu.BaseClasses.Tests;
model UA "Test UAmodel"
extends Modelica.Icons.Example;
  Buildings.Fluid.Storage.Ice_ntu.BaseClasses.UA uA
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant const1(k=0.5)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=273.15 - 5,
    startTime=0.5)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
equation
  connect(const1.y, uA.SOC) annotation (Line(points={{-79,-10},{-44,-10},{-44,
          -4},{-12,-4},{-12,-5}}, color={0,0,127}));
  connect(step.y, uA.Tin) annotation (Line(points={{-79,30},{-20,30},{-20,5},{
          -12,5}}, color={0,0,127}));
end UA;
