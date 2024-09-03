within Buildings.HeatTransfer.Windows.Examples;
model Overhang "This example tests the window overhang model"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.HeatTransfer.Windows.Overhang ove(
    dep=1.2,
    gap=0.1,
    hWin=1.0,
    wWin=1.0,
    azi=Buildings.Types.Azimuth.S,
    wR=0.1,
    wL=0.1) "Calculates fraction of window area exposed to the sun"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=Buildings.Types.Tilt.Wall,
    azi=Buildings.Types.Azimuth.S) "Direct solar irradiation"
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
 annotation (experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/Examples/Overhang.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example demonstrates the use of the overhang model.
It calculates the fraction of total window area that is exposed to the sun.
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
September 16, 2021, by Michael Wetter:<br/>
Removed parameter <code>lat</code> because the latitude is now obtained from the weather data bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
July 5, 2012, by Michael Wetter:<br/>
Changed definitions of <code>wL</code> and <code>wR</code> to be
measured from the corner of the window instead of the centerline.
</li>
<li>
Feb 01, 2012, by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end Overhang;
