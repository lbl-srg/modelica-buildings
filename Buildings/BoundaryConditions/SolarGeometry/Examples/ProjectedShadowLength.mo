within Buildings.BoundaryConditions.SolarGeometry.Examples;
model ProjectedShadowLength "Test model for projected shadow length"
  import Buildings;
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Length h = 2 "Height of object";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  Buildings.BoundaryConditions.SolarGeometry.ProjectedShadowLength proShaLenEas(
    azi=Buildings.Types.Azimuth.E,
    lat=0.73268921998722,
    h=h) "Projected shadow length facing east"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Buildings.BoundaryConditions.SolarGeometry.ProjectedShadowLength proShaLenSou(
    azi=Buildings.Types.Azimuth.S,
    lat=0.73268921998722,
    h=h) "Projected shadow length facing south"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.BoundaryConditions.SolarGeometry.ProjectedShadowLength proShaLenWes(
    azi=Buildings.Types.Azimuth.W,
    lat=0.73268921998722,
    h=h) "Projected shadow length facing West"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.BoundaryConditions.SolarGeometry.ProjectedShadowLength proShaLenNor(
    azi=Buildings.Types.Azimuth.N,
    lat=0.73268921998722,
    h=h) "Projected shadow length facing North"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,5.82867e-16},{-53.5,5.82867e-16},{-53.5,1.13798e-15},{-47,
          1.13798e-15},{-47,5.55112e-16},{-34,5.55112e-16}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(proShaLenEas.decAng, weaBus.solDec)
    annotation (Line(points={{-12,74},{-34,74},{-34,0}}, color={0,0,127}));
  connect(proShaLenEas.solTim, weaBus.solTim) annotation (Line(points={{-12,66},
          {-16,66},{-34,66},{-34,0}}, color={0,0,127}));
  connect(proShaLenSou.decAng, weaBus.solDec)
    annotation (Line(points={{-12,34},{-34,34},{-34,0}}, color={0,0,127}));
  connect(proShaLenSou.solTim, weaBus.solTim) annotation (Line(points={{-12,26},
          {-16,26},{-34,26},{-34,0}}, color={0,0,127}));
  connect(proShaLenWes.decAng, weaBus.solDec)
    annotation (Line(points={{-12,-26},{-34,-26},{-34,0}}, color={0,0,127}));
  connect(proShaLenWes.solTim, weaBus.solTim) annotation (Line(points={{-12,-34},
          {-16,-34},{-34,-34},{-34,0}}, color={0,0,127}));
  connect(proShaLenNor.decAng, weaBus.solDec)
    annotation (Line(points={{-12,-66},{-34,-66},{-34,0}}, color={0,0,127}));
  connect(proShaLenNor.solTim, weaBus.solTim) annotation (Line(points={{-12,-74},
          {-16,-74},{-34,-74},{-34,0}}, color={0,0,127}));
  annotation (
  Documentation(info="<html>
<p>
This example computes how far a shadow of a <i>2</i> meter high
object is in different directions.
The figure below shows this length for January 1 in Chicago.
Note that the length of the shadow is <em>negative</em>
if the azimuth is selected to be south because the shadow
is towards the north.
</p>
<p align=\"center\">
<img alt=\"Simulation results\" src=\"modelica://Buildings/Resources/Images/BoundaryConditions/SolarGeometry/Examples/ProjectedShadowLength.png\" border=\"1\" />
</p>
</html>", revisions="<html>
<ul>
<li>
November 14, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(StartTime=0, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/Examples/ProjectedShadowLength.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end ProjectedShadowLength;
