within Buildings.Fluid.Movers.Data;
record SpeedControlled_y
  "Generic data record for pumps and fans that take y as an input signal"
  extends FlowControlled;
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    hydraulicEfficiency(V_flow=power.V_flow,
      eta=if use_powerCharacteristic then
        sqrt(power.V_flow.*pressure.dp./
        {Buildings.Fluid.Movers.BaseClasses.Characteristics.power(
          per=power,
          V_flow=i,
          r_N=1,
          delta=0.01,
          d=Buildings.Utilities.Math.Functions.splineDerivatives(
          x=power.V_flow,
          y=power.P))
          for i in power.V_flow})
          else
          {0.7 for i in power.V_flow}) "Hydraulic efficiency";
parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    motorEfficiency(V_flow=power.V_flow,
      eta=if use_powerCharacteristic then
        sqrt(power.V_flow.*pressure.dp./
        {Buildings.Fluid.Movers.BaseClasses.Characteristics.power(
          per=power,
          V_flow=i,
          r_N=1,
          delta=0.01,
          d=Buildings.Utilities.Math.Functions.splineDerivatives(
          x=power.V_flow,
          y=power.P))
          for i in power.V_flow})
          else
          {0.7 for i in power.V_flow}) "Electric motor efficiency";
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure
    "Volume flow rate vs. total pressure rise"
    annotation(Evaluate=true);
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(
info="<html>
<p>
Record containing parameters for pumps or fans as can be found in data sheets.
If <code>use_powerCharacteristic=true</code>, then the efficiencies
are computed based on the parameters <code>power</code> and
<code>pressure</code>.
Otherwise, a default efficiency of <i>0.7</i> is assumed for
the motor efficiency and the hydraulic efficiency. 
</p>
<p>
This record may be used to assign for example fan performance data using
declaration such as
</p>
<pre>
  Buildings.Fluid.Movers.FlowMachine_y fan(
      redeclare package Medium = Medium,
      per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
                   dp={2*dp_nominal,dp_nominal,0}))) \"Fan\";
</pre>
<p>
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
</p>
</html>",
revisions="<html>
<ul>
<li>
November 22, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedControlled_y;
