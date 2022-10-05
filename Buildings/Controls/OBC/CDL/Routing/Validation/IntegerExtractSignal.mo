within Buildings.Controls.OBC.CDL.Routing.Validation;
model IntegerExtractSignal
  "Validation model for the integer extract signal block"
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractSignal extBooSig(
    final nin=4,
    final nout=3,
    final extract={3,2,4})
    "Block that extracts signal from a boolean input signal vector"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

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
  connect(conInt2.y, extBooSig.u[1]) annotation (Line(points={{-58,60},{0,60},{0,
          -0.75},{38,-0.75}}, color={255,127,0}));
  connect(intPul.y, extBooSig.u[2]) annotation (Line(points={{-58,20},{-10,20},{
          -10,-0.25},{38,-0.25}}, color={255,127,0}));
  connect(intPul1.y, extBooSig.u[3]) annotation (Line(points={{-58,-20},{-20,-20},
          {-20,0.25},{38,0.25}}, color={255,127,0}));
  connect(conInt3.y, extBooSig.u[4]) annotation (Line(points={{-58,-60},{10,-60},
          {10,0.75},{38,0.75}}, color={255,127,0}));
annotation (
  experiment(StopTime=1.0,Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/IntegerExtractSignal.mos" "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.IntegerExtractSignal\">
Buildings.Controls.OBC.CDL.Routing.IntegerExtractSignal</a>.
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
