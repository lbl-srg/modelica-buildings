within Buildings.Experimental.DHC.Plants.Combined.Controls;
block Controller "Open-loop controller for validation purposes"
  extends BaseClasses.PartialController;

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant valByp(
    k=0,
    y(start=0)) "Source signal for minimum flow bypass valve"
    annotation (Placement(transformation(extent={{-360,190},{-340,210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repHeaPum(nout=
        nHeaPum) "Replicate signal"
    annotation (Placement(transformation(extent={{220,-230},{240,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable coo(
    table=[0,0; 0.9,0; 0.9,1; 1,1],
    timeScale=10000,
    period=10000) "Boolean source for cooler circuit"
    annotation (Placement(transformation(extent={{-220,-310},{-200,-290}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repCoo(nout=nCoo)
    "Replicate signal"
    annotation (Placement(transformation(extent={{60,-310},{80,-290}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delVal1(final delayTime=
        riseTimeVal) "Delay command signal to allow for valve opening time"
    annotation (Placement(transformation(extent={{-170,-310},{-150,-290}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtValBypTan
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{-40,-270},{-20,-250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtSpeCoo
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{90,-330},{110,-310}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumCoo(nout=
        nPumConWatCoo) "Replicate signal"
    annotation (Placement(transformation(extent={{60,-350},{80,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch TChiHeaSupSet[nChiHea]
    "Switch supply temperature setpoint"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  BaseClasses.StagingPump staPumChiWat(
    final nPum=nPumChiWat,
    final nChi=nChi + nChiHea,
    final m_flow_nominal=mChiWat_flow_nominal,
    have_switchover=true) "CHW pump staging"
    annotation (Placement(transformation(extent={{60,250},{80,270}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlPumChiWat(
    k=0.1,
    Ti=60,
    r=dpChiWatSet_max)
                 "Pump speed controller"
    annotation (Placement(transformation(extent={{170,230},{190,250}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumChiWat(
    final nin=nPumChiWat)
    "Return true if any pump is commanded On"
    annotation (Placement(transformation(extent={{100,230},{120,250}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlPumHeaWat(
    k=0.1,
    Ti=60,
    r=dpHeaWatSet_max)
                 "Pump speed controller"
    annotation (Placement(transformation(extent={{190,-50},{210,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumHeaWat(nin=nPumHeaWat)
    "Return true if any pump is commanded On"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
  BaseClasses.StagingPump staPumHeaWat(
    final nPum=nPumHeaWat,
    final nChi=nChiHea,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final have_switchover=true) "HW pump staging"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  BaseClasses.StagingPump staPumConWatCon(
    final nPum=nPumConWatCon,
    final nChi=nChi + nChiHea,
    final m_flow_nominal=mConWatCon_flow_nominal,
    final have_switchover=true) "CW pump staging"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumConWatCon(nin=nPumConWatCon)
    "Return true if any pump is commanded On"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlPumConWatCon(
    k=0.1,
    Ti=60,
    final r=dpConWatConSet_max)
                 "Pump speed controller"
    annotation (Placement(transformation(extent={{190,-130},{210,-110}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlPumConWatEva(
    k=0.1,
    Ti=60,
    final r=dpConWatEvaSet_max)
                 "Pump speed controller"
    annotation (Placement(transformation(extent={{190,-190},{210,-170}})));
  BaseClasses.StagingPump staPumConWatEva(
    final nPum=nPumConWatEva,
    final nChi=nChiHea,
    final m_flow_nominal=mConWatEva_flow_nominal,
    final have_switchover=true) "CW pump staging"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumConWatEva(nin=nPumConWatEva)
    "Return true if any pump is commanded On"
    annotation (Placement(transformation(extent={{120,-170},{140,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpConNom(final k=
        dpConWatConSet_max) "Constant"
    annotation (Placement(transformation(extent={{150,-90},{170,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpEvaNom(final k=
        dpConWatEvaSet_max) "Constant"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
  BaseClasses.StagingPlant staPla(
    final nChi=nChi,
    final QChiWatChi_flow_nominal=QChiWatChi_flow_nominal,
    final nChiHea=nChiHea,
    final QChiWatCasCoo_flow_nominal=QChiWatCasCoo_flow_nominal,
    final QHeaWat_flow_nominal=QHeaWat_flow_nominal,
    final cp_default=cp_default) "Plant staging"
    annotation (Placement(transformation(extent={{-210,142},{-190,170}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repTSet(nout=nChiHea)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repTSet1(nout=nChiHea)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  BaseClasses.ModeCondenserLoop modConLoo(
    final TTanSet=TTanSet,
    final fraUslTan=fraUslTan,
    final ratFraChaTanLim=ratFraChaTanLim,
    nTTan=nTTan) "Condenser loop operating mode"
    annotation (Placement(transformation(extent={{-170,-170},{-150,-150}})));
  BaseClasses.TankCycle cycTan(final TTanSet=TTanSet, nTTan=nTTan)
    "Determine tank cycle"
    annotation (Placement(transformation(extent={{-170,-130},{-150,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isModChaAss
    "Return true if charge assist mode is active"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chaAss(
    final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.chargeAssist)
    "Charge assist mode index"
    annotation (Placement(transformation(extent={{-170,-198},{-150,-178}})));
  Buildings.Controls.OBC.CDL.Logical.And assAndPum
    "Charge assist mode and any CW pump On"
    annotation (Placement(transformation(extent={{186,-210},{206,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaPumSetVal[2](
    final k={max(TTanSet[i]) + 3 for i in 1:2})
    "HP supply temperature sepoint for each tank cycle"
    annotation (Placement(transformation(extent={{-170,-230},{-150,-210}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndRea(final nin=2)
    "Extract active setpoint"
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant heaRej(
    final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Heat rejection mode index"
    annotation (Placement(transformation(extent={{-170,-270},{-150,-250}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isModHeaRej
    "Return true if heat rejection mode is active"
    annotation (Placement(transformation(extent={{-120,-270},{-100,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Not isModNotHeaRej
    "Return true if heat rejection mode is NOT active"
    annotation (Placement(transformation(extent={{-80,-270},{-60,-250}})));
  BaseClasses.ValveCommand valCmd(
    final nChi=nChi,
    final nChiHea=nChiHea,
    final mChiWatChi_flow_nominal=mChiWatChi_flow_nominal,
    final mChiWatChi_flow_min=mChiWatChi_flow_min,
    final mConWatChi_flow_nominal=mConWatChi_flow_nominal,
    final mChiWatChiHea_flow_nominal=mChiWatChiHea_flow_nominal,
    final mChiWatChiHea_flow_min=mChiWatChiHea_flow_min,
    final mConWatChiHea_flow_nominal=mConWatChiHea_flow_nominal)
    "Compute isolation and switchover valve command signal"
    annotation (Placement(transformation(extent={{-120,16},{-100,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delRis[nChi](each delayTime=120,
      each delayOnInit=true) "Delay allowing for valve and pump transients"
    annotation (Placement(transformation(extent={{220,330},{240,350}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delRis1[nChiHea](each delayTime=
        120, each delayOnInit=true)
    "Delay allowing for valve and pump transients"
    annotation (Placement(transformation(extent={{220,150},{240,170}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delRis2[nChiHea](each delayTime=
        120, each delayOnInit=true)
    "Delay allowing for valve and pump transients"
    annotation (Placement(transformation(extent={{190,130},{210,150}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delRis3[nChiHea](each delayTime=
        120, each delayOnInit=true)
    "Delay allowing for valve and pump transients"
    annotation (Placement(transformation(extent={{150,110},{170,130}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Left limit of signal avoiding direct feedback"
    annotation (Placement(transformation(extent={{130,230},{150,250}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Left limit of signal avoiding direct feedback"
    annotation (Placement(transformation(extent={{150,-30},{170,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre3
    "Left limit of signal avoiding direct feedback"
    annotation (Placement(transformation(extent={{150,-130},{170,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre4
    "Left limit of signal avoiding direct feedback"
    annotation (Placement(transformation(extent={{150,-170},{170,-150}})));
equation
  connect(valByp.y, yValChiWatMinByp)
    annotation (Line(points={{-338,200},{280,200}}, color={0,0,127}));
  connect(valByp.y, yValHeaWatMinByp) annotation (Line(points={{-338,200},{244,
          200},{244,-80},{280,-80}},   color={0,0,127}));
  connect(repHeaPum.y, y1HeaPum)
    annotation (Line(points={{242,-220},{280,-220}},color={255,0,255}));
  connect(repCoo.y, y1Coo)
    annotation (Line(points={{82,-300},{280,-300}}, color={255,0,255}));
  connect(coo.y[1], delVal1.u)
    annotation (Line(points={{-198,-300},{-172,-300}}, color={255,0,255}));
  connect(delVal1.y, repCoo.u) annotation (Line(points={{-148,-300},{58,-300}},
                                 color={255,0,255}));
  connect(cvtValBypTan.y, yValBypTan) annotation (Line(points={{-18,-260},{240,
          -260},{240,-268},{280,-268}}, color={0,0,127}));
  connect(cvtSpeCoo.y, yCoo) annotation (Line(points={{112,-320},{280,-320}},
                                 color={0,0,127}));
  connect(delVal1.y, cvtSpeCoo.u) annotation (Line(points={{-148,-300},{0,-300},
          {0,-320},{88,-320}}, color={255,0,255}));
  connect(repPumCoo.y, y1PumConWatCoo) annotation (Line(points={{82,-340},{280,
          -340}},                       color={255,0,255}));
  connect(delVal1.y, repPumCoo.u) annotation (Line(points={{-148,-300},{0,-300},
          {0,-340},{58,-340}},  color={255,0,255}));
  connect(staPumChiWat.y1, y1PumChiWat) annotation (Line(points={{82,260},{176,260},
          {176,260},{280,260}}, color={255,0,255}));
  connect(ctlPumChiWat.y, yPumChiWat)
    annotation (Line(points={{192,240},{280,240}}, color={0,0,127}));
  connect(staPumChiWat.y1, anyPumChiWat.u) annotation (Line(points={{82,260},{90,
          260},{90,240},{98,240}}, color={255,0,255}));
  connect(dpChiWatSet, ctlPumChiWat.u_s) annotation (Line(points={{-280,180},{
          160,180},{160,240},{168,240}},
                                     color={0,0,127}));
  connect(staPumHeaWat.y1, y1PumHeaWat)
    annotation (Line(points={{102,0},{250,0},{250,-20},{280,-20}},
                                                color={255,0,255}));
  connect(ctlPumHeaWat.y, yPumHeaWat)
    annotation (Line(points={{212,-40},{280,-40}},
                                               color={0,0,127}));
  connect(dpHeaWatSet, ctlPumHeaWat.u_s) annotation (Line(points={{-280,140},{
          -240,140},{-240,-40},{188,-40}},            color={0,0,127}));
  connect(staPumHeaWat.y1, anyPumHeaWat.u) annotation (Line(points={{102,0},{
          110,0},{110,-20},{118,-20}},
                              color={255,0,255}));
  connect(ctlPumConWatEva.y, yPumConWatEva)
    annotation (Line(points={{212,-180},{280,-180}}, color={0,0,127}));
  connect(ctlPumConWatCon.y, yPumConWatCon) annotation (Line(points={{212,-120},
          {230,-120},{230,-140},{280,-140}}, color={0,0,127}));
  connect(staPumConWatCon.y1, y1PumConWatCon) annotation (Line(points={{102,-80},
          {110,-80},{110,-100},{240,-100},{240,-120},{280,-120}},
                                          color={255,0,255}));
  connect(staPumConWatEva.y1, y1PumConWatEva)
    annotation (Line(points={{102,-120},{106,-120},{106,-140},{220,-140},{220,
          -160},{280,-160}},                        color={255,0,255}));
  connect(staPumConWatEva.y1, anyPumConWatEva.u) annotation (Line(points={{102,
          -120},{106,-120},{106,-160},{118,-160}},
                                                 color={255,0,255}));
  connect(staPumConWatCon.y1, anyPumConWatCon.u) annotation (Line(points={{102,-80},
          {110,-80},{110,-120},{118,-120}}, color={255,0,255}));
  connect(dpHeaWat, ctlPumHeaWat.u_m) annotation (Line(points={{-280,-300},{
          -234,-300},{-234,-60},{200,-60},{200,-52}},
                                                 color={0,0,127}));
  connect(mHeaWatPri_flow, staPumHeaWat.m_flow) annotation (Line(points={{-280,
          -120},{-242,-120},{-242,0},{78,0}},
                                        color={0,0,127}));
  connect(dpChiWat, ctlPumChiWat.u_m) annotation (Line(points={{-280,-280},{
          -246,-280},{-246,220},{180,220},{180,228}},
                                                color={0,0,127}));
  connect(mConWatEva_flow, staPumConWatEva.m_flow) annotation (Line(points={{-280,
          -180},{-252,-180},{-252,-120},{78,-120}},
                                                  color={0,0,127}));
  connect(mConWatCon_flow, staPumConWatCon.m_flow) annotation (Line(points={{-280,
          -160},{-244,-160},{-244,-80},{78,-80}},
                                               color={0,0,127}));
  connect(mChiWatPri_flow, staPumChiWat.m_flow) annotation (Line(points={{-280,
          -100},{-238,-100},{-238,260},{58,260}},
                                                color={0,0,127}));
  connect(dpConNom.y, ctlPumConWatCon.u_s) annotation (Line(points={{172,-80},{
          184,-80},{184,-120},{188,-120}},
                                        color={0,0,127}));
  connect(dpEvaNom.y, ctlPumConWatEva.u_s) annotation (Line(points={{102,-180},
          {188,-180}},                     color={0,0,127}));
  connect(mHeaWatPri_flow, staPla.mHeaWatPri_flow) annotation (Line(points={{-280,
          -120},{-236,-120},{-236,148},{-212,148}},    color={0,0,127}));
  connect(THeaWatSupSet, staPla.THeaWatSupSet) annotation (Line(points={{-280,
          220},{-250,220},{-250,146},{-212,146}}, color={0,0,127}));
  connect(mChiWatPri_flow, staPla.mChiWatPri_flow) annotation (Line(points={{-280,
          -100},{-238,-100},{-238,162},{-212,162}},color={0,0,127}));
  connect(u1Coo, staPla.u1Coo) annotation (Line(points={{-280,340},{-236,340},{
          -236,168},{-212,168}},                       color={255,0,255}));
  connect(u1Hea, staPla.u1Hea) annotation (Line(points={{-280,300},{-240,300},{
          -240,166},{-212,166}},                       color={255,0,255}));
  connect(TChiWatSupSet, staPla.TChiWatSupSet) annotation (Line(points={{-280,
          260},{-242,260},{-242,160},{-212,160}}, color={0,0,127}));
  connect(TChiWatPriRet, staPla.TChiWatPriRet) annotation (Line(points={{-280,80},
          {-242,80},{-242,156},{-212,156}},     color={0,0,127}));
  connect(THeaWatPriRet, staPla.THeaWatPriRet) annotation (Line(points={{-280,60},
          {-242,60},{-242,144},{-212,144}},     color={0,0,127}));
  connect(repTSet1.y, TChiHeaSupSet.u3) annotation (Line(points={{-118,80},{
          -106,80},{-106,92},{-102,92}}, color={0,0,127}));
  connect(repTSet.y, TChiHeaSupSet.u1) annotation (Line(points={{-118,120},{
          -106,120},{-106,108},{-102,108}}, color={0,0,127}));
  connect(staPla.y1CooChiHea, TChiHeaSupSet.u2) annotation (Line(points={{-188,
          152},{-110,152},{-110,100},{-102,100}}, color={255,0,255}));
  connect(TChiHeaSupSet.y, TChiHeaSet)
    annotation (Line(points={{-78,100},{280,100}}, color={0,0,127}));
  connect(TChiWatSupSet, repTSet.u) annotation (Line(points={{-280,260},{-254,
          260},{-254,120},{-142,120}}, color={0,0,127}));
  connect(THeaWatSupSet, repTSet1.u) annotation (Line(points={{-280,220},{-250,
          220},{-250,80},{-142,80}}, color={0,0,127}));
  connect(mConWatHexCoo_flow, modConLoo.mConWatHexCoo_flow) annotation (Line(
        points={{-280,-200},{-248,-200},{-248,-154},{-172,-154}},
                                                                color={0,0,127}));
  connect(mConWatOutTan_flow, modConLoo.mConWatOutTan_flow) annotation (Line(
        points={{-280,-220},{-234,-220},{-234,-160},{-172,-160}},
                                                                color={0,0,127}));
  connect(TTan, modConLoo.TTan) annotation (Line(points={{-280,40},{-180,40},{
          -180,-166},{-172,-166}},
                                 color={0,0,127}));
  connect(TTan, cycTan.TTan) annotation (Line(points={{-280,40},{-180,40},{-180,
          -126},{-172,-126}},
                          color={0,0,127}));
  connect(mConWatOutTan_flow, cycTan.mConWatOutTan_flow) annotation (Line(
        points={{-280,-220},{-226,-220},{-226,-114},{-172,-114}},
                                                            color={0,0,127}));
  connect(chaAss.y, isModChaAss.u2) annotation (Line(points={{-148,-188},{-122,
          -188}},                         color={255,127,0}));
  connect(modConLoo.mode, isModChaAss.u1) annotation (Line(points={{-148,-160},
          {-144,-160},{-144,-180},{-122,-180}},
                                              color={255,127,0}));
  connect(assAndPum.y, repHeaPum.u)
    annotation (Line(points={{208,-220},{218,-220}}, color={255,0,255}));
  connect(isModChaAss.y, assAndPum.u1)
    annotation (Line(points={{-98,-180},{-80,-180},{-80,-220},{184,-220}},
                                                     color={255,0,255}));
  connect(THeaPumSetVal.y, extIndRea.u)
    annotation (Line(points={{-148,-220},{-122,-220}}, color={0,0,127}));
  connect(extIndRea.y, THeaPumSet) annotation (Line(points={{-98,-220},{-80,
          -220},{-80,-240},{280,-240}},            color={0,0,127}));
  connect(cycTan.idxCycTan, extIndRea.index) annotation (Line(points={{-148,
          -120},{-140,-120},{-140,-240},{-110,-240},{-110,-232}},
                                                         color={255,127,0}));
  connect(heaRej.y, isModHeaRej.u1)
    annotation (Line(points={{-148,-260},{-122,-260}}, color={255,127,0}));
  connect(modConLoo.mode, isModHeaRej.u2) annotation (Line(points={{-148,-160},
          {-144,-160},{-144,-268},{-122,-268}},
                                              color={255,127,0}));
  connect(isModNotHeaRej.y, cvtValBypTan.u)
    annotation (Line(points={{-58,-260},{-42,-260}}, color={255,0,255}));
  connect(isModHeaRej.y, isModNotHeaRej.u)
    annotation (Line(points={{-98,-260},{-82,-260}}, color={255,0,255}));
  connect(mEvaChi_flow, valCmd.mEvaChi_flow)
    annotation (Line(points={{-280,0},{-212,0},{-212,30},{-122,30}},
                                                 color={0,0,127}));
  connect(mConChi_flow, valCmd.mConChi_flow) annotation (Line(points={{-280,-20},
          {-256,-20},{-256,28},{-122,28}}, color={0,0,127}));
  connect(mEvaChiHea_flow, valCmd.mEvaChiHea_flow) annotation (Line(points={{-280,
          -40},{-254,-40},{-254,26},{-122,26}},      color={0,0,127}));
  connect(mConChiHea_flow, valCmd.mConChiHea_flow) annotation (Line(points={{-280,
          -60},{-252,-60},{-252,24},{-122,24}},      color={0,0,127}));
  connect(staPla.y1Chi, valCmd.u1Chi) annotation (Line(points={{-188,162},{-164,
          162},{-164,38},{-122,38}},
                                   color={255,0,255}));
  connect(staPla.y1ChiHea, valCmd.u1ChiHea) annotation (Line(points={{-188,156},
          {-166,156},{-166,36},{-122,36}},
                                         color={255,0,255}));
  connect(staPla.y1CooChiHea, valCmd.u1CooChiHea) annotation (Line(points={{-188,
          152},{-168,152},{-168,34},{-122,34}},    color={255,0,255}));
  connect(staPla.y1HeaCooChiHea, valCmd.u1HeaCooChiHea) annotation (Line(points={{-188,
          148},{-170,148},{-170,32},{-122,32}},     color={255,0,255}));
  connect(valCmd.yValEvaChi, yValEvaChi) annotation (Line(points={{-98,30},{0,
          30},{0,320},{280,320}}, color={0,0,127}));
  connect(valCmd.yValConChi, yValConChi) annotation (Line(points={{-98,28},{2,
          28},{2,300},{280,300}}, color={0,0,127}));
  connect(valCmd.yValConSwiChiHea, yValConSwiChiHea) annotation (Line(points={{-98,20},
          {280,20}},                           color={0,0,127}));
  connect(valCmd.yValEvaSwiChiHea, yValEvaSwiHea) annotation (Line(points={{-98,22},
          {240,22},{240,40},{280,40}},     color={0,0,127}));
  connect(valCmd.yValConChiHea, yValConChiHea) annotation (Line(points={{-98,24},
          {238,24},{238,60},{280,60}}, color={0,0,127}));
  connect(valCmd.yValEvaChiHea, yValEvaChiHea) annotation (Line(points={{-98,26},
          {236,26},{236,80},{280,80}}, color={0,0,127}));
  connect(dpConWatEva, ctlPumConWatEva.u_m) annotation (Line(points={{-280,-340},
          {-240,-340},{-240,-200},{200,-200},{200,-192}}, color={0,0,127}));
  connect(dpConWatCon, ctlPumConWatCon.u_m) annotation (Line(points={{-280,-320},
          {-242,-320},{-242,-138},{200,-138},{200,-132}}, color={0,0,127}));
  connect(cycTan.idxCycTan, valCmd.idxCycTan) annotation (Line(points={{-148,
          -120},{-140,-120},{-140,20},{-122,20}}, color={255,127,0}));
  connect(modConLoo.mode, valCmd.mode) annotation (Line(points={{-148,-160},{
          -144,-160},{-144,22},{-122,22}}, color={255,127,0}));
  connect(TChiWatSup, staPla.TChiWatSup) annotation (Line(points={{-280,100},{
          -246,100},{-246,158},{-212,158}},         color={0,0,127}));
  connect(dpChiWatSet, staPla.dpChiWatSet) annotation (Line(points={{-280,180},
          {-246,180},{-246,154},{-212,154}},         color={0,0,127}));
  connect(dpChiWat, staPla.dpChiWat) annotation (Line(points={{-280,-280},{-238,
          -280},{-238,152},{-212,152}},         color={0,0,127}));
  connect(delRis.y, y1Chi)
    annotation (Line(points={{242,340},{280,340}}, color={255,0,255}));
  connect(staPla.y1Chi, delRis.u) annotation (Line(points={{-188,162},{-96,162},
          {-96,164},{-2,164},{-2,340},{218,340}},          color={255,0,255}));
  connect(delRis1.y, y1ChiHea)
    annotation (Line(points={{242,160},{280,160}}, color={255,0,255}));
  connect(staPla.y1ChiHea, delRis1.u) annotation (Line(points={{-188,156},{14,
          156},{14,160},{218,160}}, color={255,0,255}));
  connect(delRis3.y, y1HeaCooChiHea) annotation (Line(points={{172,120},{220,
          120},{220,120},{280,120}}, color={255,0,255}));
  connect(delRis2.y, y1CooChiHea)
    annotation (Line(points={{212,140},{280,140}}, color={255,0,255}));
  connect(staPla.y1CooChiHea, delRis2.u) annotation (Line(points={{-188,152},{
          180,152},{180,140},{188,140}}, color={255,0,255}));
  connect(staPla.y1HeaCooChiHea, delRis3.u) annotation (Line(points={{-188,148},
          {140,148},{140,120},{148,120}}, color={255,0,255}));
  connect(valCmd.y1PumChiWat, staPumChiWat.y1Ena) annotation (Line(points={{-98,
          38},{-4,38},{-4,266},{58,266}}, color={255,0,255}));
  connect(anyPumChiWat.y, pre1.u)
    annotation (Line(points={{122,240},{128,240}}, color={255,0,255}));
  connect(pre1.y, ctlPumChiWat.uEna) annotation (Line(points={{152,240},{156,
          240},{156,224},{176,224},{176,228}}, color={255,0,255}));
  connect(ctlPumChiWat.y, staPumChiWat.y) annotation (Line(points={{192,240},{
          200,240},{200,280},{40,280},{40,254},{58,254}}, color={0,0,127}));
  connect(anyPumHeaWat.y, pre2.u) annotation (Line(points={{142,-20},{146,-20},
          {146,-20},{148,-20}}, color={255,0,255}));
  connect(pre2.y, ctlPumHeaWat.uEna) annotation (Line(points={{172,-20},{180,
          -20},{180,-56},{196,-56},{196,-52}}, color={255,0,255}));
  connect(ctlPumHeaWat.y, staPumHeaWat.y) annotation (Line(points={{212,-40},{
          220,-40},{220,20},{70,20},{70,-6},{78,-6}}, color={0,0,127}));
  connect(valCmd.y1PumHeaWat, staPumHeaWat.y1Ena) annotation (Line(points={{-98,
          36},{74,36},{74,6},{78,6}}, color={255,0,255}));
  connect(anyPumConWatCon.y, pre3.u)
    annotation (Line(points={{142,-120},{148,-120}}, color={255,0,255}));
  connect(pre3.y, ctlPumConWatCon.uEna) annotation (Line(points={{172,-120},{
          180,-120},{180,-136},{196,-136},{196,-132}}, color={255,0,255}));
  connect(pre3.y, assAndPum.u2) annotation (Line(points={{172,-120},{180,-120},
          {180,-212},{184,-212}}, color={255,0,255}));
  connect(anyPumConWatEva.y, pre4.u)
    annotation (Line(points={{142,-160},{148,-160}}, color={255,0,255}));
  connect(pre4.y, ctlPumConWatEva.uEna) annotation (Line(points={{172,-160},{
          176,-160},{176,-198},{196,-198},{196,-192}}, color={255,0,255}));
  connect(ctlPumConWatCon.y, staPumConWatCon.y) annotation (Line(points={{212,
          -120},{220,-120},{220,-96},{74,-96},{74,-86},{78,-86}}, color={0,0,
          127}));
  connect(ctlPumConWatEva.y, staPumConWatEva.y) annotation (Line(points={{212,
          -180},{214,-180},{214,-144},{74,-144},{74,-126},{78,-126}}, color={0,
          0,127}));
  connect(valCmd.y1PumConWatEva, staPumConWatEva.y1Ena) annotation (Line(points
        ={{-98,32},{-4,32},{-4,-114},{78,-114}}, color={255,0,255}));
  connect(valCmd.y1PumConWatCon, staPumConWatCon.y1Ena) annotation (Line(points
        ={{-98,34},{-50,34},{-50,34},{-2,34},{-2,-74},{78,-74}}, color={255,0,
          255}));
annotation (
  defaultComponentName="ctl", Documentation(info="<html>
<h4>
CW pumps
</h4>
<p>
CW pumps serving the evaporator loop or the condenser loop
are controlled to track the loop differential pressure
setpoint.
A constant setpoint is used.
Optimizations are possible, for instance by resetting the setpoint 
based on valve requests, or based on a linear relationship with
the loop flow setpoint.
</p>
</html>"));
end Controller;
