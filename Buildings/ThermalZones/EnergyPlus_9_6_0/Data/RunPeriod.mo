within Buildings.ThermalZones.EnergyPlus_9_6_0.Data;
record RunPeriod "Record for EnergyPlus RunPeriod"
  extends Modelica.Icons.Record;

  parameter Buildings.ThermalZones.EnergyPlus_9_6_0.Types.WeekDays startDayOfYear = Buildings.ThermalZones.EnergyPlus_9_6_0.Types.WeekDays.Sunday
    "Week day of the first day that is simulated";

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
The parameter <code>startDayOfYear</code> is the day of the week for January 1,
regardless of the actual start time of the simulation.
For example, if <code>startDayOfYear = Sunday</code>, and the Modelica model
is simulated starting at <i>t = 1</i> day, then the first simulated day is a Monday.
</p>
<p>
Please note the following points:
</p>
<ul>
<li>
If <code>startDayOfYear = Sunday</code>, and the Modelica model
is simulated starting at <i>t = 1</i> year, e.g, at <i>t = 365</i> days, then the first simulated day is a Saturday because
<i>52*7=364</i>, and therefore simulating <i>365</i> days shifts the days of the weeks by one.
</li>
<li>
The Modelica parameter <code>startDayOfYear</code> differs from how EnergyPlus, if run natively, processes the
idf entry for <code>Day of Week for Start Day</code>.
</li>
<li>
The simulation start and stop time is controlled by Modelica,
and therefore all entries in the EnergyPlus input data file for the
<code>RunPeriod</code> object are ignored.
</li>
<li>
There is no support for leap years, each year has 365 days, also in multi-year simulations.
</li>
</ul>
</html>",
  revisions="<html>
<ul>
<li>
September 3, 2024, by Michael Wetter:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2926\">#2926</a>.
</li>
</ul>
</html>"));
end RunPeriod;
