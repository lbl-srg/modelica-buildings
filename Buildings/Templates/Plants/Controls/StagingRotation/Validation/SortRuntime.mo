within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model SortRuntime "Validation model for equipment runtime sorting logic"
  Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime sorRunTim(
    nin=3)
    "Sort runtime"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Utilities.TrueArrayConditional u1Ena(
    nin=3)
    "Equipment enable signal"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[3]
    "Convert command signal to real value"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[3](
    each samplePeriod=1)
    "Hold signal value"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[3]
    "Compare to zero to compute equipment status"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaEqu(
    table=[
      0, 1, 1, 1;
      2000, 0, 1, 1;
      2500, 0, 1, 0;
      3000, 1, 1, 1],
    timeScale=1,
    period=3000)
    "Equipment available signal"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));
  Utilities.StageIndex idxSta(
    nSta=3,
    dtRun=60)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
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
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
equation
  connect(sorRunTim.yIdx, u1Ena.uIdx)
    annotation (Line(points={{-18,-6},{-12,-6},{-12,-6},{-2,-6}},color={255,127,0}));
  connect(booToRea.y, zerOrdHol.u)
    annotation (Line(points={{82,0},{88,0}},color={0,0,127}));
  connect(zerOrdHol.y, greThr.u)
    annotation (Line(points={{112,0},{118,0}},color={0,0,127}));
  connect(greThr.y, sorRunTim.u1Run)
    annotation (Line(points={{142,0},{150,0},{150,20},{-46,20},{-46,6},{-42,6}},
      color={255,0,255}));
  connect(u1AvaEqu.y[1:3], sorRunTim.u1Ava[1:3])
    annotation (Line(points={{-108,-100},{-46,-100},{-46,-6},{-42,-6},{-42,-5.33333}},
      color={255,0,255}));
  connect(u1Lea.y, idxSta.u1Lea)
    annotation (Line(points={{-108,100},{-50,100},{-50,46},{-42,46}},color={255,0,255}));
  connect(upPul.y, up.u2)
    annotation (Line(points={{-108,-20},{-100,-20},{-100,-28},{-82,-28}},color={255,0,255}));
  connect(booTimTab.y[2], dow.u1)
    annotation (Line(points={{-108,20},{-90,20},{-90,-60},{-82,-60}},color={255,0,255}));
  connect(booTimTab.y[1], up.u1)
    annotation (Line(points={{-108,20},{-90,20},{-90,-20},{-82,-20}},color={255,0,255}));
  connect(dowPul.y, dow.u2)
    annotation (Line(points={{-108,-60},{-100,-60},{-100,-68},{-82,-68}},color={255,0,255}));
  connect(up.y, idxSta.u1Up)
    annotation (Line(points={{-58,-20},{-50,-20},{-50,42},{-42,42}},color={255,0,255}));
  connect(dow.y, idxSta.u1Dow)
    annotation (Line(points={{-58,-60},{-48,-60},{-48,38},{-42,38}},color={255,0,255}));
  connect(u1AvaSta.y, idxSta.u1AvaSta)
    annotation (Line(points={{-108,60},{-52,60},{-52,34},{-42,34}},color={255,0,255}));
  connect(idxSta.y, u1Ena.u)
    annotation (Line(points={{-18,40},{-10,40},{-10,0},{-2,0}},color={255,127,0}));
  connect(u1Ena.y1, run.u1)
    annotation (Line(points={{22,0},{28,0}},color={255,0,255}));
  connect(u1AvaEqu.y[1:3], run.u2)
    annotation (Line(points={{-108,-100},{24,-100},{24,-8},{28,-8}},color={255,0,255}));
  connect(run.y, booToRea.u)
    annotation (Line(points={{52,0},{58,0}},color={255,0,255}));
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
        extent={{-160,-120},{160,120}})),
    Documentation(
      info="<html>
<p>
The simulation shows that even wear is achieved among available equipment.
When it becomes unavailable, equipment #1 is sent to last position,
and automatically moves up in the staging order only if another 
equipment (#3) becomes unavailable.
</p>
<p>
We can verify that no equipment gets \"hot swapped\".
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end SortRuntime;
