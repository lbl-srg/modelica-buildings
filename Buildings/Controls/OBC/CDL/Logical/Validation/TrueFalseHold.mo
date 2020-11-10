within Buildings.Controls.OBC.CDL.Logical.Validation;
model TrueFalseHold "Validation model for the TrueFalseHold block"

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
      delay=0, period=1500) "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    delay=0,
    period=1000,
    width=0.25) "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
      delay=0, period=1500) "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol2(trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    delay=0,
    period=1000,
    width=0.25) "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol3(trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Negation of input signal"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Negation of input signal"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    delay=100,
    period=1500) "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol4(trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul5(
    delay=100,
    period=1000,
    width=0.25) "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol5(trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul6(
    delay=100,
    period=1500) "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol6(trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul7(
    delay=100,
    period=1000,
    width=0.25) "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol7(trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Negation of input signal"
    annotation (Placement(transformation(extent={{70,-20},{90,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Negation of input signal"
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));
equation
  connect(booPul.y, truFalHol.u)
    annotation (Line(points={{-118,70},{-118,70},{-42,70}},
                                                      color={255,0,255}));
  connect(booPul1.y, truFalHol1.u)
    annotation (Line(points={{-118,30},{-42,30}},   color={255,0,255}));
  connect(booPul2.y, not1.u)
    annotation (Line(points={{-118,-10},{-92,-10}}, color={255,0,255}));
  connect(not1.y, truFalHol2.u)
    annotation (Line(points={{-68,-10},{-42,-10}},   color={255,0,255}));
  connect(booPul3.y, not3.u)
    annotation (Line(points={{-118,-50},{-92,-50}}, color={255,0,255}));
  connect(not3.y, truFalHol3.u)
    annotation (Line(points={{-68,-50},{-42,-50}},   color={255,0,255}));
  connect(booPul4.y, truFalHol4.u)
    annotation (Line(points={{42,70},{118,70}},   color={255,0,255}));
  connect(booPul5.y, truFalHol5.u)
    annotation (Line(points={{42,30},{118,30}},   color={255,0,255}));
  connect(booPul6.y, not2.u)
    annotation (Line(points={{42,-10},{68,-10}}, color={255,0,255}));
  connect(not2.y, truFalHol6.u)
    annotation (Line(points={{92,-10},{118,-10}},   color={255,0,255}));
  connect(booPul7.y, not4.u)
    annotation (Line(points={{42,-50},{68,-50}}, color={255,0,255}));
  connect(not4.y, truFalHol7.u)
    annotation (Line(points={{92,-50},{118,-50}},   color={255,0,255}));
  annotation (
  experiment(StopTime=7200.0, Tolerance=1e-06),
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/TrueFalseHold.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TrueFalseHold\">
Buildings.Controls.OBC.CDL.Logical.TrueFalseHold</a>.
</p>
<p>
The validation uses different instances to validate different hold trueHoldDurations, different lengths
of the input pulse, and different initial values for the input signal.
</p>
</html>", revisions="<html>
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
    Diagram(coordinateSystem(extent={{-160,-100},{160,100}})),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end TrueFalseHold;
