within Buildings.Controls.OBC.CDL.Logical;
block Switch "Switch between two Real signals"

  Interfaces.RealInput u1 "Connector of first Real input signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Interfaces.BooleanInput u2 "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealInput u3 "Connector of second Real input signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = if u2 then u1 else u3;
  annotation (
    defaultComponentName="swi",
    Documentation(info="<html>
<p>
Block that represents a logical switch.
</p>
<p>
If the input <code>u2</code> is <code>true</code>,
the block outputs the input <code>u1</code>.
Otherwise it outputs the input <code>u3</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
                                         Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Line(points={{12.0,0.0},{100.0,0.0}},
          color={0,0,127}),
        Line(points={{-100.0,0.0},{-40.0,0.0}},
          color={255,0,255}),
        Line(points={{-100.0,-80.0},{-40.0,-80.0},{-40.0,-80.0}},
          color={0,0,127}),
        Line(points={{-40.0,12.0},{-40.0,-12.0}},
          color={255,0,255}),
        Line(points={{-100.0,80.0},{-38.0,80.0}},
          color={0,0,127}),
        Line(points={{-38.0,80.0},{6.0,2.0}},
          color={0,0,127},
          thickness=1.0),
        Ellipse(lineColor={0,0,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{2.0,-8.0},{18.0,8.0}}),
        Ellipse(
          extent={{-71,7},{-85,-7}},
          lineColor=DynamicSelect({235,235,235}, if u2 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u2 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name")}));
end Switch;
