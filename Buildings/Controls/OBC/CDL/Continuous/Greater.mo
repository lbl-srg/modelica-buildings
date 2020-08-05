within Buildings.Controls.OBC.CDL.Continuous;
block Greater "Output y is true, if input u1 is greater than input u2"

  parameter Real h(final min=0)=0 "Hysteresis, set positive value to enable";

  parameter Boolean pre_y_start=false "Value of pre(y) at initial time"
    annotation(Dialog(tab="Advanced"));


  Interfaces.RealInput u1 "Input u1"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealInput u2 "Input u2"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Interfaces.BooleanOutput y "Output y"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y = if h < 1E-10 then u1 > u2 else (not pre(y) and u1 > u2 or pre(y) and u1 >= u2-h);

annotation (
  defaultComponentName="gre",
  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}), graphics={
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
        Ellipse(extent={{32,10},{52,-10}}, lineColor={0,0,127}),
        Line(points={{-100,-80},{42,-80},{42,0}}, color={0,0,127}),
        Line(
          points={{-54,22},{-8,2},{-54,-18}},
          thickness=0.5),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(extent={{-48,38},{57,78}},
          textString="%h",
          visible=h >= 1E-10,
          lineColor={0,0,0})}),
  Documentation(info="<html>
<p>
Block that outputs <code>true</code> if the Real input <code>u1</code>
is greater than the Real input <code>u2</code>.
Otherwise the output is <code>false</code>.
</p>
<p>
The parameter <code>h</code> can be used to specify a hysteresis.
If <i> &gt; 0</i> then the output switches to true if <i>u<sub>1</sub> &gt; u<sub>2</sub></i>,
and it switches to <code>false</code> if <i>u<sub>1</sub> &gt; u<sub>2</sub>-h</i>.
</p>
<p>
Hysteresis should be specified to avoid frequent switching. In real controllers, this could be
due to sensor noise. In simulation, this could be due to numerical noise.
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
end Greater;
