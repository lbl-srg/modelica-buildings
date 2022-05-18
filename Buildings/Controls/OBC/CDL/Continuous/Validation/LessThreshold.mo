within Buildings.Controls.OBC.CDL.Continuous.Validation;
model LessThreshold
  "Validation model for the LessThreshold block"
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold les(t=2)
    "Less block, without hysteresis"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesHys(t=2, h=1)
    "Less block, with hysteresis"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabLin(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final table=[0,-3.5; 1,-2; 2,2; 3,3; 6,4; 8,-2; 10,-3.5])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
equation
  connect(timTabLin.y[1], les.u)
    annotation (Line(points={{-18,30},{18,30}}, color={0,0,127}));
  connect(timTabLin.y[1], lesHys.u)
    annotation (Line(points={{-18,30},{0,30},{0,-20},{18,-20}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=10.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/LessThreshold.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.LessThreshold\">
Buildings.Controls.OBC.CDL.Continuous.LessThreshold</a>.
The instance <code>les</code> has no hysteresis, and the
instance <code>lesHys</code> has a hysteresis.
</p>
</html>",
      revisions="<html>
<ul>
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
end LessThreshold;
