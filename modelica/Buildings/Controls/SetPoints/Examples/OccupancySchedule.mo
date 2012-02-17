within Buildings.Controls.SetPoints.Examples;
model OccupancySchedule "Test model for occupancy schedule with look-ahead"
  extends Modelica.Icons.Example;
  Buildings.Controls.SetPoints.OccupancySchedule occSch
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  annotation (experiment(StopTime=172800), experimentSetupOutput,
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/SetPoints/Examples/OccupancySchedule.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that demonstrates the use of the occupancy schedule.
The figure below shows how the time until the next occupancy starts or ends
is decreased. The red line hits zero when the schedule indicates an occupied time,
and the blue line hits zero when the schedule indicates a non-occupied time.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/SetPoints/Examples/OccupancySchedule.png\" border=\"1\">
</p>
</html>", revisions="<html>
<ul>
<li>
November 21, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end OccupancySchedule;
