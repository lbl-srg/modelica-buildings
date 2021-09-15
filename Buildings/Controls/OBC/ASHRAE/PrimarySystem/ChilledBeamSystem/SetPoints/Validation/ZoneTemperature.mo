within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.SetPoints.Validation;
model ZoneTemperature
  "Validate zone temperature setpoint controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.SetPoints.ZoneTemperature
    TZonSet
    "Zone temperature setpoint controller"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final height=3,
    final duration=90)
    "Ramp input signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(reaToInt.y, TZonSet.uOpeMod)
    annotation (Line(points={{12,0},{18,0}}, color={255,127,0}));

  connect(ram.y, reaToInt.u)
    annotation (Line(points={{-18,0},{-12,0}}, color={0,0,127}));

annotation (
  experiment(
      StopTime=90,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChilledBeamSystem/SetPoints/Validation/ZoneTemperature.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.SetPoints.ZoneTemperature\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.SetPoints.ZoneTemperature</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 9, 2021, by Karthik Devaprasad:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end ZoneTemperature;
