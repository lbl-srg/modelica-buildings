within Buildings.Fluid.Movers.Data;
record SpeedControlled_Nrpm "Generic data record for FlowMachine_Nrpm"
  extends SpeedControlled_y;

  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm N_nominal = 1500
    "Nominal rotational speed for flow characteristic";

  annotation (Documentation(revisions="<html>
<ul>
<li>November 22, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Record containing parameters for pumps or fans of
type 
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_Nrpm\">
Buildings.Fluid.Movers.FlowMachine_Nrpm</a>.
</p>
<p>
This record is identical to 
<a href=\"modelica://Buildings.Fluid.Movers.Data.Generic\">Buildings.Fluid.Movers.Data.Generic
Buildings.Fluid.Movers.Data.Generic</a>.
except that it also declares the nominal speed which is required
for models that take the RPM as an input.
</p>
<p>
This record may be used to assign for example fan performance data using
declaration such as
</p>
<pre>
  Buildings.Fluid.Movers.FlowMachine_y fan(
  redeclare package Medium = Medium,
    N_nominal = 1800,
    per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
                 dp={2*dp_nominal,dp_nominal,0}))) \"Fan\";
</pre>
<p>
This data record can be used with
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_Nrpm\">
Buildings.Fluid.Movers.FlowMachine_Nrpm</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_dp\">
Buildings.Fluid.Movers.FlowMachine_dp</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_m_flow\">
Buildings.Fluid.Movers.FlowMachine_m_flow</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_y\">
Buildings.Fluid.Movers.FlowMachine_y</a>
</li>
</ul>
<p>
However, for the second and third model, the record
<a href=\"modelica://Buildings.Fluid.Movers.Data.FlowControlled\">
Buildings.Fluid.Movers.Data.FlowControlled</a>
is sufficient,
and for the last model,
<a href=\"modelica://Buildings.Fluid.Movers.Data.SpeedControlled_y\">
Buildings.Fluid.Movers.Data.SpeedControlled_y</a>
is sufficient.
</p>
<p>
An example that uses manufacturer data can be found in
<a href=\"modelica://Buildings.Fluid.Movers.Examples.FlowMachine_Nrpm_Data\">
Buildings.Fluid.Movers.Examples.FlowMachine_Nrpm_Data</a>.
</p>
</html>"));
end SpeedControlled_Nrpm;
