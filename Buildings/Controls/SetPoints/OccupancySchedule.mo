within Buildings.Controls.SetPoints;
block OccupancySchedule "Occupancy schedule with look-ahead"
  extends Modelica.Blocks.Icons.Block;

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
  final parameter Integer nRow = size(occupancy,1)
    "Number of rows in the schedule";

  discrete Modelica.SIunits.Time tOcc "Time when next occupancy starts";
  discrete Modelica.SIunits.Time tNonOcc "Time when next non-occupancy starts";
  discrete Modelica.SIunits.Time tNext "Time of next switch in schedule";

  function getOutput "Get the next occupancy or non-occupancy outputs"
    extends Modelica.Icons.Function;

    input Modelica.SIunits.Time t "Current model time";
    input Modelica.SIunits.Time period "Periodicity";
    input Real occupancy[nRow]
      "Occupancy table, each entry switching occupancy on or off";
    input Boolean firstEntryOccupied
      "Set to true if first entry in occupancy denotes a changed from unoccupied to occupied";
    input Integer nRow
      "Number of rows in the schedule";

    output Modelica.SIunits.Time tOcc "Time when next occupancy starts";
    output Modelica.SIunits.Time tNonOcc "Time when next non-occupancy starts";
    output Boolean occupied
    "Outputs true if occupied at current time";
    output Modelica.SIunits.Time tNext "Time of next switch in schedule";

  protected
    Integer iPerSta
      "Counter for the period in which the next occupancy starts";
    Integer iPerSto
      "Counter for the period in which the next occupancy stops";
    Integer nexStaInd "Next index when occupancy starts";
    Integer nexStoInd "Next index when occupancy stops";
  algorithm
    // Initialize variables
    iPerSta := integer(t/period);
    iPerSto := iPerSta;

    // First, assume that the first entry is occupied
    nexStaInd := 1;
    nexStoInd := 2;
    // nRow is an even number
    for
     i in 1:2:nRow-1 loop
   if t >= occupancy[i] + iPerSta*period then
     nexStaInd := i+2;
   end if;
    end for;
    for
     i in 2:2:nRow loop
   if t >= occupancy[i] + iPerSto*period then
     nexStoInd := i+2;
   end if;
    end for;
    if nexStaInd > nRow then
    nexStaInd := 1;
    iPerSta :=iPerSta + 1;
    end if;
    if nexStoInd > nRow then
    nexStoInd := 2;
    iPerSto :=iPerSto + 1;
    end if;
    tOcc := occupancy[nexStaInd] + iPerSta*period;
    tNonOcc := occupancy[nexStoInd] + iPerSto*period;

    occupied := tNonOcc < tOcc;
    // Now, correct if the first entry is vaccant instead of occupied
    if not firstEntryOccupied then
     (nexStaInd, nexStoInd) := switchInteger(nexStaInd, nexStoInd);
     (iPerSta, iPerSto)     := switchInteger(iPerSta,   iPerSto);
     (tOcc, tNonOcc)        := switchReal(tOcc,      tNonOcc);
   occupied := not occupied;
    end if;

   tNext :=min(tOcc, tNonOcc);
  end getOutput;

encapsulated function switchInteger "Switch two Integer arguments"
  import Modelica;
  extends Modelica.Icons.Function;
  input Integer x1 "First argument";
  input Integer x2 "Second argument";
  output Integer y1 "Output = x2";
  output Integer y2 "Output = x1";
algorithm
  y1:=x2;
  y2:=x1;
end switchInteger;

encapsulated function switchReal "Switch two Real arguments"
  import Modelica;
  extends Modelica.Icons.Function;
  input Real x1 "First argument";
  input Real x2 "Second argument";
  output Real y1 "Output = x2";
  output Real y2 "Output = x1";
algorithm
  y1:=x2;
  y2:=x1;
end switchReal;


initial equation
  // Check parameters for correctness
 assert(mod(nRow, 2) < 0.1,
   "The parameter \"occupancy\" must have an even number of elements.\n");
 assert(0 <= occupancy[1],
   "The first element of \"occupancy\" must be bigger than or equal to zero."
   + "\n   Received occupancy[1] = " + String(occupancy[1]));
 assert(period >= occupancy[nRow],
   "The parameter \"period\" must be greater than or equal to the last element of \"occupancy\"."
   + "\n   Received period      = " + String(period)
   + "\n            occupancy[" + String(nRow) +
     "] = " + String(occupancy[nRow]));
  for i in 1:nRow-1 loop
    assert(occupancy[i] < occupancy[i+1],
      "The elements of the parameter \"occupancy\" must be strictly increasing.");
  end for;

  (tOcc, tNonOcc, occupied, tNext) = getOutput(t = time, period = period, occupancy= occupancy, firstEntryOccupied = firstEntryOccupied, nRow=nRow);

equation
  when time >= pre(tNext) then
    (tOcc, tNonOcc, occupied, tNext) = getOutput(t = time, period = period, occupancy= occupancy, firstEntryOccupied = firstEntryOccupied, nRow=nRow);
  end when;

 tNexOcc    =  tOcc-time;
 tNexNonOcc =  tNonOcc-time;

  annotation (
    Icon(graphics={
        Line(
          points={{-62,-68},{-38,-20},{-14,-70}},
          color={0,0,255}),
        Line(
          points={{-38,-20},{-38,44}},
          color={0,0,255}),
        Ellipse(extent={{-54,74},{-22,44}}, lineColor={0,0,255}),
        Line(
          points={{-66,22},{-38,36}},
          color={0,0,255}),
        Line(
          points={{-38,36},{-6,20}},
          color={0,0,255}),
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
</p>
<pre>
  occupancy = 3600*{7, 12, 14, 19}
</pre>
<p>
This indicates that the occupancy is from <i>7:00</i> until <i>12:00</i>
and from <i>14:00</i> to <i>19:00</i>. This will be repeated periodically.
The parameter <code>periodicity</code> defines the periodicity.
The period always starts at <i>t=0</i> seconds.
</p>
</html>", revisions="<html>
<ul>
<li>
March 25, 2021, by Michael Wetter:<br/>
Integrated changes from Buildings for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1454\">IBPSA, #1454</a>.
</li>
<li>
February 26, 2021, by Michael Wetter:<br/>
Refactored implementation to use a function to compute the next time events.<br/>
This is a work-around for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2369\">Buildings, issue 2369</a>.
</li>
<li>
October 30, 2017, by Michael Wetter:<br/>
Rewrote using <code>equation</code> rather than <code>algorithm</code>
and removed assertion.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/844\">issue 844</a>.
</li>
<li>
September 11, 2012, by Michael Wetter:<br/>
Added <code>pre</code> operator in <code>when</code> clause and relaxed
tolerance in <code>assert</code> statement.
</li>
<li>
July 26, 2012, by Michael Wetter:<br/>
Fixed a bug that caused an error in the schedule if the simulation start time was negative or equal to the first entry in the schedule.
</li>
<li>
February 16, 2012, by Michael Wetter:<br/>
Removed parameter <code>startTime</code>. It was removed because <code>startTime=0</code>
would imply that the schedule should not start for one day if the simulation were
to be started at <i>t=-8760</i> seconds.
Fixed bug that prevented schedule to start when the simulation was started at a time that
is higher than <code>endTime</code>.
Renamed parameter <code>endTime</code> to <code>period</code>.
</li>
<li>
April 2, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OccupancySchedule;
