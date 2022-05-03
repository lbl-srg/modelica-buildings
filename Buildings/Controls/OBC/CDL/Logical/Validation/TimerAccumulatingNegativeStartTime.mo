within Buildings.Controls.OBC.CDL.Logical.Validation;
model TimerAccumulatingNegativeStartTime
  "Validation model for the timer that accumulates the time, with a negative start time"
  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating noThr
    "Accumulating timer that do not compare threshold"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating thrTim(
    final t=1)
    "Accumulating timer that compares threshold"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating noThrWitRes
    "Accumulating timer that could reset the output"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating thrTimWitRes(
    final t=1)
    "Accumulating timer that could reset the output and the output compares with threshold"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.5,
    final period=4,
    shift=-11)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse resTim(
    final width=0.5,
    final period=3.5,
    shift=-5)
    "Block that outputs cyclic on and off, for resetting timer"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));

equation
  connect(booPul.y,noThr.u)
    annotation (Line(points={{-58,40},{-40,40},{-40,20},{-22,20}},color={255,0,255}));
  connect(booPul.y,thrTim.u)
    annotation (Line(points={{-58,40},{-40,40},{-40,-20},{-22,-20}},color={255,0,255}));
  connect(con.y,noThr.reset)
    annotation (Line(points={{-58,-60},{-48,-60},{-48,12},{-22,12}},color={255,0,255}));
  connect(con.y,thrTim.reset)
    annotation (Line(points={{-58,-60},{-48,-60},{-48,-28},{-22,-28}},color={255,0,255}));
  connect(booPul.y,noThrWitRes.u)
    annotation (Line(points={{-58,40},{20,40},{20,20},{38,20}},color={255,0,255}));
  connect(booPul.y,thrTimWitRes.u)
    annotation (Line(points={{-58,40},{20,40},{20,-20},{38,-20}},color={255,0,255}));
  connect(resTim.y,noThrWitRes.reset)
    annotation (Line(points={{2,-60},{12,-60},{12,12},{38,12}},color={255,0,255}));
  connect(resTim.y,thrTimWitRes.reset)
    annotation (Line(points={{2,-60},{12,-60},{12,-28},{38,-28}},color={255,0,255}));
  annotation (
    experiment(
      StartTime=-10,
      StopTime=5,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/TimerAccumulatingNegativeStartTime.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TimerAccumulating\">
Buildings.Controls.OBC.CDL.Logical.TimerAccumulating</a>.
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
end TimerAccumulatingNegativeStartTime;
