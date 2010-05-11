within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_dp "Basic class for flow models"

  input Modelica.SIunits.Pressure dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Real k(unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0) "Mass flow rate";
  input Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate";
   output Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
protected
  Modelica.SIunits.Pressure dp_turbulent(displayUnit="Pa")
    "Turbulent flow if |dp| >= dp_small, not a parameter because k can be a function of time";
protected
 Real kSqu(unit="kg.m") "Flow coefficient, kSqu=k^2=m_flow^2/|dp|";
 constant Real conv(unit="m.s2/kg") = 1 "Factor, needed to satisfy unit check";
 constant Real conv2 = sqrt(conv) "Factor, needed to satisfy unit check";
algorithm
  // if dp==0, we avoid a computation
  if (dp == 0 or k==0) then
      m_flow := 0;
  else
     kSqu:=k*k;
     dp_turbulent :=m_flow_turbulent^2/kSqu;
     if linearized then
        m_flow :=k*dp*conv2;
     else
        m_flow :=Modelica.Fluid.Utilities.regRoot2(x=dp, x_small=dp_turbulent, k1=kSqu, k2=kSqu);
     end if;
  end if;
annotation(LateInline=true,
           inverse(dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent, linearized=linearized)),
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
<pre>
  m_flow = sign(dp) * k * sqrt(|dp|),
</pre>
with regularization near the origin.
The variable <tt>m_flow_turbulent</tt> determines the location of the regularization.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2010 by Michael Wetter:<br>
Changed implementation to allow <code>k=0</code>, which is
the case for a closed valve with no leakage
</li>
</ul>
</html>"),
revisions="<html>
<ul>
<li>
April 13, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
end basicFlowFunction_dp;
