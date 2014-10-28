within Buildings.Controls.Sources;
model DayType "Block that outputs a signal that indicates week-day or week-end"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Integer nDays = 7 "Periodicity in number of days";
  parameter Buildings.Controls.Types.Day[nDays] days={
    Buildings.Controls.Types.Day.WorkingDay,
    Buildings.Controls.Types.Day.WorkingDay,
    Buildings.Controls.Types.Day.WorkingDay,
    Buildings.Controls.Types.Day.WorkingDay,
    Buildings.Controls.Types.Day.WorkingDay,
    Buildings.Controls.Types.Day.NonWorkingDay,
    Buildings.Controls.Types.Day.NonWorkingDay}
    "Array where each element is a day indicator";
   parameter Integer iStart(min=1, max=nDays) = 1
    "Index of element in days that will be sent to output at time=k*samplePeriod";

  Interfaces.DayTypeOutput y "Type of the day" annotation (Placement(transformation(extent={{100,-10},
            {120,10}}), iconTransformation(extent={{100,-10},{120,10}})));

protected
  parameter Modelica.SIunits.Time samplePeriod=86400
    "Sample period of the component";
  output Integer iDay(min=1, max=nDays)
    "Pointer to days that determines what day type is sent to the output";
  parameter Modelica.SIunits.Time firstSample(fixed=false)
    "Time when the sampling starts";
  output Boolean sampleTrigger "True, if sample time instant";
  output Boolean firstTrigger "Rising edge signals first sample instant";

initial equation
  iDay = mod(iStart-1+integer(time/samplePeriod), nDays)+1;
  firstTrigger = true;
  firstSample = ceil(time/86400)*86400;
equation
  y = days[iDay];
  sampleTrigger = sample(firstSample, samplePeriod);
  when sampleTrigger then
    firstTrigger = false;
    if pre(firstTrigger) then
      iDay = pre(iDay);
    else
      iDay = mod(pre(iDay), nDays)+1;
    end if;
  end when;
  annotation (
  defaultComponentName="dayType",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-68,54},{68,-38}},
          lineColor={0,0,255},
          textString="day")}),
    Documentation(info="<html>
<p>
This block outputs a periodic signal that indicates the type of the day.
It can for example be used to generate a signal that indicates whether 
the current time is a work day or a non-working day.
The output signal is of type
<a href=\"modelica://Buildings.Controls.Types.Day\">
Buildings.Controls.Types.Day</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DayType;
