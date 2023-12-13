within Buildings.Obsolete.Controls.OBC.CDL.Logical;
block Or3 "Logical 'or': y = u1 or u2 or u3"
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1
    "Connector of first Boolean input signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u2
    "Connector of second Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u3
    "Connector of third Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=u1 or u2 or u3;
  annotation (
    defaultComponentName="or3",
    obsolete = "This model is obsolete, use two blocks of Buildings.Controls.OBC.CDL.Logical.Or stacked together instead",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-90,40},{90,-40}},
          textColor={0,0,0},
          textString="or"),
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
        Ellipse(
          extent={{-73,-6},{-87,8}},
          lineColor=DynamicSelect({235,235,235},
            if u2 then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if u2 then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-73,-73},{-87,-87}},
          lineColor=DynamicSelect({235,235,235},
            if u3 then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if u3 then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-75,72},{-89,86}},
          lineColor=DynamicSelect({235,235,235},
            if u1 then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if u1 then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid)}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>true</code> if at least one input
is <code>true</code>.
Otherwise the output is <code>false</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 8, 2023, by Jianjun Hu:<br/>
Moved this model to the <code>Obsolete</code> package. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3595\">issue 3595</a>.
</li>
<li>
April 10, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Or3;
