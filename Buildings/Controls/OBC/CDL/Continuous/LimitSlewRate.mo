within Buildings.Controls.OBC.CDL.Continuous;
block LimitSlewRate "Limit the increase or decrease rate of input"
  parameter Real raisingSlewRate(
    min=Constants.small,
    unit="1/s")
    "Speed with which to increase the output";
  parameter Real fallingSlewRate(
    max=-Constants.small,
    unit="1/s")=-raisingSlewRate
    "Speed with which to decrease the output";
  parameter Real Td(
    final quantity="Time",
    final unit="s",
    min=Constants.eps)=raisingSlewRate*10
    "Derivative time constant";
  parameter Boolean enable=true
    "Set to false to disable rate limiter";
  Interfaces.RealInput u
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Real thr=(u-y)/Td
    "Approximation to derivative between input and output";

initial equation
  assert(
    raisingSlewRate > 0,
    "raisingSlewRate must be larger than zero.");
  assert(
    fallingSlewRate < 0,
    "fallingSlewRate must be less than zero.");

  y=u;

equation
  if enable then
    der(y)=smooth(
      1,
      noEvent(
        if thr < fallingSlewRate then
          fallingSlewRate
        else
          if thr > raisingSlewRate then
            raisingSlewRate
          else
            thr));
  else
    y=u;
  end if;
  annotation (
    defaultComponentName="ramLim",
    Documentation(
      info="<html>
<p>
The block limits the rate of change of the input by a ramp.
</p>
<p>
This block computes a threshold for the rate of change between
input <code>u</code> and output <code>y</code> as
<code>thr = (u-y)/Td</code>, where <code>Td &gt; 0</code> is  parameter.
The output <code>y</code> is computed as follows:
<ul>
<li>
If <code>thr &lt; fallingSlewRate</code>, then <code>dy/dt = fallingSlewRate</code>,
</li>
<li>
if <code>thr &gt; raisingSlewRate</code>, then <code>dy/dt = raisingSlewRate</code>,
</li>
<li>
otherwise, <code>dy/dt = thr</code>.
</li>
</ul>
<h4>Implementation</h4>
<p>
For the block to work with arbitrary inputs and in order to produce a differentiable output,
the input is numerically differentiated with derivative time constant <code>Td</code>.
Smaller time constant <code>Td</code> means nearer ideal derivative.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 27, 2022, by Jianjun Hu:<br/>
Renamed the block name from SlewRateLimiter to LimitSlewRate.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">issue 2865</a>.
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
April 21, 2020, by Michael Wetter:<br/>
Removed final attribute on unit because if the input quantity is power,
then the rate limit is units of power per units of time.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
March 29, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,-90},{0,68}},
          color={192,192,192}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,0},{68,0}},
          color={192,192,192}),
        Polygon(
          points={{90,0},{68,-8},{68,8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{-50,-70},{50,70}}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}));
end LimitSlewRate;
