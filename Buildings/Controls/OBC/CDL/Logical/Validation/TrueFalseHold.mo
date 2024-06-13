within Buildings.Controls.OBC.CDL.Logical.Validation;
model TrueFalseHold
  "Validation model for the TrueFalseHold block"
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    shift=0,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    shift=0,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    shift=0,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol2(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    shift=0,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol3(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Negation of input signal"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Negation of input signal"
    annotation (Placement(transformation(extent={{-90,-130},{-70,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    shift=100,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol4(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul5(
    shift=100,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol5(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul6(
    shift=100,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol6(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul7(
    shift=100,
    period=1000,
    width=0.25)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol7(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Negation of input signal"
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Negation of input signal"
    annotation (Placement(transformation(extent={{70,-130},{90,-110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold tru0FalHol(
    trueHoldDuration=0,
    falseHoldDuration=1000)
    "Case with 0 true hold duration"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truHolFal0(
    trueHoldDuration=1000,
    falseHoldDuration=0)
    "Case with 0 false hold duration"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold tru0Fal0(
    trueHoldDuration=0)
    "Case with 0 hold duration"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
equation
  connect(booPul.y, truFalHol.u)
    annotation (Line(points={{-118,0},{-42,0}},color={255,0,255}));
  connect(booPul1.y, truFalHol1.u)
    annotation (Line(points={{-118,-40},{-42,-40}},color={255,0,255}));
  connect(booPul2.y, not1.u)
    annotation (Line(points={{-118,-80},{-92,-80}},color={255,0,255}));
  connect(not1.y, truFalHol2.u)
    annotation (Line(points={{-68,-80},{-42,-80}},color={255,0,255}));
  connect(booPul3.y, not3.u)
    annotation (Line(points={{-118,-120},{-92,-120}},color={255,0,255}));
  connect(not3.y, truFalHol3.u)
    annotation (Line(points={{-68,-120},{-42,-120}},color={255,0,255}));
  connect(booPul4.y, truFalHol4.u)
    annotation (Line(points={{42,0},{118,0}},color={255,0,255}));
  connect(booPul5.y, truFalHol5.u)
    annotation (Line(points={{42,-40},{118,-40}},color={255,0,255}));
  connect(booPul6.y, not2.u)
    annotation (Line(points={{42,-80},{68,-80}},color={255,0,255}));
  connect(not2.y, truFalHol6.u)
    annotation (Line(points={{92,-80},{118,-80}},color={255,0,255}));
  connect(booPul7.y, not4.u)
    annotation (Line(points={{42,-120},{68,-120}},color={255,0,255}));
  connect(not4.y, truFalHol7.u)
    annotation (Line(points={{92,-120},{118,-120}},color={255,0,255}));
  connect(booPul.y, tru0FalHol.u)
    annotation (Line(points={{-118,0},{-80,0},{-80,120},{-42,120}},color={255,0,255}));
  connect(booPul.y, truHolFal0.u)
    annotation (Line(points={{-118,0},{-80,0},{-80,80},{-42,80}},color={255,0,255}));
  connect(booPul.y, tru0Fal0.u)
    annotation (Line(points={{-118,0},{-80,0},{-80,40},{-42,40}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=7200.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/TrueFalseHold.mos"
        "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TrueFalseHold\">
Buildings.Controls.OBC.CDL.Logical.TrueFalseHold</a>.
</p>
<p>
The validation uses different instances to validate different hold durations, 
different lengths of the input pulse, and different initial values for the input signal.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 6, 2024, by Antoine Gautier:<br/>
Added more tests for zero hold durations.
</li>
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
        extent={{-160,-160},{160,160}})),
    Icon(
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
