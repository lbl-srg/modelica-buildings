within Buildings.Controls.OBC.CDL.Logical;
block TimerAccumulating
  "Accumulating timer that can be reset"
  parameter Real t(
    final quantity="Time",
    final unit="s")=0
    "Threshold time for comparison";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Input that switches timer on if true, and off if false"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reset
    "Connector for signal that sets timer to zero if it switches to true"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final quantity="Time",
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
  discrete Real yAcc(
    final quantity="Time",
    final unit="s")
    "Accumulated time up to last change to true";

initial equation
  pre(u)=false;
  pre(reset)=false;
  pre(entryTime)=time;
  pre(passed)=t <= 0;
  yAcc=0;

equation
  // The when constructs below are identical to the ones in Buildings.Controls.OBC.CDL.Logical.Timer
  when reset then
    entryTime=time;
    passed=t <= 0;
    yAcc=0;
  elsewhen u then
    entryTime=time;
    // When u becomes true, and t=0, we want passed to be true
    // at the first step (in superdense time).
    passed=t <= yAcc;
    yAcc=pre(yAcc);
  elsewhen u and time >= t+pre(entryTime)-pre(yAcc) then
    passed=true;
    entryTime=pre(entryTime);
    yAcc=pre(yAcc);
  elsewhen not u then
    passed=pre(passed);
    //time  >= t_internal + pre(entryTime);
    entryTime=pre(entryTime);
    yAcc=pre(y);
  end when;
  y=if u then
      yAcc+time-entryTime
    else
      yAcc;
  annotation (
    defaultComponentName="accTim",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
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
          points={{-56,-60},{-38,-60},{-38,-16},{-4,-16},{-4,-60},{26,-60},{26,-16},{64,-16}},
          color={255,0,255}),
        Line(
          points={{-58,0},{-40,0},{-6,28},{24,28},{60,58}},
          color={0,0,127}),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-64,62},{62,92}},
          textColor={0,0,0},
          textString="t=%t"),
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
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
Timer that accumulates time until it is reset by an input signal.
</p>
<p>
If the Boolean input <code>u</code> is <code>true</code>,
the output <code>y</code> is the time that has elapsed while <code>u</code> has been <code>true</code>
since the last time <code>reset</code> became <code>true</code>.
If <code>u</code> is <code>false</code>, the output <code>y</code> holds its value.
If the output <code>y</code> becomes greater than the threshold time <code>t</code>,
the output <code>passed</code> is <code>true</code>.
Otherwise it is <code>false</code>.
</p>
<p>
When <code>reset</code> becomes <code>true</code>, the timer is reset to <code>0</code>.
</p>
<p>
In the limiting case where the timer value reaches the threshold <code>t</code>
and the input <code>u</code> becomes <code>false</code> simultaneously,
the output <code>passed</code> remains <code>false</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
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
Removed parameter <code>accumulate</code> and added output <code>passed</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2101\">issue 2101</a>.
</li>
<li>
July 31, 2020, by Jianjun Hu:<br/>
Fixed the reset input. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2056\">issue 2056</a>.
</li>
<li>
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
end TimerAccumulating;
