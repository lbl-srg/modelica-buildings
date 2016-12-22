within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Cos "Output the cosine of the input"
  extends Modelica.Blocks.Interfaces.SISO;

equation
  y = Modelica.Math.cos(u);
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-80,68}}, color={192,192,192}),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,80},{-74.4,78.1},{-68.7,72.3},{-63.1,63},{-56.7,48.7},
              {-48.6,26.6},{-29.3,-32.5},{-22.1,-51.7},{-15.7,-65.3},{-10.1,-73.8},
              {-4.42,-78.8},{1.21,-79.9},{6.83,-77.1},{12.5,-70.6},{18.1,-60.6},
              {24.5,-45.7},{32.6,-23},{50.3,31.3},{57.5,50.7},{63.9,64.6},{
              69.5,73.4},{75.2,78.6},{80,80}},
          smooth=Smooth.Bezier),
        Text(
          extent={{-36,82},{36,34}},
          lineColor={192,192,192},
          textString="cos")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{-80,80},{-88,80}}, color={192,
          192,192}),Line(points={{-80,-80},{-88,-80}}, color={192,192,192}),
          Line(points={{-80,-90},{-80,84}}, color={192,192,192}),Text(
            extent={{-75,102},{-48,82}},
            lineColor={160,160,164},
            textString="y"),Polygon(
            points={{-80,100},{-86,84},{-74,84},{-80,100}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Text(
            extent={{-103,72},{-83,88}},
            textString="1",
            lineColor={0,0,255}),Text(
            extent={{-79,-72},{-59,-88}},
            textString="-1",
            lineColor={0,0,255}),Text(
            extent={{70,25},{90,5}},
            textString="2*pi",
            lineColor={0,0,255}),Line(points={{-100,0},{84,0}}, color={192,
          192,192}),Polygon(
            points={{100,0},{84,6},{84,-6},{100,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-80,80},{-74.4,78.1},
          {-68.7,72.3},{-63.1,63},{-56.7,48.7},{-48.6,26.6},{-29.3,-32.5},{-22.1,
          -51.7},{-15.7,-65.3},{-10.1,-73.8},{-4.42,-78.8},{1.21,-79.9},{6.83,
          -77.1},{12.5,-70.6},{18.1,-60.6},{24.5,-45.7},{32.6,-23},{50.3,31.3},
          {57.5,50.7},{63.9,64.6},{69.5,73.4},{75.2,78.6},{80,80}}, color={0,
          0,0}),Text(
            extent={{74,-4},{98,-24}},
            lineColor={160,160,164},
            textString="u")}),
    Documentation(info="<html>
<p>
This blocks computes the output <b>y</b>
as <b>cos</b> of the input <b>u</b>:
</p>
<pre>
    y = <b>cos</b>( u );
</pre>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/cos.png\"
     alt=\"cos.png\">
</p>

</html>"));
end Cos;
