within Buildings.Controls.OBC.CDL.Continuous;
block RampUpDown "Ramp up or down the output to maximum or maximum"

  parameter Real min = 0
    "Minimum output";
  parameter Real max = 1
    "Maximum output";
  parameter Real upDuration(
    final quantity="Time",
    final unit="s")
    "Ramp up duration time";
  parameter Real downDuration(
    final quantity="Time",
    final unit="s")=upDuration
    "Ramp down duration time";
  parameter Real y_start(
    final min=min,
    final max=max)=0
    "Initial output value";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput ramp
    "True: ramp up; False: ramp down"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput activate
    "True: ramping output"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Ramped output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  discrete Real entryTime(
    final quantity="Time",
    final unit="s",
    start=0)
    "Time instant when begining the ramping";
  discrete Real endTime(
    final quantity="Time",
    final unit="s",
    start=upDuration,
    fixed=true)
    "Time instant when ending the ramping";
  discrete Real beginValue(
    start=min,
    fixed=true)
    "Output value at the ramping begining";
  discrete Real endValue(
    start=max,
    fixed=true)
    "Output value at the ramping ending";
  discrete Real y_end
    "Output value at the moment when ramping changes";

initial equation
  y = y_start;
  y_end = y_start;
  pre(activate)=false;

equation
  when {(initial() and activate and ramp), (ramp and activate)} then
    entryTime = time;
    endTime = entryTime + upDuration;
    beginValue = y_end;
    endValue = max;
  elsewhen {(initial() and activate and not ramp), (not ramp and activate)} then
    entryTime = time;
    endTime = entryTime + downDuration;
    beginValue = y_end;
    endValue = min;
  end when;

  when {ramp and activate, not ramp and activate, not activate} then
    y_end = pre(y);
  end when;

  if activate then
     if (time<endTime) then
       y = time*(endValue - beginValue)/(endTime - entryTime) + (endValue*entryTime - beginValue*endTime)/(entryTime-endTime);
     else
       y = pre(endValue);
     end if;
  else
    y = y_end;
  end if;

annotation (defaultComponentName="ramUpDow",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{100,140}},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that ramps the output between the minimum and maximum value.
</p>
<ul>
<li>
If the boolean input <code>activate</code> is <code>true</code>,
<ul>
<li>
when the boolean input <code>ramp</code> is <code>true</code>, the output ramps
from current value to the maximum value <code>max</code>, with duration time of
<code>upDuration</code>.
</li>
<li>
when the boolean input <code>ramp</code> is <code>false</code>, the output ramps
from current value to the minimum value <code>min</code>, with duration time of
<code>downDuration</code>.
</li>
</ul>
</li>
<li>
If the boolean input <code>activate</code> is <code>false</code>, the output stays
at current value.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
November 16, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end RampUpDown;
