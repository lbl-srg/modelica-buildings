within Buildings.Controls.OBC.CDL.Discrete;
block DiscreteMovingMean "Discrete moving mean of a sampled input signal"
  parameter Integer nSam(min=2) "Number of samples to be averaged";
  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)
      "Sampling period of component";
  parameter Real y_start = 0
      "Initial value for the first nSam-1 samples";
  parameter Modelica.SIunits.Time startTime = 0
      "Simulation start time, can be negative";

  Interfaces.RealInput u "Continuous input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y "Discrete averaged signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Sampler sampler(samplePeriod=samplePeriod) "Sampled input signal as a reference"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

protected
  Routing.RealReplicator reaRep(final nout=nSam) "Replicate the input signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TriggeredSampler triSam[nSam](each final y_start=y_start)
    "Sample the replicated input signals"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Logical.Sources.SampleTrigger samTri[nSam](
                         each final period=nSam*samplePeriod,
                         startTime={startTime+(i-1)*samplePeriod for i in 1:nSam})
    "Trigger samples at different start time for each replicated signal"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Continuous.MultiSum mulSum(final k=fill(1, nSam),
                             final nin=nSam) "Sum all samples with coefficient 1"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Continuous.Gain gai(k=1/nSam) "Get the average"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(u, reaRep.u) annotation (Line(points={{-120,0},{-62,0}},
                 color={0,0,127}));
  connect(reaRep.y, triSam.u) annotation (Line(points={{-39,0},{-22,0}}, color={0,0,127}));
  connect(samTri.y, triSam.trigger) annotation (Line(points={{-39,-50},{-10,-50},
          {-10,-11.8}}, color={255,0,255}));
  connect(triSam.y, mulSum.u)  annotation (Line(points={{1,0},{18,0}}, color={0,0,127}));
  connect(u, sampler.u) annotation (Line(points={{-120,0},{-80,0},{-80,50},{-22,
          50}},
        color={0,0,127}));
  connect(mulSum.y, gai.u) annotation (Line(points={{41,0},{58,0}}, color={0,0,127}));
  connect(gai.y, y) annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  annotation (
  defaultComponentName="disMovMea",
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
        Line(points={{-78,10},{-58,10}}, color={217,67,180}),
        Line(points={{-58,10},{-58,0}}, color={217,67,180}),
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
During initialization, the initial value given by the user is the value for the 
initial n-1 samples.
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
end DiscreteMovingMean;
