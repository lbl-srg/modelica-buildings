within Buildings.Controls.OBC.CDL.Routing.Validation;
model IntegerExtractor
  "Validation model for the integer extractor block"
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndInt(
    final nin=4) "Extracts signal from an input signal vector"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndInt1(
    final nin=4)
    "Extracts signal from an input signal vector when the extract index is out of the upper range"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndInt2(
    final nin=4)
    "Extracts signal from an input signal vector when the extract index is out of the lower range"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndInt3(
    final nin=4)
    "Extracts signal from an input signal vector when the extract index changes from within range to out of range"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndInt4(
    final nin=4)
    "Extracts signal from an input signal vector when the extract index changes from out of range to within range"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=0)
    "Block that outputs integer constant"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=4)
    "Block that outputs integer constant"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul(
    final amplitude=1,
    final period=0.2) "Generate pulse signal of type Integer"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul1(
    final period=0.3,
    final amplitude=2,
    final offset=-1)   "Generate pulse signal of type Integer"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(k=6)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(k=0)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul2(
    final period=1,
    final amplitude=3,
    final offset=-1)
    "Generate pulse signal of type Integer"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul3(
    final period=1,
    final amplitude=-3,
    final offset=3)
    "Generate pulse signal of type Integer"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

equation
  connect(conInt1.y, extIndInt1.index)
    annotation (Line(points={{22,30},{50,30},{50,38}}, color={255,127,0}));
  connect(conInt2.y, extIndInt.u[1]) annotation (Line(points={{-58,80},{-40,80},
          {-40,89.25},{38,89.25}}, color={255,127,0}));
  connect(intPul.y, extIndInt.u[2]) annotation (Line(points={{-58,30},{-30,30},{
          -30,89.75},{38,89.75}}, color={255,127,0}));
  connect(intPul1.y, extIndInt.u[3]) annotation (Line(points={{-58,-30},{-20,-30},
          {-20,90.25},{38,90.25}},   color={255,127,0}));
  connect(conInt3.y, extIndInt.u[4]) annotation (Line(points={{-58,-80},{-10,-80},
          {-10,90.75},{38,90.75}},   color={255,127,0}));
  connect(conInt2.y, extIndInt1.u[1]) annotation (Line(points={{-58,80},{-40,80},
          {-40,49.25},{38,49.25}},   color={255,127,0}));
  connect(intPul.y, extIndInt1.u[2]) annotation (Line(points={{-58,30},{-30,30},
          {-30,49.75},{38,49.75}},   color={255,127,0}));
  connect(intPul1.y, extIndInt1.u[3]) annotation (Line(points={{-58,-30},{-20,-30},
          {-20,50.25},{38,50.25}},  color={255,127,0}));
  connect(conInt3.y, extIndInt1.u[4]) annotation (Line(points={{-58,-80},{-10,-80},
          {-10,50.75},{38,50.75}},   color={255,127,0}));
  connect(conInt.y, extIndInt.index)
    annotation (Line(points={{22,70},{50,70},{50,78}}, color={255,127,0}));
  connect(conInt4.y, extIndInt2.index)
    annotation (Line(points={{22,-10},{50,-10},{50,-2}},  color={255,127,0}));
  connect(conInt2.y, extIndInt2.u[1]) annotation (Line(points={{-58,80},{-40,80},
          {-40,9.25},{38,9.25}},     color={255,127,0}));
  connect(intPul.y, extIndInt2.u[2]) annotation (Line(points={{-58,30},{-30,30},
          {-30,9.75},{38,9.75}},     color={255,127,0}));
  connect(intPul1.y, extIndInt2.u[3]) annotation (Line(points={{-58,-30},{-20,-30},
          {-20,10.25},{38,10.25}},   color={255,127,0}));
  connect(conInt3.y, extIndInt2.u[4]) annotation (Line(points={{-58,-80},{-10,-80},
          {-10,10.75},{38,10.75}},   color={255,127,0}));
  connect(conInt2.y, extIndInt3.u[1]) annotation (Line(points={{-58,80},{-40,80},
          {-40,-30.75},{38,-30.75}}, color={255,127,0}));
  connect(intPul.y, extIndInt3.u[2]) annotation (Line(points={{-58,30},{-30,30},
          {-30,-30.25},{38,-30.25}}, color={255,127,0}));
  connect(intPul1.y, extIndInt3.u[3]) annotation (Line(points={{-58,-30},{-20,-30},
          {-20,-29.75},{38,-29.75}}, color={255,127,0}));
  connect(conInt3.y, extIndInt3.u[4]) annotation (Line(points={{-58,-80},{-10,-80},
          {-10,-29.25},{38,-29.25}}, color={255,127,0}));
  connect(intPul2.y, extIndInt3.index) annotation (Line(points={{22,-50},{50,-50},
          {50,-42}}, color={255,127,0}));
  connect(intPul3.y, extIndInt4.index)
    annotation (Line(points={{22,-90},{50,-90},{50,-82}}, color={255,127,0}));
  connect(conInt2.y, extIndInt4.u[1]) annotation (Line(points={{-58,80},{-40,80},
          {-40,-70.75},{38,-70.75}}, color={255,127,0}));
  connect(intPul.y, extIndInt4.u[2]) annotation (Line(points={{-58,30},{-30,30},
          {-30,-70.25},{38,-70.25}}, color={255,127,0}));
  connect(intPul1.y, extIndInt4.u[3]) annotation (Line(points={{-58,-30},{-20,-30},
          {-20,-69.75},{38,-69.75}}, color={255,127,0}));
  connect(conInt3.y, extIndInt4.u[4]) annotation (Line(points={{-58,-80},{-10,-80},
          {-10,-69.25},{38,-69.25}}, color={255,127,0}));
annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/IntegerExtractor.mos" "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.IntegerExtractor\">
Buildings.Controls.OBC.CDL.Routing.IntegerExtractor</a>.
</p>
<p>
The instances <code>extIndInt</code>, <code>extIndInt1</code>, <code>extIndInt2</code>,
<code>extIndInt3</code>, and <code>extIndInt4</code> have the same input vector with
dimension of 4. However, they have different extract index and thus different output.
</p>
<ul>
<li>
The instance <code>extIndInt</code> has the extract index of <code>2</code>. The output is <code>u[2]</code>.
</li>
<li>
The instance <code>extIndInt1</code> has the extract index of <code>6</code>.
Thus it is out of upper range <code>[1, 4]</code> and it outputs <code>u[4]</code>.
It also issues a warning to indicate that the extract index is out of range.
</li>
<li>
The instance <code>extIndInt2</code> has the extract index of <code>0</code>.
Thus it is out of lower range <code>[1, 4]</code> and it outputs <code>u[1]</code>.
It also issues a warning to indicate that the extract index is out of range.
</li>
<li>
The instance <code>extIndInt3</code> has the extract index changing from <code>2</code>
to <code>-1</code>. Thus it first outputs <code>u[2]</code>, and then changes to <code>u[1]</code>.
At the moment when the extract index becomes out of range, it issues a warning.
</li>
<li>
The instance <code>extIndInt4</code> has the extract index changing from <code>0</code>
to <code>3</code>. Thus it first outputs <code>u[1]</code>, and then changes to <code>u[3]</code>.
It issues a warning at the start of the simulation.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
October 5, 2022, by Jianjun Hu:<br/>
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
end IntegerExtractor;
