within Buildings.Controls.OBC.CDL.Routing.Validation;
model RealExtractSignal
  "Validation model for the extract signal block"
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal extSig(
    final nin=5,
    final nout=3,
    final extract={1,2,5})
    "Block that extracts signals from an input signal vector"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal extSig1(
    final nin=5,
    final nout=6,
    final extract={1,2,5,3,4,2})
    "Block that extracts signals from an input signal vector"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram(
    final height=5,
    final duration=1,
    final offset=-2)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram1(
    final duration=1,
    final height=4,
    final offset=-1)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram2(
    final duration=1,
    final height=3,
    final offset=-2)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul(
    final amplitude=0.5,
    final period=0.2)
    "Generate pulse signal of type Real"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul1(
    final period=0.2,
    final amplitude=1.5,
    final offset=-0.2)
    "Generate pulse signal of type Real"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(ram.y,extSig.u[1])
    annotation (Line(points={{-38,60},{-20,60},{-20,39.2},{18,39.2}}, color={0,0,127}));
  connect(pul.y,extSig.u[2])
    annotation (Line(points={{-38,30},{-16,30},{-16,39.6},{18,39.6}}, color={0,0,127}));
  connect(pul1.y,extSig.u[3])
    annotation (Line(points={{-38,0},{-12,0},{-12,40},{18,40}}, color={0,0,127}));
  connect(ram1.y,extSig.u[4])
    annotation (Line(points={{-38,-30},{-8,-30},{-8,40.4},{18,40.4}}, color={0,0,127}));
  connect(ram2.y,extSig.u[5])
    annotation (Line(points={{-38,-60},{-4,-60},{-4,40.8},{18,40.8}},color={0,0,127}));
  connect(ram.y, extSig1.u[1]) annotation (Line(points={{-38,60},{-20,60},{-20,-40.8},
          {18,-40.8}}, color={0,0,127}));
  connect(pul.y, extSig1.u[2]) annotation (Line(points={{-38,30},{-16,30},{-16,-40.4},
          {18,-40.4}}, color={0,0,127}));
  connect(pul1.y, extSig1.u[3]) annotation (Line(points={{-38,0},{-12,0},{-12,-40},
          {18,-40}}, color={0,0,127}));
  connect(ram1.y, extSig1.u[4]) annotation (Line(points={{-38,-30},{-8,-30},{-8,
          -39.6},{18,-39.6}}, color={0,0,127}));
  connect(ram2.y, extSig1.u[5]) annotation (Line(points={{-38,-60},{-4,-60},{-4,
          -39.2},{18,-39.2}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/RealExtractSignal.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.RealExtractSignal\">
Buildings.Controls.OBC.CDL.Routing.RealExtractSignal</a>.
</p>
<p>
The instance <code>extSig</code> has the input vector with dimension of 4 and
the extracting vector is <code>[1, 2, 5]</code>.
Thus the output vectors is <code>[u[1], u[2], u[5]]</code>.
</p>
<p>
The instance <code>extSig1</code> has the input vector with dimension of 4 and
the extracting vector is <code>[1, 2, 5, 3, 4, 2]</code>. Thus the output vectors is <code>[u[1], u[2], u[5], u[3], u[4], u[2]]</code>.
</p>
<p>
Note that when the extracting vector <code>extract</code> has any element with the value that
is out of range <code>[1, nin]</code>, e.g. <code>[1, 4]</code> for instance in <code>extSig</code>.
It will issue error and the model will not translate.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 14, 2022, by Jianjun Hu:<br/>
Added validation when the number of outputs is more than the number of inputs.
</li>
<li>
July 24, 2017, by Jianjun Hu:<br/>
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
end RealExtractSignal;
