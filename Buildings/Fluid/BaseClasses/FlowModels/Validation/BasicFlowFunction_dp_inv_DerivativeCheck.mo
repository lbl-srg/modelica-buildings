within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model BasicFlowFunction_dp_inv_DerivativeCheck
  "Model that checks the correct implementation of the 1st order derivative of the inverse of the flow function"
  extends Modelica.Icons.Example;

  constant Real gain = 0.5 "Gain for computing the mass flow rate";

  parameter Real k = 0.35 "Flow coefficient";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent=0.36
    "Mass flow rate where transition to turbulent flow occurs";

  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  Modelica.Units.SI.PressureDifference dp "Pressure difference";
  Modelica.Units.SI.PressureDifference dp_comp "Comparison value for dp";
  Modelica.Units.SI.PressureDifference err "Integration error";

initial equation
  dp = dp_comp;
equation
  m_flow = time*gain;
  dp = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv(
    m_flow=m_flow,
    k=k,
    m_flow_turbulent=m_flow_turbulent);
  der(dp) = der(dp_comp);
  err = dp-dp_comp;
  assert(abs(err) < 1E-3, "Error in implementation.");

  annotation (
    experiment(
      StartTime=-2,
      StopTime=2,
      Tolerance=1e-08),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/BasicFlowFunction_dp_inv_DerivativeCheck.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv</a>
and its first order derivative
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der</a>.
If the derivative implementation is wrong, the simulation will stop with an error.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 22, 2026, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4798\">Buildings, #4798</a>.
</li>
</ul>
</html>"));
end BasicFlowFunction_dp_inv_DerivativeCheck;
