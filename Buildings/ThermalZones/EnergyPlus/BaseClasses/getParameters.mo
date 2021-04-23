within Buildings.ThermalZones.EnergyPlus.BaseClasses;
function getParameters
  "Get parameters for an EnergyPlus object"
  extends Modelica.Icons.Function;
  input Buildings.ThermalZones.EnergyPlus.BaseClasses.SpawnExternalObject adapter
    "External object";
  input Integer nParOut
    "Number of elements in parOut";
  input Real isSynchronized
    "Set to variable that is used to synchronize the objects";
  output Real parOut[nParOut]
    "Parameter values returned from EnergyPlus";
external "C" ModelicaSpawnGetParameters(
  adapter,isSynchronized,parOut)
  annotation (
      Include="#include <EnergyPlusWrapper.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      Library={"ModelicaBuildingsEnergyPlus","fmilib_shared"});
  annotation (
    Documentation(
      info="<html>
<p>
External function that obtains parameters from the EnergyPlus FMU
and returns them to Modelica.
</p>
</html>",
      revisions="<html>
<ul><li>
February 18, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end getParameters;
