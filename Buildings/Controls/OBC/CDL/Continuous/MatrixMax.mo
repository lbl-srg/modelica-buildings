within Buildings.Controls.OBC.CDL.Continuous;
block MatrixMax "Output vector of row- or column-wise maximum values"

  parameter Boolean rowMin = true "If true outputs row-wise maximum, otherwise column-wise";

  parameter Integer ninr(min=0) "Number or input matrix rows";

  parameter Integer ninc(min=0) "Number or input matrix columns";

  Interfaces.RealInput u[ninr, ninc] "Connector of Real input signals"
    annotation (Placement(
      transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y[if rowMin then size(u, 1) else size(u, 2)] "Connector of Real output signals"
    annotation (Placement(
      transformation(extent={{100,-10},{120,10}})));

equation
  if rowMin then
    y = {max(u[i,:]) for i in 1:size(u, 1)};
  else
    y = {max(u[:,i]) for i in 1:size(u, 2)};
  end if
  annotation (
    defaultComponentName="matMax",
    Documentation(info="<html>
<p>
This blocks computes output vector <code>y</code> as the row-wise or 
column-wise (depending on the <code>rowMin</code> value) maximum of the input 
matrix <code>u</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 11, 2019, by Milica Grahovac:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
                            Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),Text(
          extent={{-78,-62},{86,68}},
          lineColor={0,0,0},
          textString="[  ] max()")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
                              Text(
          extent={{-78,-62},{86,68}},
          lineColor={0,0,0},
          textString="[  ] max()")}));
end MatrixMax;
