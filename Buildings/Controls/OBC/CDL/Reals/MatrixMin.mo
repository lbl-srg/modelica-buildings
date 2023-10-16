within Buildings.Controls.OBC.CDL.Reals;
block MatrixMin
  "Output vector of row- or column-wise minimum values"
  parameter Boolean rowMin=true
    "If true, outputs row-wise minimum, otherwise column-wise";
  parameter Integer nRow(
    final min=1)
    "Number of rows in input matrix";
  parameter Integer nCol(
    final min=1)
    "Number of columns in input matrix";
  Interfaces.RealInput u[nRow,nCol]
    "Connector of Real input signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y[
    if rowMin then
      size(
        u,
        1)
    else
      size(
        u,
        2)]
    "Connector of Real output signals"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  if rowMin then
    y={min(u[i,:]) for i in 1:size(u,1)};
  else
    y={min(u[:,i]) for i in 1:size(u,2)};
  end if;
  annotation (
    defaultComponentName="matMin",
    Documentation(
      info="<html>
<p>
If <code>rowMin = true</code>, this block outputs the row-wise minimum
of the input matrix <code>u</code>,
otherwise it outputs the column-wise minimum of the input matrix <code>u</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 17, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
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
          textColor={0,0,255}),
        Text(
          extent={{-78,-62},{86,68}},
          textColor={0,0,0},
          textString="[  ] min()")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}})));
end MatrixMin;
