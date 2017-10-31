within Buildings.Controls.OBC.CDL.Continuous;
block ChangeSign "Change sign of the input"

  Interfaces.RealInput u "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

equation
  y = -u;

annotation (
  defaultComponentName="chaSig",
  Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Line(points={{2,68},{2,-80}},     color={192,192,192}),
        Polygon(
          points={{2,90},{-6,68},{10,68},{2,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{82,0}},     color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{2,-60},{100,-60}}),
        Line(
          points={{-100,60}},
          color={0,0,127},
          thickness=1),
        Line(points={{-100,60},{2,60}}, color={0,0,0})}),
    Documentation(info="<html>
<p>
Block that outputs <code>y = -u</code>,
where <code>u</code> is an input.
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
end ChangeSign;
