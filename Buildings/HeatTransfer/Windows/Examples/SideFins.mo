within Buildings.HeatTransfer.Windows.Examples;
model SideFins "This example demonstrates the use of side fins for a window"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.HeatTransfer.Windows.SideFins fin(
    h=0.2,
    hWin=1.0,
    wWin=1.0,
    dep=0.5,
    gap=0.1) "Outputs fraction of window area exposed to the sun"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=Buildings.Types.Tilt.Wall,
    azi=Buildings.Types.Azimuth.S) "Direct solar irradiation"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
equation
  connect(weaDat.weaBus, fin.weaBus)    annotation (Line(
      points={{-40,10},{20,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDirTil.weaBus, weaDat.weaBus) annotation (Line(
      points={{-20,30},{-30,30},{-30,10},{-40,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDirTil.inc, fin.incAng) annotation (Line(
      points={{1,26},{8,26},{8,4},{18,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, fin.HDirTilUns) annotation (Line(
      points={{1,30},{12,30},{12,16},{18,16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/Examples/SideFins.mos"
        "Simulate and plot"),
        Documentation(info="<html>
<p>
This example uses the window sidefin model to calculate the fraction of total window area exposed to the sun.</p>
<p>
For a detailed description of the model, see
<a href=\"modelica://Buildings.HeatTransfer.Windows.SideFins\">Buildings.HeatTransfer.Windows.SideFins</a>.
A similar example of can be found in
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.Examples.SideFins\">Buildings.HeatTransfer.Windows.BaseClasses.Examples.SideFins</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 5, 2012, by Michael Wetter:<br/>
Changed definitions of side fin height <code>h</code> to be
measured from the top of the window.
This allows changing the window height without having to adjust the
side fin parameters.
</li>
<li>
Feb 01, 2012, by Kaustubh Phalak<br/>
First implementation.
</li>
</ul>
</html>"));
end SideFins;
