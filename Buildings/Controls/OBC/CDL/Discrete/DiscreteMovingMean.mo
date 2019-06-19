within Buildings.Controls.OBC.CDL.Discrete;
block DiscreteMovingMean "Discrete moving mean of a sampled input signal"
  parameter Integer nSam(min=2) "Number of samples to be averaged";
  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)
      "Sampling period of component";
  parameter Real y_start=0 "Initial value of output signal";

  Interfaces.RealInput u "Continuous input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y "Averaged discrete signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Sampler sampler(samplePeriod=samplePeriod) "Sampled input signal as a reference"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

protected
  Routing.RealReplicator reaRep(final nout=nSam)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TriggeredSampler triSam[nSam](each final y_start=y_start)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Logical.Sources.SampleTrigger samTri[nSam](
                                each final period=nSam*samplePeriod,
                                startTime={(i - 1)*samplePeriod for i in 1:nSam})
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Continuous.MultiSum mulSum(final k=fill(1, nSam),
                             final nin=nSam)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Continuous.Gain gai(k=1/nSam)
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
       lineColor={0,0,255})}),
Documentation(info="<html>
<p>
This block outputs the moving average values of a sampled input signal.
The continuous input signal is first sampled; then at each sampling rate, the 
output equals the mean value of the past n samples including the current 
sample.
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
