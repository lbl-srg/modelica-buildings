within Buildings.ThermalZones.EnergyPlus.BaseClasses;
function outputVariableExchange
  "Exchange the values with the EnergyPlus output variable"
  extends Modelica.Icons.Function;
  input Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUOutputVariableClass adapter
    "External object";
  input Boolean initialCall
    "Set to true if initial() is true, false otherwise";
  input Real directDependency
    "Input value on which this output directly depends on";
  input Modelica.SIunits.Time tModel
    "Current model time";
  output Real y
    "Value of the EnergyPlus output variable";
  output Modelica.SIunits.Time tNext
    "Next time that the zone need to be invoked";
external "C" SpawnOutputVariableExchange(
  adapter,
  initialCall,
  directDependency,
  tModel,
  y,
  tNext)
  annotation (
    Include="#include <EnergyPlusWrapper.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources",
    Library={"ModelicaBuildingsEnergyPlus", "fmilib_shared"});
  annotation (
    Documentation(
      info="<html>
<p>
External function that exchanges data with EnergyPlus for an output variable.
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
end outputVariableExchange;
