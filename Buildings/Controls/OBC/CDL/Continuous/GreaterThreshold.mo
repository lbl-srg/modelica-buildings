within Buildings.Controls.OBC.CDL.Continuous;
block GreaterThreshold
  "Output y is true, if input u is greater than threshold"

  parameter Real threshold=0 "Threshold for comparison";

  parameter Real h(final min=0)=0 "Hysteresis"
    annotation(Evaluate=true);

  parameter Boolean pre_y_start=false "Value of pre(y) at initial time"
    annotation(Dialog(tab="Advanced"));

  Interfaces.RealInput u "Input"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.BooleanOutput y "Output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

initial equation
  assert(h >= 0, "Hysteresis must not be negative");
  pre(y) = pre_y_start;
equation
  y = if h < 1E-10 then u > threshold else (not pre(y) and u > threshold or pre(y) and u >= threshold-h);

annotation (
  defaultComponentName="greThr",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-140},{150,-110}},
          lineColor={0,0,0},
          textString="%threshold"),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name"),
        Line(
          points={{-54,22},{-8,2},{-54,-18}},
          thickness=0.5),
        Text(extent={{-48,38},{57,78}},
          textString="%h",
          visible=h >= 1E-10,
          lineColor={0,0,0})}),
  Documentation(info="<html>
<p>
Block that outputs <code>true</code> if the Real input <code>u</code>
is greater than the parameter <code>threshold/code>, optionally within a hysteresis <code>h</code>.
</p>
<p>
The parameter <code>h</code> is used to specify a hysteresis.
If <i>h &gt; 0</i>, then the output switches to <code>true</code> if <i>u &gt; t</i>,
where <i>t</i> is the parameter <code>threshold</code>,
and it switches to <code>false</code> if <i>u &gt; t-h</i>.
</p>
<p>
Enabling hysteresis can avoid frequent switching.
Adding hysteresis is recommended in real controllers to guard against sensor noise, and
in simulation to guard against numerical noise. Numerical noise can be present if
an input depends on a state variable or a quantity that requires an iterative solution, such as
a temperature or a mass flow rate of an HVAC system.
To disable hysteresis, set <code>h=0</code>.
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
end GreaterThreshold;
