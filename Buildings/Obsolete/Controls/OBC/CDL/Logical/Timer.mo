within Buildings.Obsolete.Controls.OBC.CDL.Logical;
block Timer
  "Timer measuring the time from the time instant where the Boolean input became true"

  parameter Real t(
    final quantity="Time",
    final unit="s")=0 "Threshold time for comparison";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Connector for signal that switches timer on if true, and off if false"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final quantity="Time",
    final unit="s") "Timer output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput pasThr
    "True if the time is greater than threshold"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

protected
  discrete Modelica.SIunits.Time entryTime "Time instant when u became true";

initial equation
  pre(entryTime) = 0;
equation
  when u then
    entryTime = time;
  end when;
  y = if u then time - entryTime else 0.0;
  pasThr = y > t;

annotation (
    defaultComponentName="tim",
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
          lineColor={0,0,255},
          textString="%name"),
      Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235}, if u then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if u then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
      Ellipse(
          extent={{71,-73},{85,-87}},
          lineColor=DynamicSelect({235,235,235}, if pasThr then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if pasThr then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>When the Boolean input <code>u</code> becomes true, the timer starts and the
output <code>y</code> is the time that has elapsed since <code>u</code>
becomes true. When the output <code>y</code> becomes greater than the threshold
time <code>t</code>, the output <code>pasThr</code> becomes true.
When the input becomes false, the timer stops and the output is reset to zero.
</p>
</html>", revisions="<html>
<ul>
<li>
August 26, 2020, by Jianjun Hu:<br/>
Removed <code>reset</code> and added output <code>pasThr</code>. This is for
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
