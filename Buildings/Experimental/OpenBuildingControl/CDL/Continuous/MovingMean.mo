within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block MovingMean
  "Block to output moving average with centain time horizon"

  parameter Modelica.SIunits.Time timHor
    "Time horizon during when the input being averaged.";

  Interfaces.RealInput u "Connector of Real input signal"
   annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y "Connector of Real output signal"
   annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Real mu "Internal integrator variable";
  Real muDel "Internal integrator variable with delay";

initial equation
  mu = u;
equation
  u =der(mu);
  muDel = delay(mu, timHor);
  if (time > timHor) then
    y = (mu-muDel)/timHor;
  elseif time > 0 then
    y = (mu-muDel)/time;
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
          lineColor={0,0,255})}),
   Documentation(info="<html>
   <p>
   This block continuously calculates the mean value of its input signal. 
   It uses the function:</p>
<blockquote>
<pre>     integral( u over [time, time-timHor])
y = ---------------------------------------
                 timHor</pre>
</blockquote>
<p>This can be used to determine moving average value of a input with random 
noise signal.</p>

<p>
This block is demonstrated in the examples
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation.MovingMean\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation.MovingMean</a>,
</p>
</html>", revisions="<html>
<ul>
<li>
June 29, 2017, by Jianjun Hu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/825\">issue 825</a>.
</li>
</ul>
</html>"));
end MovingMean;
