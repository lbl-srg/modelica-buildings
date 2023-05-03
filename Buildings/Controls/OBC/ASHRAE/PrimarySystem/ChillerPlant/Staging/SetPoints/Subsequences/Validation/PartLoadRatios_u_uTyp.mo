within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Validation;
model PartLoadRatios_u_uTyp
  "Validates the operating and stage part load ratios calculation for chiller stage and stage type inputs"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios PLRs0(
    final anyVsdCen=false,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{-260,170},{-240,210}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios PLRs1(
    final anyVsdCen=false,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{-40,170},{-20,210}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios PLRs2(
    final anyVsdCen=false,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{180,170},{200,210}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios PLRs3(
    final anyVsdCen=false,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{420,170},{440,210}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios PLRs4(
    final anyVsdCen=true,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{-260,-170},{-240,-130}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios PLRs5(
    final anyVsdCen=true,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{-40,-170},{-20,-130}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios PLRs6(
    final anyVsdCen=true,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{180,-170},{200,-130}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios PLRs7(
    final anyVsdCen=true,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{420,-170},{440,-130}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staTyp[3](final k={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal})
    "Stage types"
    annotation (Placement(transformation(extent={{-420,220},{-400,240}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staTyp4[3](final k={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal})
    "Stage types"
    annotation (Placement(transformation(extent={{-420,-270},{-400,-250}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max "Maximum"
    annotation (Placement(transformation(extent={{-340,360},{-320,380}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max1 "Maximum"
    annotation (Placement(transformation(extent={{-120,360},{-100,380}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max2 "Maximum"
    annotation (Placement(transformation(extent={{100,360},{120,380}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max3 "Maximum"
    annotation (Placement(transformation(extent={{340,360},{360,380}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max4 "Maximum"
    annotation (Placement(transformation(extent={{-340,0},{-320,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max5 "Maximum"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max6 "Maximum"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max7 "Maximum"
    annotation (Placement(transformation(extent={{340,0},{360,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta(
    final k=1) "Current chiller stage"
    annotation (Placement(transformation(extent={{-420,180},{-400,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin capReq3(
    final amplitude=6e5,
    final freqHz=1/1800,
    final offset=9e5,
    final startTime=0)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{-420,380},{-400,400}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp(
    final k=2)
    "Next available chiller stage up"
    annotation (Placement(transformation(extent={{-420,140},{-400,160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown(
    final k=0)
    "Next available chiller stage down"
    annotation (Placement(transformation(extent={{-420,100},{-400,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowLim(
    final k=0)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{-420,340},{-400,360}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capDes[3](
    final k={10e5,15e5,25e5})
    "Stage design capacities"
    annotation (Placement(transformation(extent={{-380,300},{-360,320}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capMin[3](
    final k={2e5,3e5,5e5})
    "Stage unload capacities"
    annotation (Placement(transformation(extent={{-380,260},{-360,280}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta1(
    final k=2)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-200,180},{-180,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin capReq1(
    final amplitude=6e5,
    final freqHz=1/1800,
    final offset=14e5,
    final startTime=0)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{-200,380},{-180,400}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp1(
    final k=3)
    "Next available chiller stage up"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown1(
    final k=1)
    "Next available chiller stage down"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta2(
     final k=3)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{20,180},{40,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin capReq2(
    final amplitude=6e5,
    final freqHz=1/1800,
    final offset=19e5,
    final startTime=0)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{20,380},{40,400}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp2(
    final k=3)
    "Next available chiller stage up"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown2(final k=2)
    "Next available chiller stage down"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta3(
    final k=0)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{260,180},{280,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin capReq4(
    final amplitude=6e5,
    final freqHz=1/1800,
    final offset=5e5,
    final startTime=0)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{260,380},{280,400}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp3(
    final k=1)
    "Next available chiller stage up"
    annotation (Placement(transformation(extent={{260,140},{280,160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown3(
    final k=0)
    "Next available chiller stage down"
    annotation (Placement(transformation(extent={{260,100},{280,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta4(
    final k=1)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-420,-310},{-400,-290}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin capReq5(
    final amplitude=6e5,
    final freqHz=1/1800,
    final offset=9e5,
    final startTime=0)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{-420,20},{-400,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp4(
    final k=2)
    "Next available chiller stage up"
    annotation (Placement(transformation(extent={{-420,-350},{-400,-330}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown4(
    final k=0)
    "Next available chiller stage down"
    annotation (Placement(transformation(extent={{-420,-390},{-400,-370}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowLim4(
    final k=0)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{-420,-20},{-400,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capDes1[3](
    final k={10e5,15e5,25e5}) "Stage design capacities"
    annotation (Placement(transformation(extent={{-380,-60},{-360,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capMin1[3](
    final k={2e5,3e5,5e5})
    "Stage unload capacities"
    annotation (Placement(transformation(extent={{-380,-100},{-360,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta5(
    final k=2)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-200,-310},{-180,-290}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin capReq6(
    final amplitude=6e5,
    final freqHz=1/1800,
    final offset=14e5,
    final startTime=0)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp5(
    final k=3)
    "Next available chiller stage up"
    annotation (Placement(transformation(extent={{-200,-350},{-180,-330}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown5(
    final k=1)
    "Next available chiller stage down"
    annotation (Placement(transformation(extent={{-200,-390},{-180,-370}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta6(
    final k=3)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{20,-310},{40,-290}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin capReq7(
    final amplitude=6e5,
    final freqHz=1/1800,
    final offset=19e5,
    final startTime=0)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp6(
    final k=3)
    "Next available chiller stage up"
    annotation (Placement(transformation(extent={{20,-350},{40,-330}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown6(
    final k=2)
    "Next available chiller stage down"
    annotation (Placement(transformation(extent={{20,-390},{40,-370}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta7(
    final k=0)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{260,-310},{280,-290}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin capReq8(
    final amplitude=6e5,
    final freqHz=1/1800,
    final offset=5e5,
    final startTime=0)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{260,20},{280,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp7(
    final k=1)
    "Next available chiller stage up"
    annotation (Placement(transformation(extent={{260,-350},{280,-330}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown7(
    final k=0)
    "Next available chiller stage down"
    annotation (Placement(transformation(extent={{260,-390},{280,-370}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Lift(
    final k=16) "Chiller lift"
    annotation (Placement(transformation(extent={{-420,-130},{-400,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant LiftMin(
    final k=10) "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-420,-220},{-400,-200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant LiftMax(
    final k=20) "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-420,-180},{-400,-160}})));

equation

  connect(curSta.y, PLRs0.u) annotation (Line(points={{-398,190},{-330,190},{-330,
          178},{-262,178}},
          color={255,127,0}));
  connect(staUp.y, PLRs0.uUp) annotation (Line(points={{-398,150},{-320,150},{-320,
          176},{-262,176}},     color={255,127,0}));
  connect(staDown.y, PLRs0.uDown) annotation (Line(points={{-398,110},{-310,110},
          {-310,174},{-262,174}},                   color={255,127,0}));
  connect(max.y, PLRs0.uCapReq) annotation (Line(points={{-318,370},{-290,370},{
          -290,204},{-262,204}}, color={0,0,127}));
  connect(capReq3.y, max.u1) annotation (Line(points={{-398,390},{-360,390},{-360,
          376},{-342,376}}, color={0,0,127}));
  connect(lowLim.y, max.u2) annotation (Line(points={{-398,350},{-360,350},{-360,
          364},{-342,364}}, color={0,0,127}));
  connect(capDes[1].y, PLRs0.uCapDes) annotation (Line(points={{-358,310},{-292,
          310},{-292,202},{-262,202}},    color={0,0,127}));
  connect(capDes[2].y, PLRs0.uUpCapDes) annotation (Line(points={{-358,310},{-292,
          310},{-292,200},{-262,200}},    color={0,0,127}));
  connect(capMin[1].y, PLRs0.uDowCapDes) annotation (Line(points={{-358,270},{-294,
          270},{-294,198},{-262,198}},     color={0,0,127}));
  connect(capMin[1].y, PLRs0.uCapMin) annotation (Line(points={{-358,270},{-294,
          270},{-294,195},{-262,195}},    color={0,0,127}));
  connect(capMin[2].y, PLRs0.uUpCapMin) annotation (Line(points={{-358,270},{-296,
          270},{-296,193},{-262,193}},    color={0,0,127}));
  connect(staTyp.y, PLRs0.uTyp) annotation (Line(points={{-398,230},{-310,230},{
          -310,182},{-262,182}}, color={255,127,0}));
  connect(curSta1.y, PLRs1.u)
    annotation (Line(points={{-178,190},{-110,190},{-110,178},{-42,178}},
                                                    color={255,127,0}));
  connect(staUp1.y, PLRs1.uUp) annotation (Line(points={{-178,150},{-100,150},{-100,
          176},{-42,176}}, color={255,127,0}));
  connect(staDown1.y, PLRs1.uDown) annotation (Line(points={{-178,110},{-90,110},
          {-90,174},{-42,174}},    color={255,127,0}));
  connect(max1.y, PLRs1.uCapReq) annotation (Line(points={{-98,370},{-70,370},{-70,
          204},{-42,204}},    color={0,0,127}));
  connect(capReq1.y, max1.u1) annotation (Line(points={{-178,390},{-140,390},{-140,
          376},{-122,376}}, color={0,0,127}));
  connect(curSta2.y,PLRs2. u)
    annotation (Line(points={{42,190},{110,190},{110,178},{178,178}},
                                                  color={255,127,0}));
  connect(staUp2.y,PLRs2.uUp) annotation (Line(points={{42,150},{120,150},{120,176},
          {178,176}},        color={255,127,0}));
  connect(staDown2.y,PLRs2.uDown) annotation (Line(points={{42,110},{130,110},{130,
          174},{178,174}},    color={255,127,0}));
  connect(max2.y,PLRs2.uCapReq) annotation (Line(points={{122,370},{150,370},{150,
          204},{178,204}},    color={0,0,127}));
  connect(capReq2.y,max2.u1) annotation (Line(points={{42,390},{80,390},{80,376},
          {98,376}},   color={0,0,127}));
  connect(curSta3.y,PLRs3. u)
    annotation (Line(points={{282,190},{350,190},{350,178},{418,178}},
                                                  color={255,127,0}));
  connect(staUp3.y,PLRs3.uUp) annotation (Line(points={{282,150},{360,150},{360,
          176},{418,176}},   color={255,127,0}));
  connect(staDown3.y,PLRs3.uDown) annotation (Line(points={{282,110},{370,110},{
          370,174},{418,174}}, color={255,127,0}));
  connect(max3.y,PLRs3.uCapReq) annotation (Line(points={{362,370},{410,370},{410,
          204},{418,204}},    color={0,0,127}));
  connect(capReq4.y,max3.u1) annotation (Line(points={{282,390},{320,390},{320,376},
          {338,376}},  color={0,0,127}));
  connect(curSta4.y, PLRs4.u) annotation (Line(points={{-398,-300},{-330,-300},{
          -330,-162},{-262,-162}}, color={255,127,0}));
  connect(staUp4.y, PLRs4.uUp) annotation (Line(points={{-398,-340},{-320,-340},
          {-320,-164},{-262,-164}},     color={255,127,0}));
  connect(staDown4.y, PLRs4.uDown) annotation (Line(points={{-398,-380},{-310,-380},
          {-310,-166},{-262,-166}},     color={255,127,0}));
  connect(max4.y, PLRs4.uCapReq) annotation (Line(points={{-318,10},{-290,10},{-290,
          -136},{-262,-136}},     color={0,0,127}));
  connect(capReq5.y, max4.u1) annotation (Line(points={{-398,30},{-360,30},{-360,
          16},{-342,16}}, color={0,0,127}));
  connect(lowLim4.y, max4.u2) annotation (Line(points={{-398,-10},{-360,-10},{-360,
          4},{-342,4}},     color={0,0,127}));
  connect(capDes1[1].y, PLRs4.uCapDes) annotation (Line(points={{-358,-50},{-292,
          -50},{-292,-138},{-262,-138}}, color={0,0,127}));
  connect(capDes1[2].y, PLRs4.uUpCapDes) annotation (Line(points={{-358,-50},{-292,
          -50},{-292,-140},{-262,-140}}, color={0,0,127}));
  connect(capMin1[1].y, PLRs4.uDowCapDes) annotation (Line(points={{-358,-90},{-294,
          -90},{-294,-142},{-262,-142}}, color={0,0,127}));
  connect(capMin1[1].y, PLRs4.uCapMin) annotation (Line(points={{-358,-90},{-294,
          -90},{-294,-145},{-262,-145}}, color={0,0,127}));
  connect(capMin1[2].y, PLRs4.uUpCapMin) annotation (Line(points={{-358,-90},{-296,
          -90},{-296,-147},{-262,-147}}, color={0,0,127}));
  connect(staTyp4.y, PLRs4.uTyp) annotation (Line(points={{-398,-260},{-340,-260},
          {-340,-158},{-262,-158}}, color={255,127,0}));
  connect(curSta5.y,PLRs5. u)
    annotation (Line(points={{-178,-300},{-110,-300},{-110,-162},{-42,-162}},
                                                    color={255,127,0}));
  connect(staUp5.y,PLRs5. uUp) annotation (Line(points={{-178,-340},{-100,-340},
          {-100,-164},{-42,-164}}, color={255,127,0}));
  connect(staDown5.y,PLRs5. uDown) annotation (Line(points={{-178,-380},{-90,
          -380},{-90,-166},{-42,-166}},
                                  color={255,127,0}));
  connect(max5.y,PLRs5. uCapReq) annotation (Line(points={{-98,10},{-70,10},{
          -70,-136},{-42,-136}},color={0,0,127}));
  connect(capReq6.y,max5. u1) annotation (Line(points={{-178,30},{-140,30},{-140,
          16},{-122,16}}, color={0,0,127}));
  connect(curSta6.y,PLRs6. u)
    annotation (Line(points={{42,-300},{110,-300},{110,-162},{178,-162}},
          color={255,127,0}));
  connect(staUp6.y,PLRs6.uUp) annotation (Line(points={{42,-340},{120,-340},{
          120,-164},{178,-164}},
                             color={255,127,0}));
  connect(staDown6.y,PLRs6.uDown) annotation (Line(points={{42,-380},{130,-380},
          {130,-166},{178,-166}}, color={255,127,0}));
  connect(max6.y,PLRs6.uCapReq) annotation (Line(points={{122,10},{150,10},{150,
          -136},{178,-136}},    color={0,0,127}));
  connect(capReq7.y,max6.u1) annotation (Line(points={{42,30},{80,30},{80,16},{98,
          16}}, color={0,0,127}));
  connect(curSta7.y,PLRs7. u)
    annotation (Line(points={{282,-300},{350,-300},{350,-162},{418,-162}},
           color={255,127,0}));
  connect(staUp7.y,PLRs7.uUp) annotation (Line(points={{282,-340},{360,-340},{
          360,-164},{418,-164}},
                             color={255,127,0}));
  connect(staDown7.y,PLRs7.uDown) annotation (Line(points={{282,-380},{370,-380},
          {370,-166},{418,-166}}, color={255,127,0}));
  connect(max7.y,PLRs7.uCapReq) annotation (Line(points={{362,10},{390,10},{390,
          -136},{418,-136}}, color={0,0,127}));
  connect(capReq8.y,max7.u1) annotation (Line(points={{282,30},{320,30},{320,16},
          {338,16}}, color={0,0,127}));
  connect(capMin1[1].y,PLRs7.uCapDes) annotation (Line(points={{-358,-90},{388,
          -90},{388,-138},{418,-138}},
                                  color={0,0,127}));
  connect(capDes1[1].y,PLRs7.uUpCapDes) annotation (Line(points={{-358,-50},{
          388,-50},{388,-140},{418,-140}},
                                       color={0,0,127}));
  connect(capMin1[1].y,PLRs7.uDowCapDes) annotation (Line(points={{-358,-90},{
          386,-90},{386,-142},{418,-142}},
                                       color={0,0,127}));
  connect(capMin1[1].y,PLRs7.uCapMin) annotation (Line(points={{-358,-90},{386,
          -90},{386,-145},{418,-145}},
                                  color={0,0,127}));
  connect(capMin1[1].y,PLRs7.uUpCapMin) annotation (Line(points={{-358,-90},{
          384,-90},{384,-147},{418,-147}},
                                       color={0,0,127}));
  connect(staTyp.y, PLRs1.uTyp) annotation (Line(points={{-398,230},{-90,230},{-90,
          182},{-42,182}}, color={255,127,0}));
  connect(staTyp.y, PLRs2.uTyp) annotation (Line(points={{-398,230},{130,230},{130,
          182},{178,182}}, color={255,127,0}));
  connect(staTyp4.y, PLRs5.uTyp) annotation (Line(points={{-398,-260},{-120,
          -260},{-120,-158},{-42,-158}},
                                   color={255,127,0}));
  connect(staTyp4.y, PLRs6.uTyp) annotation (Line(points={{-398,-260},{100,-260},
          {100,-158},{178,-158}}, color={255,127,0}));
  connect(staTyp4.y, PLRs7.uTyp) annotation (Line(points={{-398,-260},{340,-260},
          {340,-158},{418,-158}}, color={255,127,0}));
  connect(Lift.y, PLRs4.uLif) annotation (Line(points={{-398,-120},{-360,-120},
          {-360,-150},{-262,-150}},color={0,0,127}));
  connect(LiftMax.y, PLRs4.uLifMax) annotation (Line(points={{-398,-170},{-380,-170},
          {-380,-152},{-262,-152}}, color={0,0,127}));
  connect(LiftMin.y, PLRs4.uLifMin) annotation (Line(points={{-398,-210},{-360,-210},
          {-360,-154},{-262,-154}}, color={0,0,127}));
  connect(Lift.y, PLRs5.uLif) annotation (Line(points={{-398,-120},{-140,-120},
          {-140,-150},{-42,-150}},color={0,0,127}));
  connect(LiftMax.y, PLRs5.uLifMax) annotation (Line(points={{-398,-170},{-380,
          -170},{-380,-180},{-140,-180},{-140,-152},{-42,-152}},
                                                           color={0,0,127}));
  connect(LiftMin.y, PLRs5.uLifMin) annotation (Line(points={{-398,-210},{-130,
          -210},{-130,-154},{-42,-154}},
                                   color={0,0,127}));
  connect(Lift.y, PLRs6.uLif) annotation (Line(points={{-398,-120},{80,-120},{
          80,-150},{178,-150}},
                             color={0,0,127}));
  connect(Lift.y, PLRs7.uLif) annotation (Line(points={{-398,-120},{320,-120},{
          320,-150},{418,-150}},
                             color={0,0,127}));
  connect(LiftMax.y, PLRs6.uLifMax) annotation (Line(points={{-398,-170},{-380,
          -170},{-380,-180},{80,-180},{80,-152},{178,-152}},
                                                       color={0,0,127}));
  connect(LiftMax.y, PLRs7.uLifMax) annotation (Line(points={{-398,-170},{-380,
          -170},{-380,-180},{320,-180},{320,-152},{418,-152}},
                                                         color={0,0,127}));
  connect(LiftMin.y, PLRs6.uLifMin) annotation (Line(points={{-398,-210},{92,
          -210},{92,-154},{178,-154}},
                                 color={0,0,127}));
  connect(PLRs7.uLifMin, LiftMin.y) annotation (Line(points={{418,-154},{332,
          -154},{332,-210},{-398,-210}},
                                   color={0,0,127}));
  connect(staTyp.y, PLRs3.uTyp) annotation (Line(points={{-398,230},{372,230},{372,
          182},{418,182}}, color={255,127,0}));
  connect(lowLim.y, max1.u2) annotation (Line(points={{-398,350},{-140,350},{-140,
          364},{-122,364}}, color={0,0,127}));
  connect(lowLim.y, max2.u2) annotation (Line(points={{-398,350},{80,350},{80,364},
          {98,364}}, color={0,0,127}));
  connect(lowLim.y, max3.u2) annotation (Line(points={{-398,350},{320,350},{320,
          364},{338,364}}, color={0,0,127}));
  connect(lowLim4.y, max5.u2) annotation (Line(points={{-398,-10},{-140,-10},{-140,
          4},{-122,4}}, color={0,0,127}));
  connect(lowLim4.y, max6.u2) annotation (Line(points={{-398,-10},{80,-10},{80,4},
          {98,4}}, color={0,0,127}));
  connect(lowLim4.y, max7.u2) annotation (Line(points={{-398,-10},{320,-10},{320,
          4},{338,4}}, color={0,0,127}));
  connect(capDes[2].y, PLRs1.uCapDes) annotation (Line(points={{-358,310},{-72,310},
          {-72,202},{-42,202}}, color={0,0,127}));
  connect(capDes[3].y, PLRs1.uUpCapDes) annotation (Line(points={{-358,310},{-72,
          310},{-72,200},{-42,200}}, color={0,0,127}));
  connect(capDes[1].y, PLRs1.uDowCapDes) annotation (Line(points={{-358,310},{-72,
          310},{-72,198},{-42,198}}, color={0,0,127}));
  connect(capMin[2].y, PLRs1.uCapMin) annotation (Line(points={{-358,270},{-74,270},
          {-74,195},{-42,195}}, color={0,0,127}));
  connect(capMin[3].y, PLRs1.uUpCapMin) annotation (Line(points={{-358,270},{-74,
          270},{-74,193},{-42,193}}, color={0,0,127}));
  connect(capDes1[2].y, PLRs5.uCapDes) annotation (Line(points={{-358,-50},{-80,
          -50},{-80,-138},{-42,-138}}, color={0,0,127}));
  connect(capDes1[3].y, PLRs5.uUpCapDes) annotation (Line(points={{-358,-50},{
          -80,-50},{-80,-140},{-42,-140}},
                                       color={0,0,127}));
  connect(capDes1[1].y, PLRs5.uDowCapDes) annotation (Line(points={{-358,-50},{
          -80,-50},{-80,-142},{-42,-142}},
                                       color={0,0,127}));
  connect(capMin1[2].y, PLRs5.uCapMin) annotation (Line(points={{-358,-90},{-90,
          -90},{-90,-145},{-42,-145}}, color={0,0,127}));
  connect(capMin1[1].y, PLRs5.uUpCapMin) annotation (Line(points={{-358,-90},{
          -90,-90},{-90,-147},{-42,-147}},
                                       color={0,0,127}));
  connect(capDes[3].y, PLRs2.uCapDes) annotation (Line(points={{-358,310},{140,310},
          {140,202},{178,202}}, color={0,0,127}));
  connect(capDes[3].y, PLRs2.uUpCapDes) annotation (Line(points={{-358,310},{140,
          310},{140,200},{178,200}}, color={0,0,127}));
  connect(capDes[2].y, PLRs2.uDowCapDes) annotation (Line(points={{-358,310},{140,
          310},{140,198},{178,198}}, color={0,0,127}));
  connect(capMin[3].y, PLRs2.uCapMin) annotation (Line(points={{-358,270},{138,270},
          {138,195},{178,195}}, color={0,0,127}));
  connect(capMin[3].y, PLRs2.uUpCapMin) annotation (Line(points={{-358,270},{138,
          270},{138,193},{178,193}}, color={0,0,127}));
  connect(capDes1[3].y, PLRs6.uCapDes) annotation (Line(points={{-358,-50},{140,
          -50},{140,-138},{178,-138}}, color={0,0,127}));
  connect(capDes1[3].y, PLRs6.uUpCapDes) annotation (Line(points={{-358,-50},{
          140,-50},{140,-140},{178,-140}},
                                       color={0,0,127}));
  connect(capDes1[2].y, PLRs6.uDowCapDes) annotation (Line(points={{-358,-50},{
          140,-50},{140,-142},{178,-142}},
                                       color={0,0,127}));
  connect(capMin1[3].y, PLRs6.uCapMin) annotation (Line(points={{-358,-90},{130,
          -90},{130,-145},{178,-145}}, color={0,0,127}));
  connect(capMin1[3].y, PLRs6.uUpCapMin) annotation (Line(points={{-358,-90},{
          130,-90},{130,-147},{178,-147}},
                                       color={0,0,127}));
  connect(capMin[1].y, PLRs3.uCapDes) annotation (Line(points={{-358,270},{398,270},
          {398,202},{418,202}}, color={0,0,127}));
  connect(capDes[1].y, PLRs3.uUpCapDes) annotation (Line(points={{-358,310},{400,
          310},{400,200},{418,200}}, color={0,0,127}));
  connect(capMin[1].y, PLRs3.uDowCapDes) annotation (Line(points={{-358,270},{398,
          270},{398,198},{418,198}}, color={0,0,127}));
  connect(capMin[1].y, PLRs3.uCapMin) annotation (Line(points={{-358,270},{398,270},
          {398,195},{418,195}}, color={0,0,127}));
  connect(capMin[1].y, PLRs3.uUpCapMin) annotation (Line(points={{-358,270},{398,
          270},{398,193},{418,193}}, color={0,0,127}));
annotation (
 experiment(StopTime=1200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Subsequences/Validation/PartLoadRatios_u_uTyp.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 03, 2020, by Milica Grahovac:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-480,-420},{480,420}}),
        graphics={Text(
          extent={{-232,102},{252,40}},
          textColor={127,127,127},
          textString="Stage types: 1 - positive displacement, 2 and 3 - constant speed centrifugal"),
          Text(
          extent={{-256,-372},{308,-446}},
          textColor={127,127,127},
          textString="Stage types: 1 - positive displacement, 2 - variable speed centrifugal, 3 - constant speed centrifugal")}));
end PartLoadRatios_u_uTyp;
