within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_dp
  "Function that computes mass flow rate for given pressure drop"

  input Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Real k(min=0, unit="")
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
algorithm
   m_flow := smooth(2, if noEvent(abs(dp)>dp_turbulent)
               then sign(dp)*k*sqrt(abs(dp))
               else (1.40625  + (0.15625*dpNormSq - 0.5625)*dpNormSq)*m_flow_turbulent*dpNorm);
  annotation(Inline=false,
           smoothOrder=2,
           derivative(order=1, zeroDerivative=k, zeroDerivative=m_flow_turbulent)=
             Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der,
           inverse(dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
             m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent)),
           Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Line(
          points={{-80,-40},{-80,60},{80,-40},{80,60}},
          color={0,0,255},
          thickness=1), Text(
          extent={{-40,-40},{40,-80}},
          textColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={232,0,0},
          textString="%name")}),
Documentation(info="<html>
<p>
Function that computes the pressure drop of flow elements as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775; = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
with regularization near the origin.
Therefore, the flow coefficient is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k = m&#775; &frasl; &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
The input <code>m_flow_turbulent</code> determines the location of the regularization.
</p>
</html>", revisions="<html>
<ul>
<li>
November 9, 2019, by Filip Jorissen:<br/>
Added <code>smooth(2, . )</code> for avoiding
a warning in the check valve model.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1240\">#1240</a>.
</li>
<li>
January 4, 2019, by Michael Wetter:<br/>
Set `Inline=false`.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1070\">#1070</a>.
</li>
<li>
May 1, 2017, by Filip Jorissen:<br/>
Revised implementation such that
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">basicFlowFunction_dp</a>
is C2 continuous.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/725\">#725</a>.
</li>
<li>
March 19, 2016, by Michael Wetter:<br/>
Added <code>abs</code> function for
<code>Buildings.Fluid.FixedResistances.Validation.PressureDropsExplicit</code>
to work in OpenModelica.
See <a href=\"https://trac.openmodelica.org/OpenModelica/ticket/3778\">
OpenModelica ticket 3778</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
July 28, 2015, by Michael Wetter:<br/>
Removed double declaration of <code>smooth(..)</code> and <code>smoothOrder</code>
and changed <code>Inline=true</code> to <code>LateInline=true</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/301\">issue 301</a>.
</li>
<li>
July 15, 2015, by Filip Jorissen:<br/>
New, more efficient implementation based on regularisation using simple polynomial.
Expanded common subexpressions for function inlining to be possible.
Set <code>Inline=true</code> for inlining to occur.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/279\">#279</a>.
</li>
<li>
January 9, 2014, by Michael Wetter:<br/>
Correct revision section, of which there were two.
</li>
<li>
August 10, 2011, by Michael Wetter:<br/>
Removed <code>if-then</code> optimization that set <code>m_flow=0</code> if <code>dp=0</code>,
as this causes the derivative to be discontinuous at <code>dp=0</code>.
</li>
<li>
August 4, 2011, by Michael Wetter:<br/>
Removed option to use a linear function. The linear implementation is now done
in models that call this function. With the previous implementation,
the symbolic processor may not rearrange the equations, which can lead
to coupled equations instead of an explicit solution.
</li>
<li>
March 29, 2010 by Michael Wetter:<br/>
Changed implementation to allow <code>k=0</code>, which is
the case for a closed valve with no leakage
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end basicFlowFunction_dp;
