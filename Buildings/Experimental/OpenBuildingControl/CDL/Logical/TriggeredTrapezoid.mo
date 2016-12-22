within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block TriggeredTrapezoid "Triggered trapezoid generator"
  extends Modelica.Blocks.Icons.PartialBooleanBlock;

  parameter Real amplitude=1 "Amplitude of trapezoid";
  parameter Modelica.SIunits.Time rising(final min=0) = 0
    "Rising duration of trapezoid";
  parameter Modelica.SIunits.Time falling(final min=0) = rising
    "Falling duration of trapezoid";
  parameter Real offset=0 "Offset of output signal";

  Modelica.Blocks.Interfaces.BooleanInput u
    "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  discrete Real endValue "Value of y at time of recent edge";
  discrete Real rate "Current rising/falling rate";
  discrete Modelica.SIunits.Time T
    "Predicted time of output reaching endValue";
equation
  y = if time < T then endValue - (T - time)*rate else endValue;

  when {initial(),u,not u} then
    endValue = if u then offset + amplitude else offset;
    rate = if u and (rising > 0) then amplitude/rising else if not u and (
      falling > 0) then -amplitude/falling else 0;
    T = if u and not (rising > 0) or not u and not (falling > 0) or not abs(
      amplitude) > 0 or initial() then time else time + (endValue - pre(y))/
      rate;
  end when;
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={
      Line(points={{-60.0,-70.0},{-60.0,-70.0},{-30.0,40.0},{8.0,40.0},{40.0,-70.0},{40.0,-70.0}},
        color={0,0,127}),
      Line(points={{-90.0,-70.0},{82.0,-70.0}},
        color={192,192,192}),
      Line(points={{-80.0,68.0},{-80.0,-80.0}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
      Line(points={{-80.0,-70.0},{-60.0,-70.0},{-60.0,24.0},{8.0,24.0},{8.0,-70.0},{60.0,-70.0}},
        color={255,0,255})}),
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
<p>The block TriggeredTrapezoid has a Boolean input and a real
output signal and requires the parameters <i>amplitude</i>,
<i>rising</i>, <i>falling</i> and <i>offset</i>. The
output signal <code>y</code> represents a trapezoidal signal dependent on the
input signal <code>u</code>.
</p>
<p>The behaviour is as follows: Assume the initial input to be false. In this
case, the output will be <i>offset</i>. After a rising edge (i.e., the input
changes from false to true), the output is rising during <i>rising</i> to the
sum of <i>offset</i> and <i>amplitude</i>. In contrast, after a falling
edge (i.e., the input changes from true to false), the output is falling
during <i>falling</i> to a value of <i>offset</i>.
</p>
<p>Note, that the case of edges before expiration of rising or falling is
handled properly.</p>
</html>"));
end TriggeredTrapezoid;
