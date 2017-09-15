within Buildings.Controls.OBC.CDL.Continuous;
block MovingMean
  "Block to output moving average with centain time horizon"

  parameter Modelica.SIunits.Time delta(min=2*CDL.Constants.eps)
    "Time horizon over which the input is averaged";

  Interfaces.RealInput u "Connector of Real input signal"
   annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y "Connector of Real output signal"
   annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Modelica.SIunits.Time tStart(fixed=false) "Start time";
  Real mu "Internal integrator variable";
  Real muDel "Internal integrator variable with delay";
  Mode mode "Calculation mode";
  type Mode = enumeration(
      NORMAL,
      INITIALIZE,
      GUARD_DIVISION_BY_ZERO) "Enumeration for calculation mode";

initial equation
  tStart = time;
  mu = u;
  mode = Mode.GUARD_DIVISION_BY_ZERO;
equation
  u =der(mu);
  muDel = delay(mu, delta);

  // Compute the mode so that Dymola generates time and not state events
  // as it would with an if-then construct
  when time >= tStart+delta then
    mode = Mode.NORMAL;
  elsewhen time >= tStart+Constants.eps then
    mode = Mode.INITIALIZE;
  end when;

  if mode == Mode.NORMAL then
    y = (mu-muDel)/delta;
  elseif mode == Mode.INITIALIZE then
    y = (mu-muDel)/(time-tStart);
  else
    y = u;
  end if;
  annotation (
  defaultComponentName="movMea",
  Icon(graphics={
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
        Line(points={{-78,68},{-78,-80}}, color={192,192,192}),
        Line(points={{-88,0},{70,0}}, color={192,192,192}),
        Polygon(
          points={{92,0},{70,8},{70,-8},{92,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
           points={{-78,-31},{-64,-31},{-64,-15},{-56,-15},{-56,-63},{-48,-63},{
              -48,-41},{-40,-41},{-40,43},{-32,43},{-32,11},{-32,11},{-32,-49},{
              -22,-49},{-22,-31},{-12,-31},{-12,-59},{-2,-59},{-2,23},{4,23},{4,
              37},{10,37},{10,-19},{20,-19},{20,-7},{26,-7},{26,-37},{36,-37},{36,
              35},{46,35},{46,1},{54,1},{54,-65},{64,-65}},
            color={215,215,215}),
        Line(
          points={{-78,-24},{68,-24}}),
        Text(
          extent={{-140,152},{160,112}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-42,-63},{41,-106}},
          lineColor={192,192,192},
          textString="%delta s")}),
   Documentation(info="<html>
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
During the start of the simulation, the block outputs <code>y = u</code> for
the first <i>1E-15</i> seconds (to avoid a division by zero), and for 
<i> 1E-15 &le; t &le; &delta;</i> seconds, it outputs
</P>
<pre>
       1    t
y =   ----  &int;   u(s) ds
      t-t<sub>0</sub>  t<sub>0</sub>
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
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Validation.MovingMean\">
Buildings.Controls.OBC.CDL.Continuous.Validation.MovingMean</a>
and 
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Validation.MovingMean_nonZeroStart\">
Buildings.Controls.OBC.CDL.Continuous.Validation.MovingMean_nonZeroStart</a>
for example.
</p>
</html>", revisions="<html>
<ul>
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
end MovingMean;
