within Buildings.Controls.OBC.CDL.Logical.Validation;
model TrueDelay "Validation model for the TrueDelay block"

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    width=0.5, period=1.5) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay(delayTime=0)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay1(delayTime=0.5)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay2(delayTime=0.8)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay4(delayTime=0)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay5(delayTime=0.5)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay6(delayTime=0.8)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Negation of input signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay3(delayTime=1.8)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay7(delayTime=1.8)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

equation
  connect(booPul.y, not1.u)
    annotation (Line(points={{-79,0},{-70,0},{-70,-20},{-62,-20}},
      color={255,0,255}));
  connect(booPul.y, onDelay.u)
    annotation (Line(points={{-79,0},{-20,0},{-20,50},{-2,50}},
      color={255,0,255}));
  connect(booPul.y, onDelay2.u)
    annotation (Line(points={{-79,0},{-20,0},{-20,20},{-2,20}},
      color={255,0,255}));
  connect(booPul.y, onDelay1.u)
    annotation (Line(points={{-79,0},{40,0},{40,50},{58,50}},
      color={255,0,255}));
  connect(booPul.y, onDelay3.u)
    annotation (Line(points={{-79,0},{40,0},{40,20},{58,20}},
      color={255,0,255}));
  connect(not1.y, onDelay4.u)
    annotation (Line(points={{-39,-20},{-20,-20},{-20,-40},{-2,-40}},
      color={255,0,255}));
  connect(not1.y, onDelay6.u)
    annotation (Line(points={{-39,-20},{-20,-20},{-20,-70},{-2,-70}},
      color={255,0,255}));
  connect(not1.y, onDelay5.u)
    annotation (Line(points={{-39,-20},{40,-20},{40,-40},{58,-40}},
      color={255,0,255}));
  connect(not1.y, onDelay7.u)
    annotation (Line(points={{-39,-20},{40,-20},{40,-70}, {58,-70}},
      color={255,0,255}));

annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/TrueDelay.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TrueDelay\">
Buildings.Controls.OBC.CDL.Logical.TrueDelay</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 2, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"),
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
end TrueDelay;
