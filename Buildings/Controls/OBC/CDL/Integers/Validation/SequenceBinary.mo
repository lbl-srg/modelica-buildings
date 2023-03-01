within Buildings.Controls.OBC.CDL.Integers.Validation;
model SequenceBinary
  "Validation model for the block to find the total number of enabled stages"

  Buildings.Controls.OBC.CDL.Integers.SequenceBinary seqBin(
    final nSta=4,
    final minStaHol=5)
    "Total number of enabled stages"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Integers.SequenceBinary zerHolTim(
    final nSta=4,
    final minStaHol=0)
    "Total number of enabled stages, with zero stage ON-OFF holding time"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Integers.SequenceBinary seqBin1(
    final nSta=4,
    final minStaHol=2)
    "Total number of enabled stages"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Integers.SequenceBinary lesHolTim(
    final nSta=4,
    final minStaHol=1)
    "Total number of enabled stages, with less stage holding time"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    final duration=10,
    final height=1,
    final startTime=1)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=0.5,
    final freqHz=1/5,
    final offset=0.5) "Block that generates sine signal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

equation
  connect(ramp1.y, seqBin.u)
    annotation (Line(points={{-18,60},{18,60}}, color={0,0,127}));
  connect(ramp1.y,zerHolTim. u) annotation (Line(points={{-18,60},{0,60},{0,20},
          {18,20}}, color={0,0,127}));
  connect(sin.y,seqBin1. u)
    annotation (Line(points={{-18,-20},{18,-20}}, color={0,0,127}));
  connect(sin.y, lesHolTim.u) annotation (Line(points={{-18,-20},{0,-20},{0,-60},
          {18,-60}}, color={0,0,127}));
  annotation (
    experiment(StopTime=10.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/SequenceBinary.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.SequenceBinary\">
Buildings.Controls.OBC.CDL.Integers.SequenceBinary</a>.
</p>
<p>
It shows the results for different settings of the stage holding parameter.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 12, 2022, by Jianjun Hu:<br/>
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
end SequenceBinary;
