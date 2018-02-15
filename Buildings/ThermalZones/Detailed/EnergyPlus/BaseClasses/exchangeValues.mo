within Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses;
function exchangeValues "Exchange the values for the thermal zone"
  input Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.FMUZoneAdapter adapter
    "External object";
  input Modelica.SIunits.Temperature TAir "Zone air temperature";
  input Modelica.SIunits.HeatFlowRate Q_flow "Heat flow rate";
  output Real dT_dt "Time derivative of zone temperature";
  external "C" dT_dt = FMUZoneExchange(adapter, TAir, Q_flow)
  annotation (Include="#include <FMUZoneExchange.c>",
                   IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation (Documentation(info="<html>
<p>
External function that exchanges data with EnergyPlus for the current thermal zone.
</p>
</html>", revisions="<html>
<ul><li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end exchangeValues;
