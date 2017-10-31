within Buildings.Controls.OBC.CDL.Discrete;
model DayType "Block that outputs a signal that indicates week-day or week-end"
  parameter Integer nout = 2
    "Number of days to output. Set to two for one day predictions";
  parameter Buildings.Controls.OBC.CDL.Types.Day[:] days={
    Buildings.Controls.OBC.CDL.Types.Day.WorkingDay,
    Buildings.Controls.OBC.CDL.Types.Day.WorkingDay,
    Buildings.Controls.OBC.CDL.Types.Day.WorkingDay,
    Buildings.Controls.OBC.CDL.Types.Day.WorkingDay,
    Buildings.Controls.OBC.CDL.Types.Day.WorkingDay,
    Buildings.Controls.OBC.CDL.Types.Day.NonWorkingDay,
    Buildings.Controls.OBC.CDL.Types.Day.NonWorkingDay}
    "Array where each element is a day indicator";
   parameter Integer iStart(min=1, max=size(days, 1)) = 1
    "Index of element in days at simulation start";

  Interfaces.DayTypeOutput y[nout]
    "Type of the day for the current and the next (nout-1) days" annotation (
      Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(
          extent={{100,-10},{120,10}})));

protected
  parameter Modelica.SIunits.Time samplePeriod=86400
    "Sample period of component";
  output Integer iDay(min=1, max=size(days, 1))
    "Pointer to days that determines what day type is sent to the output";
  parameter Modelica.SIunits.Time firstSample(fixed=false)
    "Time when the sampling starts";
  output Boolean sampleTrigger "True, if sample time instant";
  output Boolean skipIDayIncrement
    "If true, don't increment iDay in first sample";

initial equation
  iDay = iStart;
  firstSample = ceil(time/86400)*86400;
  // skipIDayIncrement is true if the simulation starts at midnight.
  skipIDayIncrement = abs(firstSample-time) < 1E-8;
equation
  for i in 1:nout loop
    y[i] = days[ mod(iDay+i-2, size(days, 1))+1];
  end for;
  sampleTrigger = sample(firstSample, samplePeriod);
  when sampleTrigger then
    skipIDayIncrement = false;
    if pre(skipIDayIncrement) then
      iDay = pre(iDay);
    else
      iDay = mod(pre(iDay), size(days, 1))+1;
    end if;
  end when;
  annotation (
  defaultComponentName="dayTyp",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={    Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={223,211,169},
        lineThickness=5.0,
        borderPattern=BorderPattern.Raised,
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-68,54},{68,-38}},
          lineColor={0,0,255},
          textString="day"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}),
    Documentation(info="<html>
<p>
This block outputs a signal that indicates the type of the day.
It can for example be used to generate a signal that indicates whether
the current time is a work day or a non-working day.
The output signal is of type
<a href=\"modelica://Buildings.Controls.OBC.CDL.Types.Day\">
Buildings.Controls.OBC.CDL.Types.Day</a>.
</p>
<p>
The parameter <code>nout</code> determines how many days should be
sent to the output. For applications in which only the current day
is of interest, set <code>nout=1</code>.
For applications in which the load is predicted for the next <i>24</i> hours,
set <code>nout=2</code> in order to output the type of day for today and for
tomorrow.
</p>
<p>
The transition from one day type to another always happens when the simulation time
is a multiple of <i>1</i> day. Hence, if the simulation starts for example
at <i>t=-3600</i> seconds, then the first transition to another day will be
at <i>t=0</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 11, 2016, by Milica Grahovac:<br/>
First CDL implementation.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DayType;
