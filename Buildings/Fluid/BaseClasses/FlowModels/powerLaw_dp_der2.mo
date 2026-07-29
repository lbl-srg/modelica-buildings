within Buildings.Fluid.BaseClasses.FlowModels;
function powerLaw_dp_der2
  "2nd derivative of function that computes mass flow rate for given pressure drop"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference";
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
  input Real dp_der
    "1st derivative of pressure difference";
  input Real dp_der2
    "2nd derivative of pressure difference";
  output Real m_flow_der2
    "2nd derivative of mass flow rate in design flow direction";

protected
  Modelica.Units.SI.PressureDifference abs_dp = abs(dp)
    "Absolute value of pressure difference";

algorithm
  m_flow_der2 :=
    if abs_dp < dp_turbulent
    then (a1 + 3*a3*dp^2 + 5*a5*dp^4)*dp_der2
       + (6*a3*dp + 20*a5*dp^3)*dp_der^2
    else k * m * abs_dp^(m - 1) * dp_der2
       + k * m * (m - 1) * sign(dp) * abs_dp^(m - 2) * dp_der^2;

annotation (
  smoothOrder=0,
  Inline=true,
  Documentation(info="<html>
<p>
Function that implements the second order derivative of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>
with respect to the pressure difference <code>dp</code>,
assuming constant flow coefficients.
</p>
<p>
When called with <code>dp_der=der(dp)</code> and <code>dp_der2=der(dp_der)</code>,
this function returns the second order derivative of <code>m_flow</code>
with respect to time.
When called with <code>dp_der=1</code> and <code>dp_der2=0</code>,
this function returns the second order derivative of <code>m_flow</code>
with respect to <code>dp</code>.
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
end powerLaw_dp_der2;
