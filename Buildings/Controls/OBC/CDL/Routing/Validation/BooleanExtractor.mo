within Buildings.Controls.OBC.CDL.Routing.Validation;
model BooleanExtractor
  "Validation model for the boolean extractor block"
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor extIndBoo(
    final nin=4) "Extracts signal from an input signal vector"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor extIndBoo1(
    final nin=4)
    "Extracts signal from an input signal vector when the extract index is out of the upper range"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor extIndBoo2(
    final nin=4)
    "Extracts signal from an input signal vector when the extract index is out of the lower range"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor extIndBoo3(
    final nin=4)
    "Extracts signal from an input signal vector when the extract index changes from within range to out of range"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor extIndBoo4(
    final nin=4)
    "Extracts signal from an input signal vector when the extract index changes from out of range to within range"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=true)
    "Block that outputs true signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Block that outputs false signal"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=0.2) "Generate pulse signal of type boolean"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final period=0.3)
    "Generate pulse signal of type boolean"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    k=6)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    k=0)
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
  connect(conInt.y, extIndBoo.index)
    annotation (Line(points={{22,70},{50,70},{50,78}}, color={255,127,0}));
  connect(conInt1.y, extIndBoo1.index)
    annotation (Line(points={{22,30},{50,30},{50,38}}, color={255,127,0}));
  connect(con1.y, extIndBoo.u[1]) annotation (Line(points={{-58,80},{-40,80},{-40,
          89.25},{38,89.25}}, color={255,0,255}));
  connect(booPul.y, extIndBoo.u[2]) annotation (Line(points={{-58,30},{-30,30},{
          -30,89.75},{38,89.75}}, color={255,0,255}));
  connect(booPul1.y, extIndBoo.u[3]) annotation (Line(points={{-58,-20},{-20,-20},
          {-20,90.25},{38,90.25}},   color={255,0,255}));
  connect(con.y, extIndBoo.u[4]) annotation (Line(points={{-58,-70},{-10,-70},{-10,
          90.75},{38,90.75}},   color={255,0,255}));
  connect(con1.y, extIndBoo1.u[1]) annotation (Line(points={{-58,80},{-40,80},{-40,
          49.25},{38,49.25}}, color={255,0,255}));
  connect(booPul.y, extIndBoo1.u[2]) annotation (Line(points={{-58,30},{-30,30},
          {-30,49.75},{38,49.75}}, color={255,0,255}));
  connect(booPul1.y, extIndBoo1.u[3]) annotation (Line(points={{-58,-20},{-20,-20},
          {-20,50.25},{38,50.25}}, color={255,0,255}));
  connect(con.y, extIndBoo1.u[4]) annotation (Line(points={{-58,-70},{-10,-70},{
          -10,50.75},{38,50.75}}, color={255,0,255}));
  connect(con1.y, extIndBoo2.u[1]) annotation (Line(points={{-58,80},{-40,80},{-40,
          9.25},{38,9.25}},     color={255,0,255}));
  connect(booPul.y, extIndBoo2.u[2]) annotation (Line(points={{-58,30},{-30,30},
          {-30,9.75},{38,9.75}},     color={255,0,255}));
  connect(booPul1.y, extIndBoo2.u[3]) annotation (Line(points={{-58,-20},{-10,-20},
          {-10,10.25},{38,10.25}},   color={255,0,255}));
  connect(con.y, extIndBoo2.u[4]) annotation (Line(points={{-58,-70},{-10,-70},{
          -10,10.75},{38,10.75}},   color={255,0,255}));
  connect(conInt2.y, extIndBoo2.index)
    annotation (Line(points={{22,-10},{50,-10},{50,-2}},  color={255,127,0}));
  connect(con1.y, extIndBoo3.u[1]) annotation (Line(points={{-58,80},{-40,80},{-40,
          -30.75},{38,-30.75}}, color={255,0,255}));
  connect(booPul.y, extIndBoo3.u[2]) annotation (Line(points={{-58,30},{-30,30},
          {-30,-30.25},{38,-30.25}}, color={255,0,255}));
  connect(booPul1.y, extIndBoo3.u[3]) annotation (Line(points={{-58,-20},{-20,-20},
          {-20,-29.75},{38,-29.75}}, color={255,0,255}));
  connect(con.y, extIndBoo3.u[4]) annotation (Line(points={{-58,-70},{-10,-70},{
          -10,-29.25},{38,-29.25}}, color={255,0,255}));
  connect(intPul.y, extIndBoo3.index) annotation (Line(points={{22,-50},{50,-50},
          {50,-42}}, color={255,127,0}));
  connect(intPul1.y, extIndBoo4.index)
    annotation (Line(points={{22,-90},{50,-90},{50,-82}}, color={255,127,0}));
  connect(con1.y, extIndBoo4.u[1]) annotation (Line(points={{-58,80},{-40,80},{-40,
          -70.75},{38,-70.75}}, color={255,0,255}));
  connect(booPul.y, extIndBoo4.u[2]) annotation (Line(points={{-58,30},{-30,30},
          {-30,-70.25},{38,-70.25}}, color={255,0,255}));
  connect(booPul1.y, extIndBoo4.u[3]) annotation (Line(points={{-58,-20},{-20,-20},
          {-20,-69.75},{38,-69.75}}, color={255,0,255}));
  connect(con.y, extIndBoo4.u[4]) annotation (Line(points={{-58,-70},{-10,-70},{
          -10,-69.25},{38,-69.25}}, color={255,0,255}));
annotation (
  experiment(StopTime=1.0,Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/BooleanExtractor.mos" "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.BooleanExtractor\">
Buildings.Controls.OBC.CDL.Routing.BooleanExtractor</a>.
</p>
<p>
The instances <code>extIndBoo</code>, <code>extIndBoo1</code>, <code>extIndBoo2</code>,
<code>extIndBoo3</code>, and <code>extIndBoo4</code> have the same input vector with
dimension of 4. However, they have different extract index and thus different output.
</p>
<ul>
<li>
The instance <code>extIndBoo</code> has the extract index of <code>2</code>. The output is <code>u[2]</code>.
</li>
<li>
The instance <code>extIndBoo1</code> has the extract index of <code>6</code>.
Thus it is out of upper range <code>[1, 4]</code> and it outputs <code>u[4]</code>.
It also issues a warning to indicate that the extract index is out of range.
</li>
<li>
The instance <code>extIndBoo2</code> has the extract index of <code>0</code>.
Thus it is out of lower range <code>[1, 4]</code> and it outputs <code>u[1]</code>.
It also issues a warning to indicate that the extract index is out of range.
</li>
<li>
The instance <code>extIndBoo3</code> has the extract index changing from <code>2</code>
to <code>-1</code>. Thus it first outputs <code>u[2]</code>, and then changes to <code>u[1]</code>.
At the moment when the extract index becomes out of range, it issues a warning.
</li>
<li>
The instance <code>extIndBoo4</code> has the extract index changing from <code>0</code>
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
end BooleanExtractor;
