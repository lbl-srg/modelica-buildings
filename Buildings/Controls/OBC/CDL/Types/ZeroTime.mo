within Buildings.Controls.OBC.CDL.Types;
type ZeroTime = enumeration(
    UnixTimeStamp
  "Thu, 01 Jan 1970 00:00:00 local time",
    UnixTimeStampGMT
  "Thu, 01 Jan 1970 00:00:00 GMT",
    Custom
  "User specified local time",
    NY2010
  "New year 2010, 00:00:00 local time",
    NY2011
  "New year 2011, 00:00:00 local time",
    NY2012
  "New year 2012, 00:00:00 local time",
    NY2013
  "New year 2013, 00:00:00 local time",
    NY2014
  "New year 2014, 00:00:00 local time",
    NY2015
  "New year 2015, 00:00:00 local time",
    NY2016
  "New year 2016, 00:00:00 local time",
    NY2017
  "New year 2017, 00:00:00 local time",
    NY2018
  "New year 2018, 00:00:00 local time",
    NY2019
  "New year 2019, 00:00:00 local time",
    NY2020
  "New year 2020, 00:00:00 local time")
  "Enumeration to set the date corresponding to time = 0"
  annotation (Documentation(info="<html>
<p>
Type for choosing how to set the reference time in
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime\">
Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime</a>.
</p>
<p>
For example, <code>CDL.Types.TimeReference.NY2016</code>
means that if model time is <i>0</i>, it is
January 1, 2016, 0:00:00 local time.
</p>
</html>",revisions="<html>
<ul>
<li>
March 14, 2017, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
February 23, 2017, by Milica Grahovac:<br/>
Initial CDL implementation.
</li>
<li>
September 10, 2016, by Michael Wetter:<br/>
Revised implementation and moved to new package
<a href=\"modelica://Buildings.Utilities.Time.CalendarTime.Types\">
Buildings.Utilities.Time.CalendarTime.Types</a>.
</li>
<li>
August 3, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
