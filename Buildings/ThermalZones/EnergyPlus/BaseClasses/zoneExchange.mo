within Buildings.ThermalZones.EnergyPlus.BaseClasses;
function zoneExchange
  "Exchange the values with the EnergyPlus thermal zone"
  extends Modelica.Icons.Function;
  input Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUZoneClass adapter
    "External object";
  input Boolean initialCall
    "Set to true if initial() is true, false otherwise";
  input Modelica.SIunits.Temperature T
    "Zone air temperature";
  input Modelica.SIunits.MassFraction X
    "Zone air mass fraction in kg/kg total air";
  input Modelica.SIunits.MassFlowRate mInlet_flow
    "Sum of positive mass flow rates into
    the zone for all air inlets (including infiltration)";
  input Modelica.SIunits.Temperature TAveInlet
    "Average of inlet medium temperatures
    carried by the mass flow rates";
  input Modelica.SIunits.HeatFlowRate QGaiRad_flow
    "Radiative heat gain (positive if heat gain)";
  input Modelica.SIunits.Area AFlo
    "Floor area (used to force Modelica tools to call initialize())";
  input Modelica.SIunits.Time tModel
    "Current model time";
  output Modelica.SIunits.Temperature TRad
    "Radiative temperature";
  output Modelica.SIunits.HeatFlowRate QCon_flow
    "Convective sensible heat to be added to zone air
    (positive if heat is added to zone air)";
  output Real dQCon_flow(
    unit="W/K")
    "Derivative dQCon_flow / dT";
  output Modelica.SIunits.HeatFlowRate QLat_flow
    "Latent heat gain to be added to zone air (positive if heat is added to zone air)";
  output Modelica.SIunits.HeatFlowRate QPeo_flow
    "Total heat gain from people, to be used to optionall compute CO2 emitted (positive if heat is added to zone air)";
  output Modelica.SIunits.Time tNext
    "Next time that the zone need to be invoked";
external "C" SpawnZoneExchange(
  adapter,
  initialCall,
  T,
  X,
  mInlet_flow,
  TAveInlet,
  QGaiRad_flow,
  AFlo,
  tModel,
  TRad,
  QCon_flow,
  dQCon_flow,
  QLat_flow,
  QPeo_flow,
  tNext)
  annotation (
    Include="#include <EnergyPlusWrapper.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources",
    Library={"ModelicaBuildingsEnergyPlus", "fmilib_shared"});
  annotation (
    Documentation(
      info="<html>
<p>
External function that exchanges data with EnergyPlus for the current thermal zone.
</p>
</html>",
      revisions="<html>
<ul><li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end zoneExchange;
