within Buildings.Fluid.Storage.Ice_ntu.BaseClasses.Tests;
model Tank
  extends Modelica.Icons.Example;
  Buildings.Fluid.Storage.Ice_ntu.BaseClasses.Tank tank(redeclare
      Buildings.Fluid.Storage.Ice_ntu.Data.Tank.Experiment per)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Constant const1(k=2)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Constant const(k=-5 + 273.15)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation
  connect(const1.y, tank.m_flow) annotation (Line(points={{-59,-10},{-40,-10},{
          -40,5},{-22,5}}, color={0,0,127}));
  connect(const.y, tank.Tin) annotation (Line(points={{-59,30},{-40,30},{-40,15},
          {-22,15}}, color={0,0,127}));
  annotation (experiment(
      StopTime=120000,
      Interval=1,
      __Dymola_Algorithm="Dassl"), __Dymola_experimentSetupOutput(events=false));
end Tank;
