within Buildings.ThermalZones.EnergyPlus_24_2_0.Types;
type Units = enumeration(
    Normalized
  "Normalized, such as a control signal between 0 and 1 or status 0, 1, 2, ... (1)",
    AngleRad
  "Angle (rad)",
    AngleDeg
  "Angle (deg)",
    Energy
  "Energy (J)",
    Illuminance
  "Illuminance",
    HumidityAbsolute
  "Absolute humidity (mass fraction per total mass of moist air)",
    HumidityRelative
  "Relative humidity (1)",
    LuminousFlux
  "Luminous flux (cd.sr)",
    MassFlowRate
  "Mass flow rate (kg/s)",
    Power
  "Power (W)",
    Pressure
  "Pressure (Pa)",
    Status
  "Status (e.g., rain) (1)",
    Temperature
  "Temperature (K)",
    Time
  "Time (s)",
    VolumeFlowRate
  "VolumeFlowRate (m3/s)")
  "Enumeration for units used for schedules and EMS actuators"
  annotation (Documentation(info="<html>
<p>
Enumeration for the units used as inputs to the block
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Schedule\">Buildings.ThermalZones.EnergyPlus_24_2_0.Schedule</a>.
</p>
<p>
The units are converted between Modelica and EnergyPlus as shown in the table below.
</p>
<table summary=\"Table with unit conversions\">
<colgroup>
<col style=\"width: 32%\" />
<col style=\"width: 24%\" />
<col style=\"width: 44%\" />
</colgroup>
<thead>
<tr class=\"row-odd\"><th class=\"head\"><p>Quantity</p></th>
<th class=\"head\"><p>EnergyPlus
Unit String</p></th>
<th class=\"head\"><p>Modelica Unit</p></th>
</tr>
</thead>
<tbody>
<tr class=\"row-even\"><td><p>Angle (rad)</p></td>
<td><p>rad</p></td>
<td><p>rad</p></td>
</tr>
<tr class=\"row-odd\"><td><p>Angle (deg)</p></td>
<td><p>deg</p></td>
<td><p>rad</p></td>
</tr>
<tr class=\"row-even\"><td><p>Energy</p></td>
<td><p>J</p></td>
<td><p>J</p></td>
</tr>
<tr class=\"row-odd\"><td><p>Illuminance</p></td>
<td><p>lux</p></td>
<td><p>lm/m2</p></td>
</tr>
<tr class=\"row-even\"><td><p>Humidity (absolute)</p></td>
<td><p>kgWater/kgDryAir</p></td>
<td><p>1 (converted to mass fraction
per total mass of moist air)</p></td>
</tr>
<tr class=\"row-odd\"><td><p>Humidity (relative)</p></td>
<td><p>%</p></td>
<td><p>1</p></td>
</tr>
<tr class=\"row-even\"><td><p>Luminous flux</p></td>
<td><p>lum</p></td>
<td><p>cd.sr</p></td>
</tr>
<tr class=\"row-odd\"><td><p>Mass flow rate</p></td>
<td><p>kg/s</p></td>
<td><p>kg/s</p></td>
</tr>
<tr class=\"row-even\"><td><p>Power</p></td>
<td><p>W</p></td>
<td><p>W</p></td>
</tr>
<tr class=\"row-odd\"><td><p>Pressure</p></td>
<td><p>Pa</p></td>
<td><p>Pa</p></td>
</tr>
<tr class=\"row-even\"><td><p>Status (e.g., rain)</p></td>
<td><p>(no character)</p></td>
<td><p>1</p></td>
</tr>
<tr class=\"row-odd\"><td><p>Temperature</p></td>
<td><p>degC</p></td>
<td><p>K</p></td>
</tr>
<tr class=\"row-even\"><td><p>Time</p></td>
<td><p>s</p></td>
<td><p>s</p></td>
</tr>
<tr class=\"row-odd\"><td><p>Volume flow rate</p></td>
<td><p>m3/s</p></td>
<td><p>m3/s</p></td>
</tr>
</tbody>
</table>
</html>",revisions="<html>
<ul>
<li>
November 8, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(
  graphics={Rectangle(lineColor={200,200,200},fillColor={248,248,248},
  fillPattern=FillPattern.HorizontalCylinder,extent={{-100,-100},{100,100}},radius=25.0),
  Polygon(fillColor={128,128,128},pattern=LinePattern.None,fillPattern=FillPattern.Solid,
  points={{-80,-40},{-80,-40},{-55,50},{-52.5,62.5},{-65,60},{-65,65},{-35,77.5},{-32.5,60},{-50,0},
  {-50,0},{-30,15},{-20,27.5},{-32.5,27.5},{-32.5,27.5},{-32.5,32.5},{-32.5,32.5},{2.5,32.5},
  {2.5,32.5},{2.5,27.5},{2.5,27.5},{-7.5,27.5},{-30,7.5},{-30,7.5},{-25,-25},{-17.5,-28.75},
  {-10,-25},{-5,-26.25},{-5,-32.5},{-16.25,-41.25},{-31.25,-43.75},{-40,-33.75},{-45,-5},
  {-45,-5},{-52.5,-10},{-52.5,-10},{-60,-40},{-60,-40}},smooth=Smooth.Bezier),
  Polygon(fillColor={128,128,128},pattern=LinePattern.None,fillPattern=FillPattern.Solid,
  points={{87.5,30},{62.5,30},{62.5,30},{55,33.75},{36.25,35},{16.25,25},{7.5,6.25},{11.25,-7.5},
  {22.5,-12.5},{22.5,-12.5},{6.25,-22.5},{6.25,-35},{16.25,-38.75},{16.25,-38.75},{21.25,-41.25},
  {21.25,-41.25},{45,-48.75},{47.5,-61.25},{32.5,-70},{12.5,-65},{7.5,-51.25},{21.25,-41.25},
  {21.25,-41.25},{16.25,-38.75},{16.25,-38.75},{6.25,-41.25},{-6.25,-50},{-3.75,-68.75},
  {30,-76.25},{65,-62.5},{63.75,-35},{27.5,-26.25},{22.5,-20},{27.5,-15},{27.5,-15},{30,-7.5},
  {30,-7.5},{27.5,-2.5},{28.75,11.25},{36.25,27.5},{47.5,30},{53.75,22.5},{51.25,8.75},{45,-6.25},
  {35,-11.25},{30,-7.5},{30,-7.5},{27.5,-15},{27.5,-15},{43.75,-16.25},{65,-6.25},{72.5,10},{70,20},
  {70,20},{80,20}},smooth=Smooth.Bezier)}));
