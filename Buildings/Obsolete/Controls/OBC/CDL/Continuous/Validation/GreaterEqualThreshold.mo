within Buildings.Obsolete.Controls.OBC.CDL.Continuous.Validation;
model GreaterEqualThreshold  "Validation model for the GreaterEqualThreshold block"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=1,
    offset=-1,
    height=2) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-26,-8},{-6,12}})));

  Buildings.Obsolete.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr
    "Check if the input is greater than or equal to the threshold"
    annotation (Placement(transformation(extent={{26,-8},{46,12}})));

equation
  connect(ramp2.y, greEquThr.u)
    annotation (Line(points={{-4,2},{-4,2},{24,2}},color={0,0,127}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/CDL/Continuous/Validation/GreaterEqualThreshold.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Continuous.GreaterEqualThreshold\">
Buildings.Obsolete.Controls.OBC.CDL.Continuous.GreaterEqualThreshold</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end GreaterEqualThreshold;
