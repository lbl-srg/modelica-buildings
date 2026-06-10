within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SetpointResolution "Setpoint resolution"

  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution setRes(
    resInt=0.5, refSet=293.15)
    "Block for setpoint resolution"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram(
    height=6,
    duration=0.5,
    offset=290.15,
    startTime=0.25)
    "Ramp signal for a temperature setpoint"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(ram.y, setRes.uSet)
    annotation (Line(points={{-38,10},{18,10}}, color={0,0,127}));
annotation (experiment(StopTime=1, Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/SetpointResolution.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointResolution</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 10, 2026, by Weiping Huang:<br/>
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
end SetpointResolution;
