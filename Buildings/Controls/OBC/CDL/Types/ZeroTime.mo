within Buildings.Controls.OBC.CDL.Types;
type ZeroTime = enumeration(
    UnixTimeStamp "Thu, 01 Jan 1970 00:00:00 local time",
    UnixTimeStampGMT "Thu, 01 Jan 1970 00:00:00 GMT",
    Custom "User specified local time",
    NY2010 "New year 2010, 00:00:00 local time",
    NY2011 "New year 2011, 00:00:00 local time",
    NY2012 "New year 2012, 00:00:00 local time",
    NY2013 "New year 2013, 00:00:00 local time",
    NY2014 "New year 2014, 00:00:00 local time",
    NY2015 "New year 2015, 00:00:00 local time",
    NY2016 "New year 2016, 00:00:00 local time",
    NY2017 "New year 2017, 00:00:00 local time",
    NY2018 "New year 2018, 00:00:00 local time",
    NY2019 "New year 2019, 00:00:00 local time",
    NY2020 "New year 2020, 00:00:00 local time",
    NY2021 "New year 2021, 00:00:00 local time",
    NY2022 "New year 2022, 00:00:00 local time",
    NY2023 "New year 2023, 00:00:00 local time",
    NY2024 "New year 2024, 00:00:00 local time",
    NY2025 "New year 2025, 00:00:00 local time",
    NY2026 "New year 2026, 00:00:00 local time",
    NY2027 "New year 2027, 00:00:00 local time",
    NY2028 "New year 2028, 00:00:00 local time",
    NY2029 "New year 2029, 00:00:00 local time",
    NY2030 "New year 2030, 00:00:00 local time",
    NY2031 "New year 2031, 00:00:00 local time",
    NY2032 "New year 2032, 00:00:00 local time",
    NY2033 "New year 2033, 00:00:00 local time",
    NY2034 "New year 2034, 00:00:00 local time",
    NY2035 "New year 2035, 00:00:00 local time",
    NY2036 "New year 2036, 00:00:00 local time",
    NY2037 "New year 2037, 00:00:00 local time",
    NY2038 "New year 2038, 00:00:00 local time",
    NY2039 "New year 2039, 00:00:00 local time",
    NY2040 "New year 2040, 00:00:00 local time",
    NY2041 "New year 2041, 00:00:00 local time",
    NY2042 "New year 2042, 00:00:00 local time",
    NY2043 "New year 2043, 00:00:00 local time",
    NY2044 "New year 2044, 00:00:00 local time",
    NY2045 "New year 2045, 00:00:00 local time",
    NY2046 "New year 2046, 00:00:00 local time",
    NY2047 "New year 2047, 00:00:00 local time",
    NY2048 "New year 2048, 00:00:00 local time",
    NY2049 "New year 2049, 00:00:00 local time",
    NY2050 "New year 2050, 00:00:00 local time")
  "Use this to set the date corresponding to time = 0"
  annotation (Documentation(info="<html>
<p>
Type for choosing how to set the reference time in
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Sources.CalendarTime\">
Buildings.Controls.OBC.CDL.Reals.Sources.CalendarTime</a>.
</p>
<p>
For example, <code>CDL.Types.TimeReference.NY2016</code>
means that if model time is <i>0</i>, it is
January 1, 2016, 0:00:00 local time.
</p>
</html>",revisions="<html>
<ul>
<li>
March 8, 2024, by Jelger Jansen:<br/>
Extend functionality to year 2050.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1847\">#1847</a>.
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
