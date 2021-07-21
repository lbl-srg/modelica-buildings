within Buildings.Controls.OBC.CDL.Continuous;
block MatrixMax
  "Output vector of row- or column-wise maximum of the input matrix"
  parameter Boolean rowMax=true
    "If true, outputs row-wise maximum, otherwise column-wise";
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
    if rowMax then
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
  if rowMax then
    y={max(u[i,:]) for i in 1:size(u,1)};
  else
    y={max(u[:,i]) for i in 1:size(u,2)};
  end if;
  annotation (
    defaultComponentName="matMax",
    Documentation(
      info="<html>
<p>
If <code>rowMax = true</code>, this block outputs the row-wise maximum
of the input matrix <code>u</code>,
otherwise it outputs the column-wise maximum of the input matrix <code>u</code>.
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
          lineColor={0,0,255}),
        Text(
          extent={{-78,-62},{86,68}},
          lineColor={0,0,0},
          textString="[  ] max()")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}})));
end MatrixMax;
