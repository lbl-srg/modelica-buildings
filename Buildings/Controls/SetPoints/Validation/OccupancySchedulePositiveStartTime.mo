within Buildings.Controls.SetPoints.Validation;
model OccupancySchedulePositiveStartTime
  "Validation model for occupancy schedule with positive start time"
  extends OccupancyScheduleNegativeStartTime;
  annotation (experiment(
      StartTime=86400,
      StopTime=207360,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/SetPoints/Validation/OccupancySchedulePositiveStartTime.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that validates the occupancy schedule
for a positive start time.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end OccupancySchedulePositiveStartTime;
