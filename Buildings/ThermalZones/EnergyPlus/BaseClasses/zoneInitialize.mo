within Buildings.ThermalZones.EnergyPlus.BaseClasses;
function zoneInitialize "Initialization for an EnergyPlus thermal zone"
  extends Modelica.Icons.Function;

  input Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUZoneClass
    adapter "External object";
  input Modelica.SIunits.Time startTime "Start time of the simulation";
  output Modelica.SIunits.Area AFlo "Zone floor area";
  output Modelica.SIunits.Volume V "Zone air volume";
  output Real mSenFac "Factor for scaling the sensible thermal mass of the zone air volume";

  external "C" ZoneInstantiate(adapter, startTime, AFlo, V, mSenFac)
 annotation (
   IncludeDirectory="modelica://Buildings/Resources/C-Sources/EnergyPlus",
   Include="#include \"ZoneInstantiate.c\"");

  annotation (Documentation(info="<html>
<p>
External function to obtain parameters from the EnergyPlus FMU.
</p>
</html>", revisions="<html>
<ul><li>
March 1, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end zoneInitialize;
