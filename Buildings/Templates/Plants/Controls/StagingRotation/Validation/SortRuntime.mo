within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model SortRuntime
  Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime
    sorRunTim(nin=3)
          annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Utilities.TrueArrayConditional u1Run(nin=3)
    "Equipment enable signal"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[3]
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[3](each
      samplePeriod=1)
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[3]
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable  u1Ava(
    table=[0,1,1,1; 35,1,1,1],
    timeScale=1,
    period=35) "Equipment available signal"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Utilities.StageIndex idxSta(nSta=3, dtRun=10)
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Lea(k=true)
    "Lead equipment enable signal"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger upPul(period=20)
    "Stage up command pulse"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger dowPul(period=20)
    "Stage down command pulse"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTab(table=[0,0,0;
        10,1,0; 70,0,1], period=160)
    "Signal to inhibit up and down commands"
    annotation (Placement(transformation(extent={{-200,70},{-180,90}})));
  Buildings.Controls.OBC.CDL.Logical.And up
    "Stage up command"
    annotation (Placement(transformation(extent={{-150,30},{-130,50}})));
  Buildings.Controls.OBC.CDL.Logical.And dow
    "Stage up command"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1AvaSta[3](each k=true)
    "Stage available signal"
    annotation (Placement(transformation(extent={{-90,38},{-70,58}})));
equation
  connect(sorRunTim.yIdx, u1Run.uIdx) annotation (Line(points={{-8,0},{0,0},{0,-6},
          {18,-6}},                                  color={255,127,0}));
  connect(u1Run.y1, booToRea.u)
    annotation (Line(points={{42,0},{50,0},{50,0},{58,0}}, color={255,0,255}));
  connect(booToRea.y, zerOrdHol.u)
    annotation (Line(points={{82,0},{98,0}}, color={0,0,127}));
  connect(zerOrdHol.y, greThr.u)
    annotation (Line(points={{122,0},{138,0}}, color={0,0,127}));
  connect(greThr.y, sorRunTim.u1Run) annotation (Line(points={{162,0},{180,0},{180,
          -20},{-40,-20},{-40,0},{-32,0}}, color={255,0,255}));
  connect(u1Ava.y[1:3], sorRunTim.u1Ava[1:3]) annotation (Line(points={{-68,-80},
          {-60,-80},{-60,-5.33333},{-32,-5.33333}}, color={255,0,255}));
  connect(u1Lea.y, idxSta.u1Lea) annotation (Line(points={{-68,80},{-40,80},{
          -40,46},{-32,46}}, color={255,0,255}));
  connect(upPul.y,up. u2)
    annotation (Line(points={{-178,40},{-170,40},{-170,32},{-152,32}},
                                                                  color={255,0,255}));
  connect(booTimTab.y[2],dow. u1)
    annotation (Line(points={{-178,80},{-160,80},{-160,0},{-152,0}},color={255,0,255}));
  connect(booTimTab.y[1],up. u1)
    annotation (Line(points={{-178,80},{-160,80},{-160,40},{-152,40}},
                                                                  color={255,0,255}));
  connect(dowPul.y, dow.u2) annotation (Line(points={{-178,0},{-170,0},{-170,-8},
          {-152,-8}}, color={255,0,255}));
  connect(up.y, idxSta.u1Up) annotation (Line(points={{-128,40},{-40,40},{-40,
          42},{-32,42}}, color={255,0,255}));
  connect(dow.y, idxSta.u1Dow) annotation (Line(points={{-128,0},{-120,0},{-120,
          38},{-32,38}}, color={255,0,255}));
  connect(u1AvaSta.y, idxSta.u1Ava) annotation (Line(points={{-68,48},{-60,48},
          {-60,34},{-32,34}}, color={255,0,255}));
  connect(idxSta.y, u1Run.u) annotation (Line(points={{-8,40},{10,40},{10,0},{
          18,0}}, color={255,127,0}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/SortRuntime.mos"
        "Simulate and plot"),
    experiment(
      StopTime=100.0,
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end SortRuntime;
