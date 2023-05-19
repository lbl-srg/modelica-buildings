within Buildings.Utilities.IO.Files;
model WeeklySchedule "Weekly schedule"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Integer[:] columns = {2}
    "Columns of the schedule to be produced at the output y. First column is time, hence value must be 2 or larger";
  parameter Boolean tableOnFile=false
    "= true, if table is defined on file; false if defined through parameter data"
    annotation(Dialog(group="Data source"));
  parameter String fileName = ""
    "Filename"
    annotation(Dialog(group="Data source", enable=tableOnFile));
  parameter String data = "double tab1(3,2)
# For week-day, output 1 between 7:00 and 19:00, and 0 otherwise
mon,tue,wed,thu,fri:7:00:00  1
mon,tue,wed,thu,fri:19:00:00  0
# For week-end, output always 0. Note that this line is redundant in this example.
sat,sun:0:00:00 0"
    "String data with weekly schedule"
    annotation(Dialog(group="Data source",enable=not tableOnFile));
  parameter Modelica.Units.SI.Time t_offset=0
    "Timestamp that corresponds to midnight from Sunday to Monday";

  Modelica.Blocks.Interfaces.RealOutput[n_columns] y=
    {getCalendarValue(cal, iCol-1, time) for iCol in columns} "Schedule values"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Utilities.IO.Files.BaseClasses.WeeklyScheduleObject cal=
      Buildings.Utilities.IO.Files.BaseClasses.WeeklyScheduleObject(tableOnFile, sourceName, t_offset, data)
    "Schedule object";

  final parameter Integer n_columns = size(columns,1) "Number of columns";
  parameter String sourceName = if tableOnFile then fileName else getInstanceName() +".data";

  pure function getCalendarValue
    "Returns the interpolated (zero order hold) value"
    extends Modelica.Icons.Function;
    input Buildings.Utilities.IO.Files.BaseClasses.WeeklyScheduleObject ID "Pointer to file writer object";
    input Integer iCol "Column index";
    input Real timeIn "Time for look-up";
    output Real y "Schedule value";
    external "C" y=getScheduleValue(ID, iCol, timeIn)
    annotation(Include="#include <WeeklySchedule.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  end getCalendarValue;

  annotation (
  defaultComponentName = "sch",
  experiment(
      StartTime=-10000,
      StopTime=1000000,
      Interval=100),
      Documentation(
        revisions="<html>
<ul>
<li>
April 10 2022, by Filip Jorissen:<br/>
Added parameter source implementation.
</li>
<li>
March 9 2022, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model interprets a schedule file and performs a weekly, cyclic extrapolation on the source data.
An example for a schedule entry is
</p>
<pre>
double tab1(3,2)
# For week-day, output 1 between 7:00 and 19:00, and 0 otherwise
mon,tue,wed,thu,fri:7:00:00  1
mon,tue,wed,thu,fri:19:00:00  0
# For week-end, output always 0
sat,sun:0:00:00 0
</pre>
<p>
The first row must start with <code>double tab1</code> and be followed by the number of rows (excluding comments) and number of columns, whereas
the time column is considered the first column.<br/>
Lines that start with '#' are comments.<br/>
The list of week-days is separated by a comma, and ends with a colon, after which
the time format for the start is listed in the format <code>hour:minute:second</code>.
Week-day, hour, minute and second are optional fields, but if one of these fields is used,
the fields coming before it in the sequence (week-day, hour, minute, second) must be used too.
</p>
<p>
By default, schedules are read from the parameter <code>data</code> but optionally schedules can be read from a file.
The parameter <code>columns</code> is used to specify which columns of the table should be produced at the output <code>y</code>.
The first column is time, hence for the above example, set <code>columns = {2}</code>.
</p>
<p>
See <a href=\"modelica://Buildings/Resources/Data/schedule.txt\">Buildings/Resources/Data/schedule.txt</a> 
for an example of the supported file format.
</p>
</html>"),
    Icon(graphics={
    Line(points={{40,24},{40,-88}}),
        Ellipse(
          extent={{-94,94},{16,-16}},
          lineColor={160,160,164},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,38},{-14,38}},
          thickness=0.5),
        Line(
          points={{-40,38},{-64,62}},
          thickness=0.5),
    Line(points={{56,24},{56,-88}}),
    Line(points={{72,24},{72,-88}}),
    Line(points={{88,24},{88,-88}}),
    Line(points={{26,-8},{88,-8}}),
    Line(points={{26,24},{26,-88}}),
    Line(points={{26,-40},{88,-40}}),
    Line(points={{26,-24},{88,-24}}),
    Line(points={{26,-56},{88,-56}}),
    Line(points={{26,-88},{88,-88}}),
    Line(points={{26,-72},{88,-72}}),
    Line(points={{26,24},{88,24}}),
    Line(points={{26,8},{88,8}})}));
end WeeklySchedule;
