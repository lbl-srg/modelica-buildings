within Buildings.Controls.OBC.CDL.Reals;
block MovingAverage "Block to output moving average"
  parameter Real delta(
    final quantity="Time",
    final unit="s",
    min=1E-5)
    "Time horizon over which the input is averaged";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Real tStart(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "Start time";
  Real mu
    "Internal integrator variable";
  Real muDel
    "Internal integrator variable with delay";
  Boolean mode(
    start=false,
    fixed=true)
    "Calculation mode";

initial equation
  tStart=time;
  mu=0;

equation
  u=der(mu);
  muDel=delay(
    mu,
    delta);
  // Compute the mode so that Dymola generates
  // time and not state events as it would with
  // an if-then construct
  when time >= tStart+delta then
    mode=true;
  end when;
  if mode then
    y=(mu-muDel)/delta;
  else
    y=(mu-muDel)/(time-tStart+1E-3);
  end if;
  annotation (
    defaultComponentName="movAve",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-78,90},{-86,68},{-70,68},{-78,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-78,68},{-78,-80}},
          color={192,192,192}),
        Line(
          points={{-88,0},{70,0}},
          color={192,192,192}),
        Polygon(
          points={{92,0},{70,8},{70,-8},{92,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-78,-31},{-64,-31},{-64,-15},{-56,-15},{-56,-63},{-48,-63},
          {-48,-41},{-40,-41},{-40,43},{-32,43},{-32,11},{-32,11},{-32,-49},
          {-22,-49},{-22,-31},{-12,-31},{-12,-59},{-2,-59},{-2,23},{4,23},
          {4,37},{10,37},{10,-19},{20,-19},{20,-7},{26,-7},{26,-37},
          {36,-37},{36,35},{46,35},{46,1},{54,1},{54,-65},{64,-65}},
          color={215,215,215}),
        Line(
          points={{-78,-24},{68,-24}}),
        Text(
          extent={{-140,152},{160,112}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-42,-63},{41,-106}},
          textColor={192,192,192},
          textString="%delta s"),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
This block outputs the mean value of its input signal as
</p>
<pre>
      1  t
y =   -  &int;   u(s) ds
      &delta;  t-&delta;
</pre>
<p>
where <i>&delta;</i> is a parameter that determines the time window over
which the input is averaged.
For
<i> t &lt; &delta;</i> seconds, it outputs
</P>
<pre>
           1      t
y =   --------    &int;   u(s) ds
      t-t<sub>0</sub>+10<sup>-10</sup>   t<sub>0</sub>
</pre>
<p>
where <i>t<sub>0</sub></i> is the initial time.
</p>
<p>
This block can for example be used to output the moving
average of a noisy measurement signal.
</p>
<p>
See
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Validation.MovingAverage\">
Buildings.Controls.OBC.CDL.Reals.Validation.MovingAverage</a>
and
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Validation.MovingAverage_nonZeroStart\">
Buildings.Controls.OBC.CDL.Reals.Validation.MovingAverage_nonZeroStart</a>
for example.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 27, 2022, by Jianjun Hu:<br/>
Renamed the block name from MovingMean to MovingAverage.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">issue 2865</a>.
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
October 24, 2017, by Michael Wetter:<br/>
Set initial condition for <code>mu</code>.
</li>
<li>
October 17, 2017, by Michael Wetter:<br/>
Reformulated implementation to avoid direct feedthrough.
</li>
<li>
October 16, 2017, by Michael Wetter:<br/>
Reformulated implementation to handle division by zero as the previous
implementation caused division by zero in the VAV reheat model with the Radau solver.
</li>
<li>
September 27, 2017, by Thierry S. Nouidui:<br/>
Reformulated implementation to handle division by zero.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/978\">issue 978</a>.
</li>
<li>
September 15, 2017, by Thierry S. Nouidui:<br/>
Reformulated implementation to avoid state events.
</li>
<li>
July 5, 2017, by Michael Wetter:<br/>
Revised implementation to allow non-zero start time.
</li>
<li>
June 29, 2017, by Jianjun Hu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/825\">issue 825</a>.
</li>
</ul>
</html>"));
end MovingAverage;
