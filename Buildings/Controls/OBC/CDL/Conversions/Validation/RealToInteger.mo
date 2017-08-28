within Buildings.Controls.OBC.CDL.Conversions.Validation;
model RealToInteger "Validation model for the RealToInteger block"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Block that converts Real to Integer signal"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(ramp1.y, reaToInt.u)
    annotation (Line(points={{-39,0},{28,0}},        color={0,0,127}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Conversions/Validation/RealToInteger.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Conversions.RealToInteger\">
Buildings.Controls.OBC.CDL.Conversions.RealToInteger</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 31, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end RealToInteger;
