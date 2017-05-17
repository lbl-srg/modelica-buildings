within Buildings.Controls.Continuous;
model OffTimer "Records the time since the input changed to false"
  extends Modelica.Blocks.Interfaces.partialBooleanBlockIcon;

  Modelica.Blocks.Interfaces.BooleanInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  discrete Modelica.SIunits.Time entryTime "Time instant when u became true";
initial equation
  pre(entryTime) = time;
equation
  when (not u) then
    entryTime = time;
  end when;
  y = time - entryTime;
  annotation (
    Icon(graphics={
        Line(points={{-78,16},{-60,30},{-60,-8},{42,82},{42,-8},{72,18}}, color=
             {0,0,255}),
        Polygon(
          points={{92,-78},{70,-70},{70,-86},{92,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,-78},{84,-78}}, color={192,192,192}),
        Line(points={{-78,60},{-78,-88}}, color={192,192,192}),
        Polygon(
          points={{-78,82},{-86,60},{-70,60},{-78,82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-78,-34},{-58,-34},{-58,-78},{-28,-78},{-28,-34},{40,-34},
              {40,-78},{68,-78}}, color={255,0,255})}),
defaultComponentName="offTim",
    Documentation(info="<html>
<p>
Timer that starts at the initial time with a value of <i>0</i>,
and gets reset each time the input signal switches to <code>false</code>.
</p>
<p>
For example, if the simulation starts at <i>t = 10</i> and at <i>t=11</i>,
the input becomes <code>false</code>, then the timer outputs
<i>y=t-10</i> for <i>t &lt; 11</i>, and <i>y=t-11</i> afterwards, unless
the input becomes false again.
</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Michael Wetter:<br/>
Corrected implementation for non-zero start time.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/780\">issue 780</a>.
</li>
<li>
January 4, 2011, by Wangda Zuo and Michael Wetter:<br/>
Revised implementation.
</li>
<li>
February 12, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OffTimer;
