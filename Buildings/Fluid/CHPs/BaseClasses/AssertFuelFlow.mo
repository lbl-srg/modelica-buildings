within Buildings.Fluid.CHPs.BaseClasses;
model AssertFuelFlow "Assert whether fuel flow is within boundary"
  extends Modelica.Blocks.Icons.Block;

  parameter Real dmFueMax_flow(final unit="kg/s2")
    "Maximum rate at which fuel mass flow rate can change";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mFue_flow(
    final unit="kg/s") "Fuel mass flow rate"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Rate of change in the fuel mass flow rate is outside boundaries!")
    "Assert function for checking fuel flow rate"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Check if fuel flow rate is changing slowly"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=0.99*dmFueMax_flow,
    final uHigh=1.01*dmFueMax_flow + 1e-6)
    "Check if fuel mass flow rate is changing too much"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Continuous.Derivative floChaRat(
    final initType=Modelica.Blocks.Types.Init.InitialOutput)
    "Rate at which fuel mass flow rate changes"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1 "Absolute value"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(abs1.u, floChaRat.y)
    annotation (Line(points={{-42,0},{-59,0}}, color={0,0,127}));
  connect(floChaRat.u, mFue_flow)
    annotation (Line(points={{-82,0},{-120,0}}, color={0,0,127}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{62,0},{68,0}}, color={255,0,255}));
  connect(abs1.y, hys.u)
    annotation (Line(points={{-18,0},{-2,0}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{22,0},{38,0}}, color={255,0,255}));

annotation (
  defaultComponentName="assFue",
  Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
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
The model sends a warning message if the rate at which the fuel mass flow rate changes
is outside the boundaries defined by the manufacturer.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end AssertFuelFlow;
