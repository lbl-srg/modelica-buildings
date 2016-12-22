within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Feedback "Output difference between commanded and feedback input"

  Modelica.Blocks.Interfaces.RealInput u1
    annotation (Placement(transformation(extent={{-100,-20},{-60,20}})));
  Modelica.Blocks.Interfaces.RealInput u2 annotation (Placement(transformation(
        origin={0,-80},
        extent={{-20,-20},{20,20}},
        rotation=90)));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

equation
  y = u1 - u2;
  annotation (
    Documentation(info="<html>
<p>
This blocks computes output <code>y</code> as <i>difference</i> of the
commanded input <code>u1</code> and the feedback
input <code>u2</code>:
</p>
<pre>
    <code>y</code> = <code>u1</code> - <code>u2</code>;
</pre>
<p>
Example:
</p>
<pre>
     parameter:   n = 2

  results in the following equations:

     y = u1 - u2
</pre>

</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          lineColor={0,0,127},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid,
          extent={{-20,-20},{20,20}}),
        Line(points={{-60,0},{-20,0}}, color={0,0,127}),
        Line(points={{20,0},{80,0}}, color={0,0,127}),
        Line(points={{0,-20},{0,-60}}, color={0,0,127}),
        Text(extent={{-14,-94},{82,0}}, textString="-"),
        Text(
          lineColor={0,0,255},
          extent={{-150,44},{150,94}},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Ellipse(
            extent={{-20,20},{20,-20}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),Line(points={{-60,0},{-20,0}}, color={0,0,
          255}),Line(points={{20,0},{80,0}}, color={0,0,255}),Line(points={{0,
          -20},{0,-60}}, color={0,0,255}),Text(
            extent={{-12,10},{84,-84}},
            lineColor={0,0,0},
            textString="-")}));
end Feedback;
