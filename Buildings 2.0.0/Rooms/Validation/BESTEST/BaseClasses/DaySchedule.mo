within Buildings.Rooms.Validation.BESTEST.BaseClasses;
model DaySchedule "Schedule that repeats every day"
  extends Modelica.Blocks.Sources.CombiTimeTable(
    final tableOnFile=false,
    final tableName="NoName",
    final fileName="NoName",
    final columns=2:size(table, 2),
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    final extrapolation=if size(table, 1) == 1
     then
       Modelica.Blocks.Types.Extrapolation.HoldLastPoint
     else
       Modelica.Blocks.Types.Extrapolation.Periodic,
    final offset=fill(0, size(table, 2)-1),
    final startTime=0);
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
