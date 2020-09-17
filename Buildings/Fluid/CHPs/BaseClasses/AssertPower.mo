within Buildings.Fluid.CHPs.BaseClasses;
model AssertPower "Assert if electric power is outside boundaries"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Power PEleMax
    "Maximum power output";
  parameter Modelica.SIunits.Power PEleMin
    "Minimum power output";
  parameter Boolean use_powerRateLimit
    "If true, the rate at which net power output can change is limited";
  parameter Real dPEleMax(final unit="W/s")
    "Maximum rate at which net power output can change";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEleDem(
    final unit="W")
    "Electric power demand"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesP(
    final message="Electric power is outside boundaries!")
    "Generate warning when the electric power demand is out of the range"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesDP(
    final message="Rate of change in power output is outside boundaries!") if use_powerRateLimit
    "Assert function for checking power rate"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Nor nor
    "Check if the electric power demand is out of the power production range"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 if use_powerRateLimit "Logical Nand"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Blocks.Continuous.Derivative demRat(
    final initType=Modelica.Blocks.Types.Init.InitialOutput) if use_powerRateLimit
    "Power demand rate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1 if use_powerRateLimit "Absolute value"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold maxRat(final t=
        dPEleMax) if use_powerRateLimit
    "Check if demand rate is more than the maximum rate"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis maxPow(
    final uLow=0.99*PEleMax,
    final uHigh=1.01*PEleMax + 1e-6)
    "Check if the electric power demand is more than the maximum power production"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis minPow(
    final uLow=0.99*PEleMin - 1e-6,
    final uHigh=1.01*PEleMin)
    "Check if the electric power demand is larger than the minimum power production"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Check if the electric power demand is less than the minimum power production"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(abs1.u, demRat.y) annotation (Line(points={{-42,-40},{-59,-40}},
          color={0,0,127}));
  connect(maxRat.u, abs1.y) annotation (Line(points={{-2,-40},{-18,-40}},
          color={0,0,127}));
  connect(demRat.u, PEleDem) annotation (Line(points={{-82,-40},{-90,-40},{-90,0},
          {-120,0}}, color={0,0,127}));
  connect(nor.y, assMesP.u) annotation (Line(points={{62,20},{68,20}},
          color={255,0,255}));
  connect(not2.y, assMesDP.u) annotation (Line(points={{62,-40},{68,-40}},
          color={255,0,255}));
  connect(PEleDem, maxPow.u) annotation (Line(points={{-120,0},{-90,0},{-90,40},
          {-42,40}}, color={0,0,127}));
  connect(maxPow.y, nor.u1) annotation (Line(points={{-18,40},{0,40},{0,20},{38,
          20}}, color={255,0,255}));
  connect(PEleDem, minPow.u) annotation (Line(points={{-120,0},{-82,0}},
          color={0,0,127}));
  connect(minPow.y, not1.u) annotation (Line(points={{-58,0},{-42,0}},
          color={255,0,255}));
  connect(not1.y, nor.u2) annotation (Line(points={{-18,0},{0,0},{0,12},{38,12}},
          color={255,0,255}));
  connect(maxRat.y, not2.u)
    annotation (Line(points={{22,-40},{38,-40}}, color={255,0,255}));

annotation (
  defaultComponentName="assPow",
  Diagram(coordinateSystem(extent={{-100,-80},{100,80}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),   graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,80},{-80,-60},{80,-60},{0,80}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{0,72},{-72,-56},{72,-56},{0,72}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,38},{2,-24}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-6,-32},{4,-42}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
<p>
The model sends a warning message if the power demand is outside the boundaries defined by the manufacturer.
Limits can be specified for the minimal and maximal electric power, and for the maximum rate at
which the power can change.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end AssertPower;
