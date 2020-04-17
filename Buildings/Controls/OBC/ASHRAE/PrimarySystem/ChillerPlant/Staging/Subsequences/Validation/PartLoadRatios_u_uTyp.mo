within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model PartLoadRatios_u_uTyp
  "Validates the operating and stage part load ratios calculation for chiller stage and stage type inputs"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs0(
    final anyVsdCen=false,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{-260,190},{-240,210}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs1(
    final anyVsdCen=false,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs2(
    final anyVsdCen=false,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{180,190},{200,210}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs3(
    final anyVsdCen=false,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{420,190},{440,210}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs4(
    final anyVsdCen=true,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{-260,-170},{-240,-150}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs5(
    final anyVsdCen=true,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs6(
    final anyVsdCen=true,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs7(
    final anyVsdCen=true,
    final nSta=3)
    "Stage and operative part load ratios"
    annotation (Placement(transformation(extent={{420,-170},{440,-150}})));

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

  Buildings.Controls.OBC.CDL.Continuous.Max max
    annotation (Placement(transformation(extent={{-340,360},{-320,380}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max1
    annotation (Placement(transformation(extent={{-120,360},{-100,380}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max2
    annotation (Placement(transformation(extent={{100,360},{120,380}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max3
    annotation (Placement(transformation(extent={{340,360},{360,380}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max4
    annotation (Placement(transformation(extent={{-340,0},{-320,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max5
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max6
    annotation (Placement(transformation(extent={{100,0},{120,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max7
    annotation (Placement(transformation(extent={{340,0},{360,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta(
    final k=1) "Current chiller stage"
    annotation (Placement(transformation(extent={{-420,180},{-400,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq3(
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq1(
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq2(
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq4(
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq5(
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq6(
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

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta6(final k=3)
  "Current chiller stage"
  annotation (Placement(transformation(extent={{20,-310},{40,-290}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq7(
    final amplitude=6e5,
    final freqHz=1/1800,
    final offset=19e5,
    final startTime=0)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp6(final k=3)
    "Next available chiller stage up"
    annotation (Placement(transformation(extent={{20,-350},{40,-330}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown6(final k=2)
    "Next available chiller stage down"
    annotation (Placement(transformation(extent={{20,-390},{40,-370}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta7(final k=0)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{260,-310},{280,-290}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq8(
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
    annotation (Placement(transformation(extent={{-420,-140},{-400,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant LiftMin(
    final k=10) "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-420,-220},{-400,-200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant LiftMax(
    final k=20) "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-420,-180},{-400,-160}})));

equation

  connect(curSta.y, PLRs0.u) annotation (Line(points={{-398,190},{-330,190},{
        -330,188},{-262,188}},
          color={255,127,0}));
  connect(staUp.y, PLRs0.uUp) annotation (Line(points={{-398,150},{-320,150},
        {-320,186},{-262,186}},
                           color={255,127,0}));
  connect(staDown.y, PLRs0.uDown) annotation (Line(points={{-398,110},{-310,
        110},{-310,184},{-262,184}},                color={255,127,0}));
  connect(max.y, PLRs0.uCapReq) annotation (Line(points={{-318,370},{-290,370},
        {-290,214},{-262,214}},  color={0,0,127}));
  connect(capReq3.y, max.u1) annotation (Line(points={{-398,390},{-360,390},{-360,
          376},{-342,376}}, color={0,0,127}));
  connect(lowLim.y, max.u2) annotation (Line(points={{-398,350},{-360,350},{-360,
          364},{-342,364}}, color={0,0,127}));
  connect(capDes[1].y, PLRs0.uCapDes) annotation (Line(points={{-358,310},{
        -292,310},{-292,212},{-262,212}},
                                       color={0,0,127}));
  connect(capDes[2].y, PLRs0.uUpCapDes) annotation (Line(points={{-358,310},{
        -292,310},{-292,210},{-262,210}},
                                       color={0,0,127}));
  connect(capMin[1].y, PLRs0.uDowCapDes) annotation (Line(points={{-358,270},
        {-294,270},{-294,208},{-262,208}},
                                       color={0,0,127}));
  connect(capMin[1].y, PLRs0.uCapMin) annotation (Line(points={{-358,270},{
        -294,270},{-294,205},{-262,205}},
                                       color={0,0,127}));
  connect(capMin[2].y, PLRs0.uUpCapMin) annotation (Line(points={{-358,270},{
        -296,270},{-296,203},{-262,203}},
                                       color={0,0,127}));
  connect(staTyp.y, PLRs0.uTyp) annotation (Line(points={{-398,230},{-310,230},
        {-310,192},{-262,192}},  color={255,127,0}));
  connect(curSta1.y, PLRs1.u)
    annotation (Line(points={{-178,190},{-110,190},{-110,188},{-42,188}},
                                                    color={255,127,0}));
  connect(staUp1.y, PLRs1.uUp) annotation (Line(points={{-178,150},{-100,150},
        {-100,186},{-42,186}},
                           color={255,127,0}));
  connect(staDown1.y, PLRs1.uDown) annotation (Line(points={{-178,110},{-90,
        110},{-90,184},{-42,184}},
                               color={255,127,0}));
  connect(max1.y, PLRs1.uCapReq) annotation (Line(points={{-98,370},{-70,370},
        {-70,214},{-42,214}},
                           color={0,0,127}));
  connect(capReq1.y, max1.u1) annotation (Line(points={{-178,390},{-140,390},{-140,
          376},{-122,376}}, color={0,0,127}));
  connect(curSta2.y,PLRs2. u)
    annotation (Line(points={{42,190},{110,190},{110,188},{178,188}},
                                                  color={255,127,0}));
  connect(staUp2.y,PLRs2.uUp) annotation (Line(points={{42,150},{120,150},{
        120,186},{178,186}},
                      color={255,127,0}));
  connect(staDown2.y,PLRs2.uDown) annotation (Line(points={{42,110},{130,110},
        {130,184},{178,184}},
                           color={255,127,0}));
  connect(max2.y,PLRs2.uCapReq) annotation (Line(points={{122,370},{150,370},
        {150,214},{178,214}},
                           color={0,0,127}));
  connect(capReq2.y,max2.u1) annotation (Line(points={{42,390},{80,390},{80,376},
          {98,376}},   color={0,0,127}));
  connect(curSta3.y,PLRs3. u)
    annotation (Line(points={{282,190},{350,190},{350,188},{418,188}},
                                                  color={255,127,0}));
  connect(staUp3.y,PLRs3.uUp) annotation (Line(points={{282,150},{360,150},{
        360,186},{418,186}},
                           color={255,127,0}));
  connect(staDown3.y,PLRs3.uDown) annotation (Line(points={{282,110},{370,110},
        {370,184},{418,184}},  color={255,127,0}));
  connect(max3.y,PLRs3.uCapReq) annotation (Line(points={{362,370},{410,370},
        {410,214},{418,214}},
                           color={0,0,127}));
  connect(capReq4.y,max3.u1) annotation (Line(points={{282,390},{320,390},{320,376},
          {338,376}},  color={0,0,127}));
  connect(curSta4.y, PLRs4.u) annotation (Line(points={{-398,-300},{-330,-300},
        {-330,-172},{-262,-172}},  color={255,127,0}));
  connect(staUp4.y, PLRs4.uUp) annotation (Line(points={{-398,-340},{-320,
        -340},{-320,-174},{-262,-174}},
                                    color={255,127,0}));
  connect(staDown4.y, PLRs4.uDown) annotation (Line(points={{-398,-380},{-310,
        -380},{-310,-176},{-262,-176}},
                                    color={255,127,0}));
  connect(max4.y, PLRs4.uCapReq) annotation (Line(points={{-318,10},{-290,10},
        {-290,-146},{-262,-146}},
                              color={0,0,127}));
  connect(capReq5.y, max4.u1) annotation (Line(points={{-398,30},{-360,30},{-360,
          16},{-342,16}}, color={0,0,127}));
  connect(lowLim4.y, max4.u2) annotation (Line(points={{-398,-10},{-360,-10},{-360,
          4},{-342,4}},     color={0,0,127}));
  connect(capDes1[1].y, PLRs4.uCapDes) annotation (Line(points={{-358,-50},{
        -292,-50},{-292,-148},{-262,-148}},
                                         color={0,0,127}));
  connect(capDes1[2].y, PLRs4.uUpCapDes) annotation (Line(points={{-358,-50},
        {-292,-50},{-292,-150},{-262,-150}},
                                         color={0,0,127}));
  connect(capMin1[1].y, PLRs4.uDowCapDes) annotation (Line(points={{-358,-90},
        {-294,-90},{-294,-152},{-262,-152}},
                                         color={0,0,127}));
  connect(capMin1[1].y, PLRs4.uCapMin) annotation (Line(points={{-358,-90},{
        -294,-90},{-294,-155},{-262,-155}},
                                         color={0,0,127}));
  connect(capMin1[2].y, PLRs4.uUpCapMin) annotation (Line(points={{-358,-90},
        {-296,-90},{-296,-157},{-262,-157}},
                                         color={0,0,127}));
  connect(staTyp4.y, PLRs4.uTyp) annotation (Line(points={{-398,-260},{-340,
        -260},{-340,-168},{-262,-168}},
                                    color={255,127,0}));
  connect(curSta5.y,PLRs5. u)
    annotation (Line(points={{-178,-300},{-110,-300},{-110,-172},{-42,-172}},
                                                    color={255,127,0}));
  connect(staUp5.y,PLRs5. uUp) annotation (Line(points={{-178,-340},{-100,
        -340},{-100,-174},{-42,-174}},
                                   color={255,127,0}));
  connect(staDown5.y,PLRs5. uDown) annotation (Line(points={{-178,-380},{-90,
        -380},{-90,-176},{-42,-176}},
                                  color={255,127,0}));
  connect(max5.y,PLRs5. uCapReq) annotation (Line(points={{-98,10},{-70,10},{
        -70,-146},{-42,-146}},  color={0,0,127}));
  connect(capReq6.y,max5. u1) annotation (Line(points={{-178,30},{-140,30},{-140,
          16},{-122,16}}, color={0,0,127}));
  connect(curSta6.y,PLRs6. u)
    annotation (Line(points={{42,-300},{110,-300},{110,-172},{178,-172}},
          color={255,127,0}));
  connect(staUp6.y,PLRs6.uUp) annotation (Line(points={{42,-340},{120,-340},{
        120,-174},{178,-174}},
                             color={255,127,0}));
  connect(staDown6.y,PLRs6.uDown) annotation (Line(points={{42,-380},{130,
        -380},{130,-176},{178,-176}},
                                  color={255,127,0}));
  connect(max6.y,PLRs6.uCapReq) annotation (Line(points={{122,10},{150,10},{
        150,-146},{178,-146}},  color={0,0,127}));
  connect(capReq7.y,max6.u1) annotation (Line(points={{42,30},{80,30},{80,16},{98,
          16}}, color={0,0,127}));
  connect(curSta7.y,PLRs7. u)
    annotation (Line(points={{282,-300},{350,-300},{350,-172},{418,-172}},
           color={255,127,0}));
  connect(staUp7.y,PLRs7.uUp) annotation (Line(points={{282,-340},{360,-340},
        {360,-174},{418,-174}},
                             color={255,127,0}));
  connect(staDown7.y,PLRs7.uDown) annotation (Line(points={{282,-380},{370,
        -380},{370,-176},{418,-176}},
                                  color={255,127,0}));
  connect(max7.y,PLRs7.uCapReq) annotation (Line(points={{362,10},{390,10},{
        390,-146},{418,-146}},
                             color={0,0,127}));
  connect(capReq8.y,max7.u1) annotation (Line(points={{282,30},{320,30},{320,16},
          {338,16}}, color={0,0,127}));
  connect(capMin1[1].y,PLRs7.uCapDes) annotation (Line(points={{-358,-90},{
        388,-90},{388,-148},{418,-148}},
                                  color={0,0,127}));
  connect(capDes1[1].y,PLRs7.uUpCapDes) annotation (Line(points={{-358,-50},{
        388,-50},{388,-150},{418,-150}},
                                       color={0,0,127}));
  connect(capMin1[1].y,PLRs7.uDowCapDes) annotation (Line(points={{-358,-90},
        {386,-90},{386,-152},{418,-152}},
                                       color={0,0,127}));
  connect(capMin1[1].y,PLRs7.uCapMin) annotation (Line(points={{-358,-90},{
        386,-90},{386,-155},{418,-155}},
                                  color={0,0,127}));
  connect(capMin1[1].y,PLRs7.uUpCapMin) annotation (Line(points={{-358,-90},{
        384,-90},{384,-157},{418,-157}},
                                       color={0,0,127}));
  connect(staTyp.y, PLRs1.uTyp) annotation (Line(points={{-398,230},{-90,230},
        {-90,192},{-42,192}},
                           color={255,127,0}));
  connect(staTyp.y, PLRs2.uTyp) annotation (Line(points={{-398,230},{130,230},
        {130,192},{178,192}},
                           color={255,127,0}));
  connect(staTyp4.y, PLRs5.uTyp) annotation (Line(points={{-398,-260},{-120,
        -260},{-120,-168},{-42,-168}},
                                   color={255,127,0}));
  connect(staTyp4.y, PLRs6.uTyp) annotation (Line(points={{-398,-260},{100,
        -260},{100,-168},{178,-168}},
                                  color={255,127,0}));
  connect(staTyp4.y, PLRs7.uTyp) annotation (Line(points={{-398,-260},{340,
        -260},{340,-168},{418,-168}},
                                  color={255,127,0}));
  connect(Lift.y, PLRs4.uLif) annotation (Line(points={{-398,-130},{-360,-130},
        {-360,-160},{-262,-160}},  color={0,0,127}));
  connect(LiftMax.y, PLRs4.uLifMax) annotation (Line(points={{-398,-170},{
        -380,-170},{-380,-162},{-262,-162}},
                                    color={0,0,127}));
  connect(LiftMin.y, PLRs4.uLifMin) annotation (Line(points={{-398,-210},{
        -360,-210},{-360,-164},{-262,-164}},
                                    color={0,0,127}));
  connect(Lift.y, PLRs5.uLif) annotation (Line(points={{-398,-130},{-140,-130},
        {-140,-160},{-42,-160}},  color={0,0,127}));
  connect(LiftMax.y, PLRs5.uLifMax) annotation (Line(points={{-398,-170},{
        -380,-170},{-380,-180},{-140,-180},{-140,-162},{-42,-162}},
                                                           color={0,0,127}));
  connect(LiftMin.y, PLRs5.uLifMin) annotation (Line(points={{-398,-210},{
        -130,-210},{-130,-164},{-42,-164}},
                                   color={0,0,127}));
  connect(Lift.y, PLRs6.uLif) annotation (Line(points={{-398,-130},{80,-130},
        {80,-160},{178,-160}},
                             color={0,0,127}));
  connect(Lift.y, PLRs7.uLif) annotation (Line(points={{-398,-130},{320,-130},
        {320,-160},{418,-160}},
                             color={0,0,127}));
  connect(LiftMax.y, PLRs6.uLifMax) annotation (Line(points={{-398,-170},{
        -380,-170},{-380,-180},{80,-180},{80,-162},{178,-162}},
                                                       color={0,0,127}));
  connect(LiftMax.y, PLRs7.uLifMax) annotation (Line(points={{-398,-170},{
        -380,-170},{-380,-180},{320,-180},{320,-162},{418,-162}},
                                                         color={0,0,127}));
  connect(LiftMin.y, PLRs6.uLifMin) annotation (Line(points={{-398,-210},{92,
        -210},{92,-164},{178,-164}},
                                 color={0,0,127}));
  connect(PLRs7.uLifMin, LiftMin.y) annotation (Line(points={{418,-164},{332,
        -164},{332,-210},{-398,-210}},
                                   color={0,0,127}));
  connect(staTyp.y, PLRs3.uTyp) annotation (Line(points={{-398,230},{372,230},
        {372,192},{418,192}},
                           color={255,127,0}));
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
  connect(capDes[2].y, PLRs1.uCapDes) annotation (Line(points={{-358,310},{
        -72,310},{-72,212},{-42,212}},
                                color={0,0,127}));
  connect(capDes[3].y, PLRs1.uUpCapDes) annotation (Line(points={{-358,310},{
        -72,310},{-72,210},{-42,210}},
                                     color={0,0,127}));
  connect(capDes[1].y, PLRs1.uDowCapDes) annotation (Line(points={{-358,310},
        {-72,310},{-72,208},{-42,208}},
                                     color={0,0,127}));
  connect(capMin[2].y, PLRs1.uCapMin) annotation (Line(points={{-358,270},{
        -74,270},{-74,205},{-42,205}},
                                color={0,0,127}));
  connect(capMin[3].y, PLRs1.uUpCapMin) annotation (Line(points={{-358,270},{
        -74,270},{-74,203},{-42,203}},
                                     color={0,0,127}));
  connect(capDes1[2].y, PLRs5.uCapDes) annotation (Line(points={{-358,-50},{
        -80,-50},{-80,-148},{-42,-148}},
                                       color={0,0,127}));
  connect(capDes1[3].y, PLRs5.uUpCapDes) annotation (Line(points={{-358,-50},
        {-80,-50},{-80,-150},{-42,-150}},
                                       color={0,0,127}));
  connect(capDes1[1].y, PLRs5.uDowCapDes) annotation (Line(points={{-358,-50},
        {-80,-50},{-80,-152},{-42,-152}},
                                       color={0,0,127}));
  connect(capMin1[2].y, PLRs5.uCapMin) annotation (Line(points={{-358,-90},{
        -90,-90},{-90,-155},{-42,-155}},
                                       color={0,0,127}));
  connect(capMin1[1].y, PLRs5.uUpCapMin) annotation (Line(points={{-358,-90},
        {-90,-90},{-90,-157},{-42,-157}},
                                       color={0,0,127}));
  connect(capDes[3].y, PLRs2.uCapDes) annotation (Line(points={{-358,310},{
        140,310},{140,212},{178,212}},
                                color={0,0,127}));
  connect(capDes[3].y, PLRs2.uUpCapDes) annotation (Line(points={{-358,310},{
        140,310},{140,210},{178,210}},
                                     color={0,0,127}));
  connect(capDes[2].y, PLRs2.uDowCapDes) annotation (Line(points={{-358,310},
        {140,310},{140,208},{178,208}},
                                     color={0,0,127}));
  connect(capMin[3].y, PLRs2.uCapMin) annotation (Line(points={{-358,270},{
        138,270},{138,205},{178,205}},
                                color={0,0,127}));
  connect(capMin[3].y, PLRs2.uUpCapMin) annotation (Line(points={{-358,270},{
        138,270},{138,203},{178,203}},
                                     color={0,0,127}));
  connect(capDes1[3].y, PLRs6.uCapDes) annotation (Line(points={{-358,-50},{
        140,-50},{140,-148},{178,-148}},
                                       color={0,0,127}));
  connect(capDes1[3].y, PLRs6.uUpCapDes) annotation (Line(points={{-358,-50},
        {140,-50},{140,-150},{178,-150}},
                                       color={0,0,127}));
  connect(capDes1[2].y, PLRs6.uDowCapDes) annotation (Line(points={{-358,-50},
        {140,-50},{140,-152},{178,-152}},
                                       color={0,0,127}));
  connect(capMin1[3].y, PLRs6.uCapMin) annotation (Line(points={{-358,-90},{
        130,-90},{130,-155},{178,-155}},
                                       color={0,0,127}));
  connect(capMin1[3].y, PLRs6.uUpCapMin) annotation (Line(points={{-358,-90},
        {130,-90},{130,-157},{178,-157}},
                                       color={0,0,127}));
  connect(capMin[1].y, PLRs3.uCapDes) annotation (Line(points={{-358,270},{
        398,270},{398,212},{418,212}},
                                color={0,0,127}));
  connect(capDes[1].y, PLRs3.uUpCapDes) annotation (Line(points={{-358,310},{
        400,310},{400,210},{418,210}},
                                     color={0,0,127}));
  connect(capMin[1].y, PLRs3.uDowCapDes) annotation (Line(points={{-358,270},
        {398,270},{398,208},{418,208}},
                                     color={0,0,127}));
  connect(capMin[1].y, PLRs3.uCapMin) annotation (Line(points={{-358,270},{
        398,270},{398,205},{418,205}},
                                color={0,0,127}));
  connect(capMin[1].y, PLRs3.uUpCapMin) annotation (Line(points={{-358,270},{
        398,270},{398,203},{418,203}},
                                     color={0,0,127}));
annotation (
 experiment(StopTime=1200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/PartLoadRatios_u_uTyp.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios</a>.
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
          lineColor={127,127,127},
          textString="Stage types: 1 - positive displacement, 2 and 3 - constant speed centrifugal"),
          Text(
          extent={{-256,-372},{308,-446}},
          lineColor={127,127,127},
          textString="Stage types: 1 - positive displacement, 2 - variable speed centrifugal, 3 - constant speed centrifugal")}));
end PartLoadRatios_u_uTyp;
