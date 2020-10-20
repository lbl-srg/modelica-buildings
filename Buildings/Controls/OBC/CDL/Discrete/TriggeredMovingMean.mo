within Buildings.Controls.OBC.CDL.Discrete;
block TriggeredMovingMean
  "Triggered discrete moving mean of an input signal"

  parameter Integer n(min=1)
    "Number of samples over which the input is averaged";

  Interfaces.RealInput u "Continuous input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanInput trigger "Boolean signal that triggers the block"
    annotation (Placement(
        transformation(
        origin={0,-120},
        extent={{-20,-20},{20,20}},
        rotation=90), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Interfaces.RealOutput y "Discrete averaged signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Integer iSample(start=0, fixed=true) "Sample numbering in the calculation";
  Integer counter(start=0, fixed=true)
      "Number of samples used for averaging calculation";
  Integer index(start=0, fixed=true) "Index of the vector ySample";
  Real ySample[n](
    start=zeros(n),
    each fixed=true) "Vector of samples to be averaged";

equation
  when {initial(), trigger} then
    index = mod(pre(iSample), n) + 1;
    ySample = {if (i == index) then u else pre(ySample[i]) for i in 1:n};
    counter = if pre(counter) == n then n else pre(counter) + 1;
    y = sum(ySample)/counter;
    iSample = pre(iSample) + 1;
  end when;

  annotation (
  defaultComponentName="triMovMea",
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
       Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
       Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
       Line(points={{-80,0},{-52,0}}, color={217,67,180}),
       Line(
          points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,74.6},
              {-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,59.4},
              {-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,-64.2},
              {29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},{
              57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}},
          smooth=Smooth.Bezier,
          color={28,108,200}),
       Line(points={{-52,36},{-24,36}}, color={217,67,180}),
       Line(points={{-52,0},{-52,36}}, color={217,67,180}, smooth=Smooth.Bezier),
       Line(points={{-24,36},{-24,46}}, color={217,67,180}, smooth=Smooth.Bezier),
       Line(points={{-24,46},{4,46}}, color={217,67,180}),
       Line(points={{4,4},{32,4}}, color={217,67,180}),
       Line(points={{4,46},{4,4}}, color={217,67,180}, smooth=Smooth.Bezier),
       Line(points={{32,-32},{60,-32}}, color={217,67,180}),
       Line(points={{32,4},{32,-32}}, color={217,67,180}, smooth=Smooth.Bezier),
       Line(points={{60,-58},{82,-58}}, color={217,67,180}),
       Line(points={{60,-32},{60,-58}}, color={217,67,180},smooth=Smooth.Bezier),
        Ellipse(
          extent={{-25,-10},{-45,10}},
          lineColor={176,181,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{45,-10},{25,10}},
          lineColor={176,181,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{-45,0}}, color={176,181,255}),
        Line(points={{45,0},{100,0}}, color={176,181,255}),
        Line(points={{-35,0},{28,-48}}, color={176,181,255}),
        Line(points={{0,-100},{0,-26}}, color={255,0,255}),
        Text(
          extent={{56,92},{92,60}},
          lineColor={28,108,200},
          textString="%n"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}),
Documentation(info="<html>
<p>
Block that outputs the triggered moving mean value of an input signal.
</p>
<p>
At the start of the simulation, and whenever the trigger signal is rising
(i.e., the trigger changes to <code>true</code>), the block samples
the input, computes the moving mean value over the past <code>n</code> samples,
and produces this value at its output <code>y</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 19, 2020, by Michael Wetter:<br/>
Removed non-needed protected parameter <code>t0</code>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
November 7, 2019, by Michael Wetter:<br/>
Reformulated model to use an <code>equation</code> rather than an <code>algorithm</code> section.
</li>
<li>
October 16, 2019, by Kun Zhang:<br/>
First implementation. This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1588\">issue 1588</a>.
</li>
</ul>
</html>"));
end TriggeredMovingMean;
