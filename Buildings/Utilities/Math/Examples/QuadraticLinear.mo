within Buildings.Utilities.Math.Examples;
model QuadraticLinear "Test model for quadraticLinear function "
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp x1(duration=1)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Utilities.Math.QuadraticLinear quadraticLinear(a={1,2,3,4,5,6})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp x2(
    duration=1,
    offset=2,
    height=5)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(x2.y, quadraticLinear.u2) annotation (Line(
      points={{-39,-20},{-28,-20},{-28,-6},{-12,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(x1.y, quadraticLinear.u1) annotation (Line(
      points={{-39,20},{-28,20},{-28,6},{-12,6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/QuadraticLinear.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.QuadraticLinear\">
Buildings.Utilities.Math.QuadraticLinear</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 29, 2013, by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"));
end QuadraticLinear;
