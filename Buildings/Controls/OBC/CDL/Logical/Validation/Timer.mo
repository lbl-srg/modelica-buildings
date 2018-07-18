within Buildings.Controls.OBC.CDL.Logical.Validation;
model Timer "Validation model for the Timer block"

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
      width=0.5, period=2) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer resetTimer(reset=true)
    "Timer will reset"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer accuTimer(reset=false)
    "Timer will not reset"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

equation
  connect(booPul.y, resetTimer.u)
    annotation (Line(points={{-19,0},{18,0}}, color={255,0,255}));
  connect(booPul.y, accuTimer.u)
    annotation (Line(points={{-19,0},{0,0},{0,-40},{18,-40}}, color={255,0,255}));

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
