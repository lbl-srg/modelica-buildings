within Buildings.Templates.Plants.Controls.Utilities;
block LastTrueIndex
  parameter Integer nin(
    min=0)=0
    "Size of input array"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nin]
    "Array of Boolean signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Index of first element being true"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nin](
    final integerTrue={i for i in 1:nin},
    each final integerFalse=0)
    "Return index if element is true, 0 otherwise"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Templates.Plants.Controls.Utilities.MultiMaxInteger mulMax(nin=nin)
    "Return minimum index"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(booToInt.y, mulMax.u)
    annotation (Line(points={{-38,0},{-12,0}},color={255,127,0}));
  connect(u1, booToInt.u)
    annotation (Line(points={{-120,0},{-62,0}},color={255,0,255}));
  connect(mulMax.y, y)
    annotation (Line(points={{12,0},{120,0}},color={255,127,0}));
  annotation (
    defaultComponentName="idxLasTru",
    Documentation(
      info="<html>
<p>
Returns the index of the last <code>true</code> element of the Boolean
input vector.
If no element is <code>true</code>, the block returns <i>0</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
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
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}));
end LastTrueIndex;
