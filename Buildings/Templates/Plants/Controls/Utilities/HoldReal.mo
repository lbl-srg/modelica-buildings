within Buildings.Templates.Plants.Controls.Utilities;
block HoldReal "Hold value of real signal based on timer and Boolean signal"
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
    "Sample signal when the Boolean input switches to true"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between actual and fixed value"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truHol(
    final falseHoldDuration=0, final trueHoldDuration=dtHol) if dtHol > 0
    "Hold true value of input signal for given time"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  PlaceholderLogical ph(have_inp=dtHol > 0, final have_inpPh=true)
    "Placeholder signal in case of zero minimum hold time"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
equation
  connect(u, triSam.u)
    annotation (Line(points={{-120,-40},{-60,-40},{-60,60},{-12,60}},color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{92,0},{120,0}},color={0,0,127}));
  connect(u1, triSam.trigger)
    annotation (Line(points={{-120,0},{-40,0},{-40,40},{0,40},{0,48}},color={255,0,255}));
  connect(u1, truHol.u)
    annotation (Line(points={{-120,0},{-40,0},{-40,20},{-12,20}},
                                               color={255,0,255}));
  connect(triSam.y, swi.u1)
    annotation (Line(points={{12,60},{60,60},{60,8},{68,8}},color={0,0,127}));
  connect(u, swi.u3)
    annotation (Line(points={{-120,-40},{60,-40},{60,-8},{68,-8}},color={0,0,127}));
  connect(truHol.y, ph.u) annotation (Line(points={{12,20},{20,20},{20,0},{28,0}},
        color={255,0,255}));
  connect(u1, ph.uPh) annotation (Line(points={{-120,0},{-40,0},{-40,-6},{28,-6}},
        color={255,0,255}));
  connect(ph.y, swi.u2)
    annotation (Line(points={{52,0},{68,0}}, color={255,0,255}));
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
Holds input value fixed at its last value while the Boolean signal
<code>u1</code> is true, and for at least the hold time <code>dtHol</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end HoldReal;
