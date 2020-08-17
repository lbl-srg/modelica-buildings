within Buildings.Fluid.HeatPumps.Data.DOE2Reversible;
record Generic
  "Generic data record for reverse water to water heat pump implementing the doe2 method"
  extends Modelica.Icons.Record;

  Real COPCoo_nominal
    "Reference coefficient of performance, using the evaporator heat flow rate as useful heat"
    annotation (Dialog(group="Nominal condition"));

  parameter HeatingCoolingData hea
   "Performance data for heating mode";

  parameter HeatingCoolingData coo
    "Performance data for cooling mode";

  Modelica.SIunits.MassFlowRate m1_flow_nominal
    "Nominal mass flow rate used to compute pressure drop at medium 1";
  Modelica.SIunits.MassFlowRate m2_flow_nominal
    "Nominal mass flow rate used to compute pressure drop at medium 2";
  parameter Modelica.SIunits.PressureDifference dp1_nominal(
    final min=0,
    displayUnit="Pa") = 30000
    "Nominal pressure drop at hea.m1_flow_nominal";
  parameter Modelica.SIunits.PressureDifference dp2_nominal(
    final min=0,
    displayUnit="Pa") = 30000
    "Nominal pressure drop at hea.m2_flow_nominal";

  final parameter Boolean canHeat=hea.QEva_flow_nominal < -Modelica.Constants.eps
    "= true, if the heat pump can be operated in heating mode"
    annotation (Evaluate=true);
  final parameter Boolean canCool=coo.QEva_flow_nominal < -Modelica.Constants.eps
    "= true, if the heat pump can be operated in cooling mode"
    annotation (Evaluate=true);

protected
  record HeatingCoolingData "Record for performance data that are used for heating and cooling separately"
    Modelica.SIunits.HeatFlowRate QEva_flow_nominal(max=0)
      "Nominal capacity at evaporator (negative number)"
      annotation (Dialog(group="Nominal conditions at evaporator"));
    Real capFunT[6]
     "Biquadratic coefficients for capFunT"
      annotation (Dialog(group="Performance coefficients"));
    Real EIRFunT[6]
     "Biquadratic coefficients for EIRFunT"
      annotation (Dialog(group="Performance coefficients"));
    Real EIRFunPLR[4]
     "Coefficients for EIRFunPLR";
    Real PLRMax(min=0) "
     Maximum part load ratio";
    Real PLRMinUnl(min=0)
     "Minimum part unload ratio";
    Real PLRMin(min=0)
      "Minimum part load ratio";
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
