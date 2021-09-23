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
<td>Efficiency</td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters\">
efficiencyParameters</a></td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiency\">
efficiency</a></td>
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
the hydraulic power input <i>W<sub>hyd</sub></i>, the flow work
<i>W<sub>flo</sub></i> and the heat dissipated into the medium
<i>Q</i>. Based on the first law, the flow work is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  W<sub>flo</sub> = | V&#775; &Delta;p |,
</p>
<p>
where <i>V&#775;</i> is the volume flow rate and
<i>&Delta;p</i> is the pressure rise.
The heat dissipated into the medium is as follows:
If the motor is cooled by the fluid, as indicated by
<code>per.motorCooledByFluid=true</code>, then the heat dissipated into the medium is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q = P<sub>ele</sub> - W<sub>flo</sub>.
</p>

<p>
If <code>per.motorCooledByFluid=false</code>, then the motor is outside the fluid stream,
and only the shaft, or hydraulic, work <i>W<sub>hyd</sub></i> enters the thermodynamic
control volume. Hence,
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q = Q<sub>hyd</sub> - W<sub>flo</sub>.
</p>
<p>The efficiencies are computed as</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta; = W<sub>flo</sub> &frasl; P<sub>ele</sub> = &eta;<sub>hyd</sub> &nbsp; &eta;<sub>mot</sub> <br/>
  &eta;<sub>hyd</sub> = W<sub>flo</sub> &frasl; W<sub>hyd</sub> <br/>
  &eta;<sub>mot</sub> = W<sub>hyd</sub> &frasl; P<sub>ele</sub> <br/>
</p>
<p>where
<i>&eta;<sub>hyd</sub></i> is the hydraulic efficiency,
<i>&eta;<sub>mot</sub></i> is the motor efficiency and
<i>Q</i> is the heat released by the motor.
</p>
<p>
If <code>per.use_powerCharacteristic=true</code>,
then a set of data points for the power <i>P<sub>ele</sub></i> for different
volume flow rates at full speed needs to be provided by the user.
Using the flow work <i>W<sub>flo</sub></i> and the electrical power input
<i>P<sub>ele</sub></i>, the total efficiency is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta; = W<sub>flo</sub> &frasl; P<sub>ele</sub>, <br/>
</p>
<p>
and the two efficiencies
<i>&eta;<sub>hyd</sub></i>
and <i>&eta;<sub>mot</sub></i> are computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta;<sub>hyd</sub> = 1,<br/>
  &radic;&eta;<sub>mot</sub> = &eta;.
</p>
<p>
However, if <code>per.use_powerCharacteristic=false</code>, then
performance data for
<i>&eta;<sub>hyd</sub></i> and
 <i>&eta;<sub>mot</sub></i> need to be provided by the user, and hence
the model computes
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta; = &eta;<sub>hyd</sub> &nbsp; &eta;<sub>mot</sub><br/>
  P<sub>ele</sub> = W<sub>flo</sub> &frasl; &eta;.
</p>

<p>
The efficiency data for the motor are a list of points
<i>V&#775;</i> and <i>&eta;<sub>mot</sub></i>.
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
