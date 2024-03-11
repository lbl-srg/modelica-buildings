within Buildings.Templates.Plants.Controls.Utilities;
block HoldValue
  "Hold a value based on timer and Boolean signal"
  parameter Real dtHol(
    final unit="s")=0
    "Hold time";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1
    "Boolean signal that triggers fixed output value"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Input signal"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between actual and fixed value"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol(
    final duration=dtHol)
    "Hold true value of input signal for given time"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(u, triSam.u)
    annotation (Line(points={{-120,-40},{-60,-40},{-60,40},{-12,40}},color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{92,0},{120,0}},color={0,0,127}));
  connect(u1, triSam.trigger)
    annotation (Line(points={{-120,0},{-40,0},{-40,20},{0,20},{0,28}},color={255,0,255}));
  connect(u1, truHol.u)
    annotation (Line(points={{-120,0},{-12,0}},color={255,0,255}));
  connect(truHol.y, swi.u2)
    annotation (Line(points={{12,0},{68,0}},color={255,0,255}));
  connect(triSam.y, swi.u1)
    annotation (Line(points={{12,40},{60,40},{60,8},{68,8}},color={0,0,127}));
  connect(u, swi.u3)
    annotation (Line(points={{-120,-40},{60,-40},{60,-8},{68,-8}},color={0,0,127}));
  annotation (
    defaultComponentName="hol",
    Icon(
      graphics={
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
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(
      info="<html>
<p>
Hold input value fixed at its last value while the Boolean signal <code>u1</code> 
is true, and for at least the hold time <code>dtHol</code>.
</p>
</html>"));
end HoldValue;
