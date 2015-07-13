within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_dp "Basic class for flow models"

  input Modelica.SIunits.Pressure dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Real k(min=0, unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0) "Mass flow rate";
  output Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
protected
  Modelica.SIunits.Pressure dp_turbulent(displayUnit="Pa")
    "Turbulent flow if |dp| >= dp_small, not a parameter because k can be a function of time";
protected
 Real kSqu(unit="kg.m") "Flow coefficient, kSqu=k^2=m_flow^2/|dp|";
algorithm
 kSqu:=k*k;
 dp_turbulent :=m_flow_turbulent^2/kSqu;
 m_flow :=Modelica.Fluid.Utilities.regRoot2(x=dp, x_small=dp_turbulent, k1=kSqu, k2=kSqu);

annotation(LateInline=true,
           inverse(dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent)),
           smoothOrder=2,
           Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Line(
          points={{-80,-40},{-80,60},{80,-40},{80,60}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=1), Text(
          extent={{-40,-40},{40,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={232,0,0},
          textString="%name")}),
Documentation(info="<html>
<p>
Function that computes the pressure drop of flow elements as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
with regularization near the origin.
Therefore, the flow coefficient is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k = m &frasl; &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
The input <code>m_flow_turbulent</code> determines the location of the regularization.
</p>
</html>", revisions="<html>
<ul>
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
