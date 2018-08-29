within Buildings.Controls.OBC.CDL.Logical;
block TriggeredTrapezoid "Triggered trapezoid generator"

  parameter Real amplitude "Amplitude of trapezoid";

  parameter Modelica.SIunits.Time rising(final min=0) = 0
    "Rising duration of trapezoid";

  parameter Modelica.SIunits.Time falling(final min=0) = rising
    "Falling duration of trapezoid";

  parameter Real offset=0 "Offset of output signal";

  Interfaces.BooleanInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  discrete Real endValue "Value of y at time of recent edge";
  discrete Real rate "Current rising/falling rate";
  discrete Modelica.SIunits.Time T
    "Predicted time of output reaching endValue";
equation
  y = if time < T then endValue - (T - time)*rate else endValue;

  when {initial(), u, not u} then
    endValue = if u then offset + amplitude else offset;
    rate = if u and (rising > 0) then amplitude/rising else if not u and (
      falling > 0) then -amplitude/falling else 0;
    T = if u and not (rising > 0) or not u and not (falling > 0) or not abs(
      amplitude) > 0 or initial() then time else time + (endValue - pre(y))/
      rate;
  end when;

  annotation (
    defaultComponentName="triTra",
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={                       Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
      Line(points={{-46,-70},{-46,-70},{-16,40},{22,40},{54,-70},{54,-70}},
        color={0,0,127}),
      Line(points={{-90.0,-70.0},{82.0,-70.0}},
        color={192,192,192}),
      Line(points={{-66,68},{-66,-80}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-66,90},{-74,68},{-58,68},{-66,90}}),
      Line(points={{-66,-70},{-46,-70},{-46,24},{22,24},{22,-70},{74,-70}},
        color={255,0,255}),
        Ellipse(
          extent={{-71,7},{-85,-7}},
          lineColor=DynamicSelect({235,235,235}, if u then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{-80,-20},{-60,-20},{-30,40},{
          8,40},{40,-20},{60,-20}}, color={0,0,255}),Line(points={{-90,-70},{
          82,-70}}),Line(points={{-80,68},{-80,-80}}, color={0,
          0,0}),Polygon(
            points={{90,-70},{68,-62},{68,-78},{90,-70}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Polygon(
            points={{-80,90},{-88,68},{-72,68},{-80,90}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Line(points={{-80,-68},{-60,-68},{
          -60,-42},{8,-42},{8,-68},{60,-68}}, color={255,0,255}),Line(
            points={{-60,40},{-60,-42}},
            pattern=LinePattern.Dot),Line(
            points={{8,-42},{8,40}},
            pattern=LinePattern.Dot),Line(points={{-60,40},{-30,40}}, color={
          0,0,0}),Line(points={{8,-20},{40,-20}}),Line(points=
          {{-20,40},{-20,-20}}),Line(points={{-20,-20},{-20,-70}}),Text(
            extent={{-44,50},{-44,40}},
            lineColor={0,0,0},
            textString="rising"),Text(
            extent={{24,-10},{24,-20}},
            lineColor={0,0,0},
            textString="falling"),Polygon(
            points={{-60,40},{-56,42},{-56,38},{-60,40}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Polygon(
            points={{-30,40},{-34,42},{-34,38},{-30,40}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Polygon(
            points={{8,-20},{12,-18},{12,-22},{8,-20}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Polygon(
            points={{40,-20},{36,-18},{36,-22},{40,-20}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Polygon(
            points={{-22,-24},{-20,-20},{-18,-24},{-22,-24}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Polygon(
            points={{-18,-66},{-22,-66},{-20,-70},{-18,-66}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Polygon(
            points={{-22,36},{-20,40},{-18,36},{-22,36}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Polygon(
            points={{-18,-16},{-22,-16},{-20,-20},{-18,-16}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Rectangle(
            extent={{-40,6},{0,-4}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Text(
            extent={{-20,6},{-20,-4}},
            lineColor={0,0,0},
            textString="amplitude"),Rectangle(
            extent={{-40,-48},{0,-58}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Text(
            extent={{-20,-48},{-20,-58}},
            lineColor={0,0,0},
            textString="offset"),Text(
            extent={{60,-82},{94,-92}},
            lineColor={0,0,0},
            textString="time"),Text(
            extent={{-88,-4},{-54,-14}},
            lineColor={0,0,0},
            textString="y"),Text(
            extent={{-88,-46},{-54,-56}},
            lineColor={0,0,0},
            textString="u")}),
    Documentation(info="<html>
<p>
Block that represents a triggered trapezoid.
</p>
<p>
The block has a Boolean input and a Real
output signal and requires the parameters <i>amplitude</i>,
<i>rising</i>, <i>falling</i> and <i>offset</i>. The
output signal <code>y</code> represents a trapezoidal signal dependent on the
input signal <code>u</code>.
</p>
<p>The behaviour is as follows: Assume the initial input to be
<code>false</code>. In this
case, the output will be <i>offset</i>. After a rising edge (i.e., the input
changes from <code>false</code> to <code>true</code>),
the output is rising during <i>rising</i> to the
sum of <i>offset</i> and <i>amplitude</i>. In contrast, after a falling
edge (i.e., the input changes from true to false), the output is falling
during <i>falling</i> to a value of <i>offset</i>.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/TriggeredTrapezoid.png\"
     alt=\"TriggeredTrapezoid.png\" />
</p>
<p>
Note, the case of edges before expiration of rising or falling is
handled properly.</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end TriggeredTrapezoid;
