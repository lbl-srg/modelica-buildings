within Buildings.ThermalZones.EnergyPlus.Validation.SurfaceComparison.BaseClasses;
model ReferenceSurfaces
  "Model that contains Eplus OutputVariable used to validate ZoneSurface"
  extends Modelica.Blocks.Icons.Block;

  inner Buildings.ThermalZones.EnergyPlus.Building building(
    idfName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Examples/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance.idf"),
    epwName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    usePrecompiledFMU=false,
    computeWetBulbTemperature=false)
    "Building model"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.ThermalZones.EnergyPlus.OutputVariable TGarAir(
    name="Zone Mean Air Temperature",
    key="LIVING ZONE",
    y(unit="K")) "Garage air temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.ThermalZones.EnergyPlus.OutputVariable TIntWalLivSur(
    name="Surface Inside Face Temperature",
    key="Living:Interior",
    y(unit="K")) "Interior wall living room surface temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.ThermalZones.EnergyPlus.OutputVariable TIntWalGarSur(
    name="Surface Inside Face Temperature",
    key="Garage:Interior",
    y(unit="K")) "Interior wall garage surface temperature"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.ThermalZones.EnergyPlus.OutputVariable TWesWalGarSur(
    name="Surface Inside Face Temperature",
    key="Garage:WestWall",
    y(unit="K")) "West wall garage surface temperature"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.ThermalZones.EnergyPlus.OutputVariable TEasWalGarSur(
    name="Surface Inside Face Temperature",
    key="Garage:EastWall",
    y(unit="K")) "East wall garage surface temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  annotation (
    Documentation(
      info="<html>
<p>
This model simulates the envelope of a single family house with EnergyPlus and is used
as a baseline to the 
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Validation.SurfaceComparison.SurfaceComparison\">
Buildings.ThermalZones.EnergyPlus.Validation.SurfaceComparison.SurfaceComparison</a>
validation model which compare that baseline to the same building, but using Spawn connectors
for some interior and exterior walls.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 21, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=2592000,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ReferenceSurfaces;
