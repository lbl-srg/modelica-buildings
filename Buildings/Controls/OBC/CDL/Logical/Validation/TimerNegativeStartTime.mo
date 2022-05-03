within Buildings.Controls.OBC.CDL.Logical.Validation;
model TimerNegativeStartTime
  "Validation model for the Timer block with a negative start time"
  Buildings.Controls.OBC.CDL.Logical.Timer noThr
    "Timer that do not compare threshold"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer thrTim(
    final t=0.3)
    "Timer that compares threshold"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.7,
    final period=2,
    shift=-5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

equation
  connect(booPul.y,noThr.u)
    annotation (Line(points={{-18,20},{18,20}},color={255,0,255}));
  connect(booPul.y,thrTim.u)
    annotation (Line(points={{-18,20},{0,20},{0,-20},{18,-20}},color={255,0,255}));
  annotation (
    experiment(
      StartTime=-10,
      StopTime=5,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/TimerNegativeStartTime.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Timer\">
Buildings.Controls.OBC.CDL.Logical.Timer</a>.
</p>
</html>",
      revisions="<html>
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
end TimerNegativeStartTime;
