within Buildings.HeatTransfer.Windows.Examples;
model BeamDepthInRoom "Test model for the depth of the solar beam in the room"
  import Buildings;
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Length hUppApe = 2.0
    "Upper height of aperature above ground";
  parameter Modelica.SIunits.Length depOve=1.0
    "Depth of overhang, meausured from other exterior surface of aperature (set to 0 if no overhang)";
  parameter Modelica.SIunits.Length gapOve=0.5
    "Gap between upper height of aperature and lower height of overhang (set to 0 if no overhang)";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
      computeWetBulbTemperature=false) "Weather data"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  Buildings.HeatTransfer.Windows.BeamDepthInRoom winEas(
    azi=Buildings.Types.Azimuth.E,
    hUppApe=hUppApe,
    depOve=depOve,
    gapOve=gapOve,
    lat=0.73268921998722) "Beam depth at window in East wall"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Buildings.HeatTransfer.Windows.BeamDepthInRoom winSou(
    azi=Buildings.Types.Azimuth.S,
    hUppApe=hUppApe,
    depOve=depOve,
    gapOve=gapOve,
    lat=0.73268921998722) "Beam depth at window in South wall"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.HeatTransfer.Windows.BeamDepthInRoom winWes(
    azi=Buildings.Types.Azimuth.W,
    hUppApe=hUppApe,
    depOve=depOve,
    gapOve=gapOve,
    lat=0.73268921998722) "Beam depth at window in West wall"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.HeatTransfer.Windows.BeamDepthInRoom winNor(
    azi=Buildings.Types.Azimuth.N,
    hUppApe=hUppApe,
    depOve=depOve,
    gapOve=gapOve,
    lat=0.73268921998722) "Beam depth at window in North wall"
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
  connect(winEas.decAng, weaBus.solDec)
    annotation (Line(points={{-12,74},{-34,74},{-34,0}}, color={0,0,127}));
  connect(winEas.solTim, weaBus.solTim) annotation (Line(points={{-12,66},{-16,66},
          {-34,66},{-34,0}}, color={0,0,127}));
  connect(winSou.decAng, weaBus.solDec)
    annotation (Line(points={{-12,34},{-34,34},{-34,0}}, color={0,0,127}));
  connect(winSou.solTim, weaBus.solTim) annotation (Line(points={{-12,26},{-16,26},
          {-34,26},{-34,0}}, color={0,0,127}));
  connect(winWes.decAng, weaBus.solDec)
    annotation (Line(points={{-12,-26},{-34,-26},{-34,0}}, color={0,0,127}));
  connect(winWes.solTim, weaBus.solTim) annotation (Line(points={{-12,-34},{-16,
          -34},{-34,-34},{-34,0}}, color={0,0,127}));
  connect(winNor.decAng, weaBus.solDec)
    annotation (Line(points={{-12,-66},{-34,-66},{-34,0}}, color={0,0,127}));
  connect(winNor.solTim, weaBus.solTim) annotation (Line(points={{-12,-74},{-16,
          -74},{-34,-74},{-34,0}}, color={0,0,127}));
  annotation (
  Documentation(info="<html>
<p>
This example computes how far from the wall, measured perpendicular to the wall,
hits the workplane.
The figure below shows this length for January 1 in Chicago
for windows with different orientations.
The spike at sunset is a numerical artifact that has no physical significance.
fixme: check if this can be avoided if we schedule a time event at sunrise and sunset.
</p>
<p align=\"center\">
<img alt=\"Simulation results\" src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/Examples/BeamDepthInRoom.png\" border=\"1\" />
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/Examples/BeamDepthInRoom.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end BeamDepthInRoom;
