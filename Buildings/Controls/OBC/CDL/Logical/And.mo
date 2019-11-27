within Buildings.Controls.OBC.CDL.Logical;
block And "Logical 'and': y = u1 and u2"

  Interfaces.BooleanInput u1 "Connector of first Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.BooleanInput u2
    "Connector of second Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y = u1 and u2;

  annotation (
    defaultComponentName="and2",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={           Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
                              Text(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          textString="and"),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-75,-6},{-89,8}},
          lineColor=DynamicSelect({235,235,235}, if u1 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u1 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-75,-73},{-89,-87}},
          lineColor=DynamicSelect({235,235,235}, if u2 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u2 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}),
    Documentation(info="<html>
<p>
Block that outputs <code>true</code> if all inputs are <code>true</code>.
Otherwise the output is <code>false</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end And;
