within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Division "Output first input divided by second input"
  extends Modelica.Blocks.Interfaces.SI2SO;

equation
  y = u1/u2;
  annotation (
    Documentation(info="<html>
<p>
This block computes the output <b>y</b> (element-wise)
by <i>dividing</i> the corresponding elements of
the two inputs <b>u1</b> and <b>u2</b>:
</p>
<pre>
    y = u1 / u2;
</pre>

</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{50,0},{100,0}}, color={0,0,127}),
        Line(points={{-30,0},{30,0}}),
        Ellipse(fillPattern=FillPattern.Solid, extent={{-5,20},{5,30}}),
        Ellipse(fillPattern=FillPattern.Solid, extent={{-5,-30},{5,-20}}),
        Ellipse(lineColor={0,0,127}, extent={{-50,-50},{50,50}}),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Line(points={{-100,60},{-66,60},{-40,30}}, color={0,0,127}),
        Line(points={{-100,-60},{0,-60},{0,-50}}, color={0,0,127})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Line(points={{50,0},{100,0}},
          color={0,0,255}),Line(points={{-30,0},{30,0}}),
          Ellipse(
            extent={{-5,20},{5,30}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),Ellipse(
            extent={{-5,-20},{5,-30}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),Ellipse(extent={{-50,50},{50,-50}},
          lineColor={0,0,255}),Line(points={{-100,60},{-66,60},{-40,30}},
          color={0,0,255}),Line(points={{-100,-60},{0,-60},{0,-50}}, color={0,
          0,255})}));
end Division;
