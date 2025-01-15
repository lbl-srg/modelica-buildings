within Buildings.Controls.OBC.CDL.Integers.Validation;
model GreaterEqualThreshold
  "Validation model for the GreaterEqualThreshold block"
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=10.0)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(
    t=2)
    "Block output true if input is greater or equal to threshold value"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Round round1(
    n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(ramp1.y,round1.u)
    annotation (Line(points={{-59,0},{-42,0}},color={0,0,127}));
  connect(round1.y,reaToInt.u)
    annotation (Line(points={{-19,0},{-2,0}},color={0,0,127}));
  connect(reaToInt.y,intGreEquThr.u)
    annotation (Line(points={{21,0},{38,0}},color={255,127,0}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/GreaterEqualThreshold.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold\">
Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
August 30, 2017, by Jianjun Hu:<br/>
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
end GreaterEqualThreshold;
