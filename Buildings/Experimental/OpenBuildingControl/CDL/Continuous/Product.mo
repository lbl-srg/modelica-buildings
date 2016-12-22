within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Product "Output product of the two inputs"
  extends Modelica.Blocks.Interfaces.SI2SO;

equation
  y = u1*u2;
  annotation (
    Documentation(info="<html>
<p>
This blocks computes the output <b>y</b> (element-wise)
as <i>product</i> of the corresponding elements of
the two inputs <b>u1</b> and <b>u2</b>:
</p>
<pre>
    y = u1 * u2;
</pre>

</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-100,60},{-40,60},{-30,40}}, color={0,0,127}),
        Line(points={{-100,-60},{-40,-60},{-30,-40}}, color={0,0,127}),
        Line(points={{50,0},{100,0}}, color={0,0,127}),
        Line(points={{-30,0},{30,0}}),
        Line(points={{-15,25.99},{15,-25.99}}),
        Line(points={{-15,-25.99},{15,25.99}}),
        Ellipse(lineColor={0,0,127}, extent={{-50,-50},{50,50}})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Line(points={{-100,60},{-40,60},{-30,
          40}}, color={0,0,255}),Line(points={{-100,-60},{-40,-60},{-30,-40}},
          color={0,0,255}),Line(points={{50,0},{100,0}}, color={0,0,255}),
          Line(points={{-30,0},{30,0}}),Line(points={{-15,
          25.99},{15,-25.99}}),Line(points={{-15,-25.99},{15,
          25.99}}),Ellipse(extent={{-50,50},{50,-50}},
          lineColor={0,0,255})}));
end Product;
