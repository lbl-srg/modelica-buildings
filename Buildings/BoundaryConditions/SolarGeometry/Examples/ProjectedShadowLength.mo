within Buildings.BoundaryConditions.SolarGeometry.Examples;
model ProjectedShadowLength "Test model for projected shadow length"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Length h=2 "Height of object";
  Buildings.BoundaryConditions.SolarGeometry.ProjectedShadowLength proShaLenEas(
    azi=Buildings.Types.Azimuth.E,
    h=h,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Projected shadow length facing east"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Buildings.BoundaryConditions.SolarGeometry.ProjectedShadowLength proShaLenSou(
    azi=Buildings.Types.Azimuth.S,
    h=h,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Projected shadow length facing south"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.BoundaryConditions.SolarGeometry.ProjectedShadowLength proShaLenWes(
    azi=Buildings.Types.Azimuth.W,
    h=h,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Projected shadow length facing West"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.BoundaryConditions.SolarGeometry.ProjectedShadowLength proShaLenNor(
    azi=Buildings.Types.Azimuth.N,
    h=h,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Projected shadow length facing North"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
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
experiment(StartTime=0, Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/Examples/ProjectedShadowLength.mos"
        "Simulate and plot"));
end ProjectedShadowLength;
