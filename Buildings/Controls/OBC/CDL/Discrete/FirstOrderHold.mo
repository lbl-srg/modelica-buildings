within Buildings.Controls.OBC.CDL.Discrete;
block FirstOrderHold "First order hold of a sampled-data system"

  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)
    "Sample period of component";

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

  Modelica.SIunits.Time tSample "Time of sample";
  Real uSample "Value of sample";
  Real pre_uSample "Value of previous sample";
  Real c "Slope";

initial equation
  t0 = time;
  pre(tSample) = time;
  pre(uSample) = u;
  pre(pre_uSample) = u;
  pre(c) = 0.0;

equation
  // Declarations that are used for all discrete blocks
  sampleTrigger = sample(t0, samplePeriod);
  when sampleTrigger then
    firstTrigger = time <= t0 + samplePeriod/2;
  end when;

  // Declarations specific to this type of discrete block
  when sampleTrigger then
    tSample = time;
    uSample = u;
    pre_uSample = pre(uSample);
    c = if firstTrigger then 0 else (uSample - pre_uSample)/samplePeriod;
  end when;
  /* Use pre_uSample and pre(c) to break potential algebraic loops by an
       infinitesimal delay if both the continuous and the discrete part
       have direct feedthrough.
    */
  y = pre_uSample + pre(c)*(time - tSample);
  annotation (
  defaultComponentName="firOrdHol",
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={                     Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={223,211,169},
        lineThickness=5.0,
        borderPattern=BorderPattern.Raised,
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
      Line(points={{-79.0,-41.0},{-59.0,-33.0},{-40.0,1.0},{-20.0,9.0},
                  {0.0,63.0},{21.0,20.0},{41.0,10.0},{60.0,20.0}},
        color={0,0,127}),
      Line(points={{60.0,20.0},{81.0,10.0}},
        color={0,0,127})}),
    Documentation(info="<html>
<p>
Block that outputs the extrapolation through the
values of the last two sampled input signals.
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
</html>"));
end FirstOrderHold;
