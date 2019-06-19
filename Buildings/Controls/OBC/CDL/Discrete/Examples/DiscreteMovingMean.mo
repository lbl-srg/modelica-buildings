within Buildings.Controls.OBC.CDL.Discrete.Examples;
model DiscreteMovingMean
  Continuous.Sources.Sine sin(freqHz=1/8, phase=0.5235987755983)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Discrete.DiscreteMovingMean disMovMea
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(sin.y, disMovMea.u)
    annotation (Line(points={{-39,10},{-2,10}}, color={0,0,127}));
  annotation (
  experiment(StopTime=15.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Discrete/Examples/DiscreteMovingMean.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Discrete.DiscreteMovingMean\">
Buildings.Controls.OBC.CDL.Discrete.DiscreteMovingMean</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 17, 2019 by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end DiscreteMovingMean;
