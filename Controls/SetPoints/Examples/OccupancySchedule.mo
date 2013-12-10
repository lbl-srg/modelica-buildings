within Buildings.Controls.SetPoints.Examples;
model OccupancySchedule "Test model for occupancy schedule with look-ahead"
  extends Modelica.Icons.Example;
  Buildings.Controls.SetPoints.OccupancySchedule occSchDay "Day schedule"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSchWee(occupancy=3600*{7,19,
        31,43,55,67,79,91,103,115,127,139}, period=7*24*3600) "Week schedule"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  annotation (experiment(StartTime=-86400, StopTime=1.2096e+06),
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
<img src=\"modelica://Buildings/Resources/Images/Controls/SetPoints/Examples/OccupancySchedule.png\" border=\"1\" alt=\"Time until next occupancy.\"/>
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
