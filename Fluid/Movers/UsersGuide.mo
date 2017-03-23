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
<p>
The models use 
performance curves that compute pressure rise, 
electrical power draw and efficiency as a function 
of the volume flow rate and the speed.
These performance curves are described in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics\">
Buildings.Fluid.Movers.BaseClasses.Characteristics</a>.
</p>

<h5>Models that use performance curves for pressure rise</h5>
<p>
The models
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_y\">
Buildings.Fluid.Movers.FlowMachine_y</a> and
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_Nrpm\">
Buildings.Fluid.Movers.FlowMachine_Nrpm</a>
take as an input either a control signal between <i>0</i> and <i>1</i>, or the
rotational speed in units of <i>[1/min]</i>. From this input and the current flow rate,
they compute the pressure rise.
This pressure rise is computed using user-provided list of operating points that 
defines the fan or pump curve at full speed.
For other speeds, similarity laws are used to scale the performance curves, as
described in 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure</a>.
</p>

<p>
For example, suppose a pump needs to be modeled whose pressure versus flow relation crosses, at
full speed, the points shown in the table below.</p>
  <table summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
  <tr>
      <th>Volume flow rate [m<sup>3</sup>&frasl;h] </th>
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
  Buildings.Fluid.Movers.FlowMachine_y pum(
    redeclare package Medium = Medium,
    pressure(V_flow={0.0003,0.0006,0.0008},
             dp    ={45,35,15}*1000))
    \"Circulation pump\";
</pre>

<p>
This will model the following pump curve for the pump input signal <code>y=1</code>.</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/UsersGuide_pumpCurve.png\"/>
</p>

<h5>Models that have idealized perfect controls</h5>
<p>
The models <a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_dp\">
Buildings.Fluid.Movers.FlowMachine_dp</a> and
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_m_flow\">
Buildings.Fluid.Movers.FlowMachine_m_flow</a>
take as an input the pressure difference or the mass flow rate.
This pressure difference or mass flow rate will be provided by the fan or pump,
i.e., the fan or pump has idealized perfect control and infinite capacity.
These two models do not have a performance curve for the flow
characteristics.
The reason for not using a performance curve for the flow characteristics is that</p>
<ul>
<li>
for given pressure rise (or mass flow rate), the mass flow rate (or pressure rise)
is defined by the flow resistance of the duct or piping network, and
</li>
<li>
at zero pressure difference, solving for the flow rate and the revolution leads to a singularity.
</li>
</ul>

<h5>Start-up and shut-down transients</h5>
<p>
All models have a parameter <code>filteredSpeed</code>. This
parameter affects the fan output as follows:
</p>
<ol>
<li>
If <code>filteredSpeed=false</code>, then the input signal <code>y</code> (or
<code>Nrpm</code>, <code>m_flow_in</code>, or <code>dp_in</code>)
is equal to the fan speed (or the mass flow rate or pressure rise).
Thus, a step change in the input signal causes a step change in the fan speed (or mass flow rate or pressure rise).
</li>
<li>
<p>
If <code>filteredSpeed=false</code>, which is the default,
then the fan speed (or the mass flow rate or the pressure rise)
is equal to the output of a filter. This filter is implemented
as a 2nd order differential equation and can be thought of as 
approximating the inertia of the rotor and the fluid.
Thus, a step change in the fan input signal will cause a gradual change
</p>
in the fan speed.
The filter has a parameter <code>riseTime</code>, which by default is set to
<i>30</i> seconds. 
The rise time is the time required to reach <i>99.6%</i> of the full speed, or,
if the fan is switched off, to reach a fan speed of <i>0.4%</i>.
</li>
</ol>

<p>
The figure below shows for a fan with <code>filteredSpeed=true</code>
and <code>riseTime=30</code> seconds the 
speed input signal and the actual speed.</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/UsersGuide_fanSpeedFiltered.png\"/>
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
of <code>filteredSpeed=true</code> and <code>riseTime=30</code> seconds.
An exception are situations in which the fan or pump is operated at a fixed speed during
the whole simulation. In this case, set <code>filteredSpeed=false</code>.
</p>
<p>
Note that if the fan is part of a closed loop control, then the filter affects
the transient response of the control. 
When changing the value of <code>filteredSpeed</code>, the control gains
may need to be retuned. 
We now present values control parameters that seem to work in most cases.
Suppose there is a closed loop control with a PI-controller 
<a href=\"modelica://Buildings.Controls.Continuous.LimPID\">
Buildings.Controls.Continuous.LimPID</a>
and a fan or pump, configured with <code>filteredOpening=true</code> and <code>riseTime=30</code> seconds.
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
  W<sub>flo</sub> = | V &Delta;p |.
</p>
<p>
The heat dissipated into the medium is as follows: 
If the motor is cooled by the fluid, as indicated by 
<code>motorCooledByFluid=true</code>, then the heat dissipated into the medium is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q = P<sub>ele</sub> - W<sub>flo</sub>.
</p>

<p>
If <code>motorCooledByFluid=false</code>, then the motor is outside the fluid stream,
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
If <code>use_powerCharacteristic=true</code>,
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
  &radic;&eta;<sub>hyd</sub> = &radic;&eta;<sub>mot</sub> = &eta;.
</p>
<p>
However, if <code>use_powerCharacteristic=false</code>, then
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
<i>r<sub>V</sub></i> and <i>&eta;<sub>mot</sub></i>,
where <i>r<sub>V</sub></i> is the ratio of actual volume flow rate divided by the
maximum volume flow rate <code>V_flow_max</code>,
which is the volume flow rate at full speed and zero pressure rise.
The maximum flow rate <code>V_flow_max</code> is obtained as follows:
The models 
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_y\">
Buildings.Fluid.Movers.FlowMachine_y</a> and
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_Nrpm\">
Buildings.Fluid.Movers.FlowMachine_Nrpm</a> set
</p>
<pre>
  V_flow_max = V_flow(dp=0, r_N=1);
</pre>

<p>
where <code>r_N</code> is the ratio of actual to nominal speed.
Since <a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_dp\">
Buildings.Fluid.Movers.FlowMachine_dp</a> and
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_m_flow\">
Buildings.Fluid.Movers.FlowMachine_m_flow</a>
do not have a flow versus pressure performance curve, the parameter
<code>V_flow_max</code> is assigned in these two models as
</p>
<pre>
  V_flow_max = m_flow_nominal/rho_nominal,
</pre>
<p>
where <code>m_flow_nominal</code> is the maximum flow rate, which needs to be
provided by the user as a parameter for these models, and <code>rho_nominal</code> is the
density at the nominal operating point.
</p>

<h5>Fluid volume of the component</h5>
<p>
All models can be configured to have a fluid volume at the low-pressure side.
Adding such a volume sometimes helps the solver to find a solution during
initialization and time integration of large models.
</p>

<h5>Enthalpy change of the component</h5>
<p>
If <code>motorCooledByFluid=true</code>, then
the enthalpy change between the inlet and outlet fluid port is equal 
to the electrical power <i>P<sub>ele</sub></i> that is consumed by the component.
Otherwise, it is equal to the hydraulic work <i>W<sub>hyd</sub></i>.
The parameter <code>addPowerToMedium</code>, which is by default set to 
<code>true</code>, can be used to simplify the equations.
If it is set to <code>false</code>, then no enthalpy change occurs between
inlet and outlet other than the flow work <i>W<sub>flo</sub></i>.
This can lead to simpler equations, but the temperature rise across the component
will be underestimated, in particular for fans.
</p>

<h5>Further description</h5>
<p>
For a detailed description of the models with names <code>FlowMachine_*</code>,
see their base class <a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine\">
Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine.</a>
</p>

<h5>Deprecated model</h5>
<p>
The model <a href=\"modelica://Buildings.Fluid.Movers.FlowMachinePolynomial\">
Buildings.Fluid.Movers.FlowMachinePolynomial</a> is in this package for compatibility 
with older versions of this library. It is recommended to use the other models as they optionally
allow use of a medium volume that provides state variables which are needed in some models 
when the flow rate is zero.
</p>

<h4>Differences to models in Modelica.Fluid.Machines</h4>
<p>
The models with names <code>FlowMachine_*</code> have similar parameters than the
models in the package <a href=\"Modelica.Fluid.Machines\">Modelica.Fluid.Machines</a>. 
However, the models in this package differ primarily in the following points:
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
<a href=\"Modelica.Fluid.Machines\">Modelica.Fluid.Machines</a> converts head to pressure using the density <code>medium.d</code>. Therefore, for fans, head would be converted to pressure using the density of air. However, for fans, manufacturers typically publish the head in millimeters water (mmH20). Therefore, to avoid confusion when using these models with media other than water, 
we changed the models to use total pressure in Pascals instead of head in meters.
</li>
<li>
The performance data are interpolated using cubic hermite splines instead of polynomials.
These functions are implemented at <a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics\">Buildings.Fluid.Movers.BaseClasses.Characteristics</a>.
</li>
</ul>
</html>"));

end UsersGuide;
