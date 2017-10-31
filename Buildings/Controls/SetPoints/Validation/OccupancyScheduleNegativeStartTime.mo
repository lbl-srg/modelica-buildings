within Buildings.Controls.SetPoints.Validation;
model OccupancyScheduleNegativeStartTime
  "Test model for occupancy schedule with look-ahead"
  extends Modelica.Icons.Example;
  Buildings.Controls.SetPoints.OccupancySchedule occSchDay(occupancy=3600*{7,24})
                                                       "Day schedule"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  OccupancySchedule occSchDay1(occupancy=3600*{0,2})   "Day schedule"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  OccupancySchedule occSchDay2(
    occupancy=3600*{7,10,17,20},
    firstEntryOccupied=false)                 "Day schedule"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  annotation (experiment(
      StartTime=-112320,
      StopTime=207360,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/SetPoints/Validation/OccupancyScheduleNegativeStartTime.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that validates the occupancy schedule
for a negative start time.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OccupancyScheduleNegativeStartTime;
