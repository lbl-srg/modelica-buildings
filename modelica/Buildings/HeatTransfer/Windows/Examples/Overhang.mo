within Buildings.HeatTransfer.Windows.Examples;
model Overhang
  "This example uses Window overhang model (with super position method)"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.HeatTransfer.Windows.Overhang ove(
    dep=1.2,
    wid=1.0,
    gap=0.1,
    winHt=1.0,
    winWid=1.0)
    "Calculates fraction of window area shaded by the window overhang"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAng(lat=weaDat.lat,
    azi=Buildings.HeatTransfer.Types.Azimuth.S,
    til=Buildings.HeatTransfer.Types.Tilt.Wall)
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
equation
  connect(weaDat.weaBus, ove.weaBus)      annotation (Line(
      points={{-40,10},{20,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, incAng.weaBus) annotation (Line(
      points={{-40,10},{-32,10},{-32,-19.6},{-20,-19.6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(incAng.y, ove.incAng) annotation (Line(
      points={{1,-20},{8,-20},{8,5.2},{18,5.2}},
      color={0,0,127},
      smooth=Smooth.None));
 annotation (Diagram(graphics), __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/Examples/Overhang.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example demonstrates the use of the overhang model.
It calculates the fraction of total window area shadowed by the overhang.
</p>
<p>
A similar example of an overhang model with more basic components is implemented in 
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.Examples.Overhang\">
Buildings.HeatTransfer.Windows.BaseClasses.Examples.Overhang</a>. 
</p>
</html>",
revisions="<html>
<ul>
<li>
Feb 01, 2012, by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end Overhang;
