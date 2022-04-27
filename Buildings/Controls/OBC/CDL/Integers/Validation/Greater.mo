within Buildings.Controls.OBC.CDL.Integers.Validation;
model Greater
  "Validation model for the Greater block"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=10,
    offset=-1.5,
    height=5.0)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Greater intGre
    "Block output true if input 1 is greater than input 2"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
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
  Buildings.Controls.OBC.CDL.Integers.Greater intGre1(final h=1)
    "Block output true if input 1 is greater than input 2"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable ram(
    final table=[0,-3.5; 2,-2; 3,5; 6,5; 8,-2; 10,-3.5])
    "Ramp signal"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
equation
  connect(ramp2.y,round2.u)
    annotation (Line(points={{-58,-20},{-42,-20}},color={0,0,127}));
  connect(round1.y,reaToInt.u)
    annotation (Line(points={{-18,20},{-2,20}},color={0,0,127}));
  connect(round2.y,reaToInt1.u)
    annotation (Line(points={{-18,-20},{-2,-20}},color={0,0,127}));
  connect(reaToInt.y,intGre.u1)
    annotation (Line(points={{22,20},{58,20}}, color={255,127,0}));
  connect(reaToInt1.y,intGre.u2)
    annotation (Line(points={{22,-20},{40,-20},{40,12},{58,12}},color={255,127,0}));
  connect(reaToInt1.y, intGre1.u2)
    annotation (Line(points={{22,-20},{40,-20},{40,-28},{58,-28}}, color={255,127,0}));
  connect(reaToInt.y, intGre1.u1)
    annotation (Line(points={{22,20},{48,20},{48,-20},{58,-20}}, color={255,127,0}));
  connect(ram.y[1], round1.u)
    annotation (Line(points={{-58,20},{-42,20}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=10.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/Greater.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.Greater\">
Buildings.Controls.OBC.CDL.Integers.Greater</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 27, 2022, by Jianjun Hu:<br/>
Added hysteresis.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2978\">issue 2978</a>.
</li>
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
end Greater;
