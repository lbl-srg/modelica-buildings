within Buildings.Controls.OBC.CDL.Reals.Validation;
model Round
  "Validation model for the Round block"
  Buildings.Controls.OBC.CDL.Reals.Round round1(
    n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Round round2(
    n=1)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Round round3(
    n=-1)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(k=0.1) "Gain"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(k=10) "Gain"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

equation
  connect(ramp1.y,round1.u)
    annotation (Line(points={{-39,0},{-20,0},{-20,50},{38,50}},color={0,0,127}));
  connect(ramp1.y,gai.u)
    annotation (Line(points={{-39,0},{-20,0},{-2,0}},color={0,0,127}));
  connect(round2.u,gai.y)
    annotation (Line(points={{38,0},{21,0}},color={0,0,127}));
  connect(ramp1.y,gai1.u)
    annotation (Line(points={{-39,0},{-20,0},{-20,-50},{-2,-50}},color={0,0,127}));
  connect(round3.u,gai1.y)
    annotation (Line(points={{38,-50},{30,-50},{21,-50}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Validation/Round.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Round\">
Buildings.Controls.OBC.CDL.Reals.Round</a>.
</p>
<p>
The input <code>u</code> varies from <i>-3.5</i> to <i>+3.5</i>.
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
end Round;
