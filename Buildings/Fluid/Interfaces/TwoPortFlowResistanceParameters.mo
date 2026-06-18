within Buildings.Fluid.Interfaces;
record TwoPortFlowResistanceParameters
  "Parameters for flow resistance for models with two ports"

  parameter Boolean computeFlowResistance = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance"));

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance,
                tab="Flow resistance"));
  parameter Real n(min=1, max=2) = 2
    "Flow exponent, n=1 for laminar, n=2 for turbulent"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dp_nominal(min=0, displayUnit=
        "Pa") "Pressure difference"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance,
               tab="Flow resistance"));
  parameter Real deltaM = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance, tab="Flow resistance"));

annotation (preferredView="info",
Documentation(info="<html>
This class contains parameters that are used to
compute the pressure drop in models that have one fluid stream.
Note that the nominal mass flow rate is not declared here because
the model
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
PartialTwoPortInterface</a>
already declares it.
</html>",
revisions="<html>
<ul>
<li>
June 17, 2026, by Michael Wetter:<br/>
Updated implementation to allow a flow coefficient <code>n</code> that is different from <code>2</code>.
This allows use of the model for not fully turbulent flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4620\">Buildings, #4620</a>.
</li>

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
end TwoPortFlowResistanceParameters;
