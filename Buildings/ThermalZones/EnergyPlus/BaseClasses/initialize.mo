within Buildings.ThermalZones.EnergyPlus.BaseClasses;
function initialize
  "Initialization for an EnergyPlus thermal zone"
  extends Modelica.Icons.Function;
  input Buildings.ThermalZones.EnergyPlus.BaseClasses.SpawnExternalObject adapter
    "External object";
  input Modelica.SIunits.Time startTime
    "Start time of the simulation";
  input Integer nParOut "Number of elements in parOut";
  output Real parOut[nParOut+1]
    "Parameter values returned from EnergyPlus. Last element is a dummy value to force call before exchange";
external "C" ModelicaSpawnInstantiate(
  adapter,
  startTime,
  parOut)
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
end initialize;
