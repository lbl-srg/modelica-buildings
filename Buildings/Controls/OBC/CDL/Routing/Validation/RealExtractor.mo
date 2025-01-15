within Buildings.Controls.OBC.CDL.Routing.Validation;
model RealExtractor
  "Validation model for the extractor block"
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=5) "Extracts signal from an input signal vector"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig1(
    final nin=5)
    "Extracts signal from an input signal vector when the extract index is out of the upper range"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig2(
    final nin=5)
    "Extracts signal from an input signal vector when the extract index is out of the lower range"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig3(
    final nin=5)
    "Extracts signal from an input signal vector when the extract index changes from within range to out of range"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig4(
    final nin=5)
    "Extracts signal from an input signal vector when the extract index changes from out of range to within range"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram(
    final height=5,
    final duration=1,
    final offset=-2)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram1(
    final duration=1,
    final height=4,
    final offset=-1)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram2(
    final duration=1,
    final height=3,
    final offset=-2)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul(
    final amplitude=0.5,
    final period=0.2)
    "Generate pulse signal of type Real"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul1(
    final period=0.2,
    final amplitude=1.5,
    final offset=-0.2)
    "Generate pulse signal of type Real"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(k=6)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(k=0)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul(
    final amplitude=3,
    final period=1,
    final offset=-1)
    "Generate pulse signal of type Integer"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul1(
    final amplitude=-3,
    final period=1,
    final offset=3)
    "Generate pulse signal of type Integer"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
equation
  connect(ram.y,extIndSig.u[1])
    annotation (Line(points={{-58,80},{-40,80},{-40,89.2},{38,89.2}}, color={0,0,127}));
  connect(pul.y,extIndSig.u[2])
    annotation (Line(points={{-58,50},{-34,50},{-34,89.6},{38,89.6}}, color={0,0,127}));
  connect(pul1.y,extIndSig.u[3])
    annotation (Line(points={{-58,20},{-28,20},{-28,90},{38,90}},color={0,0,127}));
  connect(ram1.y,extIndSig.u[4])
    annotation (Line(points={{-58,-10},{-22,-10},{-22,90.4},{38,90.4}}, color={0,0,127}));
  connect(ram2.y,extIndSig.u[5])
    annotation (Line(points={{-58,-40},{-16,-40},{-16,90.8},{38,90.8}}, color={0,0,127}));
  connect(conInt.y,extIndSig.index)
    annotation (Line(points={{22,70},{50,70},{50,78}},color={255,127,0}));
  connect(conInt1.y,extIndSig1.index)
    annotation (Line(points={{22,30},{50,30},{50,38}},   color={255,127,0}));
  connect(ram.y,extIndSig1.u[1])
    annotation (Line(points={{-58,80},{-40,80},{-40,49.2},{38,49.2}}, color={0,0,127}));
  connect(pul.y,extIndSig1.u[2])
    annotation (Line(points={{-58,50},{-34,50},{-34,49.6},{38,49.6}}, color={0,0,127}));
  connect(pul1.y,extIndSig1.u[3])
    annotation (Line(points={{-58,20},{-28,20},{-28,50},{38,50}},  color={0,0,127}));
  connect(ram1.y,extIndSig1.u[4])
    annotation (Line(points={{-58,-10},{-22,-10},{-22,50.4},{38,50.4}}, color={0,0,127}));
  connect(ram2.y,extIndSig1.u[5])
    annotation (Line(points={{-58,-40},{-16,-40},{-16,50.8},{38,50.8}},color={0,0,127}));
  connect(conInt2.y, extIndSig2.index)
    annotation (Line(points={{22,-10},{50,-10},{50,-2}}, color={255,127,0}));
  connect(ram.y, extIndSig2.u[1]) annotation (Line(points={{-58,80},{-40,80},{-40,
          9.2},{38,9.2}}, color={0,0,127}));
  connect(pul.y, extIndSig2.u[2]) annotation (Line(points={{-58,50},{-34,50},{-34,
          9.6},{38,9.6}}, color={0,0,127}));
  connect(pul1.y, extIndSig2.u[3]) annotation (Line(points={{-58,20},{-28,20},{-28,
          10},{38,10}}, color={0,0,127}));
  connect(ram1.y, extIndSig2.u[4]) annotation (Line(points={{-58,-10},{-22,-10},
          {-22,10.4},{38,10.4}}, color={0,0,127}));
  connect(ram2.y, extIndSig2.u[5]) annotation (Line(points={{-58,-40},{-16,-40},
          {-16,10.8},{38,10.8}}, color={0,0,127}));
  connect(ram.y, extIndSig3.u[1]) annotation (Line(points={{-58,80},{-40,80},{-40,
          -30.8},{38,-30.8}}, color={0,0,127}));
  connect(pul.y, extIndSig3.u[2]) annotation (Line(points={{-58,50},{-34,50},{-34,
          -30.4},{38,-30.4}}, color={0,0,127}));
  connect(pul1.y, extIndSig3.u[3]) annotation (Line(points={{-58,20},{-28,20},{-28,
          -30},{38,-30}}, color={0,0,127}));
  connect(ram1.y, extIndSig3.u[4]) annotation (Line(points={{-58,-10},{-22,-10},
          {-22,-29.6},{38,-29.6}}, color={0,0,127}));
  connect(ram2.y, extIndSig3.u[5]) annotation (Line(points={{-58,-40},{-16,-40},
          {-16,-29.2},{38,-29.2}}, color={0,0,127}));
  connect(ram.y, extIndSig4.u[1]) annotation (Line(points={{-58,80},{-40,80},{-40,
          -70.8},{38,-70.8}}, color={0,0,127}));
  connect(pul.y, extIndSig4.u[2]) annotation (Line(points={{-58,50},{-34,50},{-34,
          -70.4},{38,-70.4}}, color={0,0,127}));
  connect(pul1.y, extIndSig4.u[3]) annotation (Line(points={{-58,20},{-28,20},{-28,
          -70},{38,-70}}, color={0,0,127}));
  connect(ram1.y, extIndSig4.u[4]) annotation (Line(points={{-58,-10},{-22,-10},
          {-22,-69.6},{38,-69.6}}, color={0,0,127}));
  connect(ram2.y, extIndSig4.u[5]) annotation (Line(points={{-58,-40},{-16,-40},
          {-16,-69.2},{38,-69.2}}, color={0,0,127}));
  connect(intPul.y, extIndSig3.index)
    annotation (Line(points={{22,-50},{50,-50},{50,-42}}, color={255,127,0}));
  connect(intPul1.y, extIndSig4.index)
    annotation (Line(points={{22,-90},{50,-90},{50,-82}}, color={255,127,0}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/RealExtractor.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.RealExtractor\">
Buildings.Controls.OBC.CDL.Routing.RealExtractor</a>.
</p>
<p>
The instances <code>extIndSig</code>, <code>extIndSig1</code>, <code>extIndSig2</code>,
<code>extIndSig3</code>, and <code>extIndSig4</code> have the same input vector with
dimension of 5. However, they have different extract index and thus different output.
</p>
<ul>
<li>
The instance <code>extIndSig</code> has the extract index of <code>2</code>. The output is <code>u[2]</code>.
</li>
<li>
The instance <code>extIndSig1</code> has the extract index of <code>6</code>.
Thus it is out of upper range <code>[1, 5]</code> and it outputs <code>u[5]</code>.
It also issues a warning to indicate that the extract index is out of range.
</li>
<li>
The instance <code>extIndSig2</code> has the extract index of <code>0</code>.
Thus it is out of lower range <code>[1, 5]</code> and it outputs <code>u[1]</code>.
It also issues a warning to indicate that the extract index is out of range.
</li>
<li>
The instance <code>extIndSig3</code> has the extract index changing from <code>2</code>
to <code>-1</code>. Thus it first outputs <code>u[2]</code>, and then changes to <code>u[1]</code>.
At the moment when the extract index becomes out of range, it issues a warning.
</li>
<li>
The instance <code>extIndSig4</code> has the extract index changing from <code>0</code>
to <code>3</code>. Thus it first outputs <code>u[1]</code>, and then changes to <code>u[3]</code>.
It issues a warning at the start of the simulation.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
October 14, 2022, by Jianjun Hu:<br/>
Added more validations.
</li>
<li>
July 19, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})));
end RealExtractor;
