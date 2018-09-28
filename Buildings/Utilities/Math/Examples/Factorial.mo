within Buildings.Utilities.Math.Examples;
model Factorial "Test model for factorial function "
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp x(
    startTime=0.5,
    height=12.4,
    duration=12.4) "Real signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Utilities.Math.Factorial fac "Factorial"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.RealToInteger rea2Int "Conversion to rounded integer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(rea2Int.y, fac.u)
    annotation (Line(points={{11,0},{24.5,0},{38,0}}, color={255,127,0}));
  connect(x.y, rea2Int.u)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  annotation (  experiment(Tolerance=1e-6, StopTime=13.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/Factorial.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.Factorial\">
Buildings.Utilities.Math.Factorial</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2018, by Massimo Cimmino:<br/>First implementation.
</li>
</ul>
</html>"));
end Factorial;
