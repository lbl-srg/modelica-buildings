within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block LogicalSwitch "Logical Switch"

  Modelica.Blocks.Interfaces.BooleanInput u1 "Connector of first Boolean input signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.BooleanInput u2 "Connector of second Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.BooleanInput u3 "Connector of third Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = if u2 then u1 else u3;
  annotation (Documentation(info="<html>
<p>The LogicalSwitch switches, depending on the
Boolean u2 connector (the middle connector),
between the two possible input signals
u1 (upper connector) and u3 (lower connector).</p>
<p>If u2 is true, connector y is set equal to
u1, else it is set equal to u3.</p>
</html>"),
         Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
          graphics={                     Rectangle(
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
        Line(points={{-40,12},{-40,-10}}, color={255,0,255}),
        Line(points={{-100,80},{-40,80}}, color={255,0,255}),
        Line(
          points={{-40,80},{8,2}},
          color={255,0,255},
          thickness=1),
        Ellipse(lineColor={0,0,127},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{2.0,-6.0},{18.0,8.0}}),
        Ellipse(
          extent={{-71,7},{-85,-7}},
          lineColor=DynamicSelect({235,235,235}, if u2 > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u2 > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-71,74},{-85,88}},
          lineColor=DynamicSelect({235,235,235}, if u1 > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u1 > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-71,-74},{-85,-88}},
          lineColor=DynamicSelect({235,235,235}, if u3 > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u3 > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid)}));
end LogicalSwitch;
