within Buildings.Fluid.Storage.Ice.Examples.BaseClasses.Validation;
model TestControlModes "Example model to test control modes"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
    property_T=293.15,
    X_a=0.30) "Fluid medium";

  parameter Modelica.Units.SI.Mass SOC_start=3/4
    "Start value of ice mass in the tank";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=100000
    "Pressure difference";

  ControlEfficiencyMode controlEfficiencyMode
    annotation (Placement(transformation(extent={{40,40},{88,90}})));
  ControlLowPowerMode controlLowPowerMode
    annotation (Placement(transformation(extent={{40,-20},{88,30}})));
  ControlHighPowerMode controlHighPowerMode
    annotation (Placement(transformation(extent={{40,-90},{88,-40}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=0.5,
    f=1/3600,
    offset=0.5)
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Normal))
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Sources.IntegerConstant integerConstant1(k=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.None))
    annotation (Placement(transformation(extent={{-100,-38},{-80,-18}})));
  Modelica.Blocks.Sources.IntegerConstant integerConstant2(k=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Elevated))
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Controls.OBC.CDL.Integers.Switch intSwi
    annotation (Placement(transformation(extent={{-42,30},{-22,50}})));
  Controls.OBC.CDL.Integers.Switch intSwi1
    annotation (Placement(transformation(extent={{-8,60},{12,80}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    width=1/3,
    period=5400,
    shift=3600)
    annotation (Placement(transformation(extent={{-58,60},{-38,80}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    width=1/3,
    period=5400,
    shift=1800)
    annotation (Placement(transformation(extent={{-102,30},{-82,50}})));
equation
  connect(sine.y, controlHighPowerMode.SOC) annotation (Line(points={{-79,-70},
          {-48,-70},{-48,-69.8},{38.2,-69.8}}, color={0,0,127}));
  connect(sine.y, controlLowPowerMode.SOC) annotation (Line(points={{-79,-70},{
          -48,-70},{-48,-66},{24,-66},{24,-4},{37.8,-4},{37.8,1.6}}, color={0,0,
          127}));
  connect(intSwi.y, intSwi1.u3) annotation (Line(points={{-20,40},{-16,40},{-16,
          62},{-10,62}}, color={255,127,0}));
  connect(integerConstant2.y, intSwi1.u1) annotation (Line(points={{-79,90},{
          -18,90},{-18,78},{-10,78}}, color={255,127,0}));
  connect(integerConstant.y, intSwi.u1) annotation (Line(points={{-79,10},{-54,
          10},{-54,48},{-44,48}}, color={255,127,0}));
  connect(integerConstant1.y, intSwi.u3) annotation (Line(points={{-79,-28},{
          -46,-28},{-46,32},{-44,32}}, color={255,127,0}));
  connect(intSwi1.y, controlEfficiencyMode.demLev) annotation (Line(points={{14,
          70},{30,70},{30,86},{38,86}}, color={255,127,0}));
  connect(intSwi1.y, controlLowPowerMode.demLev) annotation (Line(points={{14,
          70},{20,70},{20,26},{38,26}}, color={255,127,0}));
  connect(intSwi1.y, controlHighPowerMode.demLev) annotation (Line(points={{14,
          70},{20,70},{20,-44},{38,-44}}, color={255,127,0}));
  connect(booPul.y, intSwi1.u2) annotation (Line(points={{-36,70},{-20,70},{-20,
          68},{-18,68},{-18,70},{-10,70}}, color={255,0,255}));
  connect(booPul1.y, intSwi.u2)
    annotation (Line(points={{-80,40},{-44,40}}, color={255,0,255}));
  annotation (
    experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Examples/Tank.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to check controller modes behaviours for <a href=\"Buildings.Fluid.Storage.Ice.Examples.BaseClasses.ControlClosedLoop\">Buildings.Fluid.Storage.Ice.Examples.BaseClasses.ControlClosedLoop</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TestControlModes;
