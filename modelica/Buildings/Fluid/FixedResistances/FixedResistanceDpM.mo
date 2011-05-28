within Buildings.Fluid.FixedResistances;
model FixedResistanceDpM
  "Fixed flow resistance with dp and m_flow as parameter"
  extends Buildings.Fluid.BaseClasses.PartialResistance;
  parameter Boolean use_dh = false "Set to true to specify hydraulic diameter"
       annotation(Evaluate=true, Dialog(enable = not linearized));
  parameter Modelica.SIunits.Length dh=1 "Hydraulic diameter"
       annotation(Evaluate=true, Dialog(enable = use_dh and not linearized));
  parameter Real ReC(min=0)=4000
    "Reynolds number where transition to turbulent starts"
       annotation(Evaluate=true, Dialog(enable = use_dh and not linearized));
  parameter Real deltaM(min=0.01) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true, Dialog(enable = not use_dh and not linearized));
initial equation
 assert(m_flow_nominal_pos > 0, "m_flow_nominal_pos must be non-zero. Check parameters.");
 if ( m_flow_turbulent > m_flow_nominal_pos) then
   Modelica.Utilities.Streams.print("Warning: In FixedResistanceDpM, m_flow_nominal is smaller than m_flow_turbulent."
           + "\n"
           + "  m_flow_nominal = " + String(m_flow_nominal) + "\n"
           + "  dh      = " + String(dh) + "\n"
           + "  To fix, set dh < " +
                String(     4*m_flow_nominal/eta_nominal/Modelica.Constants.pi/ReC) + "\n"
           + "  Suggested value: dh = " +
                String(1/10*4*m_flow_nominal/eta_nominal/Modelica.Constants.pi/ReC));
 end if;

equation
 // if computeFlowResistance = false, then equations of this model are disabled.
 if computeFlowResistance then
   m_flow_turbulent = if use_dh then
                      eta_nominal*dh/4*Modelica.Constants.pi*ReC else
                      deltaM * m_flow_nominal_pos;
    if linearized then
     k = m_flow_nominal_pos / dp_nominal_pos / conv2;
    else
     k = m_flow_nominal_pos / sqrt(dp_nominal_pos);
    end if;
  else
      m_flow_turbulent = 0;
      k = 0;
   end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics),
defaultComponentName="res",
Documentation(info="<html>
<p>
This is a model of a resistance with a fixed flow coefficient 
<p align=\"center\" style=\"font-style:italic;\">
k = m &frasl; 
&radic;<span style=\"text-decoration:overline;\">&Delta;P</span>.
</p>
Near the origin, the square root relation is regularized to ensure that the derivative is bounded.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2008 by Michael Wetter:<br>
Added parameters <code>use_dh</code> and <code>deltaM</code> for easier parameterization.
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
end FixedResistanceDpM;
