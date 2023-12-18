within Buildings.Obsolete.Controls.OBC.CDL.Logical;
block TriggeredTrapezoid "Triggered trapezoid generator"
  parameter Real amplitude
    "Amplitude of trapezoid";
  parameter Real rising(
    final quantity="Time",
    final unit="s",
    final min=0)=0
    "Rising duration of trapezoid";
  parameter Real falling(
    final quantity="Time",
    final unit="s",
    final min=0)=rising
    "Falling duration of trapezoid";
  parameter Real offset=0
    "Offset of output signal";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  discrete Real endValue
    "Value of y at time of recent edge";
  discrete Real rate
    "Current rising/falling rate";
  discrete Real T(
    final quantity="Time",
    final unit="s")
    "Predicted time of output reaching endValue";

equation
  y=if time < T then
      endValue-(T-time)*rate
    else
      endValue;
  when {initial(),u,not u} then
    endValue=
      if u then
        offset+amplitude
      else
        offset;
    rate=
      if u and
              (rising > 0) then
        amplitude/rising
      else
        if not u and
                    (falling > 0) then
          -amplitude/falling
        else
          0;
    T=if u and not
                  (rising > 0) or not u and not
                                               (falling > 0) or not abs(amplitude) > 0 or initial() then
        time
      else
        time+(endValue-pre(y))/rate;
  end when;
  annotation (
    defaultComponentName="triTra",
    obsolete = "This model is obsolete",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Line(
          points={{-46,-70},{-46,-70},{-16,40},{22,40},{54,-70},{54,-70}},
          color={0,0,127}),
        Line(
          points={{-90.0,-70.0},{82.0,-70.0}},
          color={192,192,192}),
        Line(
          points={{-66,68},{-66,-80}},
          color={192,192,192}),
        Polygon(
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{-66,90},{-74,68},{-58,68},{-66,90}}),
        Line(
          points={{-66,-70},{-46,-70},{-46,24},{22,24},{22,-70},{74,-70}},
          color={255,0,255}),
        Ellipse(
          extent={{-71,7},{-85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if u then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if u then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Polygon(
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}})),
    Documentation(
      info="<html>
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
</html>",
      revisions="<html>
<ul>
<li>
December 11, 2023, by Jianjun Hu:<br/>
Moved this model to the <code>Obsolete</code> package. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3595\">issue 3595</a>.
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end TriggeredTrapezoid;
