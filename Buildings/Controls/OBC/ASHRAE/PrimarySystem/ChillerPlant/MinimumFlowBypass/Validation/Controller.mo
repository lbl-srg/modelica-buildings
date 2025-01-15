within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Validation;
model Controller "Validate control of minimum bypass valve"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller
    minBypValCon(
    nChi=3,
    minFloSet={0.005,0.005,0.005})
    "Minimum bypass valve position"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse chiFloSet(
    amplitude=-0.005,
    period=3,
    offset=0.015)
    "Minimum flow setpoint"
    annotation (Placement(transformation(extent={{-80,-82},{-60,-60}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiWatPum(
    width=0.15,
    period=4,
    shift=0.1)
    "Chilled water pump on command"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    amplitude=0.0025,
    freqHz=1/2,
    offset=0.005)
    "Output sine wave value"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram(
    height=0.015,
    duration=2,
    startTime=1.2)
    "Output ramp value"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    "Measured minimum bypass flow rate"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

equation
  connect(chiWatPum.y, not4.u)
    annotation (Line(points={{-58,60},{-42,60}}, color={255,0,255}));
  connect(not4.y, minBypValCon.uChiWatPum)
    annotation (Line(points={{-18,60},{20,60},{20,8},{38,8}},
      color={255,0,255}));
  connect(sin.y, add2.u1)
    annotation (Line(points={{-58,20},{-40,20},{-40,6},{-22,6}},
      color={0,0,127}));
  connect(ram.y, add2.u2)
    annotation (Line(points={{-58,-20},{-40,-20},{-40,-6},{-22,-6}},
      color={0,0,127}));
  connect(add2.y, minBypValCon.VChiWat_flow)
    annotation (Line(points={{2,0},{38,0}},
      color={0,0,127}));
  connect(chiFloSet.y, minBypValCon.VChiWatSet_flow)
    annotation (Line(points={{-58,-71},{20,-71},{20,-8},{38,-8}}, color={0,0,127}));

annotation (
 experiment(StopTime=4.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/MinimumFlowBypass/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller</a>.
It demonstrates the bypass valve control to maintain the minimum
chilled water flow through the chillers.
</p>
<ul>
<li>
From 0.1 seconds to 0.7 seconds, there is no chilled water pump proven on
(<code>uChiWatPum=false</code>). Thus the bypass valve position setpoint
is 1.
</li>
<li>
From 0.7 seconds to the end, there is chilled water pump proven on.
When the measured chilled water flow is less than the setpoint, the
bypass valve position setpoint is 1. After the measured chilled water
flow is greater than the setpoint, the bypass valve setpoint gradually
decreases.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Controller;
