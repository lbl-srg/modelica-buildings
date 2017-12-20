within Buildings.Controls.OBC.CDL.Continuous;
block Line
  "Output the value of the input x along a line specified by two points"

  parameter Boolean limitBelow = true "If true, limit input u to be no smaller than x1"
    annotation(Evaluate=true);

  parameter Boolean limitAbove = true "If true, limit input u to be no larger than x2"
    annotation(Evaluate=true);

  Interfaces.RealInput x1 "Support point x1"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Interfaces.RealInput f1 "Support point f(x1)"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Interfaces.RealInput x2 "Support point x2"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Interfaces.RealInput f2 "Support point f(x2)"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Interfaces.RealInput u "Independent variable"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "f(x) along the line specified by (x1, f1) and (x2, f2)"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Real a "Intercept";
  Real b "Slope";
  Real xLim "Input value after applying the limits";

equation
  b = (f2-f1)/(x2-x1);
  a = f2 - b*x2;

  if limitBelow and limitAbove then
    xLim = min(x2, max(x1, u));
  elseif limitBelow then
    xLim = max(x1, u);
  elseif limitAbove then
    xLim = min(x2, u);
  else
    xLim = u;
  end if;
   y = a + b * xLim;
  annotation (
    defaultComponentName="lin",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Polygon(
          points={{92,-78},{70,-70},{70,-86},{92,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-86,-40},{88,48}}),
        Line(points={{-80,-80},{-80,66}},
                                      color={192,192,192}),
        Polygon(
          points={{-80,88},{-88,66},{-72,66},{-80,88}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,-78},{76,-78}},
                                      color={192,192,192}),
        Line(
          points={{-100,80},{38,70},{56,-78}},
          color={28,108,200},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,40},{-88,40},{-80,40}},
          color={28,108,200},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,-40},{-70,-58},{-42,-78}},
          color={28,108,200},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,-80},{-92,-54},{-80,-38}},
          color={28,108,200},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,0},{-62,0},{22,14}},
          color={28,108,200},
          smooth=Smooth.Bezier),
        Line(
          points={{22,14},{52,-8},{100,0}},
          color={28,108,200},
          smooth=Smooth.Bezier),
        Ellipse(
          extent={{42,34},{54,22}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-44,-10},{-32,-22}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,20},{26,8}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Block that outputs <code>y = a + b u</code>,
where
<code>u</code> is an input
and the coefficients <code>a</code> and <code>b</code>
are determined so that the line intercepts the two input points
specified by the two points <code>x1</code> and <code>f1</code>,
and <code>x2</code> and <code>f2</code>.
</p>
<p>
The parameters <code>limitBelow</code> and <code>limitAbove</code>
determine whether <code>x1</code> and <code>x2</code> are also used
to limit the input <code>u</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 11, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Line;
