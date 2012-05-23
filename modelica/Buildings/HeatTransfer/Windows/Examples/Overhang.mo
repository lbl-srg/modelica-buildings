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
    w=1.0,
    gap=0.1,
    hWin=1.0,
    wWin=1.0)
    "Calculates fraction of window area shaded by the window overhang"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    lat=weaDat.lat,
    til=Buildings.HeatTransfer.Types.Tilt.Wall,
    azi=Buildings.HeatTransfer.Types.Azimuth.S) "Direct solar irradiation"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
equation
  connect(weaDat.weaBus, ove.weaBus)      annotation (Line(
      points={{-40,10},{20,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDirTil.weaBus, weaDat.weaBus) annotation (Line(
      points={{-20,30},{-30,30},{-30,10},{-40,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDirTil.inc, ove.incAng) annotation (Line(
      points={{1,26},{6,26},{6,4},{18,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, ove.HDirTilUns) annotation (Line(
      points={{1,30},{10,30},{10,16},{18,16}},
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
