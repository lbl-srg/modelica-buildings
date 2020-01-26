within Buildings.Fluid.HeatPumps.Data.DOE2Reversible;
record Generic
  "Generic data record for reverse water to water heat pump implementing the doe2 method"
  extends Modelica.Icons.Record;

  parameter HeatingCoolingData coo "Performance data for heating mode";
  parameter HeatingCoolingData hea(
     mLoa_flow = coo.mLoa_flow,
     mSou_flow = coo.mSou_flow,
     COP_nominal=coo.COP_nominal,
     Q_flow=coo.Q_flow)
   "Performance data for cooling mode (set coo.P = 0 to disable operation in cooling mode)";
  parameter Modelica.SIunits.PressureDifference dpHeaLoa_nominal(min=0) = 30000
   "Nominal pressure drop at load heat exchanger side at hea.mLoa_flow";
  parameter Modelica.SIunits.PressureDifference dpHeaSou_nominal(min=0) = 30000
   "Nominal pressure drop at load heat exchanger side at hea.mSou_flow";

protected
  record HeatingCoolingData "Record for performance data that are used for heating and cooling separately"
    parameter Modelica.SIunits.HeatFlowRate Q_flow
     "Nominal capacity"
      annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
    parameter Modelica.SIunits.MassFlowRate mLoa_flow
     "Nominal mass flow rate at load heat exchanger side";
    parameter Modelica.SIunits.MassFlowRate mSou_flow
     "Nominal mass flow rate at source heat exchanger side";
    parameter Real CapFunT[6]
     "Biquadratic coefficients for capFunT"
      annotation (Dialog(group="Performance coefficients"));
    parameter Real EIRFunT[6]
     "Biquadratic coefficients for EIRFunT"
      annotation (Dialog(group="Performance coefficients"));
    parameter Real EIRFunPLR[4]
     "Coefficients for EIRFunPLR";
    parameter Real COP_nominal
     "Reference coefficient of performance"
      annotation (Dialog(group=
      "Nominal condition"));
    parameter Real PLRMax(min=0) "
     Maximum part load ratio";
    parameter Real PLRMinUnl(min=0)
     "Minimum part unload ratio";
    parameter Real PLRMin(min=0) "Minimum part load ratio";

    annotation (Dialog(group="Performance coefficients"),
                Documentation(info="<html>
<p>
Performance data for the heating or cooling mode of the DOE2 reversible heat pump
<a href=\"modelica://Buildings.Fluid.HeatPumps.DOE2Reversible\">
Buildings.Fluid.HeatPumps.DOE2Reversible</a>.
</p>
</html>"));
  end HeatingCoolingData;

annotation (
defaultComponentName="per",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
This record is used as a template for performance data
for the heat pump model
<a href=\"Buildings.Fluid.HeatPumps.DOE2Reversible\">
Buildings.Fluid.HeatPumps.DOE2Reversible</a>.
</p>
</html>",  revisions="<html>
<ul>
<li>
June 19, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
