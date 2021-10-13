within Buildings.Utilities.Math.Examples;
model Polynomial "Test model for ploynominal function "
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp x1(duration=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Utilities.Math.Polynomial polynominal(a={1,2})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(x1.y, polynominal.u) annotation (Line(
      points={{-39,0},{-12,0}},
      color={0,0,127}));
  annotation (  experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/Polynomial.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.Polynomial\">
Buildings.Utilities.Math.Polynomial</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2021, by Michael Wetter:<br/>
Renamed class to correct typo in class name.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1524\">IBPSA, #1524</a>.
</li>
<li>
November 28, 2013, by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"));
end Polynomial;
