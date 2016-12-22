within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Abs "Output the absolute value of the input"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Boolean generateEvent=false
    "Choose whether events shall be generated" annotation (Evaluate=true);
equation
  //y = abs(u);
  y = if generateEvent then (if u >= 0 then u else -u) else (if noEvent(u >=
    0) then u else -u);
  annotation (
    defaultComponentName="abs1",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Polygon(
          points={{92,0},{70,8},{70,-8},{92,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,80},{0,0},{80,80}}),
        Line(points={{0,-14},{0,68}}, color={192,192,192}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-34,-28},{38,-76}},
          lineColor={192,192,192},
          textString="abs"),
        Line(points={{-88,0},{76,0}}, color={192,192,192})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{-100,0},{76,0}}, color={192,
          192,192}),Polygon(
            points={{92,0},{76,6},{76,-6},{92,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-80,80},{0,0},{80,80}}),Line(points={{0,-80},{0,68}}, color={192,192,192}),
          Polygon(
            points={{0,90},{-8,68},{8,68},{0,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{0,-80},{0,68}},
          color={192,192,192}),Polygon(
            points={{0,90},{-8,68},{8,68},{0,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Text(
            extent={{7,98},{34,78}},
            lineColor={160,160,164},
            textString="u"),Text(
            extent={{74,-8},{96,-28}},
            lineColor={160,160,164},
            textString="y"),Text(
            extent={{52,-3},{72,-23}},
            textString="1",
            lineColor={0,0,255}),Text(
            extent={{-86,-1},{-66,-21}},
            textString="-1",
            lineColor={0,0,255}),Text(
            extent={{-28,79},{-8,59}},
            textString="1",
            lineColor={0,0,255})}),
    Documentation(info="<html>
<p>
This blocks computes the output <b>y</b>
as <i>absolute value</i> of the input <b>u</b>:
</p>
<pre>
    y = <b>abs</b>( u );
</pre>
<p>
The Boolean parameter generateEvent decides whether Events are generated at zero crossing (Modelica specification before 3) or not.
</p>
</html>"));
end Abs;
