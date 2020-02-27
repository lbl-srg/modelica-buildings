within Buildings.Utilities.Math.Examples;
model Splice "Test model for splice"
  extends Modelica.Icons.Example;
  Buildings.Utilities.Math.Splice splice(deltax=0.2)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Sine sine(f=0.5)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Constant const1(k=-0.5)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Constant const(k=0.5)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation

  connect(sine.y, splice.x) annotation (Line(
      points={{-39,10},{-2,10}},
      color={0,0,127}));
  connect(const1.y, splice.u2) annotation (Line(
      points={{-39,-30},{-22,-30},{-22,4},{-2,4}},
      color={0,0,127}));
  connect(const.y, splice.u1) annotation (Line(
      points={{-39,50},{-20.5,50},{-20.5,16},{-2,16}},
      color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=2),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/Splice.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.Splice\">
Buildings.Utilities.Math.Splice</a>
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2012, by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end Splice;
