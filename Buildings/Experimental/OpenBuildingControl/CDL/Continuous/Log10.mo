within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Log10 "Output the base 10 logarithm of the input (input > 0 required)"

  extends Modelica.Blocks.Interfaces.SISO;
equation
  y = Modelica.Math.log10(u);
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Line(
          points={{-79.8,-80},{-79.2,-50.6},{-78.4,-37},{-77.6,-28},{-76.8,-21.3},
              {-75.2,-11.4},{-72.8,-1.31},{-69.5,8.08},{-64.7,17.9},{-57.5,28},
              {-47,38.1},{-31.8,48.1},{-10.1,58},{22.1,68},{68.7,78.1},{80,80}},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-80,68}}, color={192,192,192}),
        Text(
          extent={{-30,-22},{60,-70}},
          lineColor={192,192,192},
          textString="log10")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{-80,80},{-88,80}}, color={192,
          192,192}),Line(points={{-80,-80},{-88,-80}}, color={192,192,192}),
          Line(points={{-80,-90},{-80,84}}, color={192,192,192}),Text(
            extent={{-65,96},{-38,78}},
            lineColor={160,160,164},
            textString="y"),Polygon(
            points={{-80,100},{-86,84},{-74,84},{-80,100}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-100,0},{84,0}},
          color={192,192,192}),Polygon(
            points={{100,0},{84,6},{84,-6},{100,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-79.8,-80},{-79.2,-50.6},
          {-78.4,-37},{-77.6,-28},{-76.8,-21.3},{-75.2,-11.4},{-72.8,-1.31},{
          -69.5,8.08},{-64.7,17.9},{-57.5,28},{-47,38.1},{-31.8,48.1},{-10.1,
          58},{22.1,68},{68.7,78.1},{80,80}}),Text(
            extent={{70,-3},{90,-23}},
            textString="20",
            lineColor={0,0,255}),Text(
            extent={{-78,-1},{-58,-21}},
            textString="1",
            lineColor={0,0,255}),Text(
            extent={{-109,72},{-89,88}},
            textString=" 1.3",
            lineColor={0,0,255}),Text(
            extent={{-109,-88},{-89,-72}},
            textString="-1.3",
            lineColor={0,0,255}),Text(
            extent={{62,30},{90,10}},
            lineColor={160,160,164},
            textString="u")}),
    Documentation(info="<html>
<p>
This blocks computes the output <b>y</b> as the
<i>base 10 logarithm</i> of the input <b>u</b>:
</p>
<pre>
    y = <b>log10</b>( u );
</pre>
<p>
An error occurs if the elements of the input <b>u</b> are
zero or negative.
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/log10.png\"
     alt=\"log10.png\">
</p>

</html>"));
end Log10;
