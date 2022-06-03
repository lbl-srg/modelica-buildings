within Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses;
pure function getParameters
  "Get parameters for an EnergyPlus object"
  extends Modelica.Icons.Function;
  input Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.SpawnExternalObject adapter
    "External object";
  input Integer nParOut
    "Number of elements in parOut";
  input Real isSynchronized
    "Set to variable that is used to synchronize the objects";
  output Real parOut[nParOut]
    "Parameter values returned from EnergyPlus";
external "C" getParameters_Modelica_EnergyPlus_9_6_0(
  adapter,isSynchronized,parOut)
  annotation (
      Include="#include <EnergyPlus_9_6_0_Wrapper.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      Library={"ModelicaBuildingsEnergyPlus_9_6_0","fmilib_shared"});
  annotation (
    Documentation(
      info="<html>
<p>
External function that obtains parameters from the EnergyPlus FMU
and returns them to Modelica.
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
First implementation.
</li>
</ul>
</html>"));
end getParameters;
