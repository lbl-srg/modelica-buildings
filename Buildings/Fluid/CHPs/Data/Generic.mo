within Buildings.Fluid.CHPs.Data;
record Generic "Generic data for CHP models"
  extends Modelica.Icons.Record;
  parameter Real[27] coeEtaQ
    "Vector of coefficients used to calculate thermal efficiency of the engine.
    The independent variable x1 is the steady-state power output,
    x2 is the cooling water mass flow rate, x3 is the cooling water inlet temperature.
    From index 1 to 27, coefficients correspond to the following terms:
    constant, x1^2, x1, x2^2, x2, x3^2, x3,
    x1^2*x2^2, x1*x2, x1*x2^2, x1^2*x2,
    x1^2*x3^2, x1*x3, x1*x3^2, x1^2*x3,
    x2^2*x3^2, x2*x3, x2*x3^2, x2^2*x3,
    x1^2*x2^2*x3^2, x1^2*x2^2*x3, x1^2*x2*x3^2, x1*x2^2*x3^2,
    x1^2*x2*x3, x1*x2^2*x3,  x1*x2*x3^2, x1*x2*x3";
  parameter Real[27] coeEtaE
    "Vector of coefficients used to calculate electrical conversion efficiency
    of the engine. The independent variables and mapping of the coefficients
    to the polynomial terms are the same as for the thermal efficiency";
  parameter Boolean compute_coolingWaterFlowRate=true
    "If true, then an empirical correlation is used to calculate
    cooling water mass flow rate based on internal control";
  parameter Real[6] coeMasWat
    "Vector of coefficients used to calculate cooling water mass flow rate
    in case coolingWaterControl is true.
    The independent variable x1 is the steady-state power output,
    x2 is the cooling water mass flow rate.
    From index 1 to 6, coefficients correspond to the following terms:
    constant, x1, x1^2, x2, x2^2, x1*x2";
  parameter Real[3] coeMasAir
    "Vector of coefficients used to calculate air mass flow rate.
    The independent variable x1 is the fuel mass flow rate.
    From index 1 to 3, coefficients correspond to the following terms:
    constant, x1, x1^2";
  parameter Modelica.Units.SI.ThermalConductance UAHex
    "Thermal conductance between the engine and cooling water";
  parameter Modelica.Units.SI.ThermalConductance UALos
    "Thermal conductance between the engine and surroundings";
  parameter Modelica.Units.SI.HeatCapacity capEng
    "Thermal capacitance of the engine control volume";
  parameter Modelica.Units.SI.HeatCapacity capHeaRec
    "Thermal capacitance of heat recovery portion";
  parameter Boolean warmUpByTimeDelay=true
    "If true, the plant will be in warm-up mode depending on the delay time,
    otherwise depending on engine temperature ";
  parameter Modelica.Units.SI.Time timeDelayStart=60
    "Time delay between activation and power generation";
  parameter Modelica.Units.SI.Temperature TEngNom=273.15 + 100
    "Nominal engine operating temperature";
  parameter Boolean coolDownOptional=false
    "If true, cooldown is optional. The model will complete cooldown before
    switching to standby, but if reactivated during cooldown period, it
    will immediately switch into warm-up mode";
  parameter Modelica.Units.SI.Time timeDelayCool=0 "Cooldown period";
  parameter Modelica.Units.SI.Power PEleMax "Maximum power output";
  parameter Modelica.Units.SI.Power PEleMin=0 "Minimum power output";
  parameter Modelica.Units.SI.MassFlowRate mWatMin_flow=0
    "Minimum cooling water mass flow rate";
  parameter Modelica.Units.SI.Temperature TWatMax=373.15
    "Maximum cooling water temperature";
  parameter Boolean use_powerRateLimit=false
    "If true, the rate at which net power output can change is limited";
  parameter Boolean use_fuelRateLimit=false
    "If true, the rate at which fuel mass flow rate can change is limited";
  parameter Real dPEleMax(final unit="W/s")
    "Maximum rate at which net power output can change";
  parameter Real dmFueMax_flow(final unit="kg/s2")
    "Maximum rate at which fuel mass flow rate can change";
  parameter Modelica.Units.SI.Power PStaBy "Standby electric power";
  parameter Modelica.Units.SI.Power PCooDow "Cooldown electric power";
  parameter Real LHVFue(final unit="J/kg") = 47.614e6
    "Lower heating value of fuel";
  parameter Real kF(final unit="1") = 1
    "Warm-up fuel coefficient";
  parameter Real kP(final unit="1") = 1
    "Warm-up power coefficient";
  parameter Real rFue(final unit="1") = 10
    "Warm-up maximum fuel flow ratio";
annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(preferredView="info",
  info="<html>
<p>
This is the base record for CHP models.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 8, 2020, by Antoine Gautier:<br/>
Updated parameter names and descriptions.
</li>
<li>
March 08, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
