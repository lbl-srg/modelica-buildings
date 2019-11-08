within Buildings.Experimental.EnergyPlus.Types;
type Units = enumeration(
    AngleRad        "Angle (rad)",
    AngleDeg        "Angle (deg)",
    EnergyJ         "Energy (J)",
    Illuminance_lm_m2
                    "Illuminance",
    HumidityAbsolute
                    "Absolute humidity (mass fraction per total mass of moist air)",
    HumidityRelative
                    "Relative humidity (1)",
    LuminousFlux    "Luminous flux (cd.sr)",
    MassFlowRate    "Mass flow rate (kg/s)",
    Power           "Power (W)",
    Pressure        "Pressure (Pa)",
    Status          "Status (e.g., rain) (1)",
    Temperature     "Temperature (K)",
    Time            "Time (s)",
    Transmittance   "Transmittance, reflectance and absorptance (1)",
    VolumeFlowRate  "VolumeFlowRate (m3/s)",
    unspecified     "Unspecified (not a valid entry for simulation)")
  "Enumeration for units used for schedules and EMS actuators"
 annotation (
    Documentation(info="<html>
<p>
Enumeration for the units used as inputs to the block
<a href=\"modelica://Buildings.Experimental.EnergyPlus.Schedule\">Buildings.Experimental.EnergyPlus.Schedule</a>.
</p>
<p>
The units are converted between Modelica and EnergyPlus as shown in the table below.
</p>
<table>
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
<tr class=\"row-odd\"><td><p>Transmittance,
reflectance, and
absorptance</p></td>
<td><p>(no character,
specified as a
value between 0
and 1)</p></td>
<td><p>1</p></td>
</tr>
<tr class=\"row-even\"><td><p>Volume flow rate</p></td>
<td><p>m3/s</p></td>
<td><p>m3/s</p></td>
</tr>
</tbody>
</table>
</html>", revisions="<html>
<ul>
<li>
November 8, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
