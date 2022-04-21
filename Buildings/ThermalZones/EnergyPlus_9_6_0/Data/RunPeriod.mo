within Buildings.ThermalZones.EnergyPlus_9_6_0.Data;
record RunPeriod "Record for EnergyPlus RunPeriod"
  extends Modelica.Icons.Record;

  parameter Buildings.ThermalZones.EnergyPlus_9_6_0.Types.WeekDays dayOfWeekForStartDay = Buildings.ThermalZones.EnergyPlus_9_6_0.Types.WeekDays.Sunday
    "Week day of the first day that is simulated";
  parameter Boolean dayOfWeekIsAtTime0 = true "Set to true if dayOfWeekForStartDay corresponds to model time = 0";

  parameter Boolean applyWeekEndHolidayRule = false "Set to true to apply week-end holiday rules";
  parameter Boolean use_weatherFileDaylightSavingPeriod = false
    "Set to true to apply the daylight saving period from the weather data file if present";
  parameter Boolean use_weatherFileHolidaysAndSpecialDays = false
    "Set to true to apply holidays and special days from the weather data file if present";
  parameter Boolean use_weatherFileRainIndicators = true
    "Set to true to use rain indicators from the weather file";
  parameter Boolean use_weatherFileSnowIndicators = true
    "Set to true to use rain indicators from the weather file";

  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "runPer",
  Documentation(
info="<html>
<p>
Record containing the configuration of the EnergyPlus <code>RunPeriod</code> object.
</p>
<p>
EnergyPlus has an entry \"Day of Week for Start Day\" that determines the week-day of the first simulated day.
This can be set with the Modelica parameter <code>dayOfWeekForStartDay</code> and by setting <code>dayOfWeekIsAtTime0 = false</code>.
For example, if in Modelica the start time is <i>t=24*3600</i> seconds, the setting
</p>
<pre>
dayOfWeekForStartDay = Buildings.ThermalZones.EnergyPlus_9_6_0.Types.WeekDays.Sunday,
dayOfWeekIsAtTime0 = false
</pre>
<p>
will cause the first simulated day, i.e., January 2, to be a Sunday, and January 3 to be a Monday. This is the
default behavior of EnergyPlus. However, note that if a model is started at
<i>t=2*24*3600</i>, i.e., on January 3, then with this setting, January 3 is now the Sunday.
This can give unexpected behavior if a modeller changes the start time and through this action,
January 3 is no longer a Monday.
To allow a modeller to avoid this behavior,
Modelica uses the parameter <code>dayOfWeekIsAtTime0</code>, with default set to <code>true</code>.
For the above scenario, this means that January 1 is a Sunday, January 2 is a Monday and January 3 is Tuesday,
regardless of whether the simulation starts at <i>t=24*3600</i> seconds or at <i>t=2*24*3600</i> seconds.
</p>
<p>
Note that the simulation start and stop time is controlled by Modelica,
and therefore the entries in the EnergyPlus input data file for the
<code>RunPeriod</code> object are ignored.
</p>
</html>",
  revisions="<html>
<ul>
<li>
April 21, 2022, by Michael Wetter:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2926\">#2926</a>.
</li>
</ul>
</html>"));
end RunPeriod;
