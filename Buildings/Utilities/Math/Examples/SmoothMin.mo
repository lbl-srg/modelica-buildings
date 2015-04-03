within Buildings.Utilities.Math.Examples;
model SmoothMin "Test model for smooth minimum"
  extends Modelica.Icons.Example;
  Buildings.Utilities.Math.SmoothMin smoLim[2](deltaX={0.1,0.02}) "Smooth limit"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Ramp ramp(height=1, duration=1) "Ramp input"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Sources.Constant const(k=0.5) "Constant input"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
equation

  connect(ramp.y, smoLim[1].u1) annotation (Line(
      points={{-19,20},{-12,20},{-12,6},{-2,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(smoLim[2].u1, ramp.y) annotation (Line(
      points={{-2,6},{-12,6},{-12,20},{-19,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, smoLim[1].u2) annotation (Line(
      points={{-19,-20},{-12,-20},{-12,-6},{-2,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, smoLim[2].u2) annotation (Line(
      points={{-19,-20},{-12,-20},{-12,-6},{-2,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(experiment(StopTime=1.0),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/SmoothMin.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.SmoothMin\">
Buildings.Utilities.Math.SmoothMin</a>.
</p>
<p>
This model also illustrates that the output can be larger than
the minimum of the two input signals. Smaller values for <code>deltaX</code>
will reduce this effect. Therefore do not use this function when the minimum
output value should be respected.
</p>
</html>", revisions="<html>
<ul>
<li>
March 12, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmoothMin;
