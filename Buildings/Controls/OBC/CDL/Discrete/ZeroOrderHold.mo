within Buildings.Controls.OBC.CDL.Discrete;
block ZeroOrderHold "Output the input signal with a zero order hold"

  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)
    "Sample period of component";

  Interfaces.RealInput u "Continuous input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "Continuous output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";

  output Real ySample(fixed=true, start=0)
    "Sampled value of input";

  output Boolean sampleTrigger "True, if sample time instant";

  output Boolean firstTrigger(start=false, fixed=true)
    "Rising edge signals first sample instant";

initial equation
  t0 = time;

equation
  // Declarations that are used for all discrete blocks
  sampleTrigger = sample(t0, samplePeriod);
  when sampleTrigger then
    firstTrigger = time <= t0 + samplePeriod/2;
  end when;

  // Declarations specific to this type of discrete block
  when {sampleTrigger, initial()} then
    ySample = u;
  end when;

  /* Define y=ySample with an infinitesimal delay to break potential
       algebraic loops if both the continuous and the discrete part have
       direct feedthrough
    */
  y = pre(ySample);
  annotation (
    defaultComponentName="zerOrdHol",
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
      Line(points={{-78.0,-42.0},{-52.0,-42.0},{-52.0,0.0},{-26.0,0.0},{-26.0,24.0},{-6.0,24.0},{-6.0,64.0},{18.0,64.0},{18.0,20.0},{38.0,20.0},{38.0,0.0},{44.0,0.0},{44.0,0.0},{62.0,0.0}},
        color={0,0,127})}),
    Documentation(info="<html>
<p>
Block that outputs the sampled input signal at sample
time instants. The output signal is held at the value of the last
sample instant during the sample points.
At initial time, the block feeds the input directly to the output.
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
end ZeroOrderHold;
