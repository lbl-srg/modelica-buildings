within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model DoubleSwitch "Double switch"

  Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch douSwi
    "Double switch"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin1(
    amplitude=1,
    freqHz=1/30,
    offset=5)
    "Sine wave for input variable 1"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin3(
    amplitude=2,
    freqHz=1/15,
    offset=-5)
    "Sine wave for input variable 3"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse pul2(
    period=60)
    "A pulse signal for input variable 2"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(pul2.y, douSwi.u2)
    annotation (Line(points={{-38,10},{18,10}}, color={255,0,255}));
  connect(sin1.y, douSwi.u1)
    annotation (Line(points={{-38,50},{0,50},{0,16},{18,16}}, color={0,0,127}));
  connect(sin3.y, douSwi.u3)
    annotation (Line(points={{-38,-30},{0,-30},{0,4},{18,4}}, color={0,0,127}));
annotation (experiment(StopTime=60, Interval=1, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/SetpointResolution.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch\">
Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})));
end DoubleSwitch;
