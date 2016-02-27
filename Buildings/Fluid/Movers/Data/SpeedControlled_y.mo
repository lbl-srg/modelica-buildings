within Buildings.Fluid.Movers.Data;
record SpeedControlled_y
  "Generic data record for pumps and fans that take y as an input signal"
  extends FlowControlled;

  parameter Real speed_nominal(final min=0, final unit="1") = 1
    "Nominal rotational speed for flow characteristic";

  parameter Real constantSpeed(final min=0, final unit="1") = speed_nominal
    "Normalized speed set point when using inputType = Buildings.Fluid.Types.InputType.Constant";

  parameter Real[:] speeds(each final min = 0, each final unit="1") = {1}
    "Vector of normalized speed set points when using inputType = Buildings.Fluid.Types.InputType.Stages";

  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure
    "Volume flow rate vs. total pressure rise"
    annotation(Evaluate=true);

  parameter Boolean use_powerCharacteristic=false
    "Use power data instead of motor efficiency";

  // Power requires default values to avoid in Dymola the message
  // Failed to expand the variable Power.V_flow
  parameter BaseClasses.Characteristics.powerParameters power(
    V_flow={0},
    P={0})
    "Volume flow rate vs. electrical power consumption (used if use_powerCharacteristic=true)"
   annotation (Dialog(enable=use_powerCharacteristic));

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
February 17, 2016, by Michael Wetter:<br/>
Added parameters <code>speed_nominal</code> and
<code>speeds</code>. This was done to have the same structure as
<a href=\"modelica://Buildings.Fluid.Movers.Data.SpeedControlled_Nrpm\">
Buildings.Fluid.Movers.Data.SpeedControlled_Nrpm</a>
as the only difference in these two records are the units.
</li>
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
