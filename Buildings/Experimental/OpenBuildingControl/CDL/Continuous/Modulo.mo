within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Modulo
  "Output the remainder of first input divided by second input (~=0)"

  Interfaces.RealInput u1 "Connector of Real input signal 1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Interfaces.RealInput u2 "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-8},{120,12}}),
        iconTransformation(extent={{100,-8},{120,12}})));

equation
  y = mod(u1/u2);

  annotation (
    defaultComponentName="modulo",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-32,-52},{40,-100}},
          lineColor={192,192,192},
          textString="mod"),
        Ellipse(lineColor={0,0,127}, extent={{-50,-48},{50,52}}),
        Ellipse(fillPattern=FillPattern.Solid, extent={{13,14},{23,24}}),
        Line(points={{-2,2},{40,2}}),
        Ellipse(fillPattern=FillPattern.Solid, extent={{13,-18},{23,-8}}),
        Ellipse(lineColor={0,0,127}, extent={{-34,14},{-16,32}},
          lineThickness=1),
        Ellipse(lineColor={0,0,127}, extent={{-26,-24},{-8,-6}},
          lineThickness=1),
        Line(
          points={{0,26},{-42,-20}},
          color={0,0,127},
          thickness=1),
        Line(points={{-8,16}}, color={0,0,0}),
        Line(
          points={{-100,60}},
          color={0,0,0},
          thickness=1),
        Line(points={{-100,60},{-28,60},{-12,50}}, color={0,0,127}),
        Line(points={{-100,-60},{-26,-60},{-2,-48}}, color={0,0,127}),
        Line(points={{50,2},{102,2},{100,2}}, color={0,0,127})}),
    Documentation(info="<html>
<p>
Block that outputs <code>y = mod(u1/u2)</code>,
where
<code>u1</code> and <code>u2<code> are inputs.
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Modulo;
