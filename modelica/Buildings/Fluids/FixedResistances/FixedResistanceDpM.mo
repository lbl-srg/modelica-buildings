within Buildings.Fluids.FixedResistances;
model FixedResistanceDpM
  "Fixed flow resistance with dp and m_flow as parameter"
  extends Buildings.Fluids.BaseClasses.PartialResistance;
  import SI = Modelica.SIunits;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Documentation(info="<html>
<p>
This is a model of a resistance with a fixed flow coefficient <code>k = m_flow/sqrt(dP)</code>.
<p>
</p>
Near the origin, the square root relation is regularized to ensure that the derivative is bounded.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2008 by Michael Wetter:<br>
Added parameters <tt>use_dh</tt> and <tt>deltaM</tt> for easier parameterization.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-102,86},{-4,22}},
          lineColor={0,0,255},
          textString="dp_nominal=%dp_nominal"), Text(
          extent={{-106,106},{6,60}},
          lineColor={0,0,255},
          textString="m0=%m_flow_nominal")}));
  parameter SI.MassFlowRate m_flow_nominal "Mass flow rate" annotation(Dialog(group = "Nominal Condition"));
  parameter SI.Pressure dp_nominal(min=0, displayUnit="Pa") "Pressure" 
                                              annotation(Dialog(group = "Nominal Condition"));
  parameter Boolean use_dh = false "Set to true to specify hydraulic diameter" 
       annotation(Evaluate=true, Dialog(enable = not linearized));
  parameter SI.Length dh=1 "Hydraulic diameter" annotation(Dialog(enable = use_dh and not linearized));
  parameter Real ReC=4000
    "Reynolds number where transition to turbulent starts" 
      annotation(Dialog(enable = use_dh and not linearized));
  parameter Real deltaM(min=0) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs" 
       annotation(Dialog(enable = not use_dh and not linearized));
initial equation
 if ( m_flow_turbulent > m_flow_nominal) then
   Modelica.Utilities.Streams.print("Warning: In FixedResistanceDpM, m_flow_nominal is smaller than m_flow_turbulent."
           + "\n"
           + "  m_flow_nominal = " + realString(m_flow_nominal) + "\n"
           + "  dh      = " + realString(dh) + "\n"
           + "  To fix, set dh < " +
                realString(     4*m_flow_nominal/eta_nominal/Modelica.Constants.pi/ReC) + "\n"
           + "  Suggested value: dh = " +
                realString(1/10*4*m_flow_nominal/eta_nominal/Modelica.Constants.pi/ReC));
 end if;
equation
  m_flow_turbulent = if use_dh then 
                      eta_nominal*dh/4*Modelica.Constants.pi*ReC else 
                      deltaM * m_flow_nominal;
  if linearized then
   k = m_flow_nominal / dp_nominal / conv2;
  else
   k = m_flow_nominal / sqrt(dp_nominal);
 end if;
end FixedResistanceDpM;
