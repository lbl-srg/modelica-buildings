within Buildings.ChillerWSE.BaseClasses;
block Sign "Output the sign of the input"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real threshold
    "Threshold for signal changes";
  parameter Real u1 "If u>threshold then y=u1";
  parameter Real u2 "If u<=threshold then y=u2";

equation
  //y = sign(u);
  y = if noEvent(u > threshold) then 1 else 0;
  annotation (
    defaultComponentName="sign",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{0,-80}}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{0,-80},{0,68}}, color={192,192,192}),
        Text(
          extent={{-90,72},{-18,24}},
          lineColor={192,192,192},
          textString="sign"),
        Line(points={{0,80},{80,80}}),
        Rectangle(
          extent={{-2,2},{2,-4}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{-90,0},{68,0}}, color={192,
          192,192}),Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-80,-80},{0,-80}}),Line(points={{-0.01,0},{0.01,0}}),
          Line(points={{0,80},{80,80}}),Rectangle(
            extent={{-2,2},{2,-4}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),Polygon(
            points={{0,100},{-6,84},{6,84},{0,100}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{0,-90},{0,84}},
          color={192,192,192}),Text(
            extent={{7,102},{32,82}},
            lineColor={160,160,164},
            textString="y"),Text(
            extent={{70,-6},{94,-26}},
            lineColor={160,160,164},
            textString="u"),Text(
            extent={{-25,86},{-5,70}},
            textString="1",
            lineColor={0,0,255}),Text(
            extent={{5,-72},{25,-88}},
            textString="-1",
            lineColor={0,0,255})}),
    Documentation(info="<html>
<p>
This blocks computes the output <b>y</b>
as <b>sign</b> of the input <b>u</b>:
</p>
<pre>
         u1  <b>if</b> u &gt; threshold
     y =  
         u2  <b>if</b> u &le; threshold
</pre>
</html>", revisions="<html>
<ul>
<li>
August 28, 2017, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>"));
end Sign;
