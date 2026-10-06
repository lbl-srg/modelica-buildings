within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model PowerLaw_dp_DerivativeCheck2
  "Model that checks the correct implementation of the 2nd order derivative of the power law function"
  extends Modelica.Icons.Example;

  parameter Real k = 0.5 "Flow coefficient, k = m_flow/ dp^(1/n)";
  parameter Real n(min=1, max=2) = 1.5
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent = 0.1
    "Mass flow rate where transition to turbulent flow occurs";

  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  Modelica.Units.SI.MassFlowRate m_flow_comp "Comparison value for m_flow";
  Real der_m_flow(unit="kg/s2") "1st order derivative of mass flow rate";
  Real der_m_flow_comp(unit="kg/s2")
    "1st order derivative of comparison value for m_flow";

  Modelica.Units.SI.PressureDifference dp "Pressure drop";
  Modelica.Units.SI.MassFlowRate err_m_flow "Integration error for m_flow";
  Real err_der_m_flow(unit="kg/s2") "Integration error for der_m_flow";

protected
  parameter Modelica.Units.SI.PressureDifference dp_turbulent(
    displayUnit="Pa", fixed=false)
    "Pressure difference where turbulent flow occurs";
  parameter Real m(fixed=false) "Flow exponent for the pressure drop";
  parameter Real a1(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real a3(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real a5(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real C(fixed=false)
    "Coefficient 1/k^n, based on the definition k = m_flow / dp^(1/n)";
  parameter Real b1(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b3(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b5(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";

initial equation
  (dp_turbulent, m, a1, a3, a5, C, b1, b3, b5) =
    Buildings.Fluid.BaseClasses.FlowModels.powerLawData(
      k=k, n=n, m_flow_turbulent=m_flow_turbulent);
  m_flow = m_flow_comp;
  der_m_flow = der_m_flow_comp;
equation
  // Multiply by 1 to avoid a warning due to unit mismatch,
  // and raise to third power so that dp_der2 has positive and negative sign
  // in Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_der2
  dp = 1*time^3;

  m_flow = Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp(
    dp=dp,
    k=k,
    n=n,
    m_flow_turbulent=m_flow_turbulent,
    dp_turbulent=dp_turbulent,
    m=m,
    a1=a1,
    a3=a3,
    a5=a5,
    C=C,
    b1=b1,
    b3=b3,
    b5=b5);

  // Equate first and second order derivatives
  der_m_flow      = der(m_flow);
  der_m_flow_comp = der(m_flow_comp);
  der(der_m_flow) = der(der_m_flow_comp);

  // Error control
  err_m_flow = m_flow-m_flow_comp;
  assert(abs(err_m_flow) < 1E-3, "Error in implementation.");
  err_der_m_flow = der_m_flow-der_m_flow_comp;
  assert(abs(err_der_m_flow) < 1E-3, "Error in implementation.");
annotation (
experiment(
      StartTime=-2,
      StopTime=2,
      Tolerance=1e-08),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/PowerLaw_dp_DerivativeCheck2.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>
and its second order derivative
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_der2\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_der2</a>.
If the derivative implementation is wrong, the simulation will stop with an error.
</p>
<h4>Implementation</h4>
<p>
The pressure drop <code>dp</code> is increased non-linearly in order
for the first and second derivatives in
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_der2\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_der2</a>
to be non-zero during part of the simulation. This will ensure
full code coverage of this function.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 30, 2026, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4620\">Buildings, #4620</a>.
</li>
</ul>
</html>"));
end PowerLaw_dp_DerivativeCheck2;
