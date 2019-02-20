within Buildings.Controls.OBC.CDL.Continuous;
block MultiMax "Output the maximum element of the input vector"

  parameter Integer nin(min=0) = 0 "Number of input connections"
    annotation (Dialog(connectorSizing=true), HideResult=true);
  Interfaces.RealInput u[nin]
    annotation (Placement(transformation(extent={{-140,20},{-100,-20}})));
  Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
equation
  y = max(u);

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
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
          Text(
            extent={{-90,36},{90,-36}},
            lineColor={160,160,164},
            textString="max()")}),
                                 Documentation(info="<html>
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
