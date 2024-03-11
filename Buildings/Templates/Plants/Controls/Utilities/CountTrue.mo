within Buildings.Templates.Plants.Controls.Utilities;
block CountTrue
  "Output the number of true elements in a Boolean array"
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
    each final integerTrue=1,
    each final integerFalse=0)
    "Cast to integer"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sumMul(
    final nin=nin)
    "Sum over array elements"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(u1, booToInt.u)
    annotation (Line(points={{-120,0},{-42,0}},color={255,0,255}));
  connect(sumMul.y, y)
    annotation (Line(points={{42,0},{120,0}},color={255,127,0}));
  connect(booToInt.y, sumMul.u)
    annotation (Line(points={{-18,0},{18,0}},color={255,127,0}));
  annotation (
    defaultComponentName="couTru",
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
end CountTrue;
