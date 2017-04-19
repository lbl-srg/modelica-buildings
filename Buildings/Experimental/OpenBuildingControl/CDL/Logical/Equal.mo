within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block Equal "Output y is true, if input u1 is equal to input u2"

  Interfaces.RealInput u1 "Connector of first Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealInput u2
    "Connector of second Real input signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  if (u1>(u2-1E-15)) and (u1<(u2+1E-15)) then y = true;
  else y = false;
  end if;

  annotation (
    defaultComponentName="equ",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={           Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{32,10},{52,-10}}, lineColor={0,0,127}),
        Line(points={{-100,-80},{42,-80},{42,0}}, color={0,0,127}),
        Line(
          points={{-60,10},{0,10}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-60,-14},{0,-14}},
          color={0,0,0},
          thickness=0.5)}),
    Documentation(info="<html>
<p>
Block that outputs <code>true</code> if
the inputs <code>u1</code> and <code>u2</code> are equal.
</p>
</html>", revisions="<html>
<ul>
<li>
March 24, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Equal;
