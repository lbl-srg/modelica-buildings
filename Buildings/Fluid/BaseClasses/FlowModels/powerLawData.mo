within Buildings.Fluid.BaseClasses.FlowModels;
function powerLawData
  "Function that computes the coefficients used by powerLaw_dp and powerLaw_m_flow"

  input Real k "Flow coefficient, k = m_flow/ dp^(1/n)";
  input Real n(min=1, max=2)
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";

  output Modelica.Units.SI.PressureDifference dp_turbulent(displayUnit="Pa")
    "Pressure difference where turbulent flow occurs";
  output Real m "Flow exponent for the pressure drop";
  output Real a1
    "Polynomial coefficient for regularized implementation of flow resistance";
  output Real a3
    "Polynomial coefficient for regularized implementation of flow resistance";
  output Real a5
    "Polynomial coefficient for regularized implementation of flow resistance";
  output Real C "Coefficient 1/k^n, based on the definition k = m_flow / dp^(1/n)";
  output Real b1
    "Polynomial coefficient for regularized implementation of flow resistance";
  output Real b3
    "Polynomial coefficient for regularized implementation of flow resistance";
  output Real b5
    "Polynomial coefficient for regularized implementation of flow resistance";

algorithm
  // Coefficients used by powerLaw_dp
  m := 1 / n;
  dp_turbulent := (m_flow_turbulent / k)^n;
  a1 := (k * (m - 3) * (m - 5) / 8) * (dp_turbulent^(m - 1));
  a3 := (k * (m - 1) * (5 - m) / 4) * (dp_turbulent^(m - 3));
  a5 := (k * (m - 1) * (m - 3) / 8) * (dp_turbulent^(m - 5));

  // Coefficients used by powerLaw_m_flow
  C := 1 / (k^n);
  // These coefficients match the value, 1st derivative, and 2nd derivative
  // of the function f(x) = C * x^n at the point x = m_flow_turbulent
  b1 := (C * (n - 3) * (n - 5) / 8) * (m_flow_turbulent^(n - 1));
  b3 := (C * (n - 1) * (5 - n) / 4) * (m_flow_turbulent^(n - 3));
  b5 := (C * (n - 1) * (n - 3) / 8) * (m_flow_turbulent^(n - 5));

annotation (
  Documentation(info="<html>
<p>
This function computes the coefficients that are used by the functions
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>,
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow</a>,
their inverses
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv</a>
and
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv</a>,
and their derivative functions.
</p>
<p>
The coefficients <code>dp_turbulent</code>, <code>m</code>, <code>a1</code>,
<code>a3</code> and <code>a5</code> are used by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>
and
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv</a>
(which also uses <code>C</code> in the turbulent region),
while the coefficients <code>dp_turbulent</code>, <code>m</code>, <code>C</code>,
<code>b1</code>, <code>b3</code> and <code>b5</code> are used by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow</a>
and
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv</a>.
</p>
<p>
The coefficients only depend on the <code>k</code>, <code>n</code>
and <code>m_flow_turbulent</code> which often are parameters in a model.
In this case, this function allows to compute the coefficients only once as
parameters and then pass them to the above functions,
which avoids recomputing them during the time step simulation.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 22, 2026, by Martin Sj&ouml;lund:<br/>
Corrected <code>dp_turbulent</code>, which is the pressure difference at
<code>m_flow_turbulent</code>, to <code>(m_flow_turbulent/k)^n</code>.
Previously, <code>powerLaw_dp</code> left the laminar region at
<code>m_flow = k^(1-1/n)*m_flow_turbulent</code> rather than at
<code>m_flow_turbulent</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4800\">Buildings, #4800</a>.
</li>
<li>
May 30, 2026, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4620\">Buildings, #4620</a>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Line(
          points={{-80,-40},{-80,60},{80,-40},{80,60}},
          color={0,140,72},
          thickness=1), Text(
          extent={{-40,-40},{40,-80}},
          textColor={0,0,0},
          textString="%name")}));
end powerLawData;