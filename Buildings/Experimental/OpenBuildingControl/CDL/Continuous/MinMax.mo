within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block MinMax
  "Output the minimum and the maximum element of the input vector"

  parameter Integer nin(min=0) = 0 "Number of input connections"
    annotation (Dialog(connectorSizing=true), HideResult=true);
  Interfaces.RealInput u[nin]
    annotation (Placement(transformation(extent={{-140,20},{-100,-20}})));
  Interfaces.RealOutput yMax
    annotation (Placement(
        transformation(extent={{100,50},{120,70}})));
  Interfaces.RealOutput yMin
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
equation
  yMax = max(u);
  yMin = min(u);
  annotation (Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),        Text(
          extent={{-12,80},{100,40}},
          lineColor={0,0,0},
          textString="yMax"), Text(
          extent={{-10,-40},{100,-80}},
          lineColor={0,0,0},
          textString="yMin"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}),Documentation(info="<html>
<p>
Determines the minimum and maximum element of the input vector and
provide both values as output.
</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end MinMax;
