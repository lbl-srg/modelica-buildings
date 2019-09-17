within Buildings.Fluid.HeatPumps.Data.ReverseWaterToWater;
record Generic
  "Generic data record for reverse water to water heat pump implementing the equation fit method"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.MassFlowRate mLoa_flow
   "Nominal mass flow rate at load heat exchanger side";
  parameter Modelica.SIunits.MassFlowRate mSou_flow
   "Nominal mass flow rate at source heat exchanger side";

  parameter HeatingCoolingData hea "Performance data for heating mode";
  parameter HeatingCoolingData coo "Performance data for cooling model";

protected
  record HeatingCoolingData "Record for performance data that are used for heating and cooling separately"
    parameter Modelica.SIunits.HeatFlowRate Q_flow
     "Nominal capacity"
      annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
    parameter Modelica.SIunits.Power P
    "Nominal compressor power"
      annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
    parameter Real coeQ[5]
     "Load ratio coefficients"
      annotation (Dialog(group="Performance coefficients"));
    parameter Real coeP[5]
     "Power ratio coefficients"
      annotation (Dialog(group="Electrical power performance coefficients"));
    parameter Modelica.SIunits.Temperature TRefLoa
     "Reference temperature used to normalize the load heat exchanger inlet water temperature"
      annotation (Dialog(group="Reference conditions"));
    parameter Modelica.SIunits.Temperature TRefSou
     "Reference temperature used to normalize the source heat exchanger inlet water temperature"
      annotation (Dialog(group="Reference conditions"));
  end HeatingCoolingData;

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
