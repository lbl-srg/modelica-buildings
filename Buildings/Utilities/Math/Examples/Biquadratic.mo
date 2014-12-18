within Buildings.Utilities.Math.Examples;
model Biquadratic "Test model for biquadratic function"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp x1(duration=1)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp x2(
    height=2,
    duration=1,
    offset=2)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Utilities.Math.Biquadratic biquadratic(a={1,2,3,4,5,6})
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation

  connect(x1.y, biquadratic.u1) annotation (Line(
      points={{-59,70},{-52,70},{-52,56},{-42,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(x2.y, biquadratic.u2) annotation (Line(
      points={{-59,30},{-50,30},{-50,44},{-42,44}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/Biquadratic.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.Biquadratic\">
Buildings.Utilities.Math.Biquadratic</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 14, 2012 by Michael Wetter:<br/>
Changed input values of function.
</li>
<li>
Sep 17, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Biquadratic;
