within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.Types;
package OperationModes "Definitions for operation modes"

  constant Integer occupied = 1
    "System is operated in this mode when zone is occupied.";

  constant Integer unoccupiedScheduled = 2
    "System is operated in this mode when zone is unoccupied and schedule indicates the same.";

  constant Integer unoccupiedUnscheduled = 3
    "System is operated in this mode when zone is unoccupied but schedule indicates it is occupied.";

  annotation (
    Documentation(info="<html>
    <p>
    This package provides constants that indicate the system operation mode type based on the 
    detected occupancy signal from the occupancy sensor in the zone, and the
    expected occupancy as per the schedule.
    </p>
    </html>",
    revisions="<html>
    <ul>
    <li>
    June 29, 2021, by Karthik Devaprasad:
    <br>
    First implementation.
    </li>
    </ul>
    </html>"),
    Icon(graphics={
         Rectangle(
           lineColor={200,200,200},
           fillColor={248,248,248},
           fillPattern=FillPattern.HorizontalCylinder,
           extent={{-100,-100},{100,100}},
           radius=25.0),
         Rectangle(
           lineColor={128,128,128},
           extent={{-100,-100},{100,100}},
           radius=25.0)}));
end OperationModes;
