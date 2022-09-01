within Buildings.Controls.OBC.CDL.Discrete;
block ZeroOrderHold
  "Output the input signal with a zero order hold"
  parameter Real samplePeriod(
    final quantity="Time",
    final unit="s",
    min=1E-3)
    "Sample period of component";
  Interfaces.RealInput u
    "Continuous input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y
    "Continuous output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Real t0(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "First sample time instant";
  output Real ySample(
    fixed=true,
    start=0)
    "Sampled value of input";
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
    ySample=u;
  end when;
  /* Define y=ySample with an infinitesimal delay to break potential
       algebraic loops if both the continuous and the discrete part have
       direct feedthrough
   */
  y=pre(ySample);
  annotation (
    defaultComponentName="zerOrdHol",
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
          points={{-78.0,-42.0},{-52.0,-42.0},{-52.0,0.0},{-26.0,0.0},{-26.0,24.0},{-6.0,24.0},{-6.0,64.0},{18.0,64.0},{18.0,20.0},{38.0,20.0},{38.0,0.0},{44.0,0.0},{44.0,0.0},{62.0,0.0}},
          color={0,0,127}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
Block that outputs the sampled input signal at sample
time instants. The output signal is held at the value of the last
sample instant during the sample points.
At initial time, the block feeds the input directly to the output.
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
end ZeroOrderHold;
