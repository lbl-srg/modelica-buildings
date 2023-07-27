within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Less
  "Validation model for the Less block"
  Buildings.Controls.OBC.CDL.Continuous.Less les
    "Less block, without hysteresis"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Less lesHys(
    h=1)
    "Less block, with hysteresis"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin sin(
    amplitude=3,
    freqHz=1/10,
    offset=-2,
    startTime=1)
    "Sine source"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram1(
    height=5,
    duration=10,
    offset=-2)
    "Ramp source"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
equation
  connect(sin.y, les.u1)
    annotation (Line(points={{-18,40},{18,40}}, color={0,0,127}));
  connect(sin.y, lesHys.u1) annotation (Line(points={{-18,40},{0,40},{0,-20},{18,
          -20}}, color={0,0,127}));
  connect(ram1.y, les.u2) annotation (Line(points={{-18,-20},{-10,-20},{-10,32},
          {18,32}}, color={0,0,127}));
  connect(ram1.y, lesHys.u2) annotation (Line(points={{-18,-20},{-10,-20},{-10,-28},
          {18,-28}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=10.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/Less.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Less\">
Buildings.Controls.OBC.CDL.Continuous.Less</a>.
The instance <code>les</code> has no hysteresis, and the
instance <code>lesHys</code> has a hysteresis.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 14, 2023, by Jianjun Hu:<br/>
Changed the greater block input to avoid near zero crossing.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3294\">
issue 3294</a>.
</li>  
<li>
August 5, 2020, by Michael Wetter:<br/>
Updated model to add a test case with hysteresis.
</li>
<li>
April 1, 2017, by Jianjun Hu:<br/>
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
end Less;
