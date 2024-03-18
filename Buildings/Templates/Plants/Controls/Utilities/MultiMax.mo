within Buildings.Templates.Plants.Controls.Utilities;
block MultiMax
  "Output the maximum element of the input vector"
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
equation
  y=max(u);
  annotation (
    __cdl(
      extensionBlock=true),
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
Outputs the minimum element of the input array.
</p>
</html>"));
end MultiMax;
