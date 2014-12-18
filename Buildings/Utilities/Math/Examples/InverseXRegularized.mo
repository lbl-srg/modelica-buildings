within Buildings.Utilities.Math.Examples;
model InverseXRegularized "Test model for inverseXRegularized function "
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp x1(duration=1,
    height=2,
    offset=-1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Utilities.Math.InverseXRegularized inverseXRegularized(delta=0.1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(x1.y, inverseXRegularized.u) annotation (Line(
      points={{-39,0},{-12,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/InverseXRegularized.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.InverseXRegularized\">
Buildings.Utilities.Math.InverseXRegularized</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 28, 2013, by Marcus Fuchs:<br/>
Implementation based on Functions.inverseXRegularized.
</li>
</ul>
</html>"));
end InverseXRegularized;
