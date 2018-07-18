within Buildings.Controls.OBC.CDL.Integers;
block Change
  "Check if the Integer input changes value, if it increases or decrease"
  parameter Boolean y_start = false
    "Initial value of y";

  Interfaces.IntegerInput u "Connector of Integer input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput yCha "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Interfaces.BooleanOutput yUp
    "Connector of Boolean output signal indicating input increase"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Interfaces.BooleanOutput yDow
    "Connector of Boolean output signal indicating input decrease"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
      iconTransformation(extent={{100,-70},{120,-50}})));

protected
  Integer u_start = 0 "Initial value of input";

initial equation
   pre(yCha) = y_start;
   pre(u) = u_start;

equation
  yCha = change(u);
  yUp = u > pre(u);
  yDow = u < pre(u);

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
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor={235,235,235},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}),
Diagram(coordinateSystem(preserveAspectRatio=true)),
Documentation(info="<html>
<p>
Block that evaluates the integer input <code>u</code> to check if its value 
changes. 
</p>
<ul>
<li>
When there is input value change, output <code>yCha</code> will be
<code>true</code>, otherwise it outputs <code>false</code>. 
</li>
<li>
When input <code>u</code> increases its value, output <code>yUp</code> will be 
<code>true</code>, otherwise it outputs <code>false</code>.
</li>
<li>
When input <code>u</code> decreases its value, output <code>yDow</code> will be 
<code>true</code>, otherwise it outputs <code>false</code>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
July 13, 2018, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Change;
