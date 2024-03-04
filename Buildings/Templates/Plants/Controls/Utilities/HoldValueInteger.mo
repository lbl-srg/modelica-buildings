within Buildings.Templates.Plants.Controls.Utilities;
block HoldValueInteger "Hold a value based on Boolean input signal"
  parameter Real dtHol_max(final unit="s")=0
    "Maximum hold duration";
  parameter Real y_start=0
    "Initial value of output signal";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1
    "Boolean signal that triggers fixed output value"
    annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}),   iconTransformation(
          extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Rel
    "Boolean signal that releases hold"
    annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}),  iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput
                                                  u "Input signal" annotation (
      Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput
                                                   y "Output signal" annotation (
     Placement(transformation(extent={{100,-20},{140,20}}),iconTransformation(
          extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert back to integer"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert to real"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  HoldValue hol(final dtHol_max=dtHol_max, final y_start=y_start)
    "Hold real value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(u, intToRea.u)
    annotation (Line(points={{-120,-40},{-82,-40}}, color={255,127,0}));
  connect(reaToInt.y, y)
    annotation (Line(points={{82,0},{120,0}}, color={255,127,0}));
  connect(hol.y, reaToInt.u)
    annotation (Line(points={{12,0},{58,0}}, color={0,0,127}));
  connect(u1Rel, hol.u1Rel)
    annotation (Line(points={{-120,0},{-12,0}}, color={255,0,255}));
  connect(u1, hol.u1) annotation (Line(points={{-120,40},{-20,40},{-20,6},{-12,
          6}}, color={255,0,255}));
  connect(intToRea.y, hol.u) annotation (Line(points={{-58,-40},{-20,-40},{-20,
          -6},{-12,-6}}, color={0,0,127}));
  annotation (
  DefaultComponentName="hol",
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
          textColor={0,0,255})}),
  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HoldValueInteger;
