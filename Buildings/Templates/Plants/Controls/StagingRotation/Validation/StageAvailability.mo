within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model StageAvailability "Validation model for the evaluation of stage availability"
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaEqu(
    table=[
      0, 0, 0, 0;
      1, 1, 0, 0;
      2, 0, 1, 0;
      3, 0, 0, 1;
      4, 1, 1, 0;
      5, 0, 1, 1;
      6, 1, 1, 1;
      7, 0, 0, 0],
    timeScale=1,
    period=7)
    "Equipment available signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Plants.Controls.StagingRotation.StageAvailability avaStaEqu(
    staEqu=[
      1 / 3, 1 / 3, 1 / 3;
      2 / 3, 2 / 3, 2 / 3;
      1, 1, 1])
    "Compute stage availability – Equally sized units"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Templates.Plants.Controls.StagingRotation.StageAvailability avaStaOneTwo(
    staEqu=[
      1, 0, 0;
      0, 1 / 2, 1 / 2;
      1, 1 / 2, 1 / 2;
      0, 1, 1;
      1, 1, 1])
    "Compute stage availability – One small equipment, two large equally sized equipment"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  connect(u1AvaEqu.y, avaStaEqu.u1Ava)
    annotation (Line(points={{-58,0},{-20,0},{-20,20},{-12,20}},color={255,0,255}));
  connect(u1AvaEqu.y, avaStaOneTwo.u1Ava)
    annotation (Line(points={{-58,0},{-20,0},{-20,-20},{-12,-20}},color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/StageAvailability.mos"
        "Simulate and plot"),
    experiment(
      StopTime=7.0,
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
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.StageAvailability\">
Buildings.Templates.Plants.Controls.StagingRotation.StageAvailability</a>
in a configuration with three equally sized units (component <code>avaStaEqu</code>) 
and in a configuration with one small unit and two large equally sized 
units (component <code>avaStaOneTwo</code>).
Only the units of the same size are lead/lag alternated.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StageAvailability;
