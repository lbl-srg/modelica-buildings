within Buildings.Controls.OBC.CDL.Integers.Validation;
model Add
  "Validation model for the Add block"
  Buildings.Controls.OBC.CDL.Integers.Add add1
    "Block that outputs the sum of the two inputs"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=1,
    offset=-0.5,
    height=7.0)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(
    n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(
    n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

equation
  connect(ramp1.y,round1.u)
    annotation (Line(points={{-58,20},{-42,20}},color={0,0,127}));
  connect(ramp2.y,round2.u)
    annotation (Line(points={{-58,-20},{-42,-20}},color={0,0,127}));
  connect(round2.y,reaToInt1.u)
    annotation (Line(points={{-18,-20},{-2,-20}},color={0,0,127}));
  connect(round1.y,reaToInt.u)
    annotation (Line(points={{-18,20},{-2,20}},color={0,0,127}));
  connect(reaToInt.y,add1.u1)
    annotation (Line(points={{22,20},{40,20},{40,6},{58,6}},color={255,127,0}));
  connect(reaToInt1.y,add1.u2)
    annotation (Line(points={{22,-20},{40,-20},{40,-6},{58,-6}},color={255,127,0}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/Add.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.Add\">
Buildings.Controls.OBC.CDL.Integers.Add</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
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
end Add;
