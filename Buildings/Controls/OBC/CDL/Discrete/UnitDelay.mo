within Buildings.Controls.OBC.CDL.Discrete;
block UnitDelay "Output the input signal with a unit delay"

  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)
    "Sample period of component";

  parameter Real y_start=0 "Initial value of output signal";

  Interfaces.RealInput u "Continuous input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "Continuous output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";

  output Boolean sampleTrigger "True, if sample time instant";

  output Boolean firstTrigger(start=false, fixed=true)
    "Rising edge signals first sample instant";

initial equation
  t0 = time;
  y = y_start;

equation
  // Declarations that are used for all discrete blocks
  sampleTrigger = sample(t0, samplePeriod);
  when sampleTrigger then
    firstTrigger = time <= t0 + samplePeriod/2;
  end when;

  // Declarations specific to this type of discrete block
  when sampleTrigger then
    y = pre(u);
  end when;


  annotation (
defaultComponentName="uniDel",
Documentation(info="<html>
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
</html>", revisions="<html>
<ul>
<li>
September 14, 2017, by Michael Wetter:<br/>
Removed parameter <code>startTime</code> to allow model to work
also for negative start time without having to change the value of this
parameters.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/938\">issue 938</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"), Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={                       Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={223,211,169},
        lineThickness=5.0,
        borderPattern=BorderPattern.Raised,
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
    Line(points={{-30.0,0.0},{30.0,0.0}},
      color={0,0,127}),
    Text(lineColor={0,0,127},
      extent={{-90.0,10.0},{90.0,90.0}},
      textString="1"),
    Text(lineColor={0,0,127},
      extent={{-90.0,-90.0},{90.0,-10.0}},
      textString="z")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Text(
          extent={{-160,10},{-140,-10}},
          textString="u",
          lineColor={0,0,255}),
        Text(
          extent={{115,10},{135,-10}},
          textString="y",
          lineColor={0,0,255}),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255}),
        Line(points={{40,0},{-40,0}}),
        Text(
          extent={{-55,55},{55,5}},
          lineColor={0,0,0},
          textString="1"),
        Text(
          extent={{-55,-5},{55,-55}},
          lineColor={0,0,0},
          textString="z")}));
end UnitDelay;
