within Buildings.Fluid.HeatPumps.Data.ReverseWaterToWater;
record Generic
  "Generic data record for reverse water to water heat pump implementing the equation fit method"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(min=Modelica.Constants.eps)
   "Nominal heating capacity"
    annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(max=0)
   "Nominal cooling capacity_negative number"
    annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
  parameter Modelica.SIunits.MassFlowRate mLoa_flow
   "Nominal mass flow rate at load heat exchanger side"
    annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
  parameter Modelica.SIunits.MassFlowRate mSou_flow
   "Nominal mass flow rate at source heat exchanger side"
    annotation (Dialog(group="Nominal conditions at source heat exchanger side"));
  parameter Modelica.SIunits.Power PHea
   "Nominal compressor power in heating mode"
    annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
  parameter Modelica.SIunits.Power PCoo
   "Nominal compressor power in cooling mode"
    annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
  parameter Real coeLoaRatHea[5]
   "Load ratio coefficients in heating mode"
    annotation (Dialog(group="Heating mode performance coefficients"));
  parameter Real coeLoaRatCoo[5]
   "Load ratio coefficients in cooling mode"
    annotation (Dialog(group="Cooling mode performance coefficients"));
  parameter Real coePowRatHea[5]
   "Power ratio coefficients in heating mode"
    annotation (Dialog(group="Heating mode performance coefficients"));
  parameter Real coePowRatCoo[5]
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

annotation (
defaultComponentName="datPer",
defaultComponentPrefixes="parameter",
Documentation(info =        "<html>
  <p>This record is used as a template for performance data
  for the heat pump model
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
