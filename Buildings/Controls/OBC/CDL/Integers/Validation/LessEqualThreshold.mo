within Buildings.Controls.OBC.CDL.Integers.Validation;
model LessEqualThreshold  "Validation model for the LessEqualThreshold block"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Continuous.Truncation truncation1
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=10.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(
    threshold=2)
    "Block output true if input is less or equal to threshold value"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(ramp1.y, truncation1.u)
    annotation (Line(points={{-39,0},{-22,0}}, color={0,0,127}));
  connect(truncation1.y,intLesEquThr. u)
    annotation (Line(points={{1,0},{38,0}}, color={255,127,0}));

annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/LessEqualThreshold.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold\">
Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end LessEqualThreshold;
