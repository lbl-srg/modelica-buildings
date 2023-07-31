within Buildings.Controls.OBC.CDL.Routing.Validation;
model IntegerExtractSignal
  "Validation model for extracting integer signals"
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractSignal extIntSig(
    final nin=4,
    final nout=3,
    final extract={3,2,4})
    "Block that extracts signal from an integer input signal vector"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractSignal extIntSig1(
    final nin=4,
    final nout=5,
    final extract={3,2,4,2,3})
    "Block that extracts signal from an integer input signal vector"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=1)
    "Block that outputs integer constant"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul(
    final amplitude=1,
    final period=0.2)
    "Generate pulse signal of type Integer"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul1(
    final period=0.3,
    final amplitude=2,
    final offset=-1)
    "Generate pulse signal of type Integer"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=4)
    "Block that outputs integer constant"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

equation
  connect(conInt2.y,extIntSig. u[1]) annotation (Line(points={{-58,60},{-20,60},
          {-20,29.25},{38,29.25}}, color={255,127,0}));
  connect(intPul.y,extIntSig. u[2]) annotation (Line(points={{-58,20},{-10,20},{
          -10,29.75},{38,29.75}}, color={255,127,0}));
  connect(intPul1.y,extIntSig. u[3]) annotation (Line(points={{-58,-20},{0,-20},
          {0,30.25},{38,30.25}}, color={255,127,0}));
  connect(conInt3.y,extIntSig. u[4]) annotation (Line(points={{-58,-60},{10,-60},
          {10,30.75},{38,30.75}}, color={255,127,0}));
  connect(conInt2.y, extIntSig1.u[1]) annotation (Line(points={{-58,60},{-20,60},
          {-20,-30.75},{38,-30.75}}, color={255,127,0}));
  connect(intPul.y, extIntSig1.u[2]) annotation (Line(points={{-58,20},{-10,20},
          {-10,-30.25},{38,-30.25}}, color={255,127,0}));
  connect(intPul1.y, extIntSig1.u[3]) annotation (Line(points={{-58,-20},{0,-20},
          {0,-29.75},{38,-29.75}}, color={255,127,0}));
  connect(conInt3.y, extIntSig1.u[4]) annotation (Line(points={{-58,-60},{10,-60},
          {10,-29.25},{38,-29.25}}, color={255,127,0}));
annotation (
  experiment(StopTime=1.0,Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/IntegerExtractSignal.mos" "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.IntegerExtractSignal\">
Buildings.Controls.OBC.CDL.Routing.IntegerExtractSignal</a>.
</p>
<p>
The instance <code>extIntSig</code> has the input vector with dimension of 4 and
the extracting vector is <code>[3, 2, 4]</code>. Thus the output vectors is <code>[u[3], u[2], u[4]]</code>.
</p>
<p>
The instance <code>extIntSig1</code> has the input vector with dimension of 4 and
the extracting vector is <code>[3, 2, 4, 2, 3]</code>.
Thus the output vectors is <code>[u[3], u[2], u[4], u[2], u[3]]</code>.
</p>
<p>
Note that when the extracting vector <code>extract</code> has any element with the value that
is out of range <code>[1, nin]</code>, e.g. <code>[1, 4]</code> for instance in <code>extIntSig</code>.
It will issue error and the model will not translate.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 5, 2022, by Jianjun Hu:<br/>
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
end IntegerExtractSignal;
