within Buildings.ThermalZones.EnergyPlus.BaseClasses;
function zoneInitialize
  "Initialization for an EnergyPlus thermal zone"
  extends Modelica.Icons.Function;
  input Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUZoneClass adapter
    "External object";
  input Modelica.SIunits.Time startTime
    "Start time of the simulation";
  output Modelica.SIunits.Area AFlo
    "Zone floor area";
  output Modelica.SIunits.Volume V
    "Zone air volume";
  output Real mSenFac
    "Factor for scaling the sensible thermal mass of the zone air volume";
external "C" SpawnZoneInstantiate(
  adapter,
  startTime,
  AFlo,
  V,
  mSenFac)
  annotation (
    Include="#include <EnergyPlusWrapper.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources",
    Library={"ModelicaBuildingsEnergyPlus", "fmilib_shared"});
  annotation (
    Documentation(
      info="<html>
<p>
External function to obtain parameters from the EnergyPlus FMU.
</p>
</html>",
      revisions="<html>
<ul><li>
March 1, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end zoneInitialize;
