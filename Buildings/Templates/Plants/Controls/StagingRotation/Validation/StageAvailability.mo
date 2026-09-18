within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model StageAvailability "Validation model for the evaluation of stage availability"
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaEqu(
    table=[0,0,0,0,0; 1,1,0,0,1; 2,0,1,0,1; 3,0,0,1,1; 4,1,1,0,1; 5,0,1,1,0; 6,1,
        1,1,0; 7,0,0,0,0],
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
  Buildings.Templates.Plants.Controls.StagingRotation.StageAvailability avaStaPhp(have_php=
        true, final staEqu=staPhp.staHea)
    "Compute stage availability – Two reversible HP and one polyvalent HP"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  PolyvalentHeatPumps.StagingParameters staPhp(nHp=2, nPhp=1)
    "Staging parameters for polyvalent plant"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable staOpp(
    table=[0,3; 3,0],
    timeScale=1,
    period=7) "Opposite mode (cooling) stage"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(u1AvaEqu.y[1:3], avaStaEqu.u1Ava)
    annotation (Line(points={{-58,0},{-20,0},{-20,20},{-12,20}},color={255,0,255}));
  connect(u1AvaEqu.y[1:3], avaStaOneTwo.u1Ava)
    annotation (Line(points={{-58,0},{-20,0},{-20,-20},{-12,-20}},color={255,0,255}));
  connect(u1AvaEqu.y, avaStaPhp.u1Ava) annotation (Line(points={{-58,0},{-20,0},
          {-20,60},{-12,60}},   color={255,0,255}));
  connect(staOpp.y[1], avaStaPhp.uStaOpp) annotation (Line(points={{-58,60},{
          -40,60},{-40,66},{-12,66}}, color={255,127,0}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/StageAvailability.mos"
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
