within Buildings.ThermalZones.EnergyPlus.BaseClasses;
function initialize "Initialization"
  input Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUZoneClass
    adapter "External object";
  output Modelica.SIunits.Area AFlo "Zone floor area";
  output Modelica.SIunits.Volume V "Zone air volume";
  external "C" FMUZoneInitialize(adapter, AFlo, V)
  annotation (Include="#include <FMUZoneInitialize.c>",
                   IncludeDirectory="modelica://Buildings/Resources/C-Sources");
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

end initialize;
