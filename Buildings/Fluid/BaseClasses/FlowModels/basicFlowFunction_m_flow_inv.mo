within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_m_flow_inv
  "Inverse of basicFlowFunction_m_flow, which computes mass flow rate for given pressure drop"

  input Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Real k(unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  output Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
protected
  Modelica.Units.SI.PressureDifference dp_turbulent=(m_flow_turbulent/k)^2
    "Pressure where flow changes to turbulent";
  Real dpNorm=dp/dp_turbulent
    "Normalised pressure difference";
  Real dpNormSq=dpNorm^2
    "Square of normalised pressure difference";
  Real m_flowNorm
    "Normalised mass flow rate";
  Real m_flowNormSq
    "Square of normalised mass flow rate";
  Real res
    "Residual of the normalised laminar branch of basicFlowFunction_m_flow";
  Real res_der
    "1st derivative of res with respect to m_flowNorm";
  Real res_der2
    "2nd derivative of res with respect to m_flowNorm";
algorithm
  if noEvent(abs(dp)>dp_turbulent) then
    m_flow := sign(dp)*k*sqrt(abs(dp));
  else
    m_flowNorm := dpNorm*(2.666301200630242 + dpNormSq*(191.57251790117215
      + dpNormSq*(2699.840259711808 + dpNormSq*(6949.274181341605 + dpNormSq*1988.630607720385))))
      /(1 + dpNormSq*(85.99422707488782 + dpNormSq*(1626.1346284254137
      + dpNormSq*(6465.671199681627 + dpNormSq*3653.035867847419))));
    m_flowNormSq := m_flowNorm^2;
    res := m_flowNorm*(0.375 + (0.75 - 0.125*m_flowNormSq)*m_flowNormSq) - dpNorm;
    res_der := 0.375 + (2.25 - 0.625*m_flowNormSq)*m_flowNormSq;
    res_der2 := (4.5 - 2.5*m_flowNormSq)*m_flowNorm;
    m_flow := (m_flowNorm - 2*res*res_der/(2*res_der^2 - res*res_der2))*m_flow_turbulent;
  end if;

  annotation (Inline=false,
              smoothOrder=2,
              derivative(order=1, zeroDerivative=k, zeroDerivative=m_flow_turbulent)=
                Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der,
              inverse(dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent)),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Line(
          points={{-80,-40},{-80,60},{80,-40},{80,60}},
          color={0,0,255},
          thickness=1), Text(
          extent={{-40,-40},{40,-80}},
          textColor={0,0,0},
          textString="%name")}),
Documentation(info="<html>
<p>
Function that computes the mass flow rate for a given pressure drop
as the inverse of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>.
Hence, <code>basicFlowFunction_m_flow</code> evaluated at the mass flow rate
computed by this function is equal to <code>dp</code> up to rounding errors.
</p>
<p>
This function is the <code>inverse</code> of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>.
It differs from
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>
for <i>|&Delta;p| &lt; &Delta;p<sub>t</sub></i>, where
<i>&Delta;p<sub>t</sub> = (m&#775;<sub>t</sub> &frasl; k)<sup>2</sup></i>,
because the two functions use different polynomials for the regularization.
</p>
<h4>Implementation</h4>
<p>
For <i>|&Delta;p| &gt; &Delta;p<sub>t</sub></i>, the function is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775; = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;|&Delta;p| &nbsp;</span>,
</p>
<p>
which is the exact inverse of the turbulent branch of
<code>basicFlowFunction_m_flow</code>.
Otherwise, the normalised pressure difference
<i>d = &Delta;p &frasl; &Delta;p<sub>t</sub></i>
and the normalised mass flow rate
<i>x = m&#775; &frasl; m&#775;<sub>t</sub></i>
are related by the polynomial
<i>d = x (0.375 + 0.75 x<sup>2</sup> - 0.125 x<sup>4</sup>)</i>.
Its inverse is approximated by a rational function in <i>d<sup>2</sup></i>
whose relative error is below <i>1.4 &sdot; 10<sup>-4</sup></i>,
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
end basicFlowFunction_m_flow_inv;
