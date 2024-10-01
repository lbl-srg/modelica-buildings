within Buildings.Fluid.Storage.Ice_ntu_ini.BaseClasses.Tests;
model Tank
  extends Modelica.Icons.Example;
  Buildings.Fluid.Storage.Ice_ntu_ini.BaseClasses.Tank tank(redeclare
      Buildings.Fluid.Storage.Ice_ntu_ini.Data.Tank.Experiment per)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=273.15 - 5,
    startTime=100000)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Constant const1(k=5)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation
  connect(step.y, tank.Tin) annotation (Line(points={{-59,30},{-40,30},{-40,15},
          {-22,15}}, color={0,0,127}));
  connect(const1.y, tank.m_flow) annotation (Line(points={{-59,-10},{-40,-10},{
          -40,7},{-22,7}}, color={0,0,127}));
end Tank;
