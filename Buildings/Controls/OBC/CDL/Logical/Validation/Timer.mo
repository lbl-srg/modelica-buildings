within Buildings.Controls.OBC.CDL.Logical.Validation;
model Timer "Validation model for the Timer block"

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    width=0.5, period=2) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Logical.Timer resetTimer(reset=true)
    "Timer will reset"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Logical.Timer accuTimer(reset=false)
    "Reset timer based on boolean input"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(width=0.1, period=4)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Logical.Timer accuTimer1(reset=false)
    "Reset timer based on boolean input"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(threshold=
       1.5)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

equation
  connect(booPul.y, resetTimer.u)
    annotation (Line(points={{-19,70},{18,70}}, color={255,0,255}));
  connect(booPul.y, accuTimer.u)
    annotation (Line(points={{-19,70},{0,70},{0,30},{18,30}},
      color={255,0,255}));
  connect(booPul1.y, accuTimer.u0)
    annotation (Line(points={{-19,30},{-6,30},{-6,22},{18,22}},
      color={255,0,255}));
  connect(booPul.y, accuTimer1.u)
    annotation (Line(points={{-19,70},{0,70},{0,-10},{18,-10}},
      color={255,0,255}));
  connect(accuTimer1.y, greEquThr.u)
    annotation (Line(points={{41,-10},{60,-10},{60,-30},{-92,-30},{-92,-50},
    {-82,-50}}, color={0,0,127}));
  connect(greEquThr.y, pre.u)
    annotation (Line(points={{-59,-50},{-42,-50}}, color={255,0,255}));
  connect(pre.y, accuTimer1.u0)
    annotation (Line(points={{-19,-50},{0,-50},{0,-18},{18,-18}},
      color={255,0,255}));

annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
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
Update implementation to reset accumulate timer with boolean input.
</li>
<li>
July 18, 2018, by Jianjun Hu:<br/>
Update implementation to include accumulate timer.
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
