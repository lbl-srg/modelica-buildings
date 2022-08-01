within Buildings.Fluid.Movers;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains models for fans and pumps. The same models
are used for fans or pumps.
</p>

<h4>Model description</h4>
<p>A detailed description of the fan and pump models can be
found in
<a href=\"modelica://Buildings/Resources/Images/Fluid/Movers/UsersGuide/2013-IBPSA-Wetter.pdf\">Wetter (2013)</a>.
The models are implemented as described in this paper, except
that equation (20) is no longer used. The reason is that
the transition (24) caused the derivative
</p>
<p align=\"center\" style=\"font-style:italic;\">
 d &Delta;p(r(t), V(t)) &frasl; d r(t)
</p>
<p>
to have an inflection point in the regularization region
<i>r(t) &isin; (&delta;/2, &delta;)</i>.
This caused some models to not converge.
To correct this, for <i>r(t) &lt; &delta;</i>,
the term <i>V(t) &frasl; r(t)</i> in (16)
has been modified so that (16) can be used for any
value of <i>r(t)</i>.
</p>
<p>
Below, the models are briefly described.
</p>
<h5>Performance data</h5>
<p>
The models use
performance curves that compute pressure rise,
electrical power draw and efficiency as a function
of the volume flow rate and the speed.
The following performance curves are implemented:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Independent variable</th>
<th>Dependent variable</th>
<th>Record for performance data</th>
<th>Function</th>
</tr>
<tr>
<td>Volume flow rate</td>
<td>Pressure</td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters\">
flowParameters</a></td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure\">
pressure</a></td>
</tr>
<tr>
<td>Volume flow rate</td>
<td>Efficiency<br/>
    (total, hydraulic, or motor)</td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters\">
efficiencyParameters</a></td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiency\">
efficiency</a></td>
</tr>
<tr>
<td>Motor part load ratio</td>
<td>Motor efficiency</td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot\">
efficiencyParameters_yMot</a></td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiency_yMot\">
efficiency_yMot</a></td>
</tr>
<tr>
<td>Volume flow rate</td>
<td>Power*</td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters\">
powerParameters</a></td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.power\">
power</a></td>
</tr>
</table>
<p>*Note: This record should not be used
(i.e. <code>use_powerCharacteristic</code> should be <code>false</code>)
for the movers that take as a control signal
the mass flow rate or the head,
unless also values for the record <code>pressure</code> are provided.
The reason is that for these movers the record <code>pressure</code>
is required to be able to compute the mover speed,
which is required to be able to compute the electrical power
correctly using similarity laws.
If a <code>Pressure</code> record is not provided,
the model will internally override <code>use_powerCharacteristic=false</code>.
In this case the efficiency records will be used.
Note that in this case an error is still introduced,
but it is smaller than when using the power records.
Compare
<a href=\"modelica://Buildings.Fluid.Movers.Validation.PowerSimplified\">
Buildings.Fluid.Movers.Validation.PowerSimplified</a>
with
<a href=\"modelica://Buildings.Fluid.Movers.Validation.PowerExact\">
Buildings.Fluid.Movers.Validation.PowerExact</a>
for an illustration of this error.
</p>
<p>
These performance curves are implemented in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics\">
Buildings.Fluid.Movers.BaseClasses.Characteristics</a>,
and are used in the performance records in the package
<a href=\"modelica://Buildings.Fluid.Movers.Data\">
Buildings.Fluid.Movers.Data</a>.
The package
<a href=\"modelica://Buildings.Fluid.Movers.Data\">
Buildings.Fluid.Movers.Data</a>
contains different data records.
</p>
<h5>Models that use performance curves for pressure rise</h5>
<p>
The models
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a> and
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_Nrpm\">
Buildings.Fluid.Movers.SpeedControlled_Nrpm</a>
take as an input either a control signal between <i>0</i> and <i>1</i>, or the
rotational speed in units of <i>[1/min]</i>. From this input and the current flow rate,
they compute the pressure rise.
This pressure rise is computed using a user-provided list of operating points that
defines the fan or pump curve at full speed.
For other speeds, similarity laws are used to scale the performance curves, as
described in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure</a>.
</p>

<p>
For example, suppose a pump needs to be modeled whose pressure versus flow relation crosses, at
full speed, the points shown in the table below.
</p>
  <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr>
      <th>Volume flow rate [m<sup>3</sup>&frasl;s] </th>
      <th>Head [Pa]</th>
    </tr>
    <tr>
      <td>0.0003</td>
      <td>45000</td>
    </tr>
    <tr>
      <td>0.0006</td>
      <td>35000</td>
    </tr>
    <tr>
      <td>0.0008</td>
      <td>15000</td>
    </tr>
  </table>
<p>
Then, a declaration would be
</p>
<pre>
  Buildings.Fluid.Movers.SpeedControlled_y pum(
    redeclare package Medium = Medium,
    per.pressure(V_flow={0.0003,0.0006,0.0008},
                 dp    ={45,35,15}*1000))
    \"Circulation pump\";
</pre>

<p>
This will model the following pump curve for the pump input signal <code>y=1</code>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/UsersGuide/pumpCurve.png\"/>
</p>

<h5>Models that directly control the head or the mass flow rate</h5>
<p>
The models <a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a> and
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>
take as an input the pressure difference or the mass flow rate.
This pressure difference or mass flow rate will be provided by the fan or pump,
i.e., the fan or pump has idealized perfect control and infinite capacity.
Using these models that take as an input the head or the mass flow rate often leads
to smaller system of equations compared to using the models that take
as an input the speed.
</p>
<p>
These models can be configured for three different control inputs.
For
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>,
the head is as follows:
</p>
<ul>
<li>
<p>
If the parameter <code>inputType==Buildings.Fluid.Types.InputType.Continuous</code>,
the head is <code>dp=dp_in</code>, where <code>dp_in</code> is an input connector.
</p>
</li>
<li>
<p>
If the parameter <code>inputType==Buildings.Fluid.Types.InputType.Constant</code>,
the head is <code>dp=constantHead</code>, where <code>constantHead</code> is a parameter.
</p>
</li>
<li>
<p>
If the parameter <code>inputType==Buildings.Fluid.Types.InputType.Stages</code>,
the head is <code>dp=heads</code>, where <code>heads</code> is a
vectorized parameter. For example, if a mover has
two stages and the head of the first stage should be <i>60%</i> of the nominal head
and the second stage equal to <code>dp_nominal</code>, set
<code>heads={0.6, 1}*dp_nominal</code>.
Then, the mover will have the following heads:
</p>
  <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr>
      <th>input signal <code>stage</code></th>
      <th>Head [Pa]</th>
    </tr>
    <tr>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <td>1</td>
      <td>0.6*dp_nominal</td>
    </tr>
    <tr>
      <td>2</td>
      <td>dp_nominal</td>
    </tr>
</table>
</li>
</ul>
<p>
Similarly, for
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>,
the mass flow rate is as follows:
</p>
<ul>
<li>
<p>
If the parameter <code>inputType==Buildings.Fluid.Types.InputType.Continuous</code>,
the mass flow rate is <code>m_flow=m_flow_in</code>, where <code>m_flow_in</code> is an input connector.
</p>
</li>
<li>
<p>
If the parameter <code>inputType==Buildings.Fluid.Types.InputType.Constant</code>,
the mass flow rate is <code>m_flow=constantMassFlowRate</code>, where <code>constantMassFlowRate</code> is a parameter.
</p>
</li>
<li>
<p>
If the parameter <code>inputType==Buildings.Fluid.Types.InputType.Stages</code>,
the mass flow rate is <code>m_flow=massFlowRates</code>, where <code>massFlowRates</code> is a
vectorized parameter. For example, if a mover has
two stages and the mass flow rate of the first stage should be <i>60%</i> of the nominal mass flow rate
and the second stage equal to <code>m_flow_nominal</code>, set
<code>massFlowRates={0.6, 1}*m_flow_nominal</code>.
Then, the mover will have the following mass flow rates:
</p>
  <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr>
      <th>input signal <code>stage</code></th>
      <th>Mass flow rates [kg/s]</th>
    </tr>
    <tr>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <td>1</td>
      <td>0.6*m_flow_nominal</td>
    </tr>
    <tr>
      <td>2</td>
      <td>m_flow_nominal</td>
    </tr>
</table>
</li>
</ul>
<p>
These two models do not need to use a performance curve for the flow
characteristics.
The reason is that</p>
<ul>
<li>
for given pressure rise (or mass flow rate), the mass flow rate (or pressure rise)
is computed from the flow resistance of the duct or piping network, and
</li>
<li>
at zero pressure difference, solving for the flow rate and the revolution leads to a singularity.
</li>
</ul>
<p>
However, the computation of the electrical power consumption
requires the mover speed to be known
and the computation of the mover speed requires the performance
curves for the flow and efficiency/power characteristics.
Therefore these performance curves do need to be provided
if the user desires a correct electrical power computation.
If the curves are not provided, a simplified computation is used,
where the efficiency curve is used and assumed to be correct for all speeds.
This loss of accuracy has the advantage that it allows to use the
mover models without requiring flow and efficiency/power characteristics.
</p>
<p>
The model <a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>
has an option to control the mover such
that the pressure difference set point is obtained
across two remote points in the system.
To use this functionality
parameter <code>prescribeSystemPressure</code> has
to be enabled and a differential pressure measurement
must be connected to
the pump input <code>dpMea</code>.
This functionality is demonstrated in
<a href=\"Buildings.Fluid.Movers.Validation.FlowControlled_dpSystem\">
Buildings.Fluid.Movers.Validation.FlowControlled_dpSystem</a>.
</p>
<p>
The models <a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a> and
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>
both have a parameter <code>m_flow_nominal</code>. For
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>, this parameter
is used for convenience to set a default value for the parameters
<code>constantMassFlowRate</code> and
<code>massFlowRates</code>.
For both models, the value is also used for the following:
</p>

<ul>
<li>
To compute the
size of the fluid volume that can be used to approximate the
inertia of the mover if the energy dynamics is selected to be dynamic.
</li>
<li>
To compute a default pressure curve if no pressure curve has been specified
in the record <code>per.pressure</code>.
The default pressure curve is the line that intersects
<code>(dp, V_flow) = (dp_nominal, 0)</code> and
<code>(dp, V_flow) = (m_flow_nominal/rho_default, 0)</code>.
</li>
<li>
To regularize the equations near zero flow rate to ensure a numerically
robust model.
</li>
</ul>
<p>
However, otherwise <code>m_flow_nominal</code> does not affect the mass flow rate of the mover as
the mass flow rate is determined by the input signal or the above explained parameters.
</p>
<h5>Start-up and shut-down transients</h5>
<p>
All models have a parameter <code>use_inputFilter</code>. This
parameter affects the fan output as follows:
</p>
<ol>
<li>
If <code>use_inputFilter=false</code>, then the input signal <code>y</code> (or
<code>Nrpm</code>, <code>m_flow_in</code>, or <code>dp_in</code>)
is equal to the fan speed (or the mass flow rate or pressure rise).
Thus, a step change in the input signal causes a step change in the fan speed (or mass flow rate or pressure rise).
</li>
<li>
If <code>use_inputFilter=true</code>, which is the default,
then the fan speed (or the mass flow rate or the pressure rise)
is equal to the output of a filter. This filter is implemented
as a 2nd order differential equation and can be thought of as
approximating the inertia of the rotor and the fluid.
Thus, a step change in the fan input signal will cause a gradual change
in the fan speed.
The filter has a parameter <code>riseTime</code>, which by default is set to
<i>30</i> seconds.
The rise time is the time required to reach <i>99.6%</i> of the full speed, or,
if the fan is switched off, to reach a fan speed of <i>0.4%</i>.
</li>
</ol>
<p>
The figure below shows for a fan with <code>use_inputFilter=true</code>
and <code>riseTime=30</code> seconds the
speed input signal and the actual speed.</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/UsersGuide/fanSpeedFiltered.png\"/>
</p>

<p>
Although many simulations do not require such a detailed model
that approximates the transients of fans or pumps, it turns
out that using this filter can reduce computing time and
can lead to fewer convergence problems in large system models.
With a filter, any sudden change in control signal, such as when
a fan switches on, is damped before it affects the air flow rate.
This continuous change in flow rate turns out to be easier, and in
some cases faster, to simulate compared to a step change.
For most simulations, we therefore recommend to use the default settings
of <code>use_inputFilter=true</code> and <code>riseTime=30</code> seconds.
An exception are situations in which the fan or pump is operated at a fixed speed during
the whole simulation. In this case, set <code>use_inputFilter=false</code>.
</p>
<p>
Note that if the fan is part of a closed loop control, then the filter affects
the transient response of the control.
When changing the value of <code>use_inputFilter</code>, the control gains
may need to be retuned.
We now present values control parameters that seem to work in most cases.
Suppose there is a closed loop control with a PI-controller
<a href=\"modelica://Buildings.Controls.Continuous.LimPID\">
Buildings.Controls.Continuous.LimPID</a>
and a fan or pump, configured with <code>use_inputFilter=true</code> and <code>riseTime=30</code> seconds.
Assume that the transient response of the other dynamic elements in the control loop is fast
compared to the rise time of the filter.
Then, a proportional gain of <code>k=0.5</code> and an integrator time constant of
<code>Ti=15</code> seconds often yields satisfactory closed loop control performance.
These values may need to be changed for different applications as they are also a function
of the loop gain.
If the control loop shows oscillatory behavior, then reduce <code>k</code> and/or increase <code>Ti</code>.
If the control loop reacts too slow, do the opposite.
</p>

<h5>Efficiency and electrical power consumption</h5>
<p>
All models compute the motor power draw <i>P<sub>ele</sub></i>,
the hydraulic power input <i>W&#775;<sub>hyd</sub></i>, the flow work
<i>W&#775;<sub>flo</sub></i> and the heat dissipated into the medium
<i>Q</i>. Based on the first law, the flow work is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  W&#775;<sub>flo</sub> = | V&#775; &Delta;p |,
</p>
<p>
where <i>V&#775;</i> is the volume flow rate and
<i>&Delta;p</i> is the pressure rise.
The heat dissipated into the medium is as follows:
If the motor is cooled by the fluid, as indicated by
<code>per.motorCooledByFluid=true</code>, then the heat dissipated into the medium is
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q = P<sub>ele</sub> - W&#775;<sub>flo</sub>.
</p>

<p>
If <code>per.motorCooledByFluid=false</code>, then the motor is outside the fluid stream,
and only the shaft, or hydraulic, work <i>W&#775;<sub>hyd</sub></i> enters the thermodynamic
control volume. Hence,
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q = W&#775;<sub>hyd</sub> - W&#775;<sub>flo</sub>.
</p>
<p>The efficiencies are defined as</p>
<p align=\"center\" style=\"font-style:italic;\">
&eta; = W&#775;<sub>flo</sub> &frasl; P<sub>ele</sub> = &eta;<sub>hyd</sub> &nbsp; &eta;<sub>mot</sub> <br/>
&eta;<sub>hyd</sub> = W&#775;<sub>flo</sub> &frasl; W&#775;<sub>hyd</sub> <br/>
&eta;<sub>mot</sub> = W&#775;<sub>hyd</sub> &frasl; P<sub>ele</sub> <br/>
</p>
<p>where
<i>&eta;</i> is the total efficiency,
<i>&eta;<sub>hyd</sub></i> is the hydraulic efficiency, and
<i>&eta;<sub>mot</sub></i> is the motor efficiency.
From the definition one has
</p>
<p align=\"center\" style=\"font-style:italic;\">
<i>&eta; = &eta;<sub>hyd</sub> &nbsp; &eta;<sub>mot</sub></i>.
</p>
<p>
Two of the three efficiencies need to be defined, while defining all three would
over-specify the problem. A user may have varying amounts of information about
mover and/or motor performance. Therefore, the implementation allows a user to
specify two, one, or none of the efficiencies. In the case of specifying one or
none of the efficiencies, the implementation defines default values as needed based
on reasonable assumptions. In such cases, the following default values are used:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<thead>
  <tr>
    <th colspan=\"3\">Is this item provided?</th>
    <th colspan=\"3\">How will this item be computed?</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td><i>&eta;</i></td>
    <td><i>&eta;<sub>hyd</sub></i></td>
    <td><i>&eta;<sub>mot</sub></i></td>
    <td><i>&eta;</i></td>
    <td><i>&eta;<sub>hyd</sub></i></td>
    <td><i>&eta;<sub>mot</sub></i></td>
  </tr>
  <tr>
    <td>&#10003;</td>
    <td>&#10060;</td>
    <td>&#10060;</td>
    <td>&#10003;</td>
    <td><i>= &eta; &frasl; &eta;<sub>mot</sub></i></td>
    <td>= 0.7</td>
  </tr>
  <tr>
    <td>&#10060;</td>
    <td>&#10003;</td>
    <td>&#10060;</td>
    <td><i>= &eta;<sub>hyd</sub> &nbsp; &eta;<sub>mot</sub></i></td>
    <td>&#10003;</td>
    <td>= 0.7</td>
  </tr>
  <tr>
    <td>&#10060;</td>
    <td>&#10060;</td>
    <td>&#10003;</td>
    <td><i>= &eta;<sub>hyd</sub> &nbsp; &eta;<sub>mot</sub></i></td>
    <td>= 0.7</td>
    <td>&#10003;</td>
  </tr>
  <tr>
    <td>&#10060;</td>
    <td>&#10060;</td>
    <td>&#10060;</td>
    <td>= 0.49</td>
    <td>= 0.7</td>
    <td>= 0.7</td>
  </tr>
</tbody>
</table>
<p>
Constraints
<i>&eta;<sub>Hyd</sub> &le; 1</i> and
<i>&eta;<sub>Mot</sub> &le; 1</i>
are imposed to prevent the division
<i>&eta;<sub>Hyd</sub> = &eta; &frasl; &eta;<sub>Mot</sub></i> or
<i>&eta;<sub>Mot</sub> = &eta; &frasl; &eta;<sub>Hyd</sub></i>
from producing efficiency values larger than one.
</p>
<p>
For the efficiency values that a user does define, there are different methods
for doing so, depending on the efficiency being defined, as implemented in
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>.
The methods are selected by enumeration
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod\">
Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod</a>
for <i>&eta;</i> and <i>&eta;<sub>hyd</sub></i> and by
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod\">
Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod</a>
for <i>&eta;<sub>mot</sub></i>.
</p>
<p>
<i>&eta;</i> and <i>&eta;<sub>hyd</sub></i> can be computed using the following choices:
</p>
<ul>
<li>
<code>Efficiency_VolumeFlowRate</code> - An array of efficiency vs. <i>V&#775;</i> is provided.
During simulation, if the array has only one element, the efficiency is constant. If the array has
more than one element, the efficiency is interpolated or extrapolated by
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiency\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiency</a>.
See
<a href=\"Modelica://Buildings.Fluid.Movers.Validation.PowerSimplified\">
Buildings.Fluid.Movers.Validation.PowerSimplified</a>
as an example.
</li>
<li>
<code>Power_VolumeFlowRate</code> - An array of power vs. <i>V&#775;</i> is provided.
During simulation, the power is interpolated or extrapolated by
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.power\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.power</a>.
The efficiency is then computed from the power.
See
<a href=\"Modelica://Buildings.Fluid.Movers.Validation.PowerExact\">
Buildings.Fluid.Movers.Validation.PowerExact</a>
as an example.
</li>
<li>
<code>EulerNumber</code> - An efficiency, <i>&Delta;p</i>, and
<i>V&#775;</i> are provided that correspond to an operating point where the efficiency is at its peak.
During simulation, the efficiency and power are computed using the package
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Euler\">
Buildings.Fluid.Movers.BaseClasses.Euler</a>.
The model finds the efficiency by evaluating the following correlation:
<br/>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/BaseClasses/Euler/eulerCorrelation.svg\"/>
<br/>
</p>
where <i>y=&eta; &frasl; &eta;<sub>p</sub></i>,
<i>x=log10(Eu &frasl; Eu<sub>p</sub>)</i>,
with the subscript <i>p</i> denoting the condition where
the mover is operating at peak efficiency.
The Euler number is defined as
<br/>
<p align=\"center\" style=\"font-style:italic;\">
Eu=(pressure forces)/(inertial forces)
</p>
from which one can derive the ratio of Euler numbers as<br/>
<p align=\"center\" style=\"font-style:italic;\">
Eu &frasl; Eu<sub>p</sub>=(&Delta;p&nbsp;V&#775;<sub>p</sub><sup>2</sup>)
&frasl; (&Delta;p<sub>p</sub>&nbsp;V&#775;<sup>2</sup>).
</p>
<p>
The peak point can be provided directly by the user or computed by calling
the function
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.getPeak\">
Buildings.Fluid.Movers.BaseClasses.Euler.getPeak</a>.
The function finds the peak point when both pressure and power curves are provided.
When only the pressure curve is available, the function makes an estimation at
<i>V&#775;=V&#775;<sub>max</sub> &frasl; 2</i>.
Examples:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.Examples.StaticReset\">
Buildings.Fluid.Movers.Examples.StaticReset</a>
specifies the peak point directly.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.Validation.PowerEuler\">
Buildings.Fluid.Movers.Validation.PowerEuler</a>
explictly calls the function.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Validation.EulerComparison\">
Buildings.Fluid.Movers.BaseClasses.Validation.EulerComparison</a>
implicitly calls the function when
<a href=\"modelica://Buildings.Fluid.Movers.Data.Generic\">
Buildings.Fluid.Movers.Data.Generic</a>
is instantiated.
</li>
</ul>
<p>
For more information on the Euler number method, see
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Euler.correlation\">
Buildings.Fluid.Movers.BaseClasses.Euler.correlation</a>
and <a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v9.6.0/EngineeringReference.pdf\">
EnergyPlus 9.6.0 Engineering Reference</a>
chapter 16.4 equations 16.209 through 16.218.<br/>
</p>
</li>
<li>
<code>NotProvided</code> - The information of this efficiency term is not provided.
During simulation, it will be computed using the other efficiency terms.
</li>
</ul>
<p>
<i>&eta;<sub>mot</sub></i> can be computed using the following choices:
</p>
<ul>
<li>
<code>Efficiency_VolumeFlowRate</code> - This is same as the option for
<i>&eta;</i> and <i>&eta;<sub>hyd</sub></i> with the same name.
</li>
<li>
<code>Efficiency_MotorPartLoadRatio</code> - An array of efficiency vs. motor part load ratio
<i>y<sub>mot</sub>=P<sub>ele</sub> &frasl; P<sub>ele,nominal</sub></i>
is provided. During simulation, the efficiency is interpolated or extrapolated by
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiency_yMot\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiency_yMot</a>.
See
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Validation.FlowMachineInterface_yMot\">
Buildings.Fluid.Movers.BaseClasses.Validation.FlowMachineInterface_yMot</a>
as an example.
</li>
<li>
<code>GenericCurve</code> - The rated motor power input
<i>P<sub>ele,nominal</sub></i> and maximum motor efficiency
<i>&eta;<sub>mot,max</sub></i> are provided. The model then uses a generic motor
efficiency curve as a function of motor part load ratio generated by
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve</a>.
The <i>&eta;<sub>mot,max</sub></i> is assumed to be 0.7 if not specified by user.
If <i>P<sub>ele,nominal</sub></i> is unspecified, the model tries to
estimate it in the following ways:
<ul>
<li>
If a power curve is provided,
<ul>
<li>
If the curve refers to total power,
<p align=\"center\" style=\"font-style:italic;\">
P<sub>ele,nominal</sub>=
W&#775;<sub>max</sub>,
</p>
where <i>W&#775;<sub>max</sub></i> is the maximum value on the provided power curve.
</li>
<li>
If the curve refers to hydraulic power,
<p align=\"center\" style=\"font-style:italic;\">
P<sub>ele,nominal</sub>=
W&#775;<sub>max</sub>
&frasl; &eta;<sub>mot,max</sub>
&nbsp; 1.2,
</p>
where the factor <i>1.2</i> accounts for a 20% oversize of the motor.
</li>
</ul>
</li>
<li>
Otherwise, if only a pressure curve is provided,
<p align=\"center\" style=\"font-style:italic;\">
P<sub>ele,nominal</sub>=
(V&#775;<sub>max</sub> &frasl; 2 &nbsp;&Delta;p<sub>max</sub> &frasl; 2)
&frasl; 0.7
&frasl; &eta;<sub>mot,max</sub>
&nbsp; 1.2,
</p>
where the factor <i>1 &frasl; 0.7</i> is the assumption for hydraulic efficiency
and the factor <i>1.2</i> also assumes a 20% oversize.
</li>
</ul>
The model then computes the efficiency the same way as the option of
<code>Efficiency_MotorPartLoadRatio</code>.
Also see
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Validation.FlowMachineInterface_yMot\">
Buildings.Fluid.Movers.BaseClasses.Validation.FlowMachineInterface_yMot</a>
as an example.
</li>
<li>
<code>NotProvided</code> - This is same as the option for
<i>&eta;</i> and <i>&eta;<sub>hyd</sub></i> with the same name.
</li>
</ul>
<p>
The table below shows the options available for computing each of the efficiencies.
For example usage, see <a href=\"Modelica://Buildings.Fluid.Movers.Examples.StaticReset\">
Buildings.Fluid.Movers.Examples.StaticReset</a>.
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<thead>
  <tr>
    <th></th>
    <th><code>Power_VolumeFlowRate</code><sup>1</sup></th>
    <th><code>EulerNumber</code><sup>1</sup></th>
    <th><code>Efficiency_VolumeFlowRate</code><sup>3</sup></th>
    <th><code>Efficiency_MotorPartLoadRatio</code><sup>3</sup></th>
    <th><code>GenericCurve</code><sup>3</sup></th>
    <th><code>NotProvided</code></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td><i>&eta;</i></td>
    <td>&#10003;</td>
    <td>&#10003;<sup>2</sup></td>
    <td>&#10003;</td>
    <td></td>
    <td></td>
    <td>&#10003;&#9734;</td>
  </tr>
  <tr>
    <td><i>&eta;<sub>hyd</sub></i></td>
    <td>&#10003;</td>
    <td>&#10003;&#9734;</td>
    <td>&#10003;</td>
    <td></td>
    <td></td>
    <td>&#10003;</td>
  </tr>
  <tr>
    <td><i>&eta;<sub>mot</sub></i></td>
    <td></td>
    <td></td>
    <td>&#10003;</td>
    <td>&#10003;</td>
    <td>&#10003;&#9734;<sup>4</sup></td>
    <td>&#10003;&#9734;<sup>4</sup></td>
  </tr>
</tbody>
</table>
<p>
Notes:<br/>
&#10003; - Selectable.<br/>
&#9734; - Default.<br/>
1. The <code>Power_VolumeFlowRate</code> and <code>EulerNumber</code> options cannot
be used for more than one efficiency item.
For example, if <i>&eta;<sub>hyd</sub></i> uses <code>EulerNumber</code>,
then <i>&eta;</i> must use <code>Power_VolumeFlowRate</code>,
<code>Efficiency_VolumeFlowRate</code>, or <code>NotProvided</code>.<br/>
2. Although the Euler number method is defined using <i>&eta;<sub>hyd</sub></i>,
this implementation applies it also to <i>&eta;</i> and <i>P<sub>ele</sub></i>
as an approximation. The basis is that <i>&eta;<sub>mot</sub></i> is mostly
constant for motors larger than about 3.5 kW or 5 HP except when the motor
part load drops below around 40%, (see the documentation of
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve</a>)
which makes <i>&eta;</i> and <i>&eta;<sub>hyd</sub></i> roughly linear
to each other for motors of this size.<br/>
3. All three efficiency items can use <i>V&#775;</i> as the independent variable
by selecting <code>Efficiency_VolumeFlowRate</code>. <i>&eta;<sub>mot</sub></i>
can also use the motor part load ratio
<i>y<sub>mot</sub>=P<sub>ele</sub> &frasl; P<sub>ele,nominal</sub></i>
when selecting <code>Efficiency_MotorPartLoadRatio</code> or <code>GenericCurve</code>.<br/>
4. <i>&eta;<sub>mot</sub></i> normally uses <code>GenericCurve</code> as default,
but
<a href=\"Modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a> and
<a href=\"Modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>
may override this with <code>NotProvided</code> when
the rated motor input power is not provided and cannot be estimated.
</p>

<h5>Fluid volume of the component</h5>
<p>
All models can be configured to have a fluid volume at the low-pressure side.
Adding such a volume sometimes helps the solver to find a solution during
initialization and time integration of large models.
</p>

<h5>Enthalpy change of the component</h5>
<p>
If <code>per.motorCooledByFluid=true</code>, then
the enthalpy change between the inlet and outlet fluid port is equal
to the electrical power <i>P<sub>ele</sub></i> that is consumed by the component.
Otherwise, it is equal to the hydraulic work <i>W<sub>hyd</sub></i>.
The parameter <code>addPowerToMedium</code>, which is by default set to
<code>true</code>, can be used to simplify the equations.
If <code>addPowerToMedium = false</code>, then no enthalpy change occurs between
inlet and outlet.
This can lead to simpler equations, but the temperature rise across the component
will be zero. In particular for fans, this simplification may not be permissible.
</p>

<h4>Differences to models in Modelica.Fluid.Machines</h4>
<p>
The models in this package differ from
<a href=\"Modelica.Fluid.Machines\">Modelica.Fluid.Machines</a>
primarily in the following points:
</p>
<ul>
<li>
They use a different base class, which allows to have zero mass flow rate.
The models in <code>Modelica.Fluid</code> restrict the number of revolutions, and hence the flow
rate, to be non-zero.
</li>
<li>
For the model with prescribed pressure, the input signal is the
pressure difference between the two ports, and not the absolute
pressure at <code>port_b</code>.
</li>
<li>
The pressure calculations are based on total pressure in Pascals instead of the pump head in meters.
This change was done to avoid ambiguities in the parameterization if the models are used as a fan
with air as the medium. The original formulation in
<a href=\"Modelica.Fluid.Machines\">Modelica.Fluid.Machines</a> converts head
to pressure using the density <code>medium.d</code>. Therefore, for fans,
head would be converted to pressure using the density of air. However, for pumps,
manufacturers typically publish the head in millimeters water (mmH<sub>2</sub>O).
Therefore, to avoid confusion when using these models with media other than water,
we changed the models to use total pressure in Pascals instead of head in meters.
</li>
<li>
The performance data are interpolated using cubic hermite splines instead of polynomials.
These functions are implemented in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics\">
Buildings.Fluid.Movers.BaseClasses.Characteristics</a>.
</li>
<li>
The efficiency calculation is different, in particular, the models in this package a"
           + "llow
use of the Euler number to compute the hydraulic efficiency.
</li>
</ul>
<h4>References</h4>
<p>
Michael Wetter.
<a href=\"modelica://Buildings/Resources/Images/Fluid/Movers/UsersGuide/2013-IBPSA-Wetter.pdf\">
Fan and pump model that has a unique solution for any pressure
boundary condition and control signal.</a>
<i>Proc. of the 13th Conference of the International Building Performance
Simulation Association</i>, p. 3505-3512. Chambery, France. August 2013.
</p>
</html>"));

end UsersGuide;
