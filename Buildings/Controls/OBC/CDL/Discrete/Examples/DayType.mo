within Buildings.Controls.OBC.CDL.Discrete.Examples;
model DayType
  "Example model for the source that outputs the type of the day"
  Buildings.Controls.OBC.CDL.Discrete.DayType dayTypMon
    "Model that outputs the type of the day, starting with Monday"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Discrete.DayType dayTypSat(
    iStart=6)
    "Model that outputs the type of the day, starting with Saturday"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Discrete.DayType dayTypTwoWeeks(
    days={Types.Day.WorkingDay,Types.Day.WorkingDay,Types.Day.WorkingDay,Types.Day.WorkingDay,Types.Day.WorkingDay,Types.Day.WorkingDay,Types.Day.NonWorkingDay,Types.Day.NonWorkingDay,Types.Day.NonWorkingDay,Types.Day.NonWorkingDay,Types.Day.NonWorkingDay,Types.Day.NonWorkingDay,Types.Day.NonWorkingDay,Types.Day.NonWorkingDay},
    nout=14)
    "Model that outputs the type of the day, starting with 6 workdays, then 8 non-working days"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Discrete.DayType dayTypMonThr(
    nout=3)
    "Model that outputs the type of the day for 3 days, starting with Monday"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Discrete/Examples/DayType.mos" "Simulate and plot"),
    experiment(
      StartTime=-1814400,
      StopTime=1.8144e+06,
      Tolerance=1E-6),
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
January 11, 2017, by Milica Grahovac:<br/>
First CDL implementation.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end DayType;
