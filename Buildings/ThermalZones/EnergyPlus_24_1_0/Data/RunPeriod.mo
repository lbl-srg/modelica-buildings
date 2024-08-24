within Buildings.ThermalZones.EnergyPlus_24_1_0.Data;
record RunPeriod "Record for EnergyPlus RunPeriod"
  extends Modelica.Icons.Record;

  parameter Buildings.ThermalZones.EnergyPlus_24_1_0.Types.WeekDays dayOfWeekForStartDay = Buildings.ThermalZones.EnergyPlus_24_1_0.Types.WeekDays.Sunday
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
The first simulated day can be set with the Modelica parameter <code>dayOfWeekForStartDay</code>.
Note however a difference between the default behavior of EnergyPlus, and
the EnergyPlus behavior when used with this Modelica coupling.
</p>
<p>
The default behavior of EnergyPlus -- but not of this coupling -- is as follows:
If in the idf file, the first day of the simulation is set to Sunday, then
if the simulation starts on January 1, then January 1 is a Sunday and January 2 is a Monday.
Now, if the simulation is started at January 2, then January 2 is a Sunday. Hence,
depending on the start day of the simulation, the day of the week associated with a day changes.
This can give unexpected behavior, for example, if one only simulates a few days of a year,
as in this case, a week-end day can become a working day, and thus perhaps cause EnergyPlus
to use a different schedule for occupancy or internal loads.
</p>
<p>
Therefore, in this implementation in which we couple EnergyPlus to Modelica, we have parameters
that are by default set to
<pre>
dayOfWeekForStartDay = Buildings.ThermalZones.EnergyPlus_24_1_0.Types.WeekDays.Sunday,
dayOfWeekIsAtTime0 = true
</pre>
With this setting,
January 1 is a Sunday and January 2 is a Monday,
regardless of whether the simulation starts at <i>t=0</i> seconds or at <i>t=24*3600</i> seconds.
Users who want to retain the original behavior of EnergyPlus can set
<code>dayOfWeekIsAtTime0 = false</code>.
<p>
Note that the simulation start and stop time is controlled by Modelica,
and therefore all entries in the EnergyPlus input data file for the
<code>RunPeriod</code> object are ignored.
</p>
<p>
Also, there is no support for leap years, each year has 365 days, also in multi-year simulations.
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
