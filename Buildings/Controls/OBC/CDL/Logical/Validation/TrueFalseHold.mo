within Buildings.Controls.OBC.CDL.Logical.Validation;
model TrueFalseHold
  "Validation model for the TrueFalseHold block"
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    shift=0,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    shift=0,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    shift=0,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol2(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    shift=0,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol3(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Negation of input signal"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Negation of input signal"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    shift=100,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol4(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul5(
    shift=100,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol5(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul6(
    shift=100,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol6(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul7(
    shift=100,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol7(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Negation of input signal"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Negation of input signal"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul8(
    shift=0,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol8(
    trueHoldDuration=1000,
    falseHoldDuration=0)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5
    "Negation of input signal"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul9(
    shift=0,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol9(
    trueHoldDuration=0,
    falseHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not6
    "Negation of input signal"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul10(
    shift=0,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol10(
    trueHoldDuration=0,
    falseHoldDuration=0)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not7
    "Negation of input signal"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
equation
  connect(booPul.y,truFalHol.u)
    annotation (Line(points={{-118,100},{-42,100}},        color={255,0,255}));
  connect(booPul1.y,truFalHol1.u)
    annotation (Line(points={{-118,60},{-42,60}},color={255,0,255}));
  connect(booPul2.y,not1.u)
    annotation (Line(points={{-118,20},{-92,20}},  color={255,0,255}));
  connect(not1.y,truFalHol2.u)
    annotation (Line(points={{-68,20},{-42,20}},  color={255,0,255}));
  connect(booPul3.y,not3.u)
    annotation (Line(points={{-118,-20},{-92,-20}},color={255,0,255}));
  connect(not3.y,truFalHol3.u)
    annotation (Line(points={{-68,-20},{-42,-20}},color={255,0,255}));
  connect(booPul4.y,truFalHol4.u)
    annotation (Line(points={{42,100},{118,100}}, color={255,0,255}));
  connect(booPul5.y,truFalHol5.u)
    annotation (Line(points={{42,60},{118,60}},color={255,0,255}));
  connect(booPul6.y,not2.u)
    annotation (Line(points={{42,20},{68,20}},  color={255,0,255}));
  connect(not2.y,truFalHol6.u)
    annotation (Line(points={{92,20},{118,20}},  color={255,0,255}));
  connect(booPul7.y,not4.u)
    annotation (Line(points={{42,-20},{68,-20}},color={255,0,255}));
  connect(not4.y,truFalHol7.u)
    annotation (Line(points={{92,-20},{118,-20}},color={255,0,255}));
  connect(booPul8.y,not5.u)
    annotation (Line(points={{-118,-60},{-92,-60}},color={255,0,255}));
  connect(not5.y,truFalHol8.u)
    annotation (Line(points={{-68,-60},{-42,-60}},color={255,0,255}));
  connect(booPul9.y,not6.u)
    annotation (Line(points={{42,-60},{68,-60}},   color={255,0,255}));
  connect(not6.y,truFalHol9.u)
    annotation (Line(points={{92,-60},{118,-60}}, color={255,0,255}));
  connect(booPul10.y, not7.u)
    annotation (Line(points={{-118,-100},{-92,-100}}, color={255,0,255}));
  connect(not7.y, truFalHol10.u)
    annotation (Line(points={{-68,-100},{-42,-100}}, color={255,0,255}));
  annotation (
    experiment(
      StopTime=7200.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/TrueFalseHold.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TrueFalseHold\">
Buildings.Controls.OBC.CDL.Logical.TrueFalseHold</a>.
</p>
<p>
The validation uses different instances to validate different hold trueHoldDurations, different lengths
of the input pulse, and different initial values for the input signal.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 14, 2017, by Michael Wetter:<br/>
Added more tests for different initial signals and different hold values.
</li>
<li>
May 24, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-160,-120},{160,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end TrueFalseHold;
