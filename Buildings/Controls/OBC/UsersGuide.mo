within Buildings.Controls.OBC;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  class Conventions "Naming conventions in OBC package"
    extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The <code>Buildings.Control.OBC</code> package follows the naming conventions of
the <code>Buildings</code> Library,
see <a href=\"modelica://Buildings.UsersGuide.Conventions\">Buildings.UsersGuide.Conventions</a>.
The table below shows some examples of commonly used names.
Note that the names are generally composed as follows:
</p>
<ul>
<li>
<p>If needed to understand the context, as a prefix <code>u</code> for input or <code>y</code> for output may be used.</p>
</li>
<li>
<p>Next, the quantity is used, such as <code>TOut</code> or <code>TZonHea</code>.</p>
</li>
<li>
<p>Finally, as a postfix a qualifier may be added, such as <code>Set</code> for setpoint, <code>Min</code> for minimum,
or <code>Coo</code> for cooling.
</p>
</li>
</ul>
<p>
Generally, we strife for short names, and therefore often prefix or postfix are omitted if
the type of the variable is clear from the context.
For example, a room temperature thermostat may simply use <code>T</code> as an input
as it is clear that this will be the room temperature.
</p>
<table summary=\"summary\" border=\"1\">
<tr><td colspan=\"2\"><b>Instance names</b></td></tr>
<tr><th>Name</th><th>Comments</th></tr>
<tr><td><code>TOut</code> (<code>hOut</code>)</td>
    <td>Outdoor air temperature (enthalpy)</td></tr>
<tr><td><code>TZonHeaSet</code> (<code>TZonCooSet</code>)</td>
    <td>Zone heating (cooling) setpoint temperature</td></tr>
<tr><td><code>VDis_flow</code></td>
    <td>Measured discharge airflow rate</td></tr>
<tr><td><code>dpBui</code></td>
    <td>Building static pressure difference, relative to ambient</td></tr>
<tr><td><code>uOpeMod</code></td>
    <td>Zone group operating mode</td></tr>
<tr><td><code>uResReq</code></td>
    <td>Number of reset requests</td></tr>
<tr><td><code>uSupFan</code></td>
    <td>Current supply fan enabling status, <code>true</code>: fan is enabled</td></tr>
<tr><td><code>uSupFanSpe</code></td>
    <td>Current supply fan speed</td></tr>
<tr><td><code>uDam</code></td>
    <td>Measured damper position</td></tr>
<tr><td><code>uHea</code> (<code>uCoo</code>)</td>
    <td>Heating (cooling) loop signal</td></tr>
<tr><td><code>yPosMin</code> (<code>yPosMax</code>)</td>
    <td>Minimum (maximum) position</td></tr>
<tr><td><code>yDamSet</code> (<code>yValSet</code>)</td>
    <td>Damper (valve) position setpoint</td></tr>
<tr><td><code>yHeaCoi</code> (<code>yCooCoi</code>)</td>
    <td>Heating (cooling) coil control signal</td></tr>
<tr><td colspan=\"2\"><b>Parameter names</b></td></tr>
<tr><th>Name</th> <th>Comments</th></tr>
<tr><td><code>use_TMix</code></td>
    <td>Set to <code>true</code> if mixed air temperature measurement is used</td></tr>
<tr><td><code>have_occSen</code> (<code>have_winSen</code>)</td>
    <td>Set to <code>true</code> if the zone has occupancy (window) sensor</td></tr>
<tr><td><code>AFlo</code></td>
    <td>Area of the zone</td></tr>
<tr><td><code>VDisHeaSetMax_flow</code> (<code>VDisCooSetMax_flow</code>)</td>
    <td>Zone maximum heating (cooling) airflow setpoint</td></tr>
<tr><td><code>VOutPerAre_flow</code> (<code>VOutPerPer_flow</code>)</td>
    <td>Outdoor air rate per unit area (person)</td></tr>
<tr><td><code>V_flow_nominal</code></td>
    <td>Nominal volume flow rate</td></tr>
<tr><td><code>VOutMin_flow</code></td>
    <td>Calculated minimum outdoor airflow rate at design stage</td></tr>
<tr><td><code>pMinSet</code> (<code>pMaxSet</code>)</td>
    <td>Minimum (maximum) pressure setpoint for fan speed control</td></tr>
<tr><td><code>TSupSetMin</code> (<code>TSupSetMax</code>)</td>
    <td>Lowest (Highest) cooling supply air temperature</td></tr>
<tr><td><code>TOccHeaSet</code> (<code>TUnoHeaSet</code>)</td>
    <td>Zone occupied (unoccupied) heating setpoint</td></tr>
<tr><td><code>TZonCooMax</code> (<code>TZonCooMin</code>)</td>
    <td>Maximum (minimum) zone cooling setpoint when cooling is on</td></tr>
<tr><td><code>retDamPhyPosMax</code> (<code>outDamPhyPosMax</code>)</td>
    <td>Physically fixed maximum position of the return (outdoor) air damper</td></tr>
<tr><td><code>samplePeriod</code></td>
    <td>Sample period</td></tr>
<tr><td><code>zonDisEffHea</code> (<code>zonDisEffCoo</code>)</td>
    <td>Zone air distribution effectiveness during heating (cooling)</td></tr>
<tr><td><code>kCoo</code></td>
    <td>Gain for cooling control loop signal</td></tr>
<tr><td><code>TiCoo</code></td>
    <td>Time constant of integrator block for cooling control loop signal</td></tr>
<tr><td><code>TdCoo</code></td>
    <td>Time constant of derivative block for cooling control loop signal</td></tr>
</table>
<br/>
</html>"),
    Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(origin={-4.167,-15},
          fillColor={255,255,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-15.833,20.0},{-15.833,30.0},{14.167,40.0},{24.167,20.0},{4.167,-30.0},{14.167,-30.0},{24.167,-30.0},{24.167,-40.0},{-5.833,-50.0},{-15.833,-30.0},{4.167,20.0},{-5.833,20.0}},
          smooth=Smooth.Bezier),
        Ellipse(origin={7.5,56.5},
          fillColor={255,255,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-12.5,-12.5},{12.5,12.5}})}));
  end Conventions;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The package <a href=\"modelica://Buildings.Controls.OBC\">Buildings.Controls.OBC</a>
contains models for building control. The control sequences, which include the HVAC
airside system control
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1\">Buildings.Controls.OBC.ASHRAE.G36_PR1</a>,
the outdoor lighting control <a href=\"modelica://Buildings.Controls.OBC.OutdoorLights\">Buildings.Controls.OBC.OutdoorLights</a>,
and the shading device control <a href=\"modelica://Buildings.Controls.OBC.Shade\">Buildings.Controls.OBC.Shade</a>,
are composed of the elementary blocks from the package
<a href=\"modelica://Buildings.Controls.OBC.CDL\">Buildings.Controls.OBC.CDL</a>.
</p>
<p>
The package also contains models for unit conversions,
<a href=\"modelica://Buildings.Controls.OBC.UnitConversions\">Buildings.Controls.OBC.UnitConversions</a>,
and utilities models, such as
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">Buildings.Controls.OBC.Utilities.OptimalStart</a>,
which output the optimal start time for an HVAC system.
</p>
</html>"),
  Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(origin={-4.167,-15},
          fillColor={255,255,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-15.833,20.0},{-15.833,30.0},{14.167,40.0},{24.167,20.0},{4.167,-30.0},{14.167,-30.0},{24.167,-30.0},{24.167,-40.0},{-5.833,-50.0},{-15.833,-30.0},{4.167,20.0},{-5.833,20.0}},
          smooth=Smooth.Bezier),
        Ellipse(origin={7.5,56.5},
          fillColor={255,255,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-12.5,-12.5},{12.5,12.5}})}));
end UsersGuide;
