within Buildings.Fluid.Interfaces;
record EightPortFlowResistanceParameters
  "Parameters for flow resistance for models with height ports"

  parameter Boolean computeFlowResistance1 = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 1"));

  parameter Boolean from_dp1 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance1,
                tab="Flow resistance", group="Medium 1"));
  parameter Modelica.SIunits.Pressure dp1_nominal(min=0, displayUnit="Pa")
    "Pressure" annotation(Dialog(group = "Nominal condition"));
  parameter Boolean linearizeFlowResistance1 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance1,
               tab="Flow resistance", group="Medium 1"));
  parameter Real deltaM1 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance1,
                      tab="Flow resistance", group="Medium 1"));
  parameter Boolean computeFlowResistance2 = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 2"));

  parameter Boolean from_dp2 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance2,
                tab="Flow resistance", group="Medium 2"));
  parameter Modelica.SIunits.Pressure dp2_nominal(min=0, displayUnit="Pa")
    "Pressure" annotation(Dialog(group = "Nominal condition"));
  parameter Boolean linearizeFlowResistance2 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance2,
               tab="Flow resistance", group="Medium 2"));
  parameter Real deltaM2 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance2,
                      tab="Flow resistance", group="Medium 2"));
  parameter Boolean computeFlowResistance3 = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 3"));

  parameter Boolean from_dp3 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance3,
                tab="Flow resistance", group="Medium 3"));
  parameter Modelica.SIunits.Pressure dp3_nominal(min=0, displayUnit="Pa")
    "Pressure" annotation(Dialog(group = "Nominal condition"));
  parameter Boolean linearizeFlowResistance3 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance3,
               tab="Flow resistance", group="Medium 3"));
  parameter Real deltaM3 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance3,
                      tab="Flow resistance", group="Medium 3"));
  parameter Boolean computeFlowResistance4 = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 4"));

  parameter Boolean from_dp4 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance4,
                tab="Flow resistance", group="Medium 4"));
  parameter Modelica.SIunits.Pressure dp4_nominal(min=0, displayUnit="Pa")
    "Pressure" annotation(Dialog(group = "Nominal condition"));
  parameter Boolean linearizeFlowResistance4 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance4,
               tab="Flow resistance", group="Medium 4"));
  parameter Real deltaM4 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance4,
                      tab="Flow resistance", group="Medium 4"));

annotation (preferredView="info",
Documentation(info="<html>
<p>
This class contains parameters that are used to
compute the pressure drop in components that have four fluid streams.
Note that the nominal mass flow rate is not declared here because
the model
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialEightPortInterface\">
PartialHeightPortInterface</a>
already declares it.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 28, 2015, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end EightPortFlowResistanceParameters;
