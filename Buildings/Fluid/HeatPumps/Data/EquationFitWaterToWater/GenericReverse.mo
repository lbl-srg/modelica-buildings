within Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater;
record GenericReverse
  "Generic data record for water to water heatpump equation fit method"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.HeatFlowRate QHeaLoa_flow_nominal
   "Nominal condenser heating capacity"
    annotation (Dialog(group="Nominal conditions heating mode"));
  parameter Modelica.SIunits.HeatFlowRate QCooLoa_flow_nominal(max=0)
   "Nominal evaporator cooling capacity_negative number"
    annotation (Dialog(group="Nominal conditions cooling mode"));
  parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal
   "Nominal condenser mass flow rate"
    annotation (Dialog(group="Nominal conditions heating mode"));
  parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal
   "Nominal evaporator mass flow rate"
    annotation (Dialog(group="Nominal conditions cooling mode"));
  parameter Modelica.SIunits.Power P_nominal_hea
   "Nominal compressor power heating mode"
    annotation (Dialog(group="Nominal conditions heating mode"));
  parameter Modelica.SIunits.Power P_nominal_coo
   "Nominal compressor power cooling mode"
    annotation (Dialog(group="Nominal conditions cooling mode"));
  parameter Real LRCH[nLRH]
   "Load ratio coefficients in heating mode"
    annotation (Dialog(group="Equation fit heating mode load coefficients"));
  parameter Real LRCC[nLRC]
   "Load ratio coefficients in cooling mode"
    annotation (Dialog(group="Equation fit cooling load coefficients"));
  parameter Real PRCH[nPRH]
   "Power ratio coefficients in heating mode"
    annotation (Dialog(group="Equation fit heating power coefficients"));
  parameter Real PRCC[nPRC]
   "Power ratio coefficients in cooling mode"
    annotation (Dialog(group="Equation fit cooling power coefficients"));
  parameter Modelica.SIunits.Temperature TRefHeaCon
   "Reference temperature in heating mode used to normalize the condenser inlet water temperature"
    annotation (Dialog(group="Refrence condition"));
  parameter Modelica.SIunits.Temperature TRefHeaEva
   "Reference temperature in heating mode used to normalize the evaporator inlet water temperature"
    annotation (Dialog(group="Refrence condition"));
  parameter Modelica.SIunits.Temperature TRefCooCon
   "Reference temperature in cooling mode used to normalize the condenser inlet water temperature"
    annotation (Dialog(group="Refrence condition"));
  parameter Modelica.SIunits.Temperature TRefCooEva
   "Reference temperature in cooling mode used to normalize the evaporator inlet water temperature"
    annotation (Dialog(group="Refrence condition"));
  constant Integer nLRC= 5
   "Number of coefficients for cooling load ratio CLR"
    annotation (Dialog(group="Equation fit cooling mode load coefficients"));
  constant Integer nLRH=5
   "Number of coefficients for heating load ratio HLR"
    annotation (Dialog(group="Equation fit heating mode load coefficients"));
  constant Integer nPRC= 5
  "Number of coefficients for power ratio in cooling mode"
    annotation (Dialog(group="Equation fit cooling mode power coefficients"));
  constant Integer nPRH=5
   "Number of coefficients for power ratio in heating mode"
    annotation (Dialog(group="Equation fit heating mode power coefficients"));

annotation (
defaultComponentName="datPer",
defaultComponentPrefixes="parameter",
Documentation(info =        "<html>
  <p>This record is used as a template for performance data
  for the heatpump model
  <a href=\"Buildings.Fluid.HeatPumps.EquationFitWaterToWater\">
  Buildings.Fluid.HeatPumps.EquationFitWaterToWater</a>.
  </p>
  </html>",revisions="<html>
  <ul>
  <li>
  June 19, 2019 by Hagar Elarga:<br/>
  First implementation.
  </li>
  </ul>
</html>"));
end GenericReverse;
