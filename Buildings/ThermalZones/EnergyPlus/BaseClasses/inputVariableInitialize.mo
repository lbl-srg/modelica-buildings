within Buildings.ThermalZones.EnergyPlus.BaseClasses;
function inputVariableInitialize
  "Initialization for an EnergyPlus actuator or schedule"
  extends Modelica.Icons.Function;
  input Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUInputVariableClass adapter
    "External object";
  input Modelica.SIunits.Time startTime
    "Start time of the simulation";
external "C" SpawnInputVariableInstantiate(
  adapter,
  startTime)
  annotation (
    Include="#include <EnergyPlusWrapper.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources",
    Library={"ModelicaBuildingsEnergyPlus", "fmilib_shared"});
  annotation (
    Documentation(
      info="<html>
<p>
External function to initialize the EnergyPlus actuator or schedule.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 7, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end inputVariableInitialize;
