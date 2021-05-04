within Buildings.Controls.OBC.CDL.Logical;
block LogicalSwitch
  "Switch between two boolean signals"
  Interfaces.BooleanInput u1
    "Boolean input signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Interfaces.BooleanInput u2
    "Boolean switch input signal, if true, y=u1, else y=u3"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanInput u3
    "Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Interfaces.BooleanOutput y
    "Booelan output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=
    if u2 then
      u1
    else
      u3;
  annotation (
    defaultComponentName="logSwi",
    Documentation(
      info="<html>
<p>
Block that outputs one of two boolean input signals based on a boolean input signal.
</p>
<p>
If the input signal <code>u2</code> is <code>true</code>,
the block outputs <code>y = u1</code>.
Otherwise, it outputs <code>y = u3</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 17, 2020, by Jianjun Hu:<br/>
Changed icon to display dynamically which input signal is being outputted.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2033\"># 2033</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
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
        Line(
          points={{12,0},{100,0}},
          color={255,0,255}),
        Line(
          points={{-100,0},{-40,0}},
          color={255,0,255}),
        Line(
          points={{-100,-80},{-40,-80},{-40,-80}},
          color={255,0,255}),
        Line(
          points={{-40,12},{-40,-10}},
          color={255,0,255}),
        Line(
          points={{-100,80},{-40,80}},
          color={255,0,255}),
        Line(
          points=DynamicSelect({{8,2},{-40,80}},{{8,2},
            if u2 then
              {-40,80}
            else
              {-40,-80}}),
          color={255,0,255},
          thickness=1),
        Ellipse(
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{2.0,-6.0},{18.0,8.0}}),
        Ellipse(
          extent={{-71,7},{-85,-7}},
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
          extent={{-71,74},{-85,88}},
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
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-71,-74},{-85,-88}},
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
          extent={{-90,76},{-46,50}},
          lineColor=DynamicSelect({0,0,0},
            if u2 then
              {0,0,0}
            else
              {235,235,235}),
          textString="true"),
        Text(
          extent={{-90,-42},{-38,-72}},
          lineColor=DynamicSelect({0,0,0},
            if u2 then
              {235,235,235}
            else
              {0,0,0}),
          textString="false"),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name")}));
end LogicalSwitch;
