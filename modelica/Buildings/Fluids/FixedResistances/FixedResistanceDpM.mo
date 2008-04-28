model FixedResistanceDpM 
  "Fixed flow resistance with dp and m_flow as parameter" 
  extends Buildings.BaseClasses.BaseIcon;
  extends Buildings.Fluids.Actuators.BaseClasses.PartialResistance(
                                                   m_small_flow=eta0*dh/4*
        Modelica.Constants.pi*ReC);
  import SI = Modelica.SIunits;
  annotation (Diagram, Documentation(info="<html>
<p>
This is a model of a resistance with a fixed flow coefficient <code>k = m_flow/sqrt(dP)</code>.
<p>
</p>
Near the origin, the square root relation is regularized to ensure that the derivative is bounded.
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(Text(
        extent=[-106,-26; 16,-92],
        style(color=3, rgbcolor={0,0,255}),
        string="dp0=%dp0"), Text(
        extent=[-104,-68; 8,-114],
        style(color=3, rgbcolor={0,0,255}),
        string="m0=%m0_flow")));
  parameter SI.MassFlowRate m0_flow "Mass flow rate" annotation(Dialog(group = "Nominal Condition"));
  parameter SI.Pressure dp0(min=0) "Pressure" annotation(Dialog(group = "Nominal Condition"));
  parameter SI.Length dh=1 "Hydraulic diameter";
  parameter Real ReC=4000 "Reynolds number where transition to laminar starts";
equation 
  if linearized then
   k = m0_flow / dp0;
  else
   k = m0_flow / sqrt(dp0);
 end if;
end FixedResistanceDpM;
