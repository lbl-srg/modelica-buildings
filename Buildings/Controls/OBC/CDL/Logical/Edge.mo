within Buildings.Controls.OBC.CDL.Logical;
block Edge
  "Output y is true, if the input u has a rising edge (y = edge(u))"
  parameter Boolean pre_u_start=false
    "Start value of pre(u) at initial time";
  Interfaces.BooleanInput u
    "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

initial equation
  pre(u)=pre_u_start;

equation
  y=edge(u);
  annotation (
    defaultComponentName="edg",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-50,52},{50,-46}},
          lineColor={0,0,0},
          textString="edge"),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-120,140},{-120,140}},
          lineColor={28,108,200}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>true</code> if the Boolean input has a rising edge
from <code>false</code> to <code>true</code>.
Otherwise the output is <code>false</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Edge;
