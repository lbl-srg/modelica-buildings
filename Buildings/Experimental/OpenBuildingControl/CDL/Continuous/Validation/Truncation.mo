within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model Truncation "Validation model for the Truncation block"

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Truncation trunc1
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(ramp1.y, trunc1.u)
    annotation (Line(points={{-39,0},{-12,0}},         color={0,0,127}));
  annotation (
experiment(StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/Truncation.mos"
        "Simulate and plot"),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}}),
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Trunction\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Truncation</a>.
</p>
<p>
The input <code>u</code> varies from <i>-3.5</i> to <i>+3.5</i>. 
</p>
</html>", revisions="<html>
<ul>
<li>
March 24, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Truncation;
