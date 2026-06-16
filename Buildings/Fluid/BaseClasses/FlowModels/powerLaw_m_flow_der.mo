within Buildings.Fluid.BaseClasses.FlowModels;
function powerLaw_m_flow_der
  "1st derivative of function that computes pressure drop for given mass flow rate"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.MassFlowRate m_flow(displayUnit="kg/s")
    "Mass flow rate";
  input Real k "Flow coefficient, k = m_flow/ dp^(1/n)";
  input Real n(min=1, max=2)
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Modelica.Units.SI.PressureDifference dp_turbulent(displayUnit="Pa")
    "Pressure difference where turbulent flow occurs";
  input Real m(min=0.5, max=1) "Flow exponent for the pressure drop";
  input Real a1
    "Polynomial coefficient for regularized implementation of flow resistance";
  input Real a3
    "Polynomial coefficient for regularized implementation of flow resistance";
  input Real a5
    "Polynomial coefficient for regularized implementation of flow resistance";
  input Real C "Coefficient 1/k^n, based on the definition k = m_flow / dp^(1/n)";
  input Real b1
    "Polynomial coefficient for regularized implementation of flow resistance";
  input Real b3
    "Polynomial coefficient for regularized implementation of flow resistance";
  input Real b5
    "Polynomial coefficient for regularized implementation of flow resistance";
  input Real m_flow_der
    "Derivative of mass flow rate in design flow direction";
  output Real dp_der
    "Derivative of pressure difference";

protected
  Modelica.Units.SI.MassFlowRate abs_m = abs(m_flow)
    "Absolute value of mass flow rate";

algorithm
  dp_der :=
    (if abs_m < m_flow_turbulent
      then b1 + m_flow*m_flow * (3*b3 + m_flow*m_flow * 5*b5)
     else C * n * abs_m^(n - 1)) * m_flow_der;

annotation (
  smoothOrder=1,
  Inline=true,
  derivative(
    order=2,
    zeroDerivative=k,
    zeroDerivative=n,
    zeroDerivative=m_flow_turbulent,
    zeroDerivative=dp_turbulent,
    zeroDerivative=m,
    zeroDerivative=a1,
    zeroDerivative=a3,
    zeroDerivative=a5,
    zeroDerivative=C,
    zeroDerivative=b1,
    zeroDerivative=b3,
    zeroDerivative=b5)=
      Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_der2,
  Documentation(info="<html>
<p>
Function that implements the first order derivative of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow</a>
with respect to the mass flow rate <code>m_flow</code>,
assuming constant flow coefficients.
</p>
<p>
When called with <code>m_flow_der=der(m_flow)</code>, this function returns
the time derivative of <code>dp</code>.
When called with <code>m_flow_der=1</code>, this function returns
the derivative of <code>dp</code> with respect to <code>m_flow</code>.
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
end powerLaw_m_flow_der;
