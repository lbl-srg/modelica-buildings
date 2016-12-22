within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Exp "Output the exponential (base e) of the input"
  extends Modelica.Blocks.Interfaces.SISO;

equation
  y = Modelica.Math.exp(u);
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{0,-80},{0,68}}, color={192,192,192}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-86,50},{-14,2}},
          lineColor={192,192,192},
          textString="exp"),
        Line(points={{-80,-80},{-31,-77.9},{-6.03,-74},{10.9,-68.4},{23.7,-61},
              {34.2,-51.6},{43,-40.3},{50.3,-27.8},{56.7,-13.5},{62.3,2.23},{
              67.1,18.6},{72,38.2},{76,57.6},{80,80}}),
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192},
          smooth=Smooth.Bezier),
        Polygon(
          points={{90,-80.3976},{68,-72.3976},{68,-88.3976},{90,-80.3976}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{0,80},{-8,80}}, color={192,
          192,192}),Line(points={{0,-80},{-8,-80}}, color={192,192,192}),Line(
          points={{0,-90},{0,84}}, color={192,192,192}),Text(
            extent={{9,100},{40,80}},
            lineColor={160,160,164},
            textString="y"),Polygon(
            points={{0,100},{-6,84},{6,84},{0,100}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-100,-80.3976},{84,-80.3976}},
          color={192,192,192}),Polygon(
            points={{100,-80.3976},{84,-74.3976},{84,-86.3976},{100,-80.3976}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-80,-80},{-31,-77.9},
          {-6.03,-74},{10.9,-68.4},{23.7,-61},{34.2,-51.6},{43,-40.3},{50.3,-27.8},
          {56.7,-13.5},{62.3,2.23},{67.1,18.6},{72,38.2},{76,57.6},{80,80}}),Text(
            extent={{-31,72},{-11,88}},
            textString="20",
            lineColor={0,0,255}),Text(
            extent={{-92,-83},{-72,-103}},
            textString="-3",
            lineColor={0,0,255}),Text(
            extent={{70,-83},{90,-103}},
            textString="3",
            lineColor={0,0,255}),Text(
            extent={{-18,-53},{2,-73}},
            textString="1",
            lineColor={0,0,255}),Text(
            extent={{66,-52},{96,-72}},
            lineColor={160,160,164},
            textString="u")}),
    Documentation(info="<html>
<p>
This blocks computes the output <b>y</b> as the
<i>exponential</i> (of base e) of the input <b>u</b>:
</p>
<pre>
    y = <b>exp</b>( u );
</pre>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/exp.png\"
     alt=\"exp.png\">
</p>

</html>"));
end Exp;
