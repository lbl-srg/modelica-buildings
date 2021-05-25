within Buildings.ThermalZones.EnergyPlus.BaseClasses;
function initialize
  "Initialization for an EnergyPlus thermal zone"
  extends Modelica.Icons.Function;
  input Buildings.ThermalZones.EnergyPlus.BaseClasses.SpawnExternalObject adapter
    "External object";
  input Real isSynchronized
    "Set to variable that is used to synchronize the objects";
  output Integer nObj
    "Returns 1 from C, used to force synchronization";
external "C" ModelicaSpawnInitialize(
  adapter,isSynchronized,nObj)
  annotation (
      Include="#include <EnergyPlusWrapper.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      Library={"ModelicaBuildingsEnergyPlus","fmilib_shared"});
  annotation (
    Documentation(
      info="<html>
<p>
External function that generates the EnergyPlus FMU.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 18, 2021, by Michael Wetter:<br/>
Refactor synchronization of constructors.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2360\">#2360</a>.
</li>
<li>
March 1, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end initialize;
