within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Less
  "Validation model for the Less block"
  Buildings.Controls.OBC.CDL.Continuous.Less les
    "Less block, without hysteresis"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Less lesHys(
    h=1)
    "Less block, with hysteresis"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabLin(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[0,-1; 3,1; 5,0; 7,2; 10,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabLin1(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[
      0,0;
      4,1;
      6,0;
      7,-1;
      10,-2])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

equation
  connect(timTabLin.y[1], les.u1)
    annotation (Line(points={{-18,20},{18,20}}, color={0,0,127}));
  connect(timTabLin.y[1], lesHys.u1) annotation (Line(points={{-18,20},{0,20},{0,
          -20},{18,-20}}, color={0,0,127}));
  connect(timTabLin1.y[1], les.u2) annotation (Line(points={{-18,-20},{-10,-20},
          {-10,12},{18,12}}, color={0,0,127}));
  connect(timTabLin1.y[1], lesHys.u2) annotation (Line(points={{-18,-20},{-10,-20},
          {-10,-28},{18,-28}}, color={0,0,127}));
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
