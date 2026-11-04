within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_dp_inv
  "Inverse of basicFlowFunction_dp, which computes pressure drop for given mass flow rate"

  input Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Real k(min=0, unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  output Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
protected
  Modelica.Units.SI.PressureDifference dp_turbulent=(m_flow_turbulent/k)^2
    "Pressure where flow changes to turbulent";
  Real m_flowNorm = m_flow/m_flow_turbulent
    "Normalised mass flow rate";
  Real m_flowNormSq = m_flowNorm^2
    "Square of normalised mass flow rate";
  Real dpNorm
    "Normalised pressure difference";
  Real dpNormSq
    "Square of normalised pressure difference";
  Real res
    "Residual of the normalised laminar branch of basicFlowFunction_dp";
  Real res_der
    "1st derivative of res with respect to dpNorm";
  Real res_der2
    "2nd derivative of res with respect to dpNorm";
algorithm
  if noEvent(abs(m_flow)>m_flow_turbulent) then
    dp := sign(m_flow)*(m_flow/k)^2;
  else
    dpNorm := m_flowNorm*(0.711106282162016 + m_flowNormSq*(-1.19383535798101
      + m_flowNormSq*(0.6247721024191951 + m_flowNormSq*(-0.07903228141853089))))
      /(1 + m_flowNormSq*(-1.8810639795992359 + m_flowNormSq*(1.1639688670816826
      + m_flowNormSq*(-0.21989355643179428))));
    dpNormSq := dpNorm^2;
    res := (1.40625 + (0.15625*dpNormSq - 0.5625)*dpNormSq)*dpNorm - m_flowNorm;
    res_der := 1.40625 + (0.78125*dpNormSq - 1.6875)*dpNormSq;
    res_der2 := (-3.375 + 3.125*dpNormSq)*dpNorm;
    dp := (dpNorm - 2*res*res_der/(2*res_der^2 - res*res_der2))*dp_turbulent;
  end if;

  annotation (Inline=false,
              smoothOrder=2,
              derivative(order=1, zeroDerivative=k, zeroDerivative=m_flow_turbulent)=
                Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der,
              inverse(m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                dp=dp, k=k, m_flow_turbulent=m_flow_turbulent)),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Line(
          points={{-80,-40},{-80,60},{80,-40},{80,60}},
          color={0,0,255},
          thickness=1), Text(
          extent={{-40,-40},{40,-80}},
          textColor={0,0,0},
          textString="%name")}),
Documentation(info="<html>
<p>
Function that computes the pressure drop for a given mass flow rate
as the inverse of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>.
Hence, <code>basicFlowFunction_dp</code> evaluated at the pressure difference
computed by this function is equal to <code>m_flow</code> up to rounding errors.
</p>
<p>
This function is the <code>inverse</code> of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>.
It differs from
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>
for <i>|m&#775;| &lt; m&#775;<sub>t</sub></i>
because the two functions use different polynomials for the regularization.
</p>
<h4>Implementation</h4>
<p>
For <i>|m&#775;| &gt; m&#775;<sub>t</sub></i>, the function is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p = sign(m&#775;) (m&#775; &frasl; k)<sup>2</sup>,
</p>
<p>
which is the exact inverse of the turbulent branch of
<code>basicFlowFunction_dp</code>.
Otherwise, the normalised mass flow rate
<i>x = m&#775; &frasl; m&#775;<sub>t</sub></i>
and the normalised pressure difference
<i>d = &Delta;p &frasl; &Delta;p<sub>t</sub></i>, where
<i>&Delta;p<sub>t</sub> = (m&#775;<sub>t</sub> &frasl; k)<sup>2</sup></i>,
are related by the polynomial
<i>x = d (1.40625 - 0.5625 d<sup>2</sup> + 0.15625 d<sup>4</sup>)</i>.
Its inverse is approximated by a rational function in <i>x<sup>2</sup></i>
whose relative error is below <i>10<sup>-5</sup></i>,
followed by one step of Halley's method on the polynomial.
This gives a relative error of the order of the machine precision.
For <i>k</i> between <i>10<sup>-12</sup></i> and <i>10<sup>12</sup></i>
and <i>m&#775;<sub>t</sub></i> between <i>10<sup>-14</sup></i> and
<i>10<sup>8</sup></i> kg/s, the largest relative error
compared to the exact inverse is below <i>10<sup>-14</sup></i>.
The coefficients of the rational function are computed by
<code>Buildings/Resources/src/fluid/flowModels/fitInverseFlowFunctions.py</code>.
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
</html>"));
end basicFlowFunction_dp_inv;
