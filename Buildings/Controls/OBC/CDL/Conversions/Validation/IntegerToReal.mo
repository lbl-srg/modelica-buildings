within Buildings.Controls.OBC.CDL.Conversions.Validation;
model IntegerToReal
  "Validation model for the IntegerToReal block"
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Block that converts Integer to Real signal"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Round round2(
    n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(ramp1.y,round2.u)
    annotation (Line(points={{-58,0},{-42,0}},color={0,0,127}));
  connect(round2.y,reaToInt1.u)
    annotation (Line(points={{-18,0},{-2,0}},color={0,0,127}));
  connect(reaToInt1.y,intToRea.u)
    annotation (Line(points={{22,0},{28,0},{28,0},{38,0}},color={255,127,0}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Conversions/Validation/IntegerToReal.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Conversions.IntegerToReal\">
Buildings.Controls.OBC.CDL.Conversions.IntegerToReal</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 31, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end IntegerToReal;
