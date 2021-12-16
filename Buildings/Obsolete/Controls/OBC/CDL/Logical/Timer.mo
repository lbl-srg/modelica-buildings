within Buildings.Obsolete.Controls.OBC.CDL.Logical;
block Timer
  "Timer measuring the time from the time instant where the Boolean input became true"
  extends Modelica.Icons.ObsoleteModel;

  parameter Boolean accumulate = false
    "If true, accumulate time until Boolean input 'reset' becomes true, otherwise reset timer whenever u becomes true";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Connector for signal that switches timer on if true, and off if false"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reset
    "Connector for signal that sets timer to zero if it switches to true. The input value will be ignored if the timer does not accumulate time"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final quantity="Time",
    final unit="s") "Timer output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  discrete Modelica.Units.SI.Time entryTime "Time instant when u became true";
  discrete Modelica.Units.SI.Time yAcc
    "Accumulated time up to last change to true";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reset_internal(
    final start=false,
    final fixed=true) "Internal connector";

initial equation
  pre(entryTime) = time;
  yAcc = 0;

equation
  if not accumulate then
    reset_internal = true;
  else
    reset_internal = reset;
  end if;

  when u and (not edge(reset_internal)) then
    entryTime = time;
  elsewhen reset then
    entryTime = time;
  end when;

  when reset then
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
    defaultComponentName="tim",
    obsolete = "This model is obsolete, use Buildings.Controls.OBC.CDL.Logical.Timer or Buildings.Controls.OBC.CDL.Logical.TimerAccumulating instead",
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
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
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235}, if u then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if u then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Timer with option to accumulate time until it is reset by an input signal.
</p>
<p>
Each time the Boolean input <code>u</code> becomes true, the timer runs, otherwise
it is dormant.
</p>
<ul>
<li>
If the parameter <code>accumulate</code> is <code>false</code>, the timer is set to zero each time the
input <code>u</code> becomes <code>false</code>. The value of input <code>reset</code>
will be ignored.
</li>
<li>
If the parameter <code>accumulate</code> is <code>true</code>, the timer accumulates time,
and the timer is set to zero only when the value of the input <code>reset</code> becomes <code>true</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 28, 2020, by Michael Wetter:<br/>
Corrected implementation for situation where the simulation does not start at zero.
</li>
<li>
August 26, 2020, by Jianjun Hu:<br/>
Moved to obsolete package.<br/>
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
end Timer;
