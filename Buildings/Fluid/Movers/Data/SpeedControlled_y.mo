within Buildings.Fluid.Movers.Data;
record SpeedControlled_y "Generic data record for pumps and fans that take y as an input signal"
  extends FlowControlled;

  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure
    "Volume flow rate vs. total pressure rise"
    annotation(Evaluate=true);
  annotation (Documentation(
info="<html>
<p>
Record containing parameters for pumps or fans as can be found in data sheets. 
</p>
<p>
This record may be used to assign for example fan performance data using
declaration such as
<pre>
  Buildings.Fluid.Movers.FlowMachine_y fan(
      redeclare package Medium = Medium,
      per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
                   dp={2*dp_nominal,dp_nominal,0}))) \"Fan\";
</pre>
</p>
This data record can be used with
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_y\">
Buildings.Fluid.Movers.FlowMachine_y</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_dp\">
Buildings.Fluid.Movers.FlowMachine_dp</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_m_flow\">
Buildings.Fluid.Movers.FlowMachine_m_flow</a>
</li>
</ul>
<p>
For
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_Nrpm\">
Buildings.Fluid.Movers.FlowMachine_Nrpm</a>,
use the record
<a href=\"modelica://Buildings.Fluid.Movers.Data.Generic_Nrpm\">
Buildings.Fluid.Movers.Data.Generic_Nrpm</a>.
</html>",
revisions="<html>
<ul>
<li>November 22, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedControlled_y;
