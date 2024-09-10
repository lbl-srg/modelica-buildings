within Buildings.Fluid;
package Actuators "Package with actuator models such as valves and dampers"
  extends Modelica.Icons.VariantsPackage;


package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<h4>Pressure drop of valves</h4>
<p>
All two and three-way valves have a parameter
<code>dpFixed_nominal</code>. This parameter can be set to a positive (non-zero)
value to model a pressure drop that is in series to the valve.
If <code>dpFixed_nominal=0</code>, then only the valve pressure drop is modeled.
</p>
<p>
For example, in the schematics below, a valve and a fixed resistance
are modeled in series.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Actuators/valvePressureDropSeries.png\"/>
</p>
<p>
This often introduces an additional nonlinear equation.
Suppose that in the above model, the parameters for the flow resistance are
</p>
<pre>
  val(dpValve_nominal=6000, dpFixed=0, m_flow_nominal=0.1);
  res(dp_nominal=10000,                m_flow_nominal=0.1);
</pre>
<p>
Instead of this arrangement, the model <code>res</code> can be deleted
and the valve configured as
</p>
<pre>
  val(dpValve_nominal=6000, dpFixed=10000, m_flow_nominal=0.1);
</pre>
<p>
This yields the same simulation results, but a nonlinear equation can be avoided
in some cases. Although lumping the pressure drop of other components into the
valve model violates the intent that in component-based modeling, each component
should only model its own behavior, having the option of eliminating
a nonlinear equation can be worthwhile.
</p>
<p>
For three way valves, similar parameters exist for the controlled ports of the valve. For example,
consider the configuration below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Actuators/threeWayValvePressureDropSeries.png\"/>
</p>
<p>
Suppose the parameters are
</p>
<pre>
  val(dpValve_nominal=6000, dpFixed={0, 0}, m_flow_nominal=0.1);
  res1(dp_nominal=10000,                    m_flow_nominal=0.1);
  res3(dp_nominal=100,                      m_flow_nominal=0.1);
</pre>
<p>
An equivalent model could be created by deleting the two resistance models
<code>res1</code> and <code>res3</code>, and configuring the valve as
</p>
<pre>
  val(dpValve_nominal=6000, dpFixed={10000, 100}, m_flow_nominal=0.1);
</pre>
<h4>Leakage flow rate</h4>
<p>
Valves and air dampers should for numerical reasons have a small leakage flow rate.
This leakage <i>l</i> is a non-dimensional number, defined as
<i>l=K<sub>v</sub>(y=0) &frasl; =K<sub>v</sub>(y=1)</i>.
A typical default value is <i>l=0.0001</i>.
</p>
<p>
If <i>l=0</i>, models will issue an error message as
this can in some situations lead to numerical problems if
a flow leg becomes decoupled from a reference pressure source.
</p>
<h4>Transients of actuators</h4>
<p>
This section describes how valves and dampers can be configured
to approximate the travel time of an actuator.
Such an approximation can also lead to faster simulation because
discrete or fast changes in controllers are damped before they
influence the flow network.
</p>
<h5>Approximation using a 2nd order filter</h5>
<p>
The valves and dampers in the package
<a href=\"modelica://Buildings.Fluid.Actuators\">
Buildings.Fluid.Actuators</a>
all have a parameter <code>use_strokeTime</code>.
This parameter is used as follows:
</p>
<ul>
<li>
If <code>use_strokeTime=false</code>, then the actual valve
or damper position is equal to the input signal <code>y</code>.
</li>
<li>
If <code>use_strokeTime=true</code>, then the actual valve or damper position
is computed in such a way that it approximates a valve motor.
This approximation is implemented using a 2nd order low-pass filter.
The filter has a parameter <code>strokeTime</code>, which by default is
set to <i>120</i> seconds.
The rise time is the time required to reach 99.6% of the opening.
</li>
</ul>
<p>
Using a filter often leads to a more robust simulation,
because a step change
in the input signal is \"smoothened\" by the filter, and
hence the flow network is only exposed to a continuously differentiable change
in the input signal.
However, if the filter is part of a closed loop control, then the transient
response gets changed. Therefore, if the parameter <code>use_strokeTime</code>
is changed, control gains may need to be retuned.
</p>
<p>
For example, suppose there is a closed loop control with a PI-controller
<a href=\"modelica://Buildings.Controls.Continuous.LimPID\">
Buildings.Controls.Continuous.LimPID</a>
and a valve, configured with <code>use_strokeTime=true</code> and <code>strokeTime=120</code> seconds.
Assume that the transient response of the other dynamic elements in the control loop is fast
compared to the rise time of the filter.
Then, a proportional gain of <code>k=0.1</code> and an integrator time constant of
<code>Ti=120</code> seconds often yields satisfactory closed loop control performance.
These values may need to be changed for different applications as they are also a function
of the loop gain.
If the control loop shows oscillatory behavior, then reduce <code>k</code> and/or increase <code>Ti</code>.
If the control loop reacts too slow, do the opposite.
</p>
<p>
We will now show how the parameter <code>strokeTime</code> affects the actual position of a
control valve.
The figure below shows a model with two control valves.
The valve <code>val1</code> is configured with <code>use_strokeTime=true</code>
and a rise time <code>strokeTime=120</code> seconds.
The grey motor symbol above the control valve <code>val1</code>
indicates that <code>use_strokeTime=true</code>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Actuators/valveSchematic.png\"/>
</p>
<p>
If these valves both have a step input signal at <i>10</i> seconds, then the
actual opening of the valves are as follows:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Actuators/valveResponse.png\"/>
</p>
<p>
Thus, in the valve <code>val1</code>, the mass flow rate will slowly increase,
whereas in <code>val2</code>, the mass flow rate changes instantaneously.
</p>
<p>
If <code>use_strokeTime=true</code>, then the parameter
<code>y_start</code> can be used to set the initial position of the
actuator, and the parameter
<code>init</code> can be used to configure how the position
should be initialized.
</p>
<p>
For most applications, the default values are appropriate.
Although adding a filter increases the number of equations,
it can reduce computing time because the equations are
easier to solve when a controller switches.
</p>
<h5>Approximation using a motor model with hysteresis</h5>
<p>
The model
<a href=\"modelica://Buildings.Fluid.Actuators.Motors.IdealMotor\">
Buildings.Fluid.Actuators.Motors.IdealMotor</a>
models a motor with hysteresis.
It is more detailed than the above approximation.
However, it can significantly increase computing time
because it generates a state event whenever the valve position changes.
</p>
</html>"));

end UsersGuide;


annotation (preferredView="info", Documentation(info="<html>
This package contains component models for actuators.
</html>"));
end Actuators;
