within Buildings.Fluid.BaseClasses.FlowModels;
function powerLaw_dp_inv
  "Inverse of powerLaw_dp, which computes pressure drop for given mass flow rate"

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
  output Modelica.Units.SI.PressureDifference dp(displayUnit="Pa") "Pressure difference";

protected
  Modelica.Units.SI.MassFlowRate abs_m = abs(m_flow)
    "Absolute value of mass flow rate";
  Real m_flowNorm "Normalized mass flow rate";
  Real m_flowNormSq "Square of normalized mass flow rate";
  Real dpSq "Square of pressure difference";
  Real res "Residual of the laminar branch of powerLaw_dp";
  Real res_der "1st derivative of res with respect to dp";
  Real res_der2 "2nd derivative of res with respect to dp";

algorithm
  if abs_m < m_flow_turbulent then
    m_flowNorm := m_flow/m_flow_turbulent;
    m_flowNormSq := m_flowNorm^2;
    dp := dp_turbulent*m_flowNorm*(8 + 2*(7*m - m^2 - 4)*m_flowNormSq)
      /((m - 3)*(m - 5) + (22*m - 3*m^2 - 15)*m_flowNormSq);
    for i in 1:2 loop
      dpSq := dp^2;
      res := dp*(a1 + dpSq*(a3 + dpSq*a5)) - m_flow;
      res_der := a1 + dpSq*(3*a3 + 5*a5*dpSq);
      res_der2 := dp*(6*a3 + 20*a5*dpSq);
      dp := dp - 2*res*res_der/(2*res_der^2 - res*res_der2);
    end for;
  else
    dp := if m_flow > 0 then C*m_flow^n else -C*abs_m^n;
  end if;

annotation (
  smoothOrder=2,
  Inline=false,
  derivative(
    order=1,
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
      Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv_der,
  inverse(
    m_flow=Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp(
      dp=dp, k=k, n=n, m_flow_turbulent=m_flow_turbulent,
      dp_turbulent=dp_turbulent, m=m, a1=a1, a3=a3, a5=a5,
      C=C, b1=b1, b3=b3, b5=b5)),
  Documentation(info="<html>
<p>
Function that computes the pressure difference for a given mass flow rate
as the inverse of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>.
Hence, <code>powerLaw_dp</code> evaluated at the pressure difference
computed by this function is equal to <code>m_flow</code> up to rounding errors.
</p>
<p>
This function is the <code>inverse</code> of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>.
It differs from
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow</a>
in the laminar region
because the two functions use different polynomials for the regularization.
It takes the same arguments as <code>powerLaw_dp</code>, except that
the first argument is the mass flow rate.
The coefficients are computed by the function
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLawData\">
Buildings.Fluid.BaseClasses.FlowModels.powerLawData</a>.
</p>
<h4>Implementation</h4>
<p>
For <i>|m&#775;| &ge; m&#775;<sub>t</sub></i>, the function is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p = C sign(m&#775;) |m&#775;|<sup>n</sup>,
</p>
<p>
which is the exact inverse of the turbulent branch of
<code>powerLaw_dp</code>.
Otherwise, the normalized mass flow rate
<i>x = m&#775; &frasl; m&#775;<sub>t</sub></i>
and the normalized pressure difference
<i>d = &Delta;p &frasl; &Delta;p<sub>t</sub></i>
are related by the polynomial
<i>x = d (c<sub>1</sub> + c<sub>3</sub> d<sup>2</sup> + c<sub>5</sub> d<sup>4</sup>)</i>, with
<i>c<sub>1</sub> = (m-3)(m-5)/8</i>, <i>c<sub>3</sub> = (m-1)(5-m)/4</i> and
<i>c<sub>5</sub> = (m-1)(m-3)/8</i>.
Its inverse is approximated by the rational function
</p>
<p align=\"center\" style=\"font-style:italic;\">
  d = x (8 + 2 (7m - m<sup>2</sup> - 4) x<sup>2</sup>) &frasl;
  ((m-3)(m-5) + (22m - 3m<sup>2</sup> - 15) x<sup>2</sup>),
</p>
<p>
which has the slope of the inverse at <i>x=0</i> and its value and slope at <i>x=1</i>.
Its denominator is positive for <i>0 &lt; m &lt; 3</i>.
For <i>m</i> between <i>0.5</i> and <i>1</i>, its relative error is below
<i>1.4 &sdot; 10<sup>-2</sup></i>.
Two steps of Halley's method on the polynomial reduce the relative error
to the order of the machine precision.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 22, 2026, by Martin Sj&ouml;lund:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4798\">Buildings, #4798</a>.
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
end powerLaw_dp_inv;
