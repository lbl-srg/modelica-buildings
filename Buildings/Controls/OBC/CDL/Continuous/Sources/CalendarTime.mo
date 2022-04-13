within Buildings.Controls.OBC.CDL.Continuous.Sources;
model CalendarTime
  "Computes the unix time stamp and calendar time from the simulation time"
  parameter Buildings.Controls.OBC.CDL.Types.ZeroTime zerTim
    "Enumeration for choosing how reference time (time = 0) should be defined";
  parameter Integer yearRef(
    min=firstYear,
    max=lastYear)=2016
    "Year when time = 0, used if zerTim=Custom"
    annotation (Dialog(enable=zerTim == Buildings.Controls.OBC.CDL.Types.ZeroTime.Custom));
  parameter Real offset(
    final quantity="Time",
    final unit="s")=0
    "Offset that is added to 'time', may be used for computing time in different time zone"
    annotation (Dialog(tab="Advanced"));
  discrete Interfaces.IntegerOutput year
    "Year"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}}),iconTransformation(extent={{100,-40},{120,-20}})));
  discrete Interfaces.IntegerOutput month
    "Month of the year"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{100,-10},{120,10}})));
  Interfaces.IntegerOutput day(
    fixed=false)
    "Day of the month"
    annotation (Placement(transformation(extent={{100,20},{120,40}}),iconTransformation(extent={{100,20},{120,40}})));
  Interfaces.IntegerOutput hour(
    fixed=false)
    "Hour of the day"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),iconTransformation(extent={{100,50},{120,70}})));
  Interfaces.RealOutput minute
    "Minute of the hour"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),iconTransformation(extent={{100,80},{120,100}})));
  Interfaces.IntegerOutput weekDay(
    fixed=false)
    "Integer output representing week day (monday = 1, sunday = 7)"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),iconTransformation(extent={{100,-70},{120,-50}})));

protected
  final constant Integer firstYear=2010
    "First year that is supported, i.e. the first year in timeStampsNewYear[:]";
  final constant Integer lastYear=firstYear+21
    "Last year that is supported (actual building automation system need to support a larger range)";
  Buildings.Utilities.Time.CalendarTime calTim(
    final zerTim=zerTim,
    final yearRef=yearRef,
    final offset=offset)
    "Calendar time"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(calTim.minute,minute)
    annotation (Line(points={{11,9},{55.5,9},{55.5,90},{110,90}},color={0,0,127}));
  connect(calTim.hour,hour)
    annotation (Line(points={{11,6.4},{60,6.4},{60,60},{110,60}},color={255,127,0}));
  connect(calTim.day,day)
    annotation (Line(points={{11,3.8},{64,3.8},{64,30},{110,30}},color={255,127,0}));
  connect(calTim.month,month)
    annotation (Line(points={{11,1.2},{80,1.2},{80,0},{110,0}},color={255,127,0}));
  connect(calTim.year,year)
    annotation (Line(points={{11,-1.4},{64,-1.4},{64,-30},{110,-30}},color={255,127,0}));
  connect(calTim.weekDay,weekDay)
    annotation (Line(points={{11,-4},{60,-4},{60,-60},{110,-60}},color={255,127,0}));
  annotation (
    defaultComponentName="calTim",
    Documentation(
      info="<html>
<p>
Block that outputs minute, hour, day of the month, month, year and weekday.
</p>
<h4>Assumption and limitations</h4>
<p>
The implementation only supports date computations from year 2010 up to and including 2020.
Daylight saving and time zones are not supported.
</p>
<h4>Typical use and important parameters</h4>
<p>
The user must define which time and date correspond to <code>time = 0</code>
using the model parameters <code>zerTim</code>, and, if
<code>zerTim == CDL.Types.ZeroTime.Custom</code>,
the parameter <code>yearRef</code>.
The user can choose from new year, midnight for a number of years:
2010 to 2020 and also 1970.
The latter corresponds to a unix stamp of <i>0</i>.
Note that when choosing the reference time equal to 0 at 1970,
the actual simulation time must be within the 2010-2020 range.
For example, <code>startTime = 1262304000</code> corresponds
to the simulation starting on the 1st of January 2010 local time
when setting <code>zerTim = CDL.Types.ZeroTime.UnixTimeStamp</code>.
This is within the 2010-2020 range and is therefore allowed.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 30, 2022, by Michael Wetter:<br/>
Increased value of <code>lastYear</code> as the underlying implementation allows
for 21 years.
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
August 20, 2019, by Filip Jorissen:<br/>
Revised implementation such that the meaning of <code>time</code> is better explained
and unix time stamps are correctly defined with respect to GMT.
(see <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1192\">#1192</a>).
</li>
<li>
March 14, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
February 23, 2017, by Milica Grahovac:<br/>
First CDL implementation.
</li>
<li>
August 3, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={223,211,169},
          lineThickness=5.0,
          borderPattern=BorderPattern.Raised,
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Ellipse(
          extent={{-94,94},{16,-16}},
          lineColor={160,160,164},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-34,92},{96,82}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Minute"),
        Text(
          extent={{-28,64},{96,54}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Hour"),
        Text(
          extent={{-38,36},{96,24}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Day"),
        Text(
          extent={{-50,4},{96,-6}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Month"),
        Text(
          extent={{-70,-24},{96,-34}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Year"),
        Text(
          extent={{-68,-54},{96,-66}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Right,
          textString="Weekday"),
        Line(
          points={{-40,38},{-64,62}},
          thickness=0.5),
        Line(
          points={{-40,38},{-14,38}},
          thickness=0.5)}));
end CalendarTime;
