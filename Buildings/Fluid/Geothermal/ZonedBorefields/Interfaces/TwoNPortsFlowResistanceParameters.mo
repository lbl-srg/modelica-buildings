within Buildings.Fluid.Geothermal.ZonedBorefields.Interfaces;
record TwoNPortsFlowResistanceParameters
  "Parameters for flow resistance for models with two N ports"
  extends Modelica.Icons.Record;

  parameter Integer nPorts(min=1)
    "Number of fluid ports on each side";

  parameter Boolean computeFlowResistance[nPorts] = fill(true, nPorts)
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance"));

  parameter Boolean from_dp[nPorts] = fill(false, nPorts)
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance,
                tab="Flow resistance"));
  parameter Real n[nPorts](min=1, max=2) = 2
    "Flow exponent, n[nPorts]=1 for laminar, n[nPorts]=2 for turbulent"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dp_nominal[nPorts](
    each min=0,
    each displayUnit="Pa") "Pressure difference"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean linearizeFlowResistance[nPorts] = fill(false, nPorts)
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance,
               tab="Flow resistance"));
  parameter Real deltaM[nPorts] = fill(0.1, nPorts)
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance, tab="Flow resistance"));

annotation (preferredView="info",
Documentation(info="<html>
<p>
This class contains parameters that are used to
compute the pressure drop in models that have one fluid stream.
Note that the nominal mass flow rate is not declared here because the model
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Interfaces.PartialTwoNPortsInterface\">
PartialTwoNPortsInterface</a>
already declares it.
</p>
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
February, 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoNPortsFlowResistanceParameters;
