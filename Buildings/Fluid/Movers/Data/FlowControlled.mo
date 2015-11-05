within Buildings.Fluid.Movers.Data;
record FlowControlled
  "Generic data record for pumps and fans with prescribed m_flow or dp"
  extends Modelica.Icons.Record;

  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    hydraulicEfficiency(
      V_flow={0},
      eta={0.7}) "Hydraulic efficiency (used if use_powerCharacteristic=false)";
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    motorEfficiency(
      V_flow={0},
      eta={0.7})
    "Electric motor efficiency (used if use_powerCharacteristic=false)";

  parameter Boolean motorCooledByFluid=true
    "If true, then motor heat is added to fluid stream";

  annotation(defaultComponentPrefixes = "parameter",
             defaultComponentName = "per",
  Documentation(
info="<html>
<p>
Record containing parameters for pumps or fans
that have either the mass flow rate or the pressure rise
as an input signal.
</p>
<p>
This record may be used to assign for example fan performance data using
declaration such as
</p>
<pre>
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
      redeclare package Medium = Medium) \"Fan\";
</pre>
<p>
This data record can be used with
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>
and with
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>.
</p>
<p>
For
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a>,
use the record
<a href=\"modelica://Buildings.Fluid.Movers.Data.SpeedControlled_y\">
Buildings.Fluid.Movers.Data.SpeedControlled_y</a>.
</p>
<p>
For
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_Nrpm\">
Buildings.Fluid.Movers.SpeedControlled_Nrpm</a>,
use the record
<a href=\"modelica://Buildings.Fluid.Movers.Data.Generic_Nrpm\">
Buildings.Fluid.Movers.Data.Generic_Nrpm</a>
</p>
</html>",
revisions="<html>
<ul>
<li>
November 5, 2015, by Michael Wetter:<br/>
Removed the performance record <code>power</code> and
<code>use_powerCharacteristic</code>
because
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>
and
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>
fix the flow rate or head, which can give a flow work that is higher
than the power consumption specified in this record.
Hence, users should use the efficiency data for this model.
The record has been moved to
<a href=\"modelica://Buildings.Fluid.Movers.Data.SpeedControlled_y\">
Buildings.Fluid.Movers.Data.SpeedControlled_y</a>
as it makes sense to use it for the movers
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_Nrpm\">
Buildings.Fluid.Movers.FlowControlled_Nrpm</a>
and
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_y\">
Buildings.Fluid.Movers.FlowControlled_y</a>.<br/>
This is for
<a href=\"modelica://https://github.com/lbl-srg/modelica-buildings/issues/457\">
issue 457</a>.
</li>
<li>
September 2, 2015, by Michael Wetter:<br/>
Improved documentation for
<a href=\"modelica://https://github.com/lbl-srg/modelica-buildings/issues/457\">
issue 457</a>.
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
end FlowControlled;
