within Buildings.Obsolete.Controls.OBC.CDL.Discrete;
model DayType
  "Block that outputs a signal that indicates week-day or week-end"
  parameter Integer nout(final min=1)=2
    "Number of days to output. Set to two for one day predictions";
  parameter Buildings.Obsolete.Controls.OBC.CDL.Types.Day[:] days={Buildings.Obsolete.Controls.OBC.CDL.Types.Day.WorkingDay,Buildings.Obsolete.Controls.OBC.CDL.Types.Day.WorkingDay,Buildings.Obsolete.Controls.OBC.CDL.Types.Day.WorkingDay,Buildings.Obsolete.Controls.OBC.CDL.Types.Day.WorkingDay,Buildings.Obsolete.Controls.OBC.CDL.Types.Day.WorkingDay,Buildings.Obsolete.Controls.OBC.CDL.Types.Day.NonWorkingDay,Buildings.Obsolete.Controls.OBC.CDL.Types.Day.NonWorkingDay}
    "Array where each element is a day indicator";
  parameter Integer iStart(
    min=1,
    max=size(
      days,
      1))=1
    "Index of element in days at simulation start";
  Obsolete.Controls.OBC.CDL.Interfaces.DayTypeOutput y[nout]
    "Type of the day for the current and the next (nout-1) days"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Real samplePeriod(
    final quantity="Time",
    final unit="s")=86400
    "Sample period of component";
  output Integer iDay(
    min=1,
    max=size(
      days,
      1))
    "Pointer to days that determines what day type is sent to the output";
  parameter Real firstSample(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "Time when the sampling starts";
  output Boolean sampleTrigger
    "True, if sample time instant";
  output Boolean skipIDayIncrement
    "If true, don't increment iDay in first sample";

initial equation
  iDay=iStart;
  firstSample=ceil(
    time/86400)*86400;
  // skipIDayIncrement is true if the simulation starts at midnight.
  skipIDayIncrement=abs(
    firstSample-time) < 1E-8;

equation
  for i in 1:nout loop
    y[i]=days[mod(
      iDay+i-2,
      size(
        days,
        1))+1];
  end for;
  sampleTrigger=sample(
    firstSample,
    samplePeriod);
  when sampleTrigger then
    skipIDayIncrement=false;
    if pre(skipIDayIncrement) then
      iDay=pre(iDay);
    else
      iDay=mod(
        pre(iDay),
        size(
          days,
          1))+1;
    end if;
  end when;
  annotation (
    defaultComponentName="dayTyp",
    obsolete = "Obsolete model that will be removed in future releases",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={223,211,169},
          lineThickness=5.0,
          borderPattern=BorderPattern.Raised,
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-68,54},{68,-38}},
          textColor={0,0,255},
          textString="day"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(
      info="<html>
<p>
This block outputs a signal that indicates the type of the day.
It can for example be used to generate a signal that indicates whether
the current time is a work day or a non-working day.
The output signal is of type
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Types.Day\">
Buildings.Obsolete.Controls.OBC.CDL.Types.Day</a>.
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
</html>",
      revisions="<html>
<ul>
<li>
January 13, 2022, by Michael Wetter:<br/>
Moved to <code>Obsolete</code> package.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2839\">issue 2839</a>.
</li>
<li>
October 21, 2021, by Michael Wetter:<br/>
Set <code>min</code> attribute for <code>nout</code> and removed
writing output value in icon (as it is an array of values).
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
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
