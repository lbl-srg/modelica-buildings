within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model StageCompletion "Validation model for the evaluation of stage completion"
  Buildings.Templates.Plants.Controls.StagingRotation.StageCompletion comSta(
    nin=2)
    "Check successful completion of stage change"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTab(
    table=[
      0, 0, 0, 0, 0;
      1, 0, 0, 0, 0;
      3, 1, 0, 0, 0;
      6, 1, 0, 1, 0;
      21, 1, 0, 1, 0;
      22, 0, 0, 1, 0;
      24, 0, 0, 0, 0],
    timeScale=60,
    period=1800)
    "Source for Boolean signals"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold y1ComSta(
    final falseHoldDuration=0, trueHoldDuration=1)
    "Hold stage completion signal for plotting"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable idxSta(
    table=[
      0, 0;
      1, 1;
      21, 0],
    timeScale=60,
    period=1800)
    "Stage index"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(comSta.y1End, y1ComSta.u)
    annotation (Line(points={{42,6},{50,6},{50,0},{58,0}},color={255,0,255}));
  connect(booTimTab.y[1:2], comSta.u1[1:2])
    annotation (Line(points={{-58,0},{18,0},{18,0.5}},color={255,0,255}));
  connect(booTimTab.y[3:4], comSta.u1_actual[1:2])
    annotation (Line(points={{-58,0},{0,0},{0,-4},{18,-4},{18,-3.5}},color={255,0,255}));
  connect(idxSta.y[1], comSta.uSta)
    annotation (Line(points={{-58,40},{0,40},{0,4},{18,4}},color={255,127,0}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/StageCompletion.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1800.0,
      Tolerance=1e-06),
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.StageCompletion\">
Buildings.Templates.Plants.Controls.StagingRotation.StageCompletion</a>
in a configuration with one small unit and two large equally sized
units (component <code>avaStaOneTwo</code>).
In response to a varying flow rate, the variation of the
required capacity <code>chaSta.capReq.y</code> triggers stage change
events.
The block
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.StageIndex\">
Buildings.Templates.Plants.Controls.Utilities.StageIndex</a>
is used to illustrate how these events translate into
a varying plant stage index <code>idxSta.y</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StageCompletion;
