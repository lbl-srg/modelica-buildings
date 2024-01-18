within Buildings.Templates.Plants.Components.Controls.Utilities;
block FirstTrueIndex
  parameter Integer nin(min=0)=0
    "Size of input array"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true), HideResult=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nin]
    "Array of Boolean signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Index of first element being true"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nin](final
      integerTrue={i for i in 1:nin}, each final integerFalse=nin + 1)
    "Return index if element is true, 0 otherwise"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Utilities.MultiMin mulMin(nin=nin) "Return minimum index"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{34,-50},{54,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=nin + 1)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zer(k=0)
    annotation (Placement(transformation(extent={{-12,50},{8,70}})));
equation
  connect(booToInt.y, mulMin.u)
    annotation (Line(points={{-38,0},{-12,0}},color={255,127,0}));
  connect(u1, booToInt.u)
    annotation (Line(points={{-120,0},{-62,0}}, color={255,0,255}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{12,-60},{20,-60},{20,
          -48},{32,-48}}, color={255,127,0}));
  connect(mulMin.y, intSwi.u3) annotation (Line(points={{12,0},{40,0},{40,-8},{
          68,-8}}, color={255,127,0}));
  connect(intEqu.y, intSwi.u2) annotation (Line(points={{56,-40},{60,-40},{60,0},
          {68,0}}, color={255,0,255}));
  connect(zer.y, intSwi.u1) annotation (Line(points={{10,60},{60,60},{60,8},{68,
          8}}, color={255,127,0}));
  connect(mulMin.y, intEqu.u1) annotation (Line(points={{12,0},{20,0},{20,-40},
          {32,-40}}, color={255,127,0}));
  connect(intSwi.y, y)
    annotation (Line(points={{92,0},{120,0}}, color={255,127,0}));
  annotation (
  defaultComponentName="idxFirTru",
  Documentation(info="<html>
<p>
Returns the index of the first <code>true</code> element of the Boolean 
input vector.
If no element is <code>true</code>, the block returns <i>0</i>.
</p>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}));
end FirstTrueIndex;
