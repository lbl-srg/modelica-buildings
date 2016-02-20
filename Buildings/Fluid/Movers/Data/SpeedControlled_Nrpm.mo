within Buildings.Fluid.Movers.Data;
record SpeedControlled_Nrpm "Generic data record for FlowMachine_Nrpm"
  extends SpeedControlled_y(
    final constantSpeed = constantSpeed_rpm/speed_rpm_nominal,
    final speeds =        speeds_rpm       /speed_rpm_nominal);

  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm speed_rpm_nominal=1500
    "Nominal rotational speed for flow characteristic";

  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm constantSpeed_rpm=
    speed_rpm_nominal
    "Speed set point when using inputType = Buildings.Fluid.Types.InputType.Constant";

  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm[:] speeds_rpm = {speed_rpm_nominal}
    "Vector of speed set points when using inputType = Buildings.Fluid.Types.InputType.Stages";

  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(revisions="<html>
<ul>
<li>
February 17, 2016, by Michael Wetter:<br/>
Changed parameter <code>N_nominal</code> to
<code>speed_rpm_nominal</code> as it is the same quantity as <code>speeds_rmp</code>.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/396\">#396</a>.
</li>
<li>
January 19, 2016, by Filip Jorissen:<br/>
Added parameter <code>speeds_rpm</code>.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/396\">#396</a>.
</li>
<li>
February 13, 2015, by Michael Wetter:<br/>
Updated documentation.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised record for OpenModelica.
</li>
<li>
November 22, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Record containing parameters for pumps or fans of
type
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_Nrpm\">
Buildings.Fluid.Movers.SpeedControlled_Nrpm</a>.
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
  Buildings.Fluid.Movers.SpeedControlled_y fan(
    redeclare package Medium = Medium,
      per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
                   dp={2*dp_nominal,dp_nominal,0}))) \"Fan\";
</pre>
<p>
This data record can be used with
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_Nrpm\">
Buildings.Fluid.Movers.SpeedControlled_Nrpm</a> and
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a>.
</p>
<p>
An example that uses manufacturer data can be found in
<a href=\"modelica://Buildings.Fluid.Movers.Validation.SpeedControlled_Nrpm_Data\">
Buildings.Fluid.Movers.Validation.SpeedControlled_Nrpm_Data</a>.
</p>
</html>"));
end SpeedControlled_Nrpm;
