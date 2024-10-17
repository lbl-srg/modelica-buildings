within Buildings.ThermalZones.EnergyPlus_24_2_0.Types;
type WeekDays = enumeration(
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday)
  "Enumeration for the day of the week"
  annotation (Documentation(info="<html>
<p>
Enumeration for the day of the week that is sent to EnergyPlus to configure
the first day of the EnergyPlus run period.
The possible values are
<code>Monday</code>,
<code>Tuesday</code>,
<code>Wednesday</code>,
<code>Thursday</code>,
<code>Friday</code>,
<code>Saturday</code> and
<code>Sunday</code>.
</p>
</html>",revisions="<html>
<ul>
<li>
April 21, 2022, by Michael Wetter:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2926\">#2926</a>.
</li>
</ul>
</html>"),
  Icon(
    graphics={Rectangle(
      lineColor={200,200,200},
      fillColor={248,248,248},
      fillPattern=FillPattern.HorizontalCylinder,
      extent={{-100,-100},{100,100}},radius=25.0), Text(
        extent={{-100,100},{100,-100}},
        textColor={0,0,0},
        textString="W")}));
