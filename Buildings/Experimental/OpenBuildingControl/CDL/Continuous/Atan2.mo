within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Atan2 "Output atan(u1/u2) of the inputs u1 and u2"
  extends Modelica.Blocks.Interfaces.SI2SO;
equation
  y = Modelica.Math.atan2(u1, u2);
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{0,-80},{0,68}}, color={192,192,192}),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-34.9},{-46.1,-31.4},{-29.4,-27.1},{-18.3,-21.5},{-10.3,
              -14.5},{-2.03,-3.17},{7.97,11.6},{15.5,19.4},{24.3,25},{39,30},
              {62.1,33.5},{80,34.9}},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,45.1},{-45.9,48.7},{-29.1,52.9},{-18.1,58.6},{-10.2,
              65.8},{-1.82,77.2},{0,80}},
          smooth=Smooth.Bezier),
        Line(
          points={{0,-80},{8.93,-67.2},{17.1,-59.3},{27.3,-53.6},{42.1,-49.4},
              {69.9,-45.8},{80,-45.1}},
          smooth=Smooth.Bezier),
        Text(
          extent={{-90,-46},{-18,-94}},
          lineColor={192,192,192},
          textString="atan2")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{0,80},{-8,80}}, color={192,
          192,192}),Line(points={{0,-80},{-8,-80}}, color={192,192,192}),Line(
          points={{0,-90},{0,84}}, color={192,192,192}),Text(
            extent={{11,98},{42,78}},
            lineColor={160,160,164},
            textString="y"),Polygon(
            points={{0,100},{-6,84},{6,84},{0,100}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-100,0},{84,0}},
          color={192,192,192}),Polygon(
            points={{100,0},{84,6},{84,-6},{100,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{0,-80},{8.93,-67.2},
          {17.1,-59.3},{27.3,-53.6},{42.1,-49.4},{69.9,-45.8},{80,-45.1}}),Line(points={{-80,-34.9},{-46.1,-31.4},{-29.4,-27.1},
          {-18.3,-21.5},{-10.3,-14.5},{-2.03,-3.17},{7.97,11.6},{15.5,19.4},{
          24.3,25},{39,30},{62.1,33.5},{80,34.9}}),Line(points=
           {{-80,45.1},{-45.9,48.7},{-29.1,52.9},{-18.1,58.6},{-10.2,65.8},{-1.82,
          77.2},{0,80}}),Text(
            extent={{-30,89},{-10,70}},
            textString="pi",
            lineColor={0,0,255}),Text(
            extent={{-30,-69},{-10,-88}},
            textString="-pi",
            lineColor={0,0,255}),Text(
            extent={{-30,49},{-10,30}},
            textString="pi/2",
            lineColor={0,0,255}),Line(points={{0,40},{-8,40}}, color={192,192,
          192}),Line(points={{0,-40},{-8,-40}}, color={192,192,192}),Text(
            extent={{-30,-31},{-10,-50}},
            textString="-pi/2",
            lineColor={0,0,255}),Text(
            extent={{48,0},{100,-34}},
            lineColor={160,160,164},
            textString="u1 / u2")}),
    Documentation(info="<html>
<p>
This blocks computes the output <code>y</code> as the
<i>tangent-inverse</i> of the input <code>u1</code> divided by
input <code>u2</code>:
</p>
<pre>
    y = <code>atan2</code>( u1, u2 );
</pre>
<p>
u1 and u2 shall not be zero at the same time instant.
<code>Atan2</code> uses the sign of u1 and u2 in order to construct
the solution in the range -180 deg &le; y &le; 180 deg, whereas
block <code>Atan</code> gives a solution in the range
-90 deg &le; y &le; 90 deg.
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/atan2.png\"
     alt=\"atan2.png\">
</p>

</html>"));
end Atan2;
