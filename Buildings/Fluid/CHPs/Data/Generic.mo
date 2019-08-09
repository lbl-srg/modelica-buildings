within Buildings.Fluid.CHPs.Data;
record Generic "Generic data"
  extends Modelica.Icons.Record;

  parameter Real[27] coeEtaQ = {0}
    "Vector of coefficients used to calculate thermal efficiency of the engine. The independent variables are x1=PNetSs, x2=mWat, x3=TWat.
    Coefficients next to the terms have the following order:
    constant, x1^2, x1, x2^2, x2, x3^2, x3, 
    x1^2*x2^2, x1*x2, x1*x2^2, x1^2*x2,
    x1^2*x3^2, x1*x3, x1*x3^2, x1^2*x3,
    x2^2*x3^2, x2*x3, x2*x3^2, x2^2*x3,
    x1^2*x2^2*x3^2,  x1^2*x2^2*x3,  x1^2*x2*x3^2,  x1*x2^2*x3^2,
    x1^2*x2*x3, x1*x2^2*x3,  x1*x2*x3^2,  x1*x2*x3";

  parameter Real[27] coeEtaE = {0}
    "Vector of coefficients used to calculate electrical conversion efficiency of the engine. 
    The independent varilables and order of the coefficients are the same as for the thermal efficiency";

  parameter Boolean coolingWaterControl=true
    "If true, then empirical correlation is used to calculte cooling water mass flow rate based on internal control";

  parameter Real[6] coeMasWat = {0}
    "Vector of coefficients used to calculate cooling water mass flow rate. Used if coolingWaterControl = true.
    The independent variables are x1=PNetSs,x2=TWat.
    Coefficients next to the terms have the following order:
    constant, x1, x1^2, x2, x2^2, x3^2, x1*x2";

  parameter Real[3] coeMasAir = {0}
    "Vector of coefficients used to calculate air mass flow rate.
    The independent variable is x1=mFue.
    Coefficients next to the terms have the following order:
    constant, x1, x1^2";

  parameter Modelica.SIunits.ThermalConductance UAhx = 0
    "Thermal conductance between the engine and cooling water";

  parameter Modelica.SIunits.ThermalConductance UAlos = 0
    "Thermal conductance between the engine and surroundings";

  parameter Modelica.SIunits.HeatCapacity MCeng = 0
    "Thermal capacitance of the engine control volume";

  parameter Modelica.SIunits.HeatCapacity MCcw = 0
    "Thermal capacitance of heat recovery portion";

  parameter Boolean warmUpByTimeDelay=true
    "If true, warm up control sequence depending on startUpTimeDelay else depending on engine temperature ";

  parameter Modelica.SIunits.Time timeDelayStart = 60
    "Time delay between activation and power generation";

  parameter Modelica.SIunits.Temperature TEngNom = 273.15+100
    "Nominal engine operating temperature";

  parameter Boolean coolDownOptional=false
    "If true, cooldown is optional. The model will complete cooldown before switching to standby,   
    but if reactivated during cooldown period, it will immediately switch into warmup mode";

  parameter Modelica.SIunits.Time timeDelayCool = 0
    "Cooldown period";

  parameter Modelica.SIunits.Power PEleMax = 1000000
    "Maximum electric power";

  parameter Modelica.SIunits.Power PEleMin = 0
  "Minimum electric power";

  parameter Modelica.SIunits.MassFlowRate mWatMin = 0
  "Minimum cooling water flow rate";

  parameter Modelica.SIunits.Temperature TWatMax = 373.15
  "Maximum cooling water temperature";

  parameter Boolean dPEleLim=false
  "If true, net electrical power rate of change is limited by the value dPEleMax";

  parameter Boolean dmFueLim=false
  "If true, fuel flow rate of change is limited by the value dmFueMax";

  parameter Real dPEleMax = 0
  "Maximum net electrical power rate of change in W/s";

  parameter Real dmFueMax = 0
  "Maximum fuel flow rate of change in kg/s2";

  parameter Modelica.SIunits.Power PStaBy = 0
  "Standby electric power";

  parameter Modelica.SIunits.Power PCooDow = 0
  "Cooldown electric power";

  parameter Real LHVFue(final unit="J/kg") = 47.614e6
  "Lower heating value of fuel";

  parameter Real kF(final unit="1") = 1
  "Warm up fuel coefficient";

  parameter Real kP(final unit="1") = 1
  "Warm up power coefficient";

  parameter Real rFue(final unit="1") = 10
  "Warm up maximum fuel flow ratio";

  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(revisions="<html>
<ul>
<li>
March 08, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
