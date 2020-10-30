within Buildings.ThermalZones.EnergyPlus.BaseClasses;
function inputVariableExchange
  "Exchange the values with the EnergyPlus actuator or schedule"
  extends Modelica.Icons.Function;
  input Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUInputVariableClass adapter
    "External object";
  input Boolean initialCall
    "Set to true if initial() is true, false otherwise";
  input Real u
    "Value for the EnergyPlus actuator or schedule";
  input Modelica.SIunits.Time tModel
    "Current model time";
  output Real y
    "Value send to EnergyPlus (equals u, but used to enable forcing a direct dependency for Actuators and Schedules)";
external "C" SpawnInputVariableExchange(
  adapter,
  initialCall,
  u,
  tModel,
  y)
  annotation (
    Include="#include <EnergyPlusWrapper.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources",
    Library={"ModelicaBuildingsEnergyPlus",
    "fmilib_shared"});
  annotation (
    Documentation(
      info="<html>
<p>
External function that sends data to an EnergyPlus actuator or schedule.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 8, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end inputVariableExchange;
