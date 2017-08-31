within Buildings.Controls.OBC.CDL.Logical;
block Timer
  "Timer measuring the time from the time instant where the Boolean input became true"

  Interfaces.BooleanInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  discrete Modelica.SIunits.Time entryTime "Time instant when u became true";

initial equation
  pre(entryTime) = 0;

equation
  when u then
    entryTime = time;
  end when;

  y = if u then time - entryTime else 0.0;

annotation (
    defaultComponentName="tim",
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={                       Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
      Line(points={{-66,-70},{82,-70}},
        color={192,192,192}),
      Line(points={{-58,68},{-58,-80}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-58,90},{-66,68},{-50,68},{-58,90}}),
      Line(points={{-56,-70},{-38,-70},{-38,-26},{40,-26},{40,-70},{68,-70}},
        color={255,0,255}),
      Line(points={{-58,0},{-40,0},{40,90},{40,0},{68,0}},
        color={0,0,127}),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235}, if u then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if u then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Block that represents a timer.
</p>
<p>
When the Boolean input <code>u</code> becomes <code>true</code>, the timer is started
and the output <code>y</code> is the time from the time instant where
<code>u</code> became true.
The timer is stopped and the output is reset to zero, once the
input becomes <code>false</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Timer;
