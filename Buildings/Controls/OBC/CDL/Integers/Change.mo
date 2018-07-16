within Buildings.Controls.OBC.CDL.Integers;
block Change
  "Output y is true, if there is change on integer input u"
  parameter Boolean y_start = false
    "Initial value of y";

  Interfaces.IntegerInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Integer u_start = 0 "Initial value of input";

initial equation
   pre(y) = y_start;
   pre(u) = u_start;

equation
  y = change(u);

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
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}),
Diagram(coordinateSystem(preserveAspectRatio=true)),
Documentation(info="<html>
<p>
Block that outputs <code>true</code> if there if the
integer input <code>u</code> changes its value.
Otherwise the output is <code>false</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 13, 2018, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Change;
