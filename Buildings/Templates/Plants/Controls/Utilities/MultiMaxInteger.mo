within Buildings.Templates.Plants.Controls.Utilities;
block MultiMaxInteger "Output the maximum element of the input vector"
  parameter Integer nin(
    min=0)=0
    "Size of input array"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u[nin]
    "Integer input signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Integer output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nin]
    "Cast to real type"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax mulMax(nin=nin) "Return max value"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Cast back to integer type"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(u,intToRea. u)
    annotation (Line(points={{-120,0},{-82,0}}, color={255,127,0}));
  connect(intToRea.y,mulMax. u)
    annotation (Line(points={{-58,0},{-42,0}}, color={0,0,127}));
  connect(reaToInt.y, y)
    annotation (Line(points={{22,0},{120,0}}, color={255,127,0}));
  connect(mulMax.y,reaToInt. u)
    annotation (Line(points={{-18,0},{-2,0}}, color={0,0,127}));
  annotation (
    defaultComponentName="mulMax",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-90,36},{90,-36}},
          textColor={160,160,164},
          textString="max()"),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
Outputs the maximum element of the input vector.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2026, by Antoine Gautier:<br/>
Refactored using CDL Elementary Blocks.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultiMaxInteger;
