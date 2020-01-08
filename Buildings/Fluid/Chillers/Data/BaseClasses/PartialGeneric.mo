within Buildings.Fluid.Chillers.Data.BaseClasses;
partial record PartialGeneric
  "Partial generic data record for absorption indirect chiller( steam and hot water)"
  extends Modelica.Icons.Record;

  parameter Boolean hotWater=false "Heat supplied to the generator by hot water"
    annotation (choices(checkBox=true));
  parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal(final max=0)
   "Nominal evaporator cooling capacity (negative number)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Power P_nominal "Nominal absorber pump power"
    annotation (Dialog(group="Nominal condition"));
  parameter Real PLRMax(min=0)
  "Maximum part load ratio"
   annotation (Dialog(group="Nominal condition"));
  parameter Real PLRMin(min=0)
  "Minimum part load ratio"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate at condenser"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal
    "Nominal mass flow rate at evaporator"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mGen_flow_nominal
    "Nominal mass flow rate at generator"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpCon_nominal(displayUnit="Pa") = 30000
    "Pressure difference at condenser at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpEva_nominal(displayUnit="Pa") = 30000
    "Pressure difference at evaporator at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpGen_nominal(displayUnit="Pa") = 30000
    "Pressure difference at generator at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Real capFunEva[4]
  "Cubic coefficients for the evaporator capacity factor as a function of temperature curve"
    annotation (Dialog(group="Performance curves"));
  parameter Real capFunCon[4]
  "Cubic coefficients for capFunCon for the condenser capacity factor as a function of temperature curve"
    annotation (Dialog(group="Performance curves"));
  parameter Real capFunGen[3]
  "Quadratic coefficients for capFunCon for the generator capacity factor as a function of temperature curve"
    annotation (Dialog(group="Performance curves"));
  parameter Real genHIR[4]
  "Cubic coefficients for the generator heat input to chiller operating capacity"
    annotation (Dialog(group="Performance curves"));
  parameter Real genConT[4]
  "Cubic coefficients for heat input modifier based on the generator input temperature"
    annotation (Dialog(group="Performance curves"));
  parameter Real genEvaT[4]
  "Cubic coefficients for heat input modifier based on the evaporator input temperature"
    annotation (Dialog(group="Performance curves"));
  parameter Real EIRP[3]
  "Quadratic coefficients for the actual absorber pumping power to the nominal pumping power"
    annotation (Dialog(group="Performance curves"));

annotation (
    defaultComponentPrefixes="parameter",
    Documentation(info=
                "<html>
<p>
This record is used as a partial template of performance data
for the indirect absorption chiller models
<a href=\"Buildings.Fluid.Chillers.AbsorptionIndirectSteamSwitchableRecords\">
Buildings.Fluid.Chillers.AbsorptionIndirectSteamSwitchableRecords</a> and 
<a href=\"Buildings.Fluid.Chillers.AbsorptionIndirectHotWaterSwitchableRecords\">
Buildings.Fluid.Chillers.AbsorptionIndirectHotWaterSwitchableRecords</a>
</p>
</html>",
revisions="<html>
<ul>
<li>
January 7, 2020 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialGeneric;
