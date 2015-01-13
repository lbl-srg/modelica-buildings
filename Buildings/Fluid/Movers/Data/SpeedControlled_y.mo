within Buildings.Fluid.Movers.Data;
record SpeedControlled_y
  "Generic data record for pumps and fans that take y as an input signal"
  extends FlowControlled;

  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure
    "Volume flow rate vs. total pressure rise"
    annotation(Evaluate=true);

  /*
  This does not translate in OpenModelica (even if FlowControlled is copied
  into this model rather than extended).

  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    hydraulicEfficiency(
      V_flow=power.V_flow,
      eta=if use_powerCharacteristic then
       {sqrt(power.V_flow[i]*pressure.dp[i]/
        Buildings.Fluid.Movers.BaseClasses.Characteristics.power(
          per=power,
          V_flow=power.V_flow[i],
          r_N=1,
          delta=0.01,
          d=Buildings.Utilities.Math.Functions.splineDerivatives(
          x=power.V_flow,
          y=power.P))
          ) for i in 1:size(power.V_flow, 1)}
       else {0.7 for i in 1:size(power.V_flow, 1)}) "Hydraulic efficiency";

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
*/

  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(
info="<html>
<p>
Record containing parameters for pumps or fans as can be found in data sheets.
</p>
<p>
This record may be used to assign for example fan performance data using
declaration such as
</p>
<pre>
  Buildings.Fluid.Movers.SpeedControlled_y fan(
      redeclare package Medium = Medium,
      per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
                   dp={2*dp_nominal,dp_nominal,0}))) \"Fan\";
</pre>
<p>
This data record can be used with
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a>.
</p>
<p>
For
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_Nrpm\">
Buildings.Fluid.Movers.SpeedControlled_Nrpm</a>,
use the record
<a href=\"modelica://Buildings.Fluid.Movers.Data.Generic_Nrpm\">
Buildings.Fluid.Movers.Data.Generic_Nrpm</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised record for OpenModelica.
</li>
<li>
November 22, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedControlled_y;
