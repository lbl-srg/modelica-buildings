within Buildings.Controls.OBC.CDL.Discrete;
block Sampler
  "Ideal sampler of a continuous signal"
  parameter Real samplePeriod(
    final quantity="Time",
    final unit="s",
    min=1E-3)
    "Sample period of component";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Input signal to be sampled"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Sampled input signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Real t0(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "First sample time instant";
  output Boolean sampleTrigger
    "True, if sample time instant";
  output Boolean firstTrigger(
    start=false,
    fixed=true)
    "Rising edge signals first sample instant";

initial equation
  t0=Buildings.Utilities.Math.Functions.round(
    x=integer(time/samplePeriod)*samplePeriod,
    n=6);

equation
  // Declarations that are used for all discrete blocks
  sampleTrigger=sample(
    t0,
    samplePeriod);
  when sampleTrigger then
    firstTrigger=time <= t0+samplePeriod/2;
  end when;
  // Declarations specific to this type of discrete block
  when {sampleTrigger,initial()} then
    y=u;
  end when;
  annotation (
    defaultComponentName="sam",
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
        Ellipse(
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{25.0,-10.0},{45.0,10.0}}),
        Line(
          points={{-100.0,0.0},{-45.0,0.0}},
          color={0,0,127}),
        Line(
          points={{45.0,0.0},{100.0,0.0}},
          color={0,0,127}),
        Line(
          points={{-35.0,0.0},{30.0,35.0}},
          color={0,0,127}),
        Ellipse(
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-45.0,-10.0},{-25.0,10.0}})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
Block that outputs the input signal, sampled at a sampling rate defined
via parameter <code>samplePeriod</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 30, 2022, by Michael Wetter:<br/>
Removed graphic from diagram view.
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
October 19, 2020, by Michael Wetter:<br/>
Refactored implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2170\">#2170</a>.
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
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/938\">issue 938</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Sampler;
