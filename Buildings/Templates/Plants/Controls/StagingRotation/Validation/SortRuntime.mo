within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model SortRuntime "Validation model for equipment runtime sorting logic"
  Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime sorRunTim(nin=3)
    "Sort runtime"
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Utilities.TrueArrayConditional u1Ena(
    nin=3)
    "Equipment enable signal"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaEqu(
    table=[0,1,1,1; 1500,0,1,1; 2500,0,1,0; 3000,1,1,1],
    timeScale=1,
    period=5000)
    "Equipment available signal"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));
  Utilities.StageIndex idxSta(
    nSta=3,
    dtRun=60)
    annotation (Placement(transformation(extent={{-28,30},{-8,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Lea(
    k=true)
    "Lead equipment enable signal"
    annotation (Placement(transformation(extent={{-130,90},{-110,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger upPul(
    period=60)
    "Stage up command pulse"
    annotation (Placement(transformation(extent={{-130,-30},{-110,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger dowPul(
    period=60)
    "Stage down command pulse"
    annotation (Placement(transformation(extent={{-130,-70},{-110,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTab(
    table=[
      0, 0, 0;
      60, 1, 0;
      300, 0, 1],
    period=500)
    "Signal to inhibit up and down commands"
    annotation (Placement(transformation(extent={{-130,10},{-110,30}})));
  Buildings.Controls.OBC.CDL.Logical.And up
    "Stage up command"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And dow
    "Stage up command"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1AvaSta[3](
    each k=true)
    "Stage available signal"
    annotation (Placement(transformation(extent={{-130,50},{-110,70}})));
  Buildings.Controls.OBC.CDL.Logical.And run[3]
    "Returns true if equipment is enabled and available"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Components.Controls.StatusEmulator y1_actual[3] "Equipment status"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  connect(sorRunTim.yIdx, u1Ena.uIdx)
    annotation (Line(points={{-6,-6},{8,-6}},                    color={255,127,0}));
  connect(u1AvaEqu.y[1:3], sorRunTim.u1Ava[1:3])
    annotation (Line(points={{-108,-100},{-46,-100},{-46,-6},{-30,-6},{-30,
          -5.33333}},
      color={255,0,255}));
  connect(u1Lea.y, idxSta.u1Lea)
    annotation (Line(points={{-108,100},{-50,100},{-50,46},{-30,46}},color={255,0,255}));
  connect(upPul.y, up.u2)
    annotation (Line(points={{-108,-20},{-100,-20},{-100,-28},{-82,-28}},color={255,0,255}));
  connect(booTimTab.y[2], dow.u1)
    annotation (Line(points={{-108,20},{-90,20},{-90,-60},{-82,-60}},color={255,0,255}));
  connect(booTimTab.y[1], up.u1)
    annotation (Line(points={{-108,20},{-90,20},{-90,-20},{-82,-20}},color={255,0,255}));
  connect(dowPul.y, dow.u2)
    annotation (Line(points={{-108,-60},{-100,-60},{-100,-68},{-82,-68}},color={255,0,255}));
  connect(up.y, idxSta.u1Up)
    annotation (Line(points={{-58,-20},{-50,-20},{-50,42},{-30,42}},color={255,0,255}));
  connect(dow.y, idxSta.u1Dow)
    annotation (Line(points={{-58,-60},{-48,-60},{-48,38},{-30,38}},color={255,0,255}));
  connect(u1AvaSta.y, idxSta.u1AvaSta)
    annotation (Line(points={{-108,60},{-52,60},{-52,34},{-30,34}},color={255,0,255}));
  connect(idxSta.y, u1Ena.u)
    annotation (Line(points={{-6,40},{6,40},{6,0},{8,0}},      color={255,127,0}));
  connect(u1Ena.y1, run.u1)
    annotation (Line(points={{32,0},{48,0}},color={255,0,255}));
  connect(u1AvaEqu.y[1:3], run.u2)
    annotation (Line(points={{-108,-100},{40,-100},{40,-8},{48,-8}},color={255,0,255}));
  connect(run.y, y1_actual.y1)
    annotation (Line(points={{72,0},{88,0}}, color={255,0,255}));
  connect(y1_actual.y1_actual, sorRunTim.u1Run) annotation (Line(points={{112,0},
          {120,0},{120,20},{-40,20},{-40,6},{-30,6}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/SortRuntime.mos"
        "Simulate and plot"),
    experiment(
      StopTime=5000.0,
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
    Diagram(
      coordinateSystem(
        extent={{-140,-120},{140,120}})),
    Documentation(
      info="<html>
<p>
The simulation shows that even wear is achieved among available equipment.
When it becomes unavailable, equipment #1 is sent to last position
(<code>sorRunTim.yIdx[3]=1</code>),
and automatically moves up in the staging order only if another 
equipment (#3) becomes unavailable
(<code>sorRunTim.yIdx[3]=3</code> and <code>sorRunTim.yIdx[2]=1</code>).
</p>
<p>
We can verify that no equipment gets \"hot swapped\".
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2024, by Antoine Gautier:<br/>
Updated the model with <code>StatusEmulator</code>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end SortRuntime;
