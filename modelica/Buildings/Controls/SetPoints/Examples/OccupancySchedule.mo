within Buildings.Controls.SetPoints.Examples;
model OccupancySchedule "Test model for occupancy schedule with look-ahead"
  Buildings.Controls.SetPoints.OccupancySchedule occSch
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  annotation (experiment(StopTime=172800), experimentSetupOutput,
    Commands(file="OccupancySchedule.mos" "run"));
end OccupancySchedule;
