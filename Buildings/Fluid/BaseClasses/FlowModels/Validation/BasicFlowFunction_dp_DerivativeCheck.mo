within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model BasicFlowFunction_dp_DerivativeCheck
  "Model that checks the correct implementation of the 1st order derivative of the flow function"
  extends Modelica.Icons.Example;

  constant Real gain = 2 "Gain for computing the mass flow rate";

  parameter Real k = 0.35 "Flow coefficient";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent=0.36
    "Mass flow rate where transition to turbulent flow occurs";
  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  Modelica.Units.SI.MassFlowRate m_flow_comp "Comparison value for m_flow";
  Modelica.Units.SI.PressureDifference dp "Pressure drop";
  Modelica.Units.SI.MassFlowRate err "Integration error";
initial equation
 m_flow = m_flow_comp;
equation
  dp = time*gain;
  m_flow = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
    dp=dp,
    k = k,
    m_flow_turbulent=m_flow_turbulent);
  der(m_flow) = der(m_flow_comp);
  err = m_flow-m_flow_comp;
  assert(abs(err) < 1E-3, "Error in implementation.");
annotation (
experiment(
      StartTime=-2,
      StopTime=2,
      Tolerance=1e-8),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/BasicFlowFunction_dp_DerivativeCheck.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>
and its first order derivative
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der</a>.
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
end BasicFlowFunction_dp_DerivativeCheck;
