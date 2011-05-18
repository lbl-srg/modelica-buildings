within Buildings.Controls.SetPoints.Examples;
model OccupancySchedule "Test model for occupancy schedule with look-ahead"
  extends Modelica.Icons.Example; 
  Buildings.Controls.SetPoints.OccupancySchedule occSch
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  annotation (experiment(StopTime=172800), experimentSetupOutput,
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/SetPoints/Examples/OccupancySchedule.mos" "Simulate and plot"));
end OccupancySchedule;
