within Buildings.Utilities.Time;
model CalendarTime
  "Computes the unix time stamp and calendar time from the simulation time"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Buildings.Utilities.Time.Types.ZeroTime zerTim
    "Enumeration for choosing how reference time (time = 0) should be defined";
  parameter Integer yearRef(min=firstYear, max=lastYear) = 2016
    "Year when time = 0, used if zerTim=Custom"
    annotation(Dialog(enable=zerTim==Buildings.Utilities.Time.Types.ZeroTime.Custom));
  parameter Boolean outputUnixTimeStamp = false
    "= true, to output the unix time stamp (using GMT reference)"
    annotation(Dialog(group="Unix time stamp"));
  parameter Modelica.Units.SI.Time timZon(displayUnit="h") = 0
    "The local time zone, for computing the unix time stamp only"
    annotation (Dialog(enable=outputUnixTimeStamp, group="Unix time stamp"));
  parameter Modelica.Units.SI.Time offset(displayUnit="h") = 0
    "Offset that is added to 'time', may be used for computing time in different time zones"
    annotation (Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealOutput unixTimeStampLocal(final unit="s")
    "Unix time stamp at local time"
        annotation (Placement(transformation(extent={{100,-78},{120,-58}}),
        iconTransformation(extent={{100,-78},{120,-58}})));
  Modelica.Blocks.Interfaces.RealOutput unixTimeStamp(final unit="s") = unixTimeStampLocal - timZon if outputUnixTimeStamp
    "Unix time stamp"
        annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
  discrete Modelica.Blocks.Interfaces.IntegerOutput year "Year"
    annotation (Placement(transformation(extent={{100,-24},{120,-4}}),
        iconTransformation(extent={{100,-24},{120,-4}})));
  discrete Modelica.Blocks.Interfaces.IntegerOutput month "Month of the year"
    annotation (Placement(transformation(extent={{100,2},{120,22}}),
        iconTransformation(extent={{100,2},{120,22}})));
  Modelica.Blocks.Interfaces.IntegerOutput day(fixed=false) "Day of the month"
    annotation (Placement(transformation(extent={{100,28},{120,48}}),
        iconTransformation(extent={{100,28},{120,48}})));
  Modelica.Blocks.Interfaces.IntegerOutput hour(fixed=false) "Hour of the day"
    annotation (Placement(transformation(extent={{100,54},{120,74}}),
        iconTransformation(extent={{100,54},{120,74}})));
  Modelica.Blocks.Interfaces.RealOutput minute "Minute of the hour"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.IntegerOutput weekDay(fixed=false)
    "Integer output representing week day (monday = 1, sunday = 7)"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

protected
  final constant Real eps_time(final unit="s") = 1 "Small value for time";
  final constant Integer firstYear = 2010
    "First year that is supported, i.e. the first year in timeStampsNewYear[:]";
  final constant Integer lastYear = firstYear + size(timeStampsNewYear,1) - 1;
  constant Modelica.Units.SI.Time timeStampsNewYear[22]={1262304000.0,
      1293840000.0,1325376000.0,1356998400.0,1388534400.0,1420070400.0,
      1451606400.0,1483228800.0,1514764800.0,1546300800.0,1577836800.0,
      1609459200.0,1640995200.0,1672531200.0,1704067200.0,1735689600.0,
      1767225600.0,1798761600.0,1830297600.0,1861920000.0,1893456000.0,
      1924992000.0} "Epoch time stamps for new years day 2010 to 2031";
  constant Boolean isLeapYear[21] = {
    false, false, true, false,
    false, false, true, false,
    false, false, true, false,
    false, false, true, false,
    false, false, true, false,
    false}
    "List of leap years starting from firstYear (2010), up to and including 2030";
  final constant Integer dayInMonth[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    "Number of days in each month";
  parameter Modelica.Units.SI.Time timOff(fixed=false) "Time offset";
  // final parameters since the user may wrongly assume that this model shifts the
  // actual time of the simulation
  final constant Integer monthRef(min=1, max=12) = 1 "Month when time = 0"
    annotation(Dialog(enable=zerTim==Buildings.Utilities.Time.Types.ZeroTime.Custom));
  final constant Integer dayRef(min=1, max=31) = 1 "Day when time = 0"
    annotation(Dialog(enable=zerTim==Buildings.Utilities.Time.Types.ZeroTime.Custom));
  Integer daysSinceEpoch(fixed=false) "Number of days that passed since 1st of January 1970";
  discrete Integer yearIndex "Index of the current year in timeStampsNewYear";
  discrete Real epochLastMonth
    "Unix time stamp of the beginning of the current month";

  final parameter Modelica.Units.SI.Time hourSampleStart(fixed=false)
    "Time when the sampling every hour starts";
  final parameter Modelica.Units.SI.Time daySampleStart(fixed=false)
    "Time when the sampling every day starts";


  Boolean hourSampleTrigger "True, if hourly sample time instant";
  Boolean daySampleTrigger "True, if daily sample time instant";

  Boolean firstHourSampling(fixed=true, start=true)
    "=true if the hour is sampled the first time";
  Boolean firstDaySampling(fixed=true, start=true)
    "=true if the day is sampled the first time";
initial equation
  hourSampleStart = integer(time/3600)*3600 - offset;
  daySampleStart  = integer(time/(3600*24))*3600*24 - offset;

  hour = integer(floor(rem(unixTimeStampLocal,3600*24)/3600));
  daysSinceEpoch = integer(floor(unixTimeStampLocal/3600/24));

  day = integer(1+floor((unixTimeStampLocal-epochLastMonth)/3600/24));
  weekDay = integer(rem(4+daysSinceEpoch-1,7)+1);
initial algorithm
  // check if yearRef is in the valid range
  assert(not zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom
         or yearRef>=firstYear and yearRef<=lastYear,
    "The value you chose for yearRef (=" + String(yearRef) + ") is outside of
   the validity range of " + String(firstYear) + " to " + String(lastYear) + ".");

  // check if the day number exists for the chosen month and year
  assert(not zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom
         or dayInMonth[monthRef] + (if monthRef==2 and isLeapYear[yearRef-firstYear + 1] then 1 else 0) >=dayRef,
    "The day number you chose is larger than the number of days contained by the month you chose.");

  // compute the offset to be added to time based on the parameters specified by the user
  if zerTim == Buildings.Utilities.Time.Types.ZeroTime.UnixTimeStamp then
    timOff :=0;
  elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.UnixTimeStampGMT then
    timOff :=timZon;
  elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.NY2010 or
    zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom and yearRef == 2010 then
      timOff :=timeStampsNewYear[1];
  elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.NY2011 or
    zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom and yearRef == 2011 then
      timOff :=timeStampsNewYear[2];
  elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.NY2012 or
    zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom and yearRef == 2012 then
      timOff :=timeStampsNewYear[3];
  elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.NY2013 or
    zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom and yearRef == 2013 then
      timOff :=timeStampsNewYear[4];
  elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.NY2014 or
    zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom and yearRef == 2014 then
      timOff :=timeStampsNewYear[5];
  elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.NY2015 or
    zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom and yearRef == 2015 then
      timOff :=timeStampsNewYear[6];
  elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.NY2016 or
    zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom and yearRef == 2016 then
      timOff :=timeStampsNewYear[7];
  elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.NY2017 or
    zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom and yearRef == 2017 then
      timOff :=timeStampsNewYear[8];
  elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.NY2018 or
    zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom and yearRef == 2018 then
      timOff :=timeStampsNewYear[9];
  elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.NY2019 or
    zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom and yearRef == 2019 then
      timOff :=timeStampsNewYear[10];
  elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.NY2020 or
    zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom and yearRef == 2020 then
      timOff :=timeStampsNewYear[11];
  else
    timOff :=0;
    // this code should not be reachable
    assert(false, "No valid ZeroTime could be identified.
   This is a bug, please submit a bug report.");
  end if;

  // add additional offset when using a custom date and time
  if zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom then
    timOff :=timOff + ((dayRef - 1) + sum({dayInMonth[i] for i in 1:(monthRef - 1)})
     + (if monthRef > 2 and isLeapYear[yearRef - firstYear + 1] then 1 else 0))*3600*24;
  end if;

   // input data range checks at initial time
  assert(time + offset + timOff >= timeStampsNewYear[1],
    if zerTim == Buildings.Utilities.Time.Types.ZeroTime.UnixTimeStamp then
      "Could not initialize date in the CalendarTime block.
   You selected 1970 as the time=0 reference.
   Therefore the simulation startTime must be at least " + String(timeStampsNewYear[1]) + "."
    elseif zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom then
      if yearRef <firstYear then
        "Could not initialize date in the CalendarTime block.
   You selected a custom time=0 reference.
   The minimum value for yearRef is then " + String(firstYear) + " but your value is " + String(yearRef) + "."
      else
        "Could not initialize date in the CalendarTime block.
   You selected a custom time=0 reference.
   Possibly your startTime is too small."
      else
        "Could not initialize date in the CalendarTime block.
   Possibly your startTime is negative?");

  assert(time + offset + timOff < timeStampsNewYear[size(timeStampsNewYear,1)],
    if zerTim == Buildings.Utilities.Time.Types.ZeroTime.Custom and yearRef >= lastYear then
      "Could not initialize date in the CalendarTime block.
   You selected a custom time=0 reference.
   The maximum value for yearRef is then " + String(lastYear) +
   " but your value is " + String(yearRef) + "."
    else
       "Could not initialize date in the CalendarTime block.
       Possibly your startTime is too large.");

  // iterate to find the year at initialization
initial algorithm
  year :=0;
  for i in 1:size(timeStampsNewYear,1) loop
    // may be reformulated using break if JModelica fixes bug
    if unixTimeStampLocal < timeStampsNewYear[i]
      and (if i == 1 then true else unixTimeStampLocal >= timeStampsNewYear[i-1]) then
      yearIndex :=i - 1;
      year :=firstYear + i - 2;
    end if;
  end for;

  // iterate to find the month at initialization
  epochLastMonth := timeStampsNewYear[yearIndex];
  month:=13;
  for i in 1:12 loop
    if (unixTimeStampLocal-epochLastMonth)/3600/24 <
      (if i==2 and isLeapYear[yearIndex] then 1 + dayInMonth[i] else dayInMonth[i]) then
      // construction below avoids the need of a break, which bugs out JModelica
      month :=min(i,month);
    else
      epochLastMonth :=epochLastMonth + (if i == 2 and isLeapYear[yearIndex]
         then 1 + dayInMonth[i] else dayInMonth[i])*3600*24;
    end if;
  end for;

equation
  // compute unix time step based on found offset
  unixTimeStampLocal = time + offset + timOff;

  // compute other variables that can be computed without using when() statements
  hourSampleTrigger =sample(hourSampleStart, 3600);
  when hourSampleTrigger then
    if pre(firstHourSampling) then
      hour = integer(floor(rem(unixTimeStampLocal,3600*24)/3600));
    else
      hour = if (pre(hour) == 23) then 0 else (pre(hour) + 1);
    end if;
    firstHourSampling = false;
  end when;

  daySampleTrigger =sample(daySampleStart, 86400);
  when daySampleTrigger then
    if pre(firstDaySampling) then
      daysSinceEpoch = integer(floor(unixTimeStampLocal/3600/24));
      weekDay=integer(rem(4+daysSinceEpoch-1,7)+1);

    else
      daysSinceEpoch = pre(daysSinceEpoch) + 1;
      weekDay = if (pre(weekDay) == 7) then 1 else (pre(weekDay) + 1);
    end if;

    // update the year when passing the epoch time stamp of the next year
    if unixTimeStampLocal - timeStampsNewYear[pre(yearIndex)+1] > -eps_time then
      yearIndex=pre(yearIndex)+1;
      year = pre(year) + 1;
    else
      yearIndex = pre(yearIndex);
      year = pre(year);
    end if;
    assert(yearIndex<=size(timeStampsNewYear,1),
      "Index out of range for epoch vector: timeStampsNewYear needs to be extended beyond the year "
        + String(firstYear+size(timeStampsNewYear,1)));

    // update the month when passing the last day of the current month
    if unixTimeStampLocal - ( pre(epochLastMonth) + (if pre(month)==2 and isLeapYear[yearIndex] then 1 + dayInMonth[pre(month)] else dayInMonth[pre(month)])*3600*24 ) > -eps_time then
      month = if pre(month) == 12 then 1 else pre(month) + 1;
      // Use floor(0.1 + ...) to avoid floating point errors when accumulating epochLastMonth.
      epochLastMonth = floor(0.1 + pre(epochLastMonth) +
        (if pre(month)==2 and isLeapYear[yearIndex]
          then 1 + dayInMonth[pre(month)] else dayInMonth[pre(month)])*3600*24);
    else
      month = pre(month);
      epochLastMonth = pre(epochLastMonth);
    end if;

    day = integer(1+floor((unixTimeStampLocal-epochLastMonth)/3600/24));

    firstDaySampling = false;
  end when;

  // using Real variables and operations for minutes since otherwise too many events are generated
  minute = (unixTimeStampLocal/60-daysSinceEpoch*60*24-hour*60);

  annotation (
    defaultComponentName="calTim",
  Documentation(revisions="<html>
<ul>
<li>
December 19, 2022, by Michael Wetter:<br/>
Refactored implementation to avoid wrong day number due to rounding errors that caused simultaneous events
to not be triggered at the same time.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3199\">Buildings, #3199</a>.
</li>
<li>
November 6, 2019, by Milica Grahovac:<br/>
Extended functionality to year 2030.
</li>
<li>
August 20, 2019, by Filip Jorissen:<br/>
Revised implementation such that the meaning of <code>time</code> is better explained
and unix time stamps are correctly defined with respect to GMT.
(see <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1192\">#1192</a>).
</li>
<li>
February 14, 2019, by Damien Picard:<br/>
Fix bug when non-zero offset by substracting the offset from hourSampleStart and daySampleStart
(see <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1099\">#1099</a>).
</li>
<li>
August 3, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This blocks computes the unix time stamp, date and time
and the day of the week based on the Modelica
variable <code>time</code>.
As for the weather data reader
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>,
<code>time=0</code> corresponds to January 1st at midnight
in the <em>local time zone</em>.
The computed outputs are thus also for the local time zone.
The year for which <code>time=0</code> is determined by
the parameter <code>zerTim</code>.
</p>
<h4>Main equations</h4>
<p>
The unix time stamp corresponding to the current time is computed.
From this variables the corresponding, year, date and time are computed using functions
such as <code>floor()</code> and <code>ceil()</code>.
</p>
<h4>Assumption and limitations</h4>
<p>
The implementation only supports date computations from year 2010 up to and including 2020.
Daylight saving is not supported.
</p>
<h4>Typical use and important parameters</h4>
<p>
The user must define which time and date correspond to <code>time = 0</code>
using the model parameters <code>zerTim</code>, and, if
<code>zerTim==Buildings.Utilities.Time.Types.ZeroTime.Custom</code>,
the parameter <code>yearRef</code>.
When <code>zerTim==Buildings.Utilities.Time.Types.ZeroTime.UnixTimeStampGMT</code>,
<code>time</code> is defined with respect to GMT. This is different from the use
of <code>time</code> in the weather data reader
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>, as the weather data files
used with this reader are generally defined with <code>time</code> being local time.
If  <code>zerTim==Buildings.Utilities.Time.Types.ZeroTime.UnixTimeStampGMT</code> is used,
then the weather data files read by
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>
must also be defined with GMT as the time stamp.

The user can choose from new year, midnight for a number of years:
2010 to 2030 and also 1970.
The latter corresponds to a unix stamp of <i>0</i>.
(Note that when choosing the reference time equal to 0 at 1970,
the actual simulation time must be within the 2010-2030 range.
For instance <code>startTime = 1262304000</code> corresponds
to the simulation starting on the 1st of January 2010
when setting <code>zerTim = ZeroTime.UnixTimeStamp</code>.
This is within the 2010-2020 range and is therefore allowed.)
The unix time stamp is formally defined as the number of
seconds since midnight of new year in 1970 GMT.
To output the correct unix time stamp, set <code>outputUnixTimeStamp=true</code>
We then require the local time zone <code>timZon</code>
(see <a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>)
since <code>time</code> uses the local time zone instead of GMT.
We always output <code>unixTimeStampLocal</code>, which is a time stamp
that uses the local time zone reference instead of GMT.
</p>
<h4>Implementation</h4>
<p>
The model was implemented such that no events are being generated for computing the minute of the day.
The model also contains an implementation for setting <code>time=0</code>
for any day and month other than January first.
This is however not activated in the current model since these options may wrongly give the impression
that it changes the time based on which the solar position is computed and TMY3 data are read.
</p>
</html>"),
    Icon(graphics={
        Text(
          extent={{-34,90},{96,80}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Minute"),
        Text(
          extent={{-28,68},{96,58}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Hour"),
        Text(
          extent={{-38,44},{96,32}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Day"),
        Text(
          extent={{-50,18},{96,8}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Month"),
        Text(
          extent={{-70,-8},{96,-18}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Year"),
        Text(
          extent={{-68,-30},{96,-42}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Weekday"),
        Text(
          extent={{-102,-60},{94,-72}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Unix time stamp (local)"),
        Ellipse(
          extent={{-94,94},{16,-16}},
          lineColor={160,160,164},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,38},{-64,62}},
          thickness=0.5),
        Line(
          points={{-40,38},{-14,38}},
          thickness=0.5),
        Text(
          extent={{-102,-82},{94,-94}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          visible=outputUnixTimeStamp,
          textString="Unix time stamp (GMT)")}));
end CalendarTime;
