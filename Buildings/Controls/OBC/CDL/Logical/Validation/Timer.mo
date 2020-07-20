within Buildings.Controls.OBC.CDL.Logical.Validation;
model Timer "Validation model for the Timer block"

  Buildings.Controls.OBC.CDL.Logical.Timer resetTimer "Timer will reset"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer accuTimer(
    final accumulate=true)
    "Reset timer based on boolean input"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer accuTimer1(
    final accumulate=true)
    "Reset timer based on boolean input"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer accuTimer2(
    final accumulate=true)
    "Reset timer based on boolean input"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer accuTimer3(
    final accumulate=true)
    "Reset timer based on boolean input"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.1,
    final period=4)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=1.5)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.5,
    final period=2) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.5,
    final period=2,
    final startTime=0.5)  "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

equation
  connect(booPul.y, resetTimer.u)
    annotation (Line(points={{-18,80},{18,80}}, color={255,0,255}));
  connect(booPul.y, accuTimer.u)
    annotation (Line(points={{-18,80},{0,80},{0,40},{18,40}},
      color={255,0,255}));
  connect(booPul1.y, accuTimer.reset)
    annotation (Line(points={{-18,40},{-10,40},{-10,32},{18,32}},color={255,0,255}));
  connect(booPul.y,accuTimer3. u)
    annotation (Line(points={{-18,80},{0,80},{0,-70},{18,-70}},
      color={255,0,255}));
  connect(accuTimer3.y, greEquThr.u)
    annotation (Line(points={{42,-70},{60,-70},{60,-90},{-92,-90},{-92,-70},
      {-82,-70}}, color={0,0,127}));
  connect(greEquThr.y, pre.u)
    annotation (Line(points={{-58,-70},{-42,-70}}, color={255,0,255}));
  connect(pre.y,accuTimer3. reset)
    annotation (Line(points={{-18,-70},{-10,-70},{-10,-78},{18,-78}},
      color={255,0,255}));
  connect(booPul.y, accuTimer1.u)
    annotation (Line(points={{-18,80},{0,80},{0,0},{18,0}}, color={255,0,255}));
  connect(booPul.y, accuTimer1.reset)
    annotation (Line(points={{-18,80},{0,80},{0,-8},{18,-8}}, color={255,0,255}));
  connect(booPul.y, accuTimer2.reset)
    annotation (Line(points={{-18,80},{0,80},{0,-48},{18,-48}}, color={255,0,255}));
  connect(booPul2.y, accuTimer2.u)
    annotation (Line(points={{-18,-40},{18,-40}}, color={255,0,255}));

annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/Timer.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Timer\">
Buildings.Controls.OBC.CDL.Logical.Timer</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 23, 2018, by Jianjun Hu:<br/>
Updated implementation to reset accumulate timer with boolean input.
</li>
<li>
July 18, 2018, by Jianjun Hu:<br/>
Updated implementation to include accumulate timer.
</li>
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
end Timer;
