within Buildings.Controls.OBC.CDL.Continuous;
block RampUpDown "Ramp up or down the output to maximum or maximum"

  parameter Real min = 0
    "minimum output";
  parameter Real max = 1
    "maximum output";
  parameter Real upDuration(
    final quantity="Time",
    final unit="s")
    "Ramp up duration time";
  parameter Real downDuration(
    final quantity="Time",
    final unit="s")=upDuration
    "Ramp down duration time";
  parameter Real y_start = 0
    "Initial output value";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput up
    "True: ramp up the output"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput down
    "True: ramp down the output"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Ramped output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  discrete Real entryTime(
    final quantity="Time",
    final unit="s")
    "Time instant when begining the ramping";
  discrete Real endTime(
    final quantity="Time",
    final unit="s")
    "Time instant when ending the ramping";
  discrete Real beginValue
    "Output value at the ramping begining";
  discrete Real endValue
    "Output value at the ramping ending";
  discrete Real y_end;

initial equation
  y = y_start;
  pre(entryTime)=0;
  pre(endTime)=upDuration;
  pre(beginValue)=min;
  pre(endValue)=max;
  pre(y_end)=y_start;

equation
  when up then
    entryTime = time;
    endTime = time + upDuration;
    beginValue = pre(y_end);
    endValue = max;
  elsewhen down then
    entryTime = time;
    endTime = time + downDuration;
    beginValue = pre(y_end);
    endValue = min;
  end when;
  when {not up, not down} then
    y_end = y;
  end when;
  if (up or down) then
     if (time<endTime) then
       y = time*(endValue - beginValue)/(endTime - entryTime) + (endValue*entryTime - beginValue*endTime)/(entryTime-endTime);
//        der(y)*(endTime - entryTime) = (endValue - beginValue);
     else
       y = endValue;
     end if;
  else
    y = y_end;
  end if;


  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{100,140}},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RampUpDown;
