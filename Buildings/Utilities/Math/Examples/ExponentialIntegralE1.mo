within Buildings.Utilities.Math.Examples;
model ExponentialIntegralE1
  "Test model for exponentialIntegralE1 function "
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp x(duration=30, height=30) "Real signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Utilities.Math.ExponentialIntegralE1 E1 "Exponential integral E1"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(x.y, E1.u)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  annotation (  experiment(Tolerance=1e-6, StartTime=0.01, StopTime=3.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/ExponentialIntegralE1.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.ExponentialIntegralE1\">
Buildings.Utilities.Math.ExponentialIntegralE1</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2018, by Massimo Cimmino:<br/>First implementation.
</li>
</ul>
</html>"));
end ExponentialIntegralE1;
