within Buildings.Rooms.Examples.BESTEST.BaseClasses;
model DaySchedule "Schedule that repeats every day"
  extends Modelica.Blocks.Sources.CombiTimeTable(
    final tableOnFile=false,
    final tableName="NoName",
    final fileName="NoName",
    final columns=2:size(table, 2),
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final offset=fill(0, size(table, 2)-1),
    final startTime=0);
end DaySchedule;
