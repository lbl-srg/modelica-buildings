within Buildings.ThermalZones.Detailed.Validation.BESTEST.BaseClasses;
model DaySchedule "Schedule that repeats every day"
  extends Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable(
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.LinearSegments,
    final extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
    final offset=fill(0, size(table, 2)-1));
  annotation (Documentation(info="<html>
<p>
Time schedule that is used for set points.
</p>
</html>", revisions="<html>
<ul>
<li>
September 30, 2013, by Michael Wetter:<br/>
Changed implementation of periodicity for MSL 3.2 table.
</li>
<li>
October 6, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DaySchedule;
