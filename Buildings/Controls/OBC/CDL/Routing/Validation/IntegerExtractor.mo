within Buildings.Controls.OBC.CDL.Routing.Validation;
model IntegerExtractor
  "Validation model for the integer extractor block"
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndIntSig(
    final nin=4)
    "Block that extracts signal from an input signal vector"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndIntSig1(
    final nin=4)
    "Block that extracts signal from an input signal vector"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=1)
    "Block that outputs integer constant"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=4)
    "Block that outputs integer constant"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul(
    final amplitude=1,
    final period=0.2) "Generate pulse signal of type Integer"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul1(
    final period=0.3,
    final amplitude=2,
    final offset=-1)   "Generate pulse signal of type Integer"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=6)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

equation
  connect(conInt1.y, extIndIntSig1.index)
    annotation (Line(points={{42,-80},{50,-80},{50,-42}}, color={255,127,0}));
  connect(conInt2.y, extIndIntSig.u[1]) annotation (Line(points={{-58,80},{-40,80},
          {-40,79.25},{38,79.25}}, color={255,127,0}));
  connect(intPul.y, extIndIntSig.u[2]) annotation (Line(points={{-58,40},{-30,40},
          {-30,79.75},{38,79.75}}, color={255,127,0}));
  connect(intPul1.y, extIndIntSig.u[3]) annotation (Line(points={{-58,0},{-20,0},
          {-20,80.25},{38,80.25}}, color={255,127,0}));
  connect(conInt3.y, extIndIntSig.u[4]) annotation (Line(points={{-58,-40},{-10,
          -40},{-10,80.75},{38,80.75}}, color={255,127,0}));
  connect(conInt2.y, extIndIntSig1.u[1]) annotation (Line(points={{-58,80},{-40,
          80},{-40,-30.75},{38,-30.75}}, color={255,127,0}));
  connect(intPul.y, extIndIntSig1.u[2]) annotation (Line(points={{-58,40},{-30,40},
          {-30,-30.25},{38,-30.25}}, color={255,127,0}));
  connect(intPul1.y, extIndIntSig1.u[3]) annotation (Line(points={{-58,0},{-20,0},
          {-20,-29.75},{38,-29.75}}, color={255,127,0}));
  connect(conInt3.y, extIndIntSig1.u[4]) annotation (Line(points={{-58,-40},{-10,
          -40},{-10,-29.25},{38,-29.25}}, color={255,127,0}));
  connect(conInt.y, extIndIntSig.index)
    annotation (Line(points={{42,30},{50,30},{50,68}}, color={255,127,0}));
annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/IntegerExtractor.mos" "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.IntegerExtractor\">
Buildings.Controls.OBC.CDL.Routing.IntegerExtractor</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 5, by Jianjun Hu:<br/>
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
end IntegerExtractor;
