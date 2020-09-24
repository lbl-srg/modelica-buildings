within Buildings.Controls.OBC.FDE.DOAS.Validation;
model Dewpoint "This model simulates Dewpoint calculations."
  Buildings.Controls.OBC.FDE.DOAS.Dewpoint Dewpt
    annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Sine                        ralHumGen(
    amplitude=10,
    freqHz=1/3600,
    offset=60,
    startTime=0)
      annotation (Placement(transformation(extent={{-48,8},{-28,28}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Sine raTGen(
    amplitude=3,
    freqHz=1/4800,
    phase=0.78539816339745,
    offset=295,
    startTime=0)
    annotation (Placement(transformation(extent={{-48,-30},{-28,-10}})));
equation
  connect(ralHumGen.y, Dewpt.relHum) annotation (Line(points={{-26,18},{-16,18},
          {-16,6},{-6.2,6}}, color={0,0,127}));
  connect(raTGen.y, Dewpt.dbT) annotation (Line(points={{-26,-20},{-16,-20},{-16,
          -6},{-6.2,-6}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
September 16, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.DOAS.Dewpoint\">
Buildings.Controls.OBC.FDE.DOAS.Dewpoint</a>.
</p>
</html>"));
end Dewpoint;
