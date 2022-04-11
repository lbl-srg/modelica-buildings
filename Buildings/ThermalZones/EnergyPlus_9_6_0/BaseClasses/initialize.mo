within Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses;
pure function initialize
  "Initialization for an EnergyPlus thermal zone"
  extends Modelica.Icons.Function;
  input Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.SpawnExternalObject adapter
    "External object";
  input Real isSynchronized
    "Set to variable that is used to synchronize the objects";
  output Integer nObj
    "Returns 1 from C, used to force synchronization";
external "C" initialize_Modelica_EnergyPlus_9_6_0(
  adapter,isSynchronized,nObj)
  annotation (
      Include="#include <EnergyPlus_9_6_0_Wrapper.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      Library={"ModelicaBuildingsEnergyPlus_9_6_0","fmilib_shared"});
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
December 11, 2021, by Michael Wetter:<br/>
Declared function as <code>pure</code> for MSL 4.0.0.
</li>
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
