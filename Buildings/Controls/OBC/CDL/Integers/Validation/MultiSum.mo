within Buildings.Controls.OBC.CDL.Integers.Validation;
model MultiSum
  "Validation model for the block to find sum of multiple inputs"
  Buildings.Controls.OBC.CDL.Integers.MultiSum add1(
    nin=3)
    "Block that outputs the sum of the inputs"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=1,
    offset=-0.5,
    height=7.0)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp3(
    duration=1,
    height=7.0,
    offset=-1.5)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(
    n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(
    n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round3(
    n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

equation
  connect(ramp1.y,round1.u)
    annotation (Line(points={{-59,40},{-42,40}},color={0,0,127}));
  connect(ramp2.y,round2.u)
    annotation (Line(points={{-59,0},{-42,0}},color={0,0,127}));
  connect(ramp3.y,round3.u)
    annotation (Line(points={{-59,-40},{-42,-40}},color={0,0,127}));
  connect(round3.y,reaToInt2.u)
    annotation (Line(points={{-19,-40},{-2,-40}},color={0,0,127}));
  connect(round2.y,reaToInt1.u)
    annotation (Line(points={{-19,0},{-2,0}},color={0,0,127}));
  connect(round1.y,reaToInt.u)
    annotation (Line(points={{-19,40},{-2,40}},color={0,0,127}));
  connect(reaToInt.y,add1.u[1])
    annotation (Line(points={{21,40},{40,40},{40,4.66667},{58,4.66667}},color={255,127,0}));
  connect(reaToInt1.y,add1.u[2])
    annotation (Line(points={{21,0},{38,0},{38,0},{58,0}},color={255,127,0}));
  connect(reaToInt2.y,add1.u[3])
    annotation (Line(points={{21,-40},{40,-40},{40,-4.66667},{58,-4.66667}},color={255,127,0}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/MultiSum.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.MultiSum\">
Buildings.Controls.OBC.CDL.Integers.MultiSum</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 14, 2017, by Jianjun Hu:<br/>
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
end MultiSum;
