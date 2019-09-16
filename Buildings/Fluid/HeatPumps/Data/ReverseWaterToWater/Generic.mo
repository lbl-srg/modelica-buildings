within Buildings.Fluid.HeatPumps.Data.ReverseWaterToWater;
record Generic
  "Generic data record for reverse water to water heatpump implementing the equation fit method"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal
   "Nominal heating capacity"
    annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(max=0)
   "Nominal cooling capacity_negative number"
    annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
  parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal
   "Nominal mass flow rate at load heat exchanger side"
    annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
  parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal
   "Nominal mass flow rate at source heat exchanger side"
    annotation (Dialog(group="Nominal conditions at source heat exchanger side"));
  parameter Modelica.SIunits.Power P_nominal_hea
   "Nominal compressor power in heating mode"
    annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
  parameter Modelica.SIunits.Power P_nominal_coo
   "Nominal compressor power in cooling mode"
    annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
  parameter Real LRCH[nLRH]
   "Load ratio coefficients in heating mode"
    annotation (Dialog(group="Heating mode performance coefficients"));
  parameter Real LRCC[nLRC]
   "Load ratio coefficients in cooling mode"
    annotation (Dialog(group="Cooling mode performance coefficients"));
  parameter Real PRCH[nPRH]
   "Power ratio coefficients in heating mode"
    annotation (Dialog(group="Heating mode performance coefficients"));
  parameter Real PRCC[nPRC]
   "Power ratio coefficients in cooling mode"
    annotation (Dialog(group="Cooling mode performance coefficients"));
  parameter Modelica.SIunits.Temperature TRefHeaLoa
   "Reference temperature in heating mode used to normalize the Load heat exchanger inlet water temperature"
    annotation (Dialog(group="Refrence conditions"));
  parameter Modelica.SIunits.Temperature TRefHeaSou
   "Reference temperature in heating mode used to normalize the source heat exchanger inlet water temperature"
    annotation (Dialog(group="Refrence conditions"));
  parameter Modelica.SIunits.Temperature TRefCooSou
   "Reference temperature in cooling mode used to normalize the source heat exchanger inlet water temperature"
    annotation (Dialog(group="Refrence conditions"));
  parameter Modelica.SIunits.Temperature TRefCooLoa
   "Reference temperature in cooling mode used to normalize the load heat exchanger inlet water temperature"
    annotation (Dialog(group="Refrence conditions"));
  constant Integer nLRC= 5
   "Number of coefficients for cooling load ratio CLR";
  constant Integer nLRH=5
   "Number of coefficients for heating load ratio HLR";
  constant Integer nPRC= 5
  "Number of coefficients for power ratio in cooling mode";
  constant Integer nPRH=5
   "Number of coefficients for power ratio in heating mode";

annotation (
defaultComponentName="datPer",
defaultComponentPrefixes="parameter",
Documentation(info =        "<html>
  <p>This record is used as a template for performance data
  for the heatpump model
  <a href=\"Buildings.Fluid.HeatPumps.ReverseWaterToWater\">
  Buildings.Fluid.HeatPumps.ReverseWaterToWater</a>.
  </p>
  </html>",revisions="<html>
  <ul>
  <li>
  June 19, 2019 by Hagar Elarga:<br/>
  First implementation.
  </li>
  </ul>
</html>"));
end Generic;
