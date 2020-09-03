within Buildings.ThermalZones.EnergyPlus.BaseClasses;
function outputVariableInitialize
  "Initialization for an EnergyPlus output variable"
  extends Modelica.Icons.Function;

  input Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUOutputVariableClass
    adapter "External object";
  input Modelica.SIunits.Time startTime "Start time of the simulation";

  external "C" OutputVariableInstantiate(adapter, startTime)
      annotation (Library={"ModelicaBuildingsEnergyPlus", "fmilib_shared"});
      // dl provides dlsym to load EnergyPlus dll, which is needed by OpenModelica compiler


  annotation (Documentation(info="<html>
<p>
External function to initialize the EnergyPlus output variable.
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

end outputVariableInitialize;
