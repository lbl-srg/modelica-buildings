within Buildings.Utilities.Math.Examples;
model FallingFactorial "Test model for falling factorial function "
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp k(
    startTime=0.5,
    height=10.4,
    duration=10.4) "Real signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Math.RealToInteger rea2Int "Conversion to rounded integer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Utilities.Math.FallingFactorial falFac "Falling factorial"
    annotation (Placement(transformation(extent={{40,-4},{60,16}})));
  Modelica.Blocks.Sources.IntegerConstant n(k=13) "Falling factorial power"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
equation
  connect(k.y, rea2Int.u)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  connect(rea2Int.y, falFac.k)
    annotation (Line(points={{11,0},{24,0},{38,0}}, color={255,127,0}));
  connect(n.y, falFac.n) annotation (Line(points={{11,40},{24,40},{24,12},{38,12}},
        color={255,127,0}));
  annotation (  experiment(Tolerance=1e-6, StopTime=11.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/FallingFactorial.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.FallingFactorial\">
Buildings.Utilities.Math.FallingFactorial</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2018, by Massimo Cimmino:<br/>First implementation.
</li>
</ul>
</html>"));
end FallingFactorial;
