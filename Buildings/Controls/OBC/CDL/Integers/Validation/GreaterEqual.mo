within Buildings.Controls.OBC.CDL.Integers.Validation;
model GreaterEqual "Validation model for the GreaterEqual block"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Continuous.Truncation truncation1
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=10.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Truncation truncation2
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=1,
    offset=-1.5,
    height=5.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqual intGreEqu
    "Block output true if input 1 is greater or equal to input 2"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(ramp1.y, truncation1.u)
    annotation (Line(points={{-39,20},{-22,20}},  color={0,0,127}));
  connect(ramp2.y, truncation2.u)
    annotation (Line(points={{-39,-20},{-22,-20}}, color={0,0,127}));
  connect(truncation1.y, intGreEqu.u1)
    annotation (Line(points={{1,20},{20,20},{20,0},{38,0}}, color={255,127,0}));
  connect(truncation2.y, intGreEqu.u2)
    annotation (Line(points={{1,-20},{20,-20},{20,-8},{38,-8}}, color={255,127,0}));

annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/GreaterEqual.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.GreaterEqual\">
Buildings.Controls.OBC.CDL.Integers.GreaterEqual</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end GreaterEqual;
