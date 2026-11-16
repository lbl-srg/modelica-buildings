within Buildings.Fluid.BaseClasses.FlowModels;
function powerLaw_m_flow_inv
  "Inverse of powerLaw_m_flow, which computes mass flow rate for given pressure drop"

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
  output Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";

protected
  Modelica.Units.SI.PressureDifference abs_dp = abs(dp)
    "Absolute value of pressure difference";
  Real dpNorm "Normalized pressure difference";
  Real dpNormSq "Square of normalized pressure difference";
  Real s "Flow exponent minus one";
  Real m_flowSq "Square of mass flow rate";
  Real res "Residual of the laminar branch of powerLaw_m_flow";
  Real res_der "1st derivative of res with respect to m_flow";
  Real res_der2 "2nd derivative of res with respect to m_flow";

algorithm
  if abs_dp < dp_turbulent then
    dpNorm := dp/dp_turbulent;
    dpNormSq := dpNorm^2;
    s := n - 1;
    m_flow := m_flow_turbulent*dpNorm
      *(1.0255728546643417 + s*(0.34880573321667135 + s*1.2085317901795196)
      + dpNormSq*(0.24511112689906714 + s*(-0.15483539675312938 + s*8.953044291492196)))
      /(1 + dpNormSq*(0.24963763863239502 + s*(0.6760945993330013 + s*9.319542996321854)));
    for i in 1:2 loop
      m_flowSq := m_flow^2;
      res := m_flow*(b1 + m_flowSq*(b3 + m_flowSq*b5)) - dp;
      res_der := b1 + m_flowSq*(3*b3 + 5*b5*m_flowSq);
      res_der2 := m_flow*(6*b3 + 20*b5*m_flowSq);
      m_flow := m_flow - 2*res*res_der/(2*res_der^2 - res*res_der2);
    end for;
  else
    m_flow := if dp > 0 then k*dp^m else -k*abs_dp^m;
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
      Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv_der,
  inverse(
    dp=Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow(
      m_flow=m_flow, k=k, n=n, m_flow_turbulent=m_flow_turbulent,
      dp_turbulent=dp_turbulent, m=m, a1=a1, a3=a3, a5=a5,
      C=C, b1=b1, b3=b3, b5=b5)),
  Documentation(info="<html>
<p>
Function that computes the mass flow rate for a given pressure difference
as the inverse of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow</a>.
Hence, <code>powerLaw_m_flow</code> evaluated at the mass flow rate
computed by this function is equal to <code>dp</code> up to rounding errors.
</p>
<p>
This function is the <code>inverse</code> of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow</a>.
It differs from
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>
in the laminar region
because the two functions use different polynomials for the regularization.
It takes the same arguments as <code>powerLaw_m_flow</code>, except that
the first argument is the pressure difference.
The coefficients are computed by the function
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLawData\">
Buildings.Fluid.BaseClasses.FlowModels.powerLawData</a>.
</p>
<h4>Implementation</h4>
<p>
For <i>|&Delta;p| &ge; &Delta;p<sub>t</sub></i>, the function is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775; = k sign(&Delta;p) |&Delta;p|<sup>1/n</sup>,
</p>
<p>
which is the exact inverse of the turbulent branch of
<code>powerLaw_m_flow</code>.
Otherwise, the normalized pressure difference
<i>d = &Delta;p &frasl; &Delta;p<sub>t</sub></i>
and the normalized mass flow rate
<i>x = m&#775; &frasl; m&#775;<sub>t</sub></i>
are related by the polynomial
<i>d = x (c<sub>1</sub> + c<sub>3</sub> x<sup>2</sup> + c<sub>5</sub> x<sup>4</sup>)</i>, with
<i>c<sub>1</sub> = (n-3)(n-5)/8</i>, <i>c<sub>3</sub> = (n-1)(5-n)/4</i> and
<i>c<sub>5</sub> = (n-1)(n-3)/8</i>.
Its inverse is approximated by a rational function in <i>d<sup>2</sup></i>
whose coefficients are quadratic polynomials in <i>n-1</i>.
For <i>n</i> between <i>1</i> and <i>2</i>, its relative error is below
<i>3.4 &sdot; 10<sup>-2</sup></i>.
Two steps of Halley's method on the polynomial reduce the relative error
to below <i>4 &sdot; 10<sup>-15</sup></i>.
The coefficients of the rational function are computed by
<code>Buildings/Resources/src/fluid/flowModels/fitInverseFlowFunctions.py</code>.
</p>
<p>
An alternative without fitted coefficients is the rational function
<i>x = d (8 + 2 (7n - n<sup>2</sup> - 4) d<sup>2</sup>) &frasl;
((n-3)(n-5) + (22n - 3n<sup>2</sup> - 15) d<sup>2</sup>)</i>,
which has the slope of the inverse at <i>d=0</i> and its value and slope at <i>d=1</i>,
as is used in
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv</a>.
For <i>n</i> close to <i>2</i>, it needs three Halley steps rather than two,
which makes the function about 30% to 40% slower in the laminar region.
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
end powerLaw_m_flow_inv;
