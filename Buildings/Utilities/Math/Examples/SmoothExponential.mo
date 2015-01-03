within Buildings.Utilities.Math.Examples;
model SmoothExponential "Test model for smoothExponential function "
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp x1(duration=1,
    height=2,
    offset=-1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Utilities.Math.SmoothExponential smoothExponential(delta=0.1)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
equation
  connect(x1.y, smoothExponential.u) annotation (Line(
      points={{-39,0},{-10,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (  experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/SmoothExponential.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.SmoothExponential\">
Buildings.Utilities.Math.SmoothExponential</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 28, 2013, by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmoothExponential;
