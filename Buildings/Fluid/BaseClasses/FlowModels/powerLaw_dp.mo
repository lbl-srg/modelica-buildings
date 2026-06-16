within Buildings.Fluid.BaseClasses.FlowModels;
function powerLaw_dp
  "Power law used in pressure drop equations when the flow exponent is constant and may be different from 2"

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

algorithm
  m_flow :=
    if abs_dp < dp_turbulent
    then dp * (a1 + dp * dp * (a3 + dp * dp * a5))
    else
    if dp > 0 then k * dp^m else - k * abs_dp^m;

annotation (
  smoothOrder=2,
  Inline=true,
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
      Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_der,
  inverse(
    dp=Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow(
      m_flow=m_flow, k=k, n=n, m_flow_turbulent=m_flow_turbulent,
      dp_turbulent=dp_turbulent, m=m, a1=a1, a3=a3, a5=a5,
      C=C, b1=b1, b3=b3, b5=b5)),
  Documentation(info="<html>
<p>
This model describes the mass flow rate and pressure difference relation
of a flow resistance in the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775; = k sign(&Delta;p) |&Delta;p|<sup>1/n</sup>
</p>
<p>
where
<i>m&#775;</i> is the mass flow rate,
<i>k > 0</i> is a flow coefficient
<i>&Delta; p</i> is the pressure drop and
<i>n &isin; [1, 2]</i> is a flow exponent.
The equation is regularized for
<i>|&Delta;p| < &Delta;p<sub>t</sub></i>, where
<i>&Delta;p<sub>t</sub></i> is a parameter that is computed from the input <code>m_flow_turbulent</code>.
For laminar flow, set <i>n=1</i> and
for turbulent flow, set <i>n=2</i>.
</p>
<p>
The polynomial coefficients <code>a1</code>, <code>a3</code> and <code>a5</code>,
the flow exponent <code>m</code> and the pressure difference
<code>dp_turbulent</code> are computed by the function
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLawData\">
Buildings.Fluid.BaseClasses.FlowModels.powerLawData</a>
and passed as inputs. As these quantities only depend on the parameters
<code>k</code>, <code>n</code> and <code>m_flow_turbulent</code>, they
can be computed once as parameters rather than at each function evaluation.
</p>
<p>
The model is used for the fluid flow models that are neither fully laminar nor fully turbulent.
It is identical to
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM\">
Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM</a> except that it
is formulated for mass flow rate rather than volume flow rate.
</p>
<h4>Note regarding arguments</h4>
<p>
This function takes as inputs not only the coefficients
<code>dp_turbulent</code>, <code>m</code>, <code>a1</code>, <code>a3</code> and <code>a5</code>
that are used in its own implementation,
but also the coefficients <code>C</code>, <code>b1</code>, <code>b3</code> and <code>b5</code>
that are used by its inverse function
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow</a>.
These additional arguments are needed so that the <code>inverse</code> annotation
can pass the input arguments of this function directly to its inverse function.
Therefore, this function and its inverse function
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow</a>
have the same input arguments, except that this function takes the pressure difference
<code>dp</code> as the first argument while its inverse takes the mass flow rate
<code>m_flow</code> as the first argument.
The coefficients <code>C</code>, <code>b1</code>, <code>b3</code> and <code>b5</code>
are computed by the function
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLawData\">
Buildings.Fluid.BaseClasses.FlowModels.powerLawData</a>.
</p>
<h4>Implementation</h4>
<p>
For <i>|&Delta;p| < &Delta;p<sub>t</sub></i>, the equation is regularized
so that it is twice continuously differentiable in <i>&Delta;p</i>, and that it
has an infinite number of continuous derivatives in <i>n</i> and in <i>k</i>.
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
</html>"),
    Icon(graphics={                Line(
          points={{-80,-40},{-80,60},{80,-40},{80,60}},
          color={0,140,72},
          thickness=1), Text(
          extent={{-40,-40},{40,-80}},
          textColor={0,0,0},
          textString="%name")}));
end powerLaw_dp;
