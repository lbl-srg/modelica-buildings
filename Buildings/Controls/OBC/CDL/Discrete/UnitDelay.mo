within Buildings.Controls.OBC.CDL.Discrete;
block UnitDelay
  "Output the input signal with a unit delay"
  parameter Real samplePeriod(
    final quantity="Time",
    final unit="s",
    min=1E-3)
    "Sample period of component";
  parameter Real y_start=0
    "Initial value of output signal";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Input signal to be sampled"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Input signal at the previous sample instant"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Real t0(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "First sample time instant";
  output Boolean sampleTrigger
    "True, if sample time instant";
  discrete Real u_internal
    "Input value at each sampling moment";

initial equation
  t0=Buildings.Utilities.Math.Functions.round(
    x=integer(time/samplePeriod)*samplePeriod,
    n=6);
  y=y_start;
  u_internal=y_start;

equation
  // Declarations that are used for all discrete blocks
  sampleTrigger=sample(
    t0,
    samplePeriod);
  when sampleTrigger then
    u_internal=u;
    y=pre(u_internal);
  end when;
  annotation (
    defaultComponentName="uniDel",
    Documentation(
      info="<html>
<p>
Block that outputs the input signal with a unit delay:
</p>
<pre>
          1
     y = --- * u
          z
</pre>
<p>
that is, the output signal <code>y</code> is the
input signal <code>u</code> of the
previous sample instant. Before the second sample instant,
the output <code>y</code> is identical to parameter <code>y_start</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
August 8, 2024, by Jianjun Hu:<br/>
Delayed the input.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3953\">Buildings, issue 3953</a>.
</li> 
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">Buildings, issue 2243</a>.
</li>
<li>
October 19, 2020, by Michael Wetter:<br/>
Refactored implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2170\">Buildings, issue 2170</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
September 14, 2017, by Michael Wetter:<br/>
Removed parameter <code>startTime</code> to allow model to work
also for negative start time without having to change the value of this
parameters.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/938\">Buildings, issue 938</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={223,211,169},
          lineThickness=5.0,
          borderPattern=BorderPattern.Raised,
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{-30.0,0.0},{30.0,0.0}},
          color={0,0,127}),
        Text(
          textColor={0,0,127},
          extent={{-90.0,10.0},{90.0,90.0}},
          textString="1"),
        Text(
          textColor={0,0,127},
          extent={{-90.0,-90.0},{90.0,-10.0}},
          textString="z"),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}));
end UnitDelay;
