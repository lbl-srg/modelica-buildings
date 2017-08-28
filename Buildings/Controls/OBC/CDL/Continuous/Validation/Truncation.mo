within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Truncation "Validation model for the Truncation block"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Continuous.Truncation truncation1
    "Block that discards the fractional portion of the input and outputs its integer value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(ramp1.y, truncation1.u)
    annotation (Line(points={{-39,0},{-12,0}},         color={0,0,127}));
  annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/Truncation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Trunction\">
Buildings.Controls.OBC.CDL.Continuous.Truncation</a>.
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
