within Buildings.Fluid.CHPs.BaseClasses;
model AssertWaterFlow "Assert if water flow is outside boundaries"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.MassFlowRate mWatMin_flow
    "Minimum cooling water mass flow rate";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput runSig
    "True when electricity or heat demand is larger than zero"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mWat_flow(
    final unit="kg/s")
    "Water mass flow rate"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Water flow rate is lower than the minimum!")
    "Assert function for checking water flow rate"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Nand nand "Logical Nand"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=0.99*mWatMin_flow - 1e-6,
    final uHigh=1.01*mWatMin_flow)
    "Check if water flow rate is larger than minimum rate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Check if water flow rate is smaller than minimum rate"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

equation
  connect(hys.u, mWat_flow) annotation (Line(points={{-82,-40},{-120,-40}},
          color={0,0,127}));
  connect(nand.u1, runSig) annotation (Line(points={{18,0},{0,0},{0,40},{-120,40}},
          color={255,0,255}));
  connect(nand.y, assMes.u) annotation (Line(points={{42,0},{58,0}},
          color={255,0,255}));
  connect(nand.u2, not1.y) annotation (Line(points={{18,-8},{0,-8},{0,-40},{-18,
          -40}}, color={255,0,255}));
  connect(not1.u, hys.y) annotation (Line(points={{-42,-40},{-58,-40}},
          color={255,0,255}));

annotation (
  defaultComponentName="assWatMas",
  Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
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
The model sends a warning message if the water mass flow rate is lower than the
minimum defined by the manufacturer.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end AssertWaterFlow;
