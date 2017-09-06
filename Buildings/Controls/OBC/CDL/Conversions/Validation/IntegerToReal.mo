within Buildings.Controls.OBC.CDL.Conversions.Validation;
model IntegerToReal "Validation model for the IntegerToReal block"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Block that convert Integer to Real signal"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Truncation truncation
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(ramp1.y, truncation.u)
    annotation (Line(points={{-39,0},{-12,0},{-12,0}}, color={0,0,127}));
  connect(truncation.y, intToRea.u)
    annotation (Line(points={{11,0},{19.5,0},{28,0}}, color={255,127,0}));

  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Conversions/Validation/IntegerToReal.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Conversions.IntegerToReal\">
Buildings.Controls.OBC.CDL.Conversions.IntegerToReal</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 31, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end IntegerToReal;
