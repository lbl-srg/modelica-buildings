within Buildings.Controls.OBC.CDL.Integers.Validation;
model AddParameter "Validation model for the AddParameter block"
  Buildings.Controls.OBC.CDL.Integers.AddParameter addPar(p=5)
    "Block that outputs the sum of an input plus a parameter"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger  reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(ramp1.y,round1.u)
    annotation (Line(points={{-58,0},{-42,0}},  color={0,0,127}));
  connect(round1.y,reaToInt.u)
    annotation (Line(points={{-18,0},{-2,0}},  color={0,0,127}));
  connect(reaToInt.y, addPar.u)
    annotation (Line(points={{22,0},{38,0}}, color={255,127,0}));

annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/AddParameter.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.AddParameter\">
Buildings.Controls.OBC.CDL.Integers.AddParameter</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 3, 2022, by Jianjun Hu:<br/>
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
end AddParameter;
