within Buildings.Utilities.Math.Examples;
model Bicubic "Test model for bicubic function"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp x1(duration=1)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp x2(
    height=2,
    duration=1,
    offset=2)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Utilities.Math.Bicubic bicubic(a={1,2,3,4,5,6,7,8,9,10})
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation

  connect(x1.y, bicubic.u1) annotation (Line(
      points={{-59,70},{-52,70},{-52,56},{-42,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(x2.y, bicubic.u2) annotation (Line(
      points={{-59,30},{-50,30},{-50,44},{-42,44}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/Bicubic.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.Bicubic\">
Buildings.Utilities.Math.Bicubic</a>.
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
end Bicubic;
