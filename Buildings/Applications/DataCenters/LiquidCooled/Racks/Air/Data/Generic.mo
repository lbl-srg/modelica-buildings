within Buildings.Applications.DataCenters.LiquidCooled.Racks.Air.Data;
record Generic "Generic data record for air cooled rack"
  extends Buildings.Applications.DataCenters.LiquidCooled.Racks.BaseClasses.Data.Generic(
    m_flow_nominal = P_nominal/(dTSet*cp_default),
    dp_nominal=200,
    n=2);

  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    fanHydraulicEfficiency(
      V_flow=m_flow_nominal/Buildings.Media.Air.dStp*{0},
      eta={0.7}) "Fan hydraulic efficiency vs. volumetric flow rate";

  parameter Modelica.Units.SI.Efficiency etaMot_max = 0.9
    "Maximum fan motor efficiency"
    annotation(Dialog(group="Motor efficiency and power"));
  parameter Modelica.Units.SI.Power WMot_nominal = m_flow_nominal/Buildings.Media.Air.dStp *dp_nominal / etaMot_max / max(fanHydraulicEfficiency.eta)
    "Approximate motor maximum power use. Used only to parameterize shape of efficiency curve, whose peak is given by etaMot_max"
    annotation(Dialog(group="Motor efficiency and power"));

  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot
    fanMotorEfficiency_yMot=
        Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve(
          P_nominal=WMot_nominal,
          eta_max=etaMot_max)
    "Fan motor efficiency vs part load"
    annotation(Dialog(group="Motor efficiency and power"));

  constant Modelica.Units.SI.SpecificHeatCapacity cp_default = 1014.54
    "Specific heat capacity";

  parameter Modelica.Units.SI.TemperatureDifference dTSet(min=1) = 10
    "Set point for temperature raise across rack";

annotation (
  defaultComponentName="dat",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic data record for air-cooled IT rack.
<p>
</html>", revisions="<html>
<ul>
<li>
June 26, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
