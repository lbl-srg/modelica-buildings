within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Tan "Output the tangent of the input"
  extends Modelica.Blocks.Interfaces.SISO;

equation
  y = Modelica.Math.tan(u);
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{0,-80},{0,68}}, color={192,192,192}),
        Line(
          points={{-80,-80},{-78.4,-68.4},{-76.8,-59.7},{-74.4,-50},{-71.2,-40.9},
              {-67.1,-33},{-60.7,-24.8},{-51.1,-17.2},{-35.8,-9.98},{-4.42,-1.07},
              {33.4,9.12},{49.4,16.2},{59.1,23.2},{65.5,30.6},{70.4,39.1},{
              73.6,47.4},{76,56.1},{77.6,63.8},{80,80}},
          smooth=Smooth.Bezier),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,72},{-18,24}},
          lineColor={192,192,192},
          textString="tan")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{0,80},{-8,80}}, color={192,
          192,192}),Line(points={{0,-80},{-8,-80}}, color={192,192,192}),Line(
          points={{0,-88},{0,86}}, color={192,192,192}),Text(
            extent={{11,100},{38,80}},
            lineColor={160,160,164},
            textString="y"),Polygon(
            points={{0,102},{-6,86},{6,86},{0,102}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Text(
            extent={{-37,-72},{-17,-88}},
            textString="-5.8",
            lineColor={0,0,255}),Text(
            extent={{-33,86},{-13,70}},
            textString=" 5.8",
            lineColor={0,0,255}),Text(
            extent={{70,25},{90,5}},
            textString="1.4",
            lineColor={0,0,255}),Line(points={{-100,0},{84,0}}, color={192,
          192,192}),Polygon(
            points={{100,0},{84,6},{84,-6},{100,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-80,-80},{-78.4,-68.4},
          {-76.8,-59.7},{-74.4,-50},{-71.2,-40.9},{-67.1,-33},{-60.7,-24.8},{
          -51.1,-17.2},{-35.8,-9.98},{-4.42,-1.07},{33.4,9.12},{49.4,16.2},{
          59.1,23.2},{65.5,30.6},{70.4,39.1},{73.6,47.4},{76,56.1},{77.6,63.8},
          {80,80}}),Text(
            extent={{70,-6},{94,-26}},
            lineColor={160,160,164},
            textString="u")}),
    Documentation(info="<html>
<p>
This blocks computes the output <code>y</code>
as <code>tan</code> of the input <code>u</code>:
</p>
<pre>
    y = <code>tan</code>( u );
</pre>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/tan.png\"
     alt=\"tan.png\">
</p>

</html>"));
end Tan;
