within Buildings.HeatTransfer.Windows.Examples;
model SideFins
  "This example uses Window SideFins model to calculate fraction of window area shaded by the side fins"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.HeatTransfer.Windows.SideFins fin(
    ht=1.2,
    winHt=1.0,
    winWid=1.0,
    dep=0.5,
    gap=0.1) "Outputs fraction of window area shaded by the side fins"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAng(lat=weaDat.lat,
    azi=Buildings.HeatTransfer.Types.Azimuth.S,
    til=Buildings.HeatTransfer.Types.Tilt.Wall)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
equation
  connect(weaDat.weaBus, fin.weaBus)    annotation (Line(
      points={{-40,10},{20,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, incAng.weaBus) annotation (Line(
      points={{-40,10},{-30,10},{-30,-29.6},{-20,-29.6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(incAng.y, fin.incAng) annotation (Line(
      points={{1,-30},{8,-30},{8,5.2},{18,5.2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/Examples/SideFins.mos"
        "Simulate and plot"),
        Documentation(info="<html>
<p>
This example uses the side fins model with weather data as input and calculates the fraction of total window area shadowed by the side fins.
For detail discription refer to documentation of the SideFins block <a href=\"modelica://Buildings.HeatTransfer.Windows.SideFins\">Buildings.HeatTransfer.Windows.SideFins</a> 
used in the model. 
A similar example of SideFins model with basic components is described in 
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.Examples.SideFins\">Buildings.HeatTransfer.Windows.BaseClasses.Examples.SideFins</a>. 
</p>
</html>",
revisions="<html>
<ul>
<li>
Feb 01, 2012, by Kaustubh Phalak<br>
First implementation. 
</li>
</ul>
</html>"));
end SideFins;
