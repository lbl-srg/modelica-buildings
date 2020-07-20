within Buildings.Fluid.HeatPumps.Data.EquationFitReversible;
record Generic
  "Generic data record for reverse water to water heat pump implementing the equation fit method"
  extends Modelica.Icons.Record;

  parameter HeatingCoolingData hea "Performance data for heating mode";
  parameter HeatingCoolingData coo(
     mLoa_flow = hea.mLoa_flow,
     mSou_flow = hea.mSou_flow)
   "Performance data for cooling mode (set coo.P = 0 to disable operation in cooling mode)";
  parameter Modelica.SIunits.PressureDifference dpHeaLoa_nominal(min=0) = 30000
   "Nominal pressure drop at load heat exchanger side at hea.mLoa_flow";
  parameter Modelica.SIunits.PressureDifference dpHeaSou_nominal(min=0) = 30000
   "Nominal pressure drop at load heat exchanger side at hea.mSou_flow";

  final parameter Boolean reverseCycle=coo.P > Modelica.Constants.eps
    "= true, if the heat pump can be reversed to also operate in cooling mode"
      annotation(Evaluate=true);

protected
  record HeatingCoolingData "Record for performance data that are used for heating and cooling separately"
    parameter Modelica.SIunits.HeatFlowRate Q_flow
     "Nominal capacity"
      annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
    parameter Modelica.SIunits.Power P
    "Nominal compressor power"
      annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
    parameter Modelica.SIunits.MassFlowRate mLoa_flow
     "Nominal mass flow rate at load heat exchanger side";
    parameter Modelica.SIunits.MassFlowRate mSou_flow
     "Nominal mass flow rate at source heat exchanger side";
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
    annotation (Documentation(info="<html>
<p>
Performance data for the heating or cooling mode of the reverse heat pump
<a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>.
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
<a href=\"Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>.
</p>
</html>",  revisions="<html>
<ul>
<li>
September 16, 2019 by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 19, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
