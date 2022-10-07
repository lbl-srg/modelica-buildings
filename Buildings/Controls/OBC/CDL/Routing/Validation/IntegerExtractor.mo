within Buildings.Controls.OBC.CDL.Routing.Validation;
model IntegerExtractor
  "Validation model for the integer extractor block"
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndInt(
    final nin=4)
    "Block that extracts signal from an input signal vector"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndInt1(
    final nin=4)
    "Block that extracts signal from an input signal vector"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndInt2(
    final nin=4)
    "Block that extracts signal from an input signal vector"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(final k=0)
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
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=6)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=0)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

equation
  connect(conInt1.y, extIndInt1.index)
    annotation (Line(points={{42,-10},{50,-10},{50,8}},   color={255,127,0}));
  connect(conInt2.y, extIndInt.u[1]) annotation (Line(points={{-58,80},{-40,80},
          {-40,79.25},{38,79.25}}, color={255,127,0}));
  connect(intPul.y, extIndInt.u[2]) annotation (Line(points={{-58,30},{-30,30},{
          -30,79.75},{38,79.75}}, color={255,127,0}));
  connect(intPul1.y, extIndInt.u[3]) annotation (Line(points={{-58,-30},{-20,-30},
          {-20,80.25},{38,80.25}}, color={255,127,0}));
  connect(conInt3.y, extIndInt.u[4]) annotation (Line(points={{-58,-80},{-10,-80},
          {-10,80.75},{38,80.75}}, color={255,127,0}));
  connect(conInt2.y, extIndInt1.u[1]) annotation (Line(points={{-58,80},{-40,80},
          {-40,19.25},{38,19.25}},   color={255,127,0}));
  connect(intPul.y, extIndInt1.u[2]) annotation (Line(points={{-58,30},{-30,30},
          {-30,19.75},{38,19.75}},   color={255,127,0}));
  connect(intPul1.y, extIndInt1.u[3]) annotation (Line(points={{-58,-30},{-20,-30},
          {-20,20.25},{38,20.25}},  color={255,127,0}));
  connect(conInt3.y, extIndInt1.u[4]) annotation (Line(points={{-58,-80},{-10,-80},
          {-10,20.75},{38,20.75}},   color={255,127,0}));
  connect(conInt.y, extIndInt.index)
    annotation (Line(points={{42,50},{50,50},{50,68}}, color={255,127,0}));
  connect(conInt4.y, extIndInt2.index)
    annotation (Line(points={{42,-80},{50,-80},{50,-62}}, color={255,127,0}));
  connect(conInt2.y, extIndInt2.u[1]) annotation (Line(points={{-58,80},{-40,80},
          {-40,-50.75},{38,-50.75}}, color={255,127,0}));
  connect(intPul.y, extIndInt2.u[2]) annotation (Line(points={{-58,30},{-30,30},
          {-30,-50.25},{38,-50.25}}, color={255,127,0}));
  connect(intPul1.y, extIndInt2.u[3]) annotation (Line(points={{-58,-30},{-20,-30},
          {-20,-49.75},{38,-49.75}}, color={255,127,0}));
  connect(conInt3.y, extIndInt2.u[4]) annotation (Line(points={{-58,-80},{-10,-80},
          {-10,-49.25},{38,-49.25}}, color={255,127,0}));
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
The instance <code>extIndInt</code> has the input vector with dimension of 4 and
the extract index is 2. The output is <code>u[2]</code>.
</p>
<p>
The instance <code>extIndInt1</code> has the input vector with dimension of 4 and
the extract index is 6 thus it is out of range <code>[1, 4]</code>.
It outputs <code>u[4]</code>, which is <code>4</code>. It also
issues a warning to indicate that the extract index is out of range.
</p>
<p>
The instance <code>extIndInt2</code> has the input vector with dimension of 4 and
the extract index is 0 thus it is out of range <code>[1, 4]</code>.
It outputs <code>u[1]</code>, which is <code>0</code>. It also
issues a warning to indicate that the extract index is out of range.
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
