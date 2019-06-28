within Buildings.Controls.OBC.CDL.Discrete;
block MovingMean "Discrete moving mean of a sampled input signal"
  parameter Integer n(min=2) "Number of samples over which the input is averaged";
  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)
      "Sampling period of component";

  Interfaces.RealInput u "Continuous input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y "Discrete averaged signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  output Real yDiscrete(fixed=true, start=0)
    "Discretized input signal as a reference for verification";

protected
  parameter Modelica.SIunits.Time t0(fixed=false) "First sample time instant";
  Boolean discreteTrigger "Trigger samples at each sampling rate";
  Boolean sampleTrigger[n]
    "Trigger samples at different start time for each replicated signal";
  Real ySample[n](fixed=true, start=vector(zeros(n,1)))
    "Sampling outputs at different start time";
  Boolean mode(start=false, fixed=true) "Calculation mode";

initial equation
  t0 = time;

equation
  // Get the sampled signal at the user-defined sampling rate
  discreteTrigger = sample(t0, samplePeriod);
  when discreteTrigger then
    yDiscrete = u;
  end when;

  // Build replicative samples at different start time used for averaging
  for i in 1:n loop
    sampleTrigger[i] = sample(t0+(i-1)*samplePeriod, n*samplePeriod);
    when sampleTrigger[i] then
      ySample[i] = u;
    end when;
  end for;

  when time >= t0+(n-1)*samplePeriod then
    mode = true;
  end when;

  // Only when there are n or more samples, the signal is averaged over n samples
  if mode then
    y = sum(ySample)/n;
  else
    y = sum(ySample)/(integer(time-t0)/samplePeriod+1);
  end if;

  annotation (
  defaultComponentName="movMea",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
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
       lineColor={0,0,255}),
        Line(points={{-88,0},{70,0}}, color={192,192,192}),
        Polygon(
          points={{92,0},{70,8},{70,-8},{92,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-78,68},{-78,-80}}, color={192,192,192}),
        Polygon(
          points={{-78,90},{-86,68},{-70,68},{-78,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-78,22},{-58,22},{-58,-22}}, color={28,108,200}),
        Line(points={{-58,-22},{-42,-22},{-38,-22},{-38,22}}, color={28,108,200}),
        Line(points={{-38,22},{-18,22},{-18,-22}}, color={28,108,200}),
        Line(points={{-18,-22},{-2,-22},{2,-22},{2,22}}, color={28,108,200}),
        Line(points={{2,22},{22,22},{22,-22}}, color={28,108,200}),
        Line(points={{22,-22},{38,-22},{42,-22},{42,22}}, color={28,108,200}),
        Line(points={{-78,22},{-58,22}}, color={217,67,180}),
        Line(points={{-58,22},{-58,0}}, color={217,67,180}),
        Line(points={{-58,0},{62,0}}, color={217,67,180}),
        Line(points={{42,22},{62,22},{62,-22}}, color={28,108,200})}),
Documentation(info="<html>
<p>
This block calculates the discrete moving mean values of an input signal.
The continuous input signal is first sampled; then at each sampling rate, the 
block outputs the average value of the past n samples including the current 
sample. 
</p>
<p>
At the first sample, the block produces the first sampled input. At the next 
sample, it produces the average of the past two samples, then the past three 
samples and so on up to n samples.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 17, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"));
end MovingMean;
