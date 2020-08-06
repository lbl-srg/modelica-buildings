within Buildings.Controls.OBC.CDL.Continuous;
block Less "Output y is true, if input u1 is less than input u2"

  parameter Real h(final min=0)=0 "Hysteresis"
    annotation(Evaluate=true);

  parameter Boolean pre_y_start=false "Value of pre(y) at initial time"
    annotation(Dialog(tab="Advanced"));

  Interfaces.RealInput u1 "Input u1"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealInput u2 "Input u2"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Interfaces.BooleanOutput y "Output y"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

initial equation
  assert(h >= 0, "Hysteresis must not be negative");
  pre(y) = pre_y_start;
equation
  y = if h < 1E-10 then u1 < u2 else (not pre(y) and u1 < u2 or pre(y) and u1 <= u2+h);

annotation (
  defaultComponentName="les",
  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}),
  graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{73,7},{87,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Line(points={{-100,-80},{42,-80},{42,-62}},
             color={0,0,127}),
        Line(
          points={{18,14},{-12,2},{18,-8}},
          thickness=0.5),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(extent={{-64,62},{62,92}},
          lineColor={0,0,0},
          textString="h=%h"),
        Text(extent={{-88,-18},{-21,24}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(u1, leftjustified=false, significantDigits=3))),
        Text(extent={{-86,-76},{-19,-34}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(u2, leftjustified=false, significantDigits=3))),
        Text(extent={{22,20},{89,62}},
          lineColor=DynamicSelect({235,235,235}, if y then {135,135,135} else {0,0,0}),
          textString=DynamicSelect("", String(u2, leftjustified=false, significantDigits=3)),
          visible=h >= 1E-10),
        Text(extent={{22,20},{89,62}},
          lineColor=DynamicSelect({235,235,235}, if y then {135,135,135} else {0,0,0}),
          textString=DynamicSelect("", String(u2, leftjustified=false, significantDigits=3)),
          visible=h >= 1E-10),
        Text(extent={{20,-56},{87,-14}},
          lineColor=DynamicSelect({235,235,235}, if not y then {135,135,135} else {0,0,0}),
          textString=DynamicSelect("", String(u2+h, leftjustified=false, significantDigits=3)),
          visible=h >= 1E-10)}),
  Documentation(info="<html>
<p>
Block that outputs <code>true</code> if the Real input <code>u1</code>
is less than the Real input <code>u2</code>, optionally within a hysteresis <code>h</code>.
</p>
<p>
The parameter <code>h</code> is used to specify a hysteresis.
If <i>h &gt; 0</i>, then the output switches to <code>true</code> if <i>u<sub>1</sub> &lt; u<sub>2</sub></i>,
and it switches to <code>false</code> if <i>u<sub>1</sub> &lt; u<sub>2</sub>+h</i>.
</p>
<p>
Enabling hysteresis can avoid frequent switching.
Adding hysteresis is recommended in real controllers to guard against sensor noise, and
in simulation to guard against numerical noise. Numerical noise can be present if
an input depends on a state variable or a quantity that requires an iterative solution, such as
a temperature or a mass flow rate of an HVAC system.
To disable hysteresis, set <i>h=0</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 5, 2020, by Michael Wetter:<br/>
Added hysteresis.<br/>
This is for <a href=\\\"https://github.com/lbl-srg/modelica-buildings/issues/2076\\\">issue 2076</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Less;
