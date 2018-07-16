within Buildings.Controls.OBC.CDL.Integers.Validation;
model Change "Validation model for the Change block"
  Buildings.Controls.OBC.CDL.Integers.Change cha
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    offset=0,
    height=20,
    duration=1) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triggeredSampler
    "Triggered sampler"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabLin(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[0,-1;0.3,0.5; 0.5,0; 0.7,1; 1,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(ramp2.y, triggeredSampler.u)
    annotation (Line(points={{41,50},{58,50}}, color={0,0,127}));
  connect(cha.y, triggeredSampler.trigger)
    annotation (Line(points={{41,0},{70,0},{70,38.2}}, color={255,0,255}));
  connect(timTabLin.y[1], reaToInt.u)
    annotation (Line(points={{-39,0},{-22,0}}, color={0,0,127}));
  connect(reaToInt.y, cha.u)
    annotation (Line(points={{1,0},{18,0}}, color={255,127,0}));

annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/Change.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.Change\">
Buildings.Controls.OBC.CDL.Integers.Change</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 13, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
Diagram(coordinateSystem(preserveAspectRatio=false)));
end Change;
