within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model BasicFlowFunction_m_flow_DerivativeCheck
  "Model that checks the correct implementation of the 1st order derivative of the flow function"
  extends Modelica.Icons.Example;

  constant Real gain = 0.5 "Gain for computing the mass flow rate";

  parameter Real k = 0.35 "Flow coefficient";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent=0.36
    "Mass flow rate where transition to turbulent flow occurs";
  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  Modelica.Units.SI.PressureDifference dp "Pressure drop";
  Modelica.Units.SI.PressureDifference dp_comp "Comparison value for dp";
  Modelica.Units.SI.PressureDifference err "Integration error";
initial equation
 dp = dp_comp;
equation
  m_flow = time*gain;
  dp = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
    m_flow=m_flow,
    k = k,
    m_flow_turbulent=m_flow_turbulent);
  der(dp) = der(dp_comp);
  err = dp-dp_comp;
  assert(abs(err) < 1E-3, "Error in implementation.");
annotation (
experiment(StartTime=-2,
           StopTime=2,
           Tolerance=1e-8),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/BasicFlowFunction_m_flow_DerivativeCheck.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>
and its first order derivative
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der</a>.
If the derivative implementation is wrong, the simulation will stop with an error.
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
July 29, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BasicFlowFunction_m_flow_DerivativeCheck;
