within Buildings.Controls.OBC.CDL.Reals;
block Switch
  "Switch between two Real signals"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1
    "Real input signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u2
    "Boolean switch input signal, if true, y=u1, else y=u3"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u3
    "Real input signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=smooth(0, if u2 then u1 else u3);
  annotation (
    defaultComponentName="swi",
    Documentation(
      info="<html>
<p>
Block that outputs one of two real input signals based on a boolean input signal.
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
February 27, 2023, by Michael Wetter:<br/>
Added <code>smoothOrder(0, ...)</code> as Dymola 2023x assumes <code>y</code> to be
smooth, and simulations can then fail if it differentiated this output.
</li>
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
          points={{12.0,0.0},{100.0,0.0}},
          color={0,0,127}),
        Line(
          points={{-100.0,0.0},{-40.0,0.0}},
          color={255,0,255}),
        Line(
          points={{-100.0,-80.0},{-40.0,-80.0},{-40.0,-80.0}},
          color={0,0,127}),
        Line(
          points={{-40.0,12.0},{-40.0,-12.0}},
          color={255,0,255}),
        Line(
          points={{-100.0,80.0},{-40.0,80.0}},
          color={0,0,127}),
        Line(
          points=DynamicSelect({{10,0},{-40,80}},{{10,0},
            if u2 then
              {-40,80}
            else
              {-40,-80}}),
          color={0,0,127},
          thickness=1.0),
        Ellipse(
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{2.0,-8.0},{18.0,8.0}}),
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
        Text(
          extent={{-90,80},{-46,54}},
          textColor=DynamicSelect({0,0,0},
            if u2 then
              {0,0,0}
            else
              {235,235,235}),
          textString="true"),
        Text(
          extent={{-90,-46},{-38,-76}},
          textColor=DynamicSelect({0,0,0},
            if u2 then
              {235,235,235}
            else
              {0,0,0}),
          textString="false"),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name")}));
end Switch;
