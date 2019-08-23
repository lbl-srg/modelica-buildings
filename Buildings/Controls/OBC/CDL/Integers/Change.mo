within Buildings.Controls.OBC.CDL.Integers;
block Change
  "Output whether the Integer input changes values, increases or decreases"
  parameter Boolean y_start = false
    "Initial value of y";

  Interfaces.IntegerInput u "Connector of Integer input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Interfaces.BooleanOutput up
    "Connector of Boolean output signal indicating input increase"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Interfaces.BooleanOutput down
    "Connector of Boolean output signal indicating input decrease"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));

protected
  Integer u_start = 0 "Initial value of input";

initial equation
   pre(y) = y_start;
   pre(u) = u_start;

equation
  y = change(u);
  up = u > pre(u);
  down = u < pre(u);

annotation (defaultComponentName="cha",
Icon(coordinateSystem(preserveAspectRatio=true), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-50,62},{50,-56}},
          lineColor={255,127,0},
          textString="change"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}),
Documentation(info="<html>
<p>
Block that evaluates the integer input <code>u</code> to check if its value
changes.
</p>
<ul>
<li>
When the input <code>u</code> changes, the output <code>y</code> will be
<code>true</code>, otherwise it will be <code>false</code>.
</li>
<li>
When the input <code>u</code> increases, the output <code>up</code> will be
<code>true</code>, otherwise it will be <code>false</code>.
</li>
<li>
When the input <code>u</code> decreases, the output <code>down</code> will be
<code>true</code>, otherwise it will be <code>false</code>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
July 18, 2018, by Michael Wetter:<br/>
Revised model and icon.
</li>
<li>
July 13, 2018, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Change;
