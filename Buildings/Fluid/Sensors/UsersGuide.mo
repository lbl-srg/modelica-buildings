within Buildings.Fluid.Sensors;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains models of sensors.
There are models with one and with two fluid ports.
</p>

<h4>Selection and parameterization of sensor models</h4>
<p>
When selecting a sensor model, a distinction needs to be made
whether the measured quantity depends on the direction of the flow or
not, and whether the sensor output signal is the product of the mass flow rate
and a medium property.
</p>

<p>
Output signals that depend on the flow direction and are not multiplied by
the mass flow rate are temperature, relative humidity,
water vapor concentration <i>X</i>, trace substances <i>C</i> and density.
For such quantities, sensors with two fluid ports need to be used.
An exception is if the quantity is measured directly in a fluid volume, such as modeled in
models of the package
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a>.
Therefore, to measure for example the outlet temperature of a heat exchanger, the
configuration on the left in the figure below should be used, and not the configuration on the right.
For an explanation, see
<a href=\"modelica://Modelica.Fluid.Examples.Explanatory.MeasuringTemperature\">
Modelica.Fluid.Examples.Explanatory.MeasuringTemperature</a>.
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th valign=\"top\" align=\"left\">Correct use</th>
    <td valign=\"top\">
    <img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Sensors/twoPortHex.png\" />
    </td>
</tr>
<tr><th valign=\"top\" align=\"left\">Not recommended</th>
    <td valign=\"top\">
    <img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Sensors/onePortHex.png\" />
    </td>
</tr>
</table>

<p>
Except for the mass flow rate sensor,
all sensors with two ports can be
configured as dynamic sensors or as steady-state sensor.
For numerical reasons, if the sensor output signal is <i>not</i> multiplied by the
mass flow rate, then it is strongly suggested to configure these sensors
as a dynamic sensor, which the default setting.
Configuring a sensor as a dynamic sensor is done by setting the time constant to a non-zero
value. Typically, setting <code>tau=10</code> seconds yields good results.
For <code>tau=0</code>, numerical problems may occur if mass flow rates are close to zero.
</p>

<p>
If the sensor output signal is the product of mass flow rate times a measured fluid property,
such as sensors for volumentric flow rate or enthalpy flow rate,
then the sensor is by default configured as steady-state sensor. These sensors may be configured by the user
as a dynamic sensor by setting <code>tau &gt; 0</code>, but there is typically little benefit as these sensors typically
do not cause numerical problems.
The reason is that these sensors multiply the quantity that is carried by the flow,
such as specific enthalpy <i>h</i> by the mass flow rate <i>m&#775;</i>
to output the measured signal <i>H&#775;=m&#775; h</i>.
Hence, as the mass flow rate goes to zero, the sensor output
signal also goes to zero, which seems to avoid numerical problems.
</p>
<p>
For static pressure measurements, sensors with one or with two
ports can be used for all connection topologies.
</p>
<p>
The table below summarizes the recommendations for the use of sensors.
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th rowspan=\"2\" valign=\"top\">Measured quantity</th>
    <th rowspan=\"2\" valign=\"top\">One port sensor</th>
    <th colspan=\"2\" valign=\"top\">Two port sensor</th>
</tr>
<tr><td valign=\"top\">steady-state (<code>tau=0</code>)</td>
    <td valign=\"top\">dynamic (<code>tau &gt; 0</code>)</td>
</tr>
<tr><td valign=\"top\">temperature<br/>
                       relative humidity<br/>
                       mass fraction<br/>
                       trace substances<br/>
                       specific enthalpy<br/>
                       specific entropy</td>
    <td valign=\"top\">use only if connected to a volume</td>
    <td valign=\"top\">avoid</td>
    <td valign=\"top\">recommended</td>
</tr>
<tr><td valign=\"top\">volume flow rate<br/>
                       enthalpy flow rate<br/>
                       entropy flow rate</td>
    <td valign=\"top\">-</td>
    <td valign=\"top\">recommended</td>
    <td valign=\"top\">recommended</td>
</tr>
<tr><td valign=\"top\">pressure</td>
    <td valign=\"top\">recommended</td>
    <td valign=\"top\">recommended</td>
    <td valign=\"top\">recommended</td>
</tr>
</table>

<h4>Sensor Dynamics</h4>
<h5>Dynamic response to fluid flowing through the sensor</h5>
<p>
If a sensor is configured as a dynamic sensor by setting <code>tau &gt; 0</code>,
then the measured quantity, say the temperature <i>T</i>, is
computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &tau; &nbsp; dT &frasl; dt = |m&#775;| &frasl; m&#775;<sub>0</sub> &nbsp; (&theta;-T),
</p>
<p>
where <i>&tau;</i> is a user-defined time constant of the sensor (a suggested value is around 10 seconds,
which is the default setting for the components),
<i>dT &frasl; dt</i> is the time derivative of the sensor output signal,
<i>|m&#775;|</i> is the absolute value of the mass flow rate,
<i>m&#775;<sub>0</sub></i> is the user-specified nominal value of the mass flow rate and
<i>&theta;</i> is the temperature of the medium inside the sensor.
An equivalent physical model of such a sensor would be a perfectly mixed volume
with a sensor that outputs the temperature of this volume. In this situation, the size of the volume would
be <i>V=&tau; &nbsp; m&#775;<sub>0</sub> &frasl; &rho;</i>, where
<i>&rho;</i> is the density of the fluid.
</p>
<h5>Dynamic response to ambient temperature</h5>
<p>
For the sensor
<a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\">
Buildings.Fluid.Sensors.TemperatureTwoPort</a>,
by setting <code>transferHeat = true</code>, heat transfer to a
fixed ambient can be approximated. The heat transfer is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &tau;<sub>HeaTra</sub> &nbsp; dT &frasl; dt = (T<sub>Amb</sub>-T),
</p>
<p>
where <i>&tau;<sub>HeaTra</sub></i> is a fixed time constant and
<i>T<sub>Amb</sub></i> is a fixed ambient temperature.
Setting <code>transferHeat = true</code> is useful if the sensor output <i>T</i>
is used to switch the mass flow rate on again. If <code>transferHeat = false</code>,
then the sensor output <i>T</i> remains constant if the mass flow rate is zero
and hence a fan or pump controller that uses this signal may never switch the device
on again.
If the sensor output <i>T</i> is not used to switch on the mass flow rate, then
in general one can use <code>transferHeat=false</code>.
</p>
<p>
Note that since in practice the heat transfer is due to a combination of ambient
temperature and upstream or downstream fluid temperature, for example by two-way
buoyancy-driven flow inside the duct or pipe, the model uses as an approximation
a fixed ambient temperature.
Since the sensor is not affecting the temperature of the medium, this approximation
of the heat transfer does not add or remove heat from the fluid.
</p>
<h5>Combined dynamic response</h5>
<p>
For the sensor
<a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\">
Buildings.Fluid.Sensors.TemperatureTwoPort</a>,
if both dynamic effects are enabled, then
the output <i>T</i> is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
dT &frasl; dt = |m&#775;| &frasl; m&#775;<sub>0</sub> &nbsp; (&theta;-T) &frasl; &tau; +
(T<sub>Amb</sub>-T) &frasl;  &tau;<sub>HeaTra</sub>.
</p>
<h4>Implementation</h4>
<p>
The above equation is implemented in such a way that it is differentiable in the mass flow rate.
</p>
<p>
Note that the implementation of the dynamic sensors does not use the model
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a>.
The reason is that depending on the selected medium model, the
mixing volume may introduce states for the pressure, species concentration,
trace substance, specific enthalpy and specific entropy. Not all states are typically needed to
model the dynamics of a sensor. Moreover, in many building system applications,
the sensor dynamics is not of concern, but is rather used here to avoid numerical
problems that steady-state models of sensors cause when flow rates are
very close to zero.
</p>
</html>"));
end UsersGuide;
