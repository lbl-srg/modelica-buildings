within Buildings.HeatTransfer.Windows.Examples;
model BeamDepthInRoom "Test model for the depth of the solar beam in the room"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Length hApe = 2.0
    "Upper height of aperature above ground";
  parameter Modelica.SIunits.Length depOve=1.0
    "Depth of overhang, meausured from other exterior surface of aperature (set to 0 if no overhang)";
  parameter Modelica.SIunits.Length gapOve=0.5
    "Gap between upper height of aperature and lower height of overhang (set to 0 if no overhang)";
  Buildings.HeatTransfer.Windows.BeamDepthInRoom winEas(
    azi=Buildings.Types.Azimuth.E,
    hApe=hApe,
    depOve=depOve,
    gapOve=gapOve,
    filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Beam depth at window in East wall"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Buildings.HeatTransfer.Windows.BeamDepthInRoom winSou(
    azi=Buildings.Types.Azimuth.S,
    hApe=hApe,
    depOve=depOve,
    gapOve=gapOve,
    filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Beam depth at window in South wall"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.HeatTransfer.Windows.BeamDepthInRoom winWes(
    azi=Buildings.Types.Azimuth.W,
    hApe=hApe,
    depOve=depOve,
    gapOve=gapOve,
    filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Beam depth at window in West wall"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.HeatTransfer.Windows.BeamDepthInRoom winNor(
    azi=Buildings.Types.Azimuth.N,
    hApe=hApe,
    depOve=depOve,
    gapOve=gapOve,
    filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Beam depth at window in North wall"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  annotation (
  Documentation(info="<html>
<p>
This example computes how far from the wall, measured perpendicular to the wall,
hits the workplane.
The figure below shows this length for January 1 in Chicago
for windows with different orientations.
The spike at sunset is a numerical artifact that has no physical significance.
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
experiment(StartTime=0, Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/Examples/BeamDepthInRoom.mos"
        "Simulate and plot"));
end BeamDepthInRoom;
