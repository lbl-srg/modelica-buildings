within Buildings.Controls.SetPoints;
block OccupancySchedule "Occupancy schedule with look-ahead"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Real occupancy[:]=3600*{7, 19}
    "Occupancy table, each entry switching occupancy on or off";
  parameter Boolean firstEntryOccupied = true
    "Set to true if first entry in occupancy denotes a changed from unoccupied to occupied";
  parameter Modelica.SIunits.Time period =   86400 "End time of periodicity";

  Modelica.Blocks.Interfaces.RealOutput tNexNonOcc
    "Time until next non-occupancy"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput tNexOcc "Time until next occupancy"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.BooleanOutput occupied
    "Outputs true if occupied at current time"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

protected
  parameter Modelica.SIunits.Time offSet(fixed=false)
    "Time off-set, in multiples of period, that is used to switch the time when doing the table lookup";
  final parameter Integer nRow = size(occupancy,1);

  output Integer nexStaInd "Next index when occupancy starts";
  output Integer nexStoInd "Next index when occupancy stops";

  output Integer iPerSta
    "Counter for the period in which the next occupancy starts";
  output Integer iPerSto
    "Counter for the period in which the next occupancy stops";

  output Modelica.SIunits.Time tOcc "Time when next occupancy starts";
  output Modelica.SIunits.Time tNonOcc "Time when next non-occupancy starts";

encapsulated function switch
  input Integer x1;
  input Integer x2;
  output Integer y1;
  output Integer y2;
algorithm
  y1:=x2;
  y2:=x1;
end switch;

initial algorithm
  // Check parameters for correctness
 assert(mod(nRow, 2) < 0.1,
   "The parameter \"occupancy\" must have an even number of elements.\n");
 assert(0 < occupancy[1],
   "The first element of \"occupancy\" must be bigger than or equal than zero."
   + "\n   Received occupancy[1] = " + String(occupancy[1]));
 assert(period > occupancy[nRow],
   "The parameter \"period\" must be greater than the last element of \"occupancy\"."
   + "\n   Received period      = " + String(period)
   + "\n            occupancy[" + String(nRow) +
     "] = " + String(occupancy[nRow]));
  for i in 1:nRow-1 loop
    assert(occupancy[i] < occupancy[i+1],
      "The elements of the parameter \"occupancy\" must be strictly increasing.");
  end for;
 // Initialize variables
 iPerSta   := integer(time/period);
 iPerSto   := iPerSta;
 offSet:=iPerSta*period;

 // First, assume that the first entry is occupied.
 nexStaInd := 1;
 for i in 1:2:nRow-1 loop
   if time > occupancy[i] + offSet then
     nexStaInd :=i;
   end if;
 end for;

 nexStoInd := 2;
 for i in 2:2:nRow loop
   if time > occupancy[i] + offSet then
     nexStoInd :=i;
   end if;
 end for;

 occupied := (time+offSet - occupancy[nexStaInd]) < (time+offSet - occupancy[nexStoInd]);

 // Now, correct if the first entry is vaccant instead of occupied
 if not firstEntryOccupied then
   (nexStaInd, nexStoInd) := switch(nexStaInd, nexStoInd);
   occupied := not occupied;
 end if;

 tOcc    := occupancy[nexStaInd]+offSet;
 tNonOcc := occupancy[nexStoInd]+offSet;

algorithm
  when time >= pre(occupancy[nexStaInd])+ iPerSta*period then
    nexStaInd :=nexStaInd + 2;
    occupied := not occupied;
    // Wrap index around
    if nexStaInd > nRow then
       nexStaInd := if firstEntryOccupied then 1 else 2;
       iPerSta := iPerSta + 1;
    end if;
    tOcc := occupancy[nexStaInd] + iPerSta*(period);
  end when;

  // Changed the index that computes the time until the next non-occupancy
  when time >= pre(occupancy[nexStoInd])+ iPerSto*period then
    nexStoInd :=nexStoInd + 2;
    occupied := not occupied;
    // Wrap index around
    if nexStoInd > nRow then
       nexStoInd := if firstEntryOccupied then 2 else 1;
       iPerSto := iPerSto + 1;
    end if;
    tNonOcc := occupancy[nexStoInd] + iPerSto*(period);
  end when;

 tNexOcc    := tOcc-time;
 tNexNonOcc := tNonOcc-time;
  annotation (
    Icon(graphics={
        Line(
          points={{-62,-68},{-38,-20},{-14,-70}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-38,-20},{-38,44}},
          color={0,0,255},
          smooth=Smooth.None),
        Ellipse(extent={{-54,74},{-22,44}}, lineColor={0,0,255}),
        Line(
          points={{-66,22},{-38,36}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-38,36},{-6,20}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{34,74},{90,50}},
          lineColor={0,0,255},
          textString="occupancy"),
        Text(
          extent={{32,16},{92,-16}},
          lineColor={0,0,255},
          textString="non-occupancy"),
        Text(
          extent={{34,-44},{94,-76}},
          lineColor={0,0,255},
          textString="occupied")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
defaultComponentName="occSch",
Documentation(info="<html>
<p>
This model outputs whether the building is currently occupied,
and how long it will take until the next time when the building 
will be occupied or non-occupied.
The latter may be used, for example, to start a ventilation system
half an hour before occupancy starts in order to ventilate the room.
</p>
<p>
The occupancy is defined by a time schedule of the form
<pre>
  occupancy = 3600*{7, 12, 14, 19}
</pre>
This indicates that the occupancy is from <i>7:00</i> until <i>12:00</i>
and from <i>14:00</i> to <i>19:00</i>. This will be repeated periodically.
The parameter <code>periodicity</code> defines the periodicity.
The period always starts at <i>t=0</i> seconds.
</p>
</html>", revisions="<html>
<ul>
<li>
February 16, 2012, by Michael Wetter:<br>
Removed parameter <code>startTime</code>. It was removed because <code>startTime=0</code>
would imply that the schedule should not start for one day if the the simulation were
to be started at <i>t=-8760</i> seconds.
Fixed bug that prevented schedule to start when the simulation was started at a time that
is higher than <code>endTime</code>.
Renamed parameter <code>endTime</code> to <code>period</code>.
</li>
<li>
April 2, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end OccupancySchedule;
