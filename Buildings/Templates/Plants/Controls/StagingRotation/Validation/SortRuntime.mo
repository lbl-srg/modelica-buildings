within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model SortRuntime
  Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime
    sorRunTim(nin=3)
          annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Utilities.TrueArrayConditional u1Run(nin=3)
    "Equipment enable signal"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[3]
    "Convert command signal to real value"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[3](each
      samplePeriod=1) "Hold signal value"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[3]
    "Compare to zero to compute equipment status"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaEqu(
    table=[0,1,1,1; 35,1,1,1],
    timeScale=1,
    period=35) "Equipment available signal"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));
  Utilities.StageIndex idxSta(nSta=3, dtRun=10)
    annotation (Placement(transformation(extent={{-38,30},{-18,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Lea(k=true)
    "Lead equipment enable signal"
    annotation (Placement(transformation(extent={{-130,90},{-110,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger upPul(period=20)
    "Stage up command pulse"
    annotation (Placement(transformation(extent={{-130,-30},{-110,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger dowPul(period=20)
    "Stage down command pulse"
    annotation (Placement(transformation(extent={{-130,-70},{-110,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTab(table=[0,0,0;
        10,1,0; 70,0,1], period=160)
    "Signal to inhibit up and down commands"
    annotation (Placement(transformation(extent={{-130,10},{-110,30}})));
  Buildings.Controls.OBC.CDL.Logical.And up
    "Stage up command"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And dow
    "Stage up command"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1AvaSta[3](each k=true)
    "Stage available signal"
    annotation (Placement(transformation(extent={{-130,50},{-110,70}})));
equation
  connect(sorRunTim.yIdx, u1Run.uIdx) annotation (Line(points={{-18,0},{-10,0},
          {-10,-6},{-2,-6}},                         color={255,127,0}));
  connect(u1Run.y1, booToRea.u)
    annotation (Line(points={{22,0},{28,0}},               color={255,0,255}));
  connect(booToRea.y, zerOrdHol.u)
    annotation (Line(points={{52,0},{58,0}}, color={0,0,127}));
  connect(zerOrdHol.y, greThr.u)
    annotation (Line(points={{82,0},{88,0}},   color={0,0,127}));
  connect(greThr.y, sorRunTim.u1Run) annotation (Line(points={{112,0},{120,0},{
          120,20},{-44,20},{-44,0},{-42,0}},
                                           color={255,0,255}));
  connect(u1AvaEqu.y[1:3], sorRunTim.u1Ava[1:3]) annotation (Line(points={{-108,
          -100},{-44,-100},{-44,-5.33333},{-42,-5.33333}}, color={255,0,255}));
  connect(u1Lea.y, idxSta.u1Lea) annotation (Line(points={{-108,100},{-50,100},
          {-50,46},{-40,46}},color={255,0,255}));
  connect(upPul.y,up. u2)
    annotation (Line(points={{-108,-20},{-100,-20},{-100,-28},{-82,-28}},
                                                                  color={255,0,255}));
  connect(booTimTab.y[2],dow. u1)
    annotation (Line(points={{-108,20},{-90,20},{-90,-60},{-82,-60}},
                                                                    color={255,0,255}));
  connect(booTimTab.y[1],up. u1)
    annotation (Line(points={{-108,20},{-90,20},{-90,-20},{-82,-20}},
                                                                  color={255,0,255}));
  connect(dowPul.y, dow.u2) annotation (Line(points={{-108,-60},{-100,-60},{
          -100,-68},{-82,-68}},
                      color={255,0,255}));
  connect(up.y, idxSta.u1Up) annotation (Line(points={{-58,-20},{-50,-20},{-50,
          42},{-40,42}}, color={255,0,255}));
  connect(dow.y, idxSta.u1Dow) annotation (Line(points={{-58,-60},{-48,-60},{
          -48,38},{-40,38}},
                         color={255,0,255}));
  connect(u1AvaSta.y, idxSta.u1Ava) annotation (Line(points={{-108,60},{-52,60},
          {-52,34},{-40,34}}, color={255,0,255}));
  connect(idxSta.y, u1Run.u) annotation (Line(points={{-16,40},{-6,40},{-6,0},{
          -2,0}}, color={255,127,0}));
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-140,-120},{140,120}})));
end SortRuntime;
