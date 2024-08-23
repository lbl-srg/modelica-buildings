within Buildings.Controls.OBC.CDL.Logical.Validation;
model TrueFalseHold_test "Validation model for the TrueFalseHold block"
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    shift=100,
    period=1500)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol4(
    trueHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol8(trueHoldDuration=
        0, falseHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol9(trueHoldDuration=
        0, falseHoldDuration=1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(trueHoldDuration=
        1000, falseHoldDuration=0)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol2(trueHoldDuration=
        1000)
    "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
equation
  connect(booPul4.y,truFalHol4.u)
    annotation (Line(points={{-38,0},{-20,0},{-20,-40},{38,-40}},
                                               color={255,0,255}));
  connect(booPul4.y, truFalHol8.u)
    annotation (Line(points={{-38,0},{38,0}}, color={255,0,255}));
  connect(booPul4.y, edg.u) annotation (Line(points={{-38,0},{-20,0},{-20,40},{
          -2,40}}, color={255,0,255}));
  connect(edg.y, truFalHol9.u)
    annotation (Line(points={{22,40},{38,40}}, color={255,0,255}));
  connect(edg.y, truFalHol1.u) annotation (Line(points={{22,40},{26,40},{26,80},
          {38,80}}, color={255,0,255}));
  connect(edg.y, truFalHol2.u) annotation (Line(points={{22,40},{26,40},{26,120},
          {38,120}}, color={255,0,255}));
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
        extent={{-160,-100},{160,100}})),
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
end TrueFalseHold_test;
