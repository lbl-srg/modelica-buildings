within Buildings.Fluid.Interfaces;
record FourPortFlowResistanceParameters
  "Parameters for flow resistance for models with four ports"

  parameter Boolean computeFlowResistance1 = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 1"));

  parameter Boolean from_dp1 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance1,
                tab="Flow resistance", group="Medium 1"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal(min=0,
                                                            displayUnit="Pa")
    "Pressure difference"
    annotation(Dialog(group = "Nominal condition"));
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
  parameter Modelica.SIunits.PressureDifference dp2_nominal(min=0,
                                                            displayUnit="Pa")
    "Pressure difference"
    annotation(Dialog(group = "Nominal condition"));
  parameter Boolean linearizeFlowResistance2 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance2,
               tab="Flow resistance", group="Medium 2"));
  parameter Real deltaM2 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance2,
                      tab="Flow resistance", group="Medium 2"));
annotation (preferredView="info",
Documentation(info="<html>
<p>
This class contains parameters that are used to
compute the pressure drop in components that have two fluid streams.
Note that the nominal mass flow rate is not declared here because
the model
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialFourPortInterface\">
PartialFourPortInterface</a>
already declares it.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FourPortFlowResistanceParameters;
