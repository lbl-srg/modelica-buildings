within Buildings.Controls.OBC.CDL.Logical;
block FallingEdge
  "Output y is true, if the input u has a falling edge (y = edge(not u))"

  Interfaces.BooleanInput u
    "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Boolean not_u=not u
    "Boolean not of the input";

initial equation
  pre(not_u)=not u;

equation
  y=edge(not_u);
  annotation (
    defaultComponentName="falEdg",
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
          extent={{-62,64},{56,-54}},
          textColor={0,0,0},
          textString="falling"),
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
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(
      info="<html>
<p>
Block that outputs  <code>true</code> if the Boolean input has a falling edge
from <code>true</code> to <code>false</code>.
Otherwise the output is <code>false</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 3, 2022, by Michael Wetter:<br/>
Removed non-needed parameter <code>pre_u_start</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2990\">#2990</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end FallingEdge;
