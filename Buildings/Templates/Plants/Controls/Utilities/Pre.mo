within Buildings.Templates.Plants.Controls.Utilities;
block Pre
  "Breaks algebraic loops by an infinitesimal small time delay (y = pre(u): event iteration continues until u = pre(u))"
  parameter Integer pre_u_start=0
    "Start value of pre(u) at initial time";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u
    "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
initial equation
  pre(u)=pre_u_start;
equation
  y=pre(u);
  annotation (
    defaultComponentName="pre",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,40},{90,-40}},
          textColor={160,160,164},
          textString="pre"),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name")}),
    Documentation(
      info="<html>
<p>
This block delays the Boolean input by an infinitesimal small time delay and
therefore breaks algebraic loops. In a network of logical blocks, in every
<i>closed connection loop</i>, at least one logical block must have a delay,
since algebraic systems of Boolean equations are not solvable.
</p>

<p>
This block returns the value of the input signal <code>u</code> from the
last event iteration. The event iteration stops once both
values are identical, i.e., if <code>u = pre(u)</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 24, 2017, by Milica Grahovac:<br/>
First CDL implementation.
</li>
</ul>
</html>"));
end Pre;
