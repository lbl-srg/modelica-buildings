within Buildings.Controls.OBC.CDL.Continuous;
block MultiMax "Output the maximum element of the input vector"

  parameter Integer nin(min=0) = 0 "Number of input connections"
    annotation (Dialog(connectorSizing=true), HideResult=true);
  Interfaces.RealInput u[nin]
    annotation (Placement(transformation(extent={{-140,20},{-100,-20}})));
  Interfaces.RealOutput yMax
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
equation
  yMax = max(u);

annotation (Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Text(
          extent={{-12,20},{100,-20}},
          lineColor={0,0,0},
          textString="yMax"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}),Documentation(info="<html>
<p>
Outputs the maximum element of the input vector.
</p>
</html>", revisions="<html>
<ul>
<li>
September 14, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end MultiMax;
