within Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses;
function exchange "Exchange the values for the thermal zone"
  input Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.FMUZoneClass
    adapter "External object";
  input Modelica.SIunits.Temperature T "Zone air temperature";
  input Modelica.SIunits.MassFraction X "Zone air mass fraction in kg/kg total air";
  input Modelica.SIunits.MassFlowRate m_flow[:] "Mass flow rate (positive if mass flows into the zone)";
  input Modelica.SIunits.Temperature TInlet[:] "Air inlet temperatures";
  input Modelica.SIunits.HeatFlowRate QGaiRad_flow
    "Radiative heat gain (positive if heat gain)";
  input Modelica.SIunits.Time tModel "Current model time";
  output Modelica.SIunits.Temperature TRad "Radiative temperature";
  output Modelica.SIunits.HeatFlowRate QGaiCon_flow
    "Convective sensible heat gain (positive if heat is added to zone air)";
  output Modelica.SIunits.HeatFlowRate  QGaiLat_flow "Latent heat gain (positive if heat is added to zone air)";
  output Modelica.SIunits.HeatFlowRate  QPeo_flow "Total heat gain from people (positive if heat is added to zone air)";
  output Modelica.SIunits.Time tNext "Next time that the zone need to be invoked";

  external "C" FMUZoneExchange(adapter,
    T, X, m_flow, TInlet, QGaiRad_flow, tModel,
    TRad, QGaiCon_flow, QGaiLat_flow, QPeo_flow, tNext)
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
end exchange;
