within Buildings.Controls.Sources.Examples;
model DayType "Example model for the source that outputs the type of the day"
  extends Modelica.Icons.Example;
  Buildings.Controls.Sources.DayType dayTypMon
    "Model that outputs the type of the day, starting with Monday"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.Sources.DayType dayTypSat(iStart=6)
    "Model that outputs the type of the day, starting with Saturday"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.Sources.DayType dayTypTwoWeeks(
    days={
        Buildings.Controls.Types.Day.WorkingDay,
        Buildings.Controls.Types.Day.WorkingDay,
        Buildings.Controls.Types.Day.WorkingDay,
        Buildings.Controls.Types.Day.WorkingDay,
        Buildings.Controls.Types.Day.WorkingDay,
        Buildings.Controls.Types.Day.WorkingDay,
        Buildings.Controls.Types.Day.NonWorkingDay,Buildings.Controls.Types.Day.NonWorkingDay,
        Buildings.Controls.Types.Day.NonWorkingDay,Buildings.Controls.Types.Day.NonWorkingDay,
        Buildings.Controls.Types.Day.NonWorkingDay,Buildings.Controls.Types.Day.NonWorkingDay,
        Buildings.Controls.Types.Day.NonWorkingDay,Buildings.Controls.Types.Day.NonWorkingDay},
    nout=14)
    "Model that outputs the type of the day, starting with 6 workdays, then 8 non-working days"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.Sources.DayType dayTypMonThr(nout=3)
    "Model that outputs the type of the day for 3 days, starting with Monday"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Sources/Examples/DayType.mos"
        "Simulate and plot"),
        experiment(StartTime=-1814400, StopTime=1814400),
    Documentation(
    info="<html>
<p>
This example generates signals for three different work weeks.
The instance <code>dayTypMon</code> outputs a signal with five working
days, followed by two non-working days.
The instance <code>dayTypSat</code> does the same, except that the first
days is a non-working day.
The instance <code>dayTypTwoWeeks</code> outputs six working days, followed
by 8 non-working days.
The instance <code>dayTypMonThr</code> is configured the same as
<code>dayTypMon</code>, except that it outputs the type of the day
for three days, starting with the current day, then the next day and
the day after.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DayType;
