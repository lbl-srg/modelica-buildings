within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Sin "Output the sine of the input"
  extends Modelica.Blocks.Interfaces.SISO;
equation
  y = Modelica.Math.sin(u);
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
        Line(
          points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,74.6},
              {-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,59.4},
              {-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,-64.2},
              {29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},{
              57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}},
          smooth=Smooth.Bezier),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{12,84},{84,36}},
          lineColor={192,192,192},
          textString="sin")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{-80,80},{-88,80}}, color={192,
          192,192}),Line(points={{-80,-80},{-88,-80}}, color={192,192,192}),
          Line(points={{-80,-90},{-80,84}}, color={192,192,192}),Text(
            extent={{-75,98},{-46,78}},
            lineColor={160,160,164},
            textString="y"),Polygon(
            points={{-80,96},{-86,80},{-74,80},{-80,96}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-100,0},{84,0}},
          color={192,192,192}),Polygon(
            points={{100,0},{84,6},{84,-6},{100,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-80,0},{-68.7,34.2},
          {-61.5,53.1},{-55.1,66.4},{-49.4,74.6},{-43.8,79.1},{-38.2,79.8},{-32.6,
          76.6},{-26.9,69.7},{-21.3,59.4},{-14.9,44.1},{-6.83,21.2},{10.1,-30.8},
          {17.3,-50.2},{23.7,-64.2},{29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,
          -77.6},{51.9,-71.5},{57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}}),Text(
            extent={{-105,72},{-85,88}},
            textString="1",
            lineColor={0,0,255}),Text(
            extent={{70,25},{90,5}},
            textString="2*pi",
            lineColor={0,0,255}),Text(
            extent={{-105,-72},{-85,-88}},
            textString="-1",
            lineColor={0,0,255}),Text(
            extent={{76,-10},{98,-30}},
            lineColor={160,160,164},
            textString="u")}),
    Documentation(info="<html>
<p>
This blocks computes the output <code>y</code>
as <code>sine</code> of the input <code>u</code>:
</p>
<pre>
    y = <code>sin</code>( u );
</pre>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/sin.png\"
     alt=\"sin.png\">
</p>

</html>"));
end Sin;
