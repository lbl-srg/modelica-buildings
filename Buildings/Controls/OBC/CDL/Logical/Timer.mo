within Buildings.Controls.OBC.CDL.Logical;
block Timer
  "Timer measuring the time from the time instant where the Boolean input became true"
<<<<<<< HEAD

  parameter Boolean accumulate = false
    "If true, accumulate time until Boolean input 'reset' becomes true, otherwise reset timer whenever u becomes true";

  Interfaces.BooleanInput u "Connector for signal that switches timer on if true, and off if false"
=======
  parameter Real t(
    final quantity="Time",
    final unit="s")=0
    "Threshold time for comparison";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Input that switches timer on if true, and off if false"
>>>>>>> master
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanInput reset if accumulate
    "Connector for signal that sets timer to zero if it switches to true"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Interfaces.RealOutput y(
    final quantity="Time",
<<<<<<< HEAD
    final unit="s") "Timer output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  discrete Modelica.SIunits.Time entryTime "Time instant when u became true";
  discrete Modelica.SIunits.Time yAcc "Accumulated time up to last change to true";
  Interfaces.BooleanInput reset_internal(
    final start=false,
    final fixed=true) "Internal connector";

initial equation
  pre(entryTime) = 0;
  yAcc = 0;

equation
  connect(reset, reset_internal);
  if not accumulate then
    reset_internal = false;
  end if;

  when u and (not edge(reset_internal)) then
    entryTime = time;
  elsewhen reset_internal then
    entryTime = time;
  end when;

  when reset_internal then
    yAcc = 0;
  elsewhen (not u) then
    yAcc = pre(y);
  end when;

  if not accumulate then
    y = if u then time - entryTime else 0.0;
  else
    y = if u then yAcc + (time - entryTime) else yAcc;
  end if;

annotation (
=======
    final unit="s")
    "Elapsed time"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput passed
    "True if the elapsed time is greater than threshold"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),iconTransformation(extent={{100,-100},{140,-60}})));

protected
  discrete Real entryTime(
    final quantity="Time",
    final unit="s")
    "Time instant when u became true";

initial equation
  pre(entryTime)=time;
  pre(passed)=t <= 0;

equation
  when u then
    entryTime=time;
    // When u becomes true, and t=0, we want passed to be true
    // at the first step (in superdense time).
    passed=t <= 0;
  elsewhen(u and time >= t+pre(entryTime)) then
    passed=true;
    entryTime=pre(entryTime);
  elsewhen not u then
    // Set passed to false.
    // This is the behavior a timer would have if the threshold test is done with a greater block connected to the output of the timer
    passed=false;
    entryTime=pre(entryTime);
  end when;
  y=
    if u then
      time-entryTime
    else
      0.0;
  annotation (
>>>>>>> master
    defaultComponentName="tim",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
<<<<<<< HEAD
        graphics={Rectangle(
=======
      graphics={
        Rectangle(
>>>>>>> master
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
<<<<<<< HEAD
      Line(points={{-66,-60},{82,-60}},
        color={192,192,192}),
      Line(points={{-58,68},{-58,-80}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90,-60},{68,-52},{68,-68},{90,-60}}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-58,90},{-66,68},{-50,68},{-58,90}}),
      Line(points={{-56,-60},{-38,-60},{-38,-16},{40,-16},{40,-60},{68,-60}},
        color={255,0,255}),
      Line(points={{-58,0},{-40,0},{40,90},{40,0},{68,0}},
        color={0,0,127}),
=======
        Line(
          points={{-66,-60},{82,-60}},
          color={192,192,192}),
        Line(
          points={{-58,68},{-58,-80}},
          color={192,192,192}),
        Polygon(
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{90,-60},{68,-52},{68,-68},{90,-60}}),
        Polygon(
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{-58,90},{-66,68},{-50,68},{-58,90}}),
        Line(
          points={{-56,-60},{-38,-60},{-38,-16},{40,-16},{40,-60},{68,-60}},
          color={255,0,255}),
        Line(
          points={{-58,0},{-40,0},{40,58},{40,0},{68,0}},
          color={0,0,127}),
>>>>>>> master
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name"),
<<<<<<< HEAD
=======
        Text(
          extent={{-64,62},{62,92}},
          lineColor={0,0,0},
          textString="t=%t"),
>>>>>>> master
        Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235},
            if u then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if u then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
<<<<<<< HEAD
        Text(
          extent={{-88,-58},{88,-98}},
          lineColor={217,67,180},
          textString="accumulate: %accumulate")}),
    Documentation(info="<html>
=======
        Ellipse(
          extent={{71,-73},{85,-87}},
          lineColor=DynamicSelect({235,235,235},
            if passed then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if passed then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftjustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
>>>>>>> master
<p>
Timer with option to accumulate time until it is reset by an input signal.
</p>
<p>
Each time the Boolean input <code>u</code> becomes true, the timer runs, otherwise
it is dormant.
If the parameter <code>accumulate</code> is <code>false</code>, the timer is set to zero each time the
input <code>u</code> becomes <code>false</code>.
If <code>accumulate = true</code>, an input <code>reset</code> is enabled, the timer accumulates time,
and the timer is set to zero only when the value of the input <code>reset</code> becomes <code>true</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
<<<<<<< HEAD
=======
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.SIunits</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
August 28, 2020, by Michael Wetter:<br/>
Revised implementation to correctly deal with non-zero simulation start time,
and to avoid state events.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2101\">issue 2101</a>.
</li>
<li>
August 26, 2020, by Jianjun Hu:<br/>
Removed <code>reset</code> boolean input and added output <code>passed</code>
to show if the time becomes greater than threshold time.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2101\">issue 2101</a>.
</li>
<li>
July 31, 2020, by Jianjun Hu:<br/>
Fixed the reset input. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2056\">issue 2056</a>.
</li>
<li>
>>>>>>> master
November 8, 2019, by Michael Wetter:<br/>
Revised implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1221\">issue 1221</a>.
</li>
<li>
July 23, 2018, by Jianjun Hu:<br/>
Added conditional boolean input for cumulative time measuring. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1221\">issue 1221</a>.
</li>
<li>
July 18, 2018, by Jianjun Hu:<br/>
Updated implementation to output accumulated true input time.  This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1212\">issue 1212</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Timer;
