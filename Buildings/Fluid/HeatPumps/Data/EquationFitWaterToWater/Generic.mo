within Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater;
record Generic
  "Generic data record for water to water heatpump equation fit method"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.HeatFlowRate QCon_flow_nominal
   "Nominal condenser heating capacity"
    annotation (Dialog(group="Nominal conditions heating dominated mode"));
  parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal(max=0)
   "Nominal evaporator cooling capacity_negative number"
    annotation (Dialog(group="Nominal conditions cooling dominated mode"));
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
   "Nominal condenser mass flow rate"
    annotation (Dialog(group="Nominal conditions heating dominated mode"));
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal
   "Nominal evaporator mass flow rate"
    annotation (Dialog(group="Nominal conditions cooling dominated mode"));
  parameter Modelica.SIunits.Power PH_nominal
   "Nominal compressor power heating mode"
    annotation (Dialog(group="Nominal conditions heating dominated mode"));
  parameter Modelica.SIunits.Power PC_nominal
   "Nominal compressor power cooling mode"
    annotation (Dialog(group="Nominal conditions cooling dominated mode"));
  constant Integer nCLR= 5
   "Number of coefficients for cooling load ratio CLR"
    annotation (Dialog(group="Equationfit cooling dominated load coefficients"));
  constant Integer nPRC= 5
  "Number of coefficients for power ratio in cooling mode"
    annotation (Dialog(group="Equationfit cooling dominated  power coefficients"));
  constant Integer nHLR=5
   "Number of coefficients for heating load ratio HLR"
    annotation (Dialog(group="Equationfit heating dominated load coefficients"));
  constant Integer nPRH=5
   "Number of coefficients for power ratio in heating mode"
    annotation (Dialog(group="Equationfit heating dominated  power coefficients"));
  parameter Real HLRC[nHLR]
   "Heating load ratio coefficients"
    annotation (Dialog(group="Equationfit heating dominated load coefficients"));
  parameter Real PHC[nPRH]
   "Power ratio coefficients in heating mode"
    annotation (Dialog(group="Equationfit heating dominated  power coefficients"));
  parameter Real CLRC[nCLR]
   "Cooling load ratio coefficients"
    annotation (Dialog(group="Equationfit cooling dominated load coefficients"));
  parameter Real PCC[nPRC]
   "Power ratio coefficients in cooling mode"
    annotation (Dialog(group="Equationfit cooling dominated  power coefficients"));
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
end Generic;
