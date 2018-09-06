within Buildings.Utilities.Math.Examples;
model BesselY0 "Test model for besselY0 function "
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp x(duration=30, height=30) "Real signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Utilities.Math.BesselY0 Y0 "Bessel function Y0"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(x.y, Y0.u)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  annotation (  experiment(Tolerance=1e-6, StartTime=0.1, StopTime=30.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/BesselY0.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.BesselY0\">
Buildings.Utilities.Math.BesselY0</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2018, by Massimo Cimmino:<br/>First implementation.
</li>
</ul>
</html>"));
end BesselY0;
