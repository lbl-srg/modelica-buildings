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
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repCoo(nout=nCoo)
    "Replicate signal"
    annotation (Placement(transformation(extent={{60,-310},{80,-290}})));
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
    annotation (Placement(transformation(extent={{-210,140},{-190,172}})));
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
    annotation (Placement(transformation(extent={{-80,16},{-60,40}})));
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
  Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.DirectHeatRecovery dirHeaCoo(
    final nChi=nChi,
    final nChiHea=nChiHea,
    final mChiWatChi_flow_nominal=mChiWatChi_flow_nominal,
    final mChiWatChi_flow_min=mChiWatChi_flow_min,
    final mChiWatChiHea_flow_nominal=mChiWatChiHea_flow_nominal,
    final mChiWatChiHea_flow_min=mChiWatChiHea_flow_min)
    "Control logic for HRC in direct HR mode"
    annotation (Placement(transformation(extent={{-120,-32},{-100,-8}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant        repCoo1(k=true)
    "FIXME"
    annotation (Placement(transformation(extent={{0,-330},{20,-310}})));
equation
  connect(valByp.y, yValChiWatMinByp)
    annotation (Line(points={{-338,200},{280,200}}, color={0,0,127}));
  connect(valByp.y, yValHeaWatMinByp) annotation (Line(points={{-338,200},{244,
          200},{244,-80},{280,-80}},   color={0,0,127}));
  connect(repHeaPum.y, y1HeaPum)
    annotation (Line(points={{242,-220},{280,-220}},color={255,0,255}));
  connect(repCoo.y, y1Coo)
    annotation (Line(points={{82,-300},{280,-300}}, color={255,0,255}));
  connect(cvtValBypTan.y, yValBypTan) annotation (Line(points={{-18,-260},{240,
          -260},{240,-268},{280,-268}}, color={0,0,127}));
  connect(cvtSpeCoo.y, yCoo) annotation (Line(points={{112,-320},{280,-320}},
                                 color={0,0,127}));
  connect(repPumCoo.y, y1PumConWatCoo) annotation (Line(points={{82,-340},{280,
          -340}},                       color={255,0,255}));
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
  connect(dpHeaWat, ctlPumHeaWat.u_m) annotation (Line(points={{-280,-340},{-234,
          -340},{-234,-72},{200,-72},{200,-52}}, color={0,0,127}));
  connect(mHeaWatPri_flow, staPumHeaWat.m_flow) annotation (Line(points={{-280,-160},
          {-242,-160},{-242,0},{78,0}}, color={0,0,127}));
  connect(dpChiWat, ctlPumChiWat.u_m) annotation (Line(points={{-280,-320},{-246,
          -320},{-246,208},{180,208},{180,228}},color={0,0,127}));
  connect(mConWatEva_flow, staPumConWatEva.m_flow) annotation (Line(points={{-280,
          -220},{-252,-220},{-252,-120},{78,-120}},
                                                  color={0,0,127}));
  connect(mConWatCon_flow, staPumConWatCon.m_flow) annotation (Line(points={{-280,
          -200},{-244,-200},{-244,-80},{78,-80}},
                                               color={0,0,127}));
  connect(mChiWatPri_flow, staPumChiWat.m_flow) annotation (Line(points={{-280,-140},
          {-238,-140},{-238,260},{58,260}},     color={0,0,127}));
  connect(dpConNom.y, ctlPumConWatCon.u_s) annotation (Line(points={{172,-80},{
          184,-80},{184,-120},{188,-120}},
                                        color={0,0,127}));
  connect(dpEvaNom.y, ctlPumConWatEva.u_s) annotation (Line(points={{102,-180},
          {188,-180}},                     color={0,0,127}));
  connect(mHeaWatPri_flow, staPla.mHeaWatPri_flow) annotation (Line(points={{-280,
          -160},{-236,-160},{-236,152},{-212,152}},    color={0,0,127}));
  connect(THeaWatSupSet, staPla.THeaWatSupSet) annotation (Line(points={{-280,220},
          {-250,220},{-250,150},{-212,150}},      color={0,0,127}));
  connect(mChiWatPri_flow, staPla.mChiWatPri_flow) annotation (Line(points={{-280,
          -140},{-238,-140},{-238,166},{-212,166}},color={0,0,127}));
  connect(u1Coo, staPla.u1Coo) annotation (Line(points={{-280,340},{-236,340},{-236,
          170.2},{-212,170.2}},                        color={255,0,255}));
  connect(u1Hea, staPla.u1Hea) annotation (Line(points={{-280,300},{-240,300},{-240,
          168.2},{-212,168.2}},                        color={255,0,255}));
  connect(TChiWatSupSet, staPla.TChiWatSupSet) annotation (Line(points={{-280,260},
          {-242,260},{-242,164},{-212,164}},      color={0,0,127}));
  connect(TChiWatPriRet, staPla.TChiWatPriRet) annotation (Line(points={{-280,80},
          {-242,80},{-242,160},{-212,160}},     color={0,0,127}));
  connect(THeaWatPriRet, staPla.THeaWatPriRet) annotation (Line(points={{-280,20},
          {-242,20},{-242,146},{-212,146}},     color={0,0,127}));
  connect(repTSet1.y, TChiHeaSupSet.u3) annotation (Line(points={{-118,80},{
          -106,80},{-106,92},{-102,92}}, color={0,0,127}));
  connect(repTSet.y, TChiHeaSupSet.u1) annotation (Line(points={{-118,120},{
          -106,120},{-106,108},{-102,108}}, color={0,0,127}));
  connect(staPla.y1CooChiHea, TChiHeaSupSet.u2) annotation (Line(points={{-188,148},
          {-110,148},{-110,100},{-102,100}},      color={255,0,255}));
  connect(TChiHeaSupSet.y, TChiHeaSet)
    annotation (Line(points={{-78,100},{280,100}}, color={0,0,127}));
  connect(TChiWatSupSet, repTSet.u) annotation (Line(points={{-280,260},{-254,
          260},{-254,120},{-142,120}}, color={0,0,127}));
  connect(THeaWatSupSet, repTSet1.u) annotation (Line(points={{-280,220},{-250,
          220},{-250,80},{-142,80}}, color={0,0,127}));
  connect(mConWatHexCoo_flow, modConLoo.mConWatHexCoo_flow) annotation (Line(
        points={{-280,-240},{-248,-240},{-248,-154},{-172,-154}},
                                                                color={0,0,127}));
  connect(mConWatOutTan_flow, modConLoo.mConWatOutTan_flow) annotation (Line(
        points={{-280,-260},{-234,-260},{-234,-160},{-172,-160}},
                                                                color={0,0,127}));
  connect(TTan, modConLoo.TTan) annotation (Line(points={{-280,0},{-180,0},{-180,
          -166},{-172,-166}},    color={0,0,127}));
  connect(TTan, cycTan.TTan) annotation (Line(points={{-280,0},{-180,0},{-180,-126},
          {-172,-126}},   color={0,0,127}));
  connect(mConWatOutTan_flow, cycTan.mConWatOutTan_flow) annotation (Line(
        points={{-280,-260},{-226,-260},{-226,-114},{-172,-114}},
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
    annotation (Line(points={{-280,-40},{-212,-40},{-212,26},{-82,26}},
                                                 color={0,0,127}));
  connect(mConChi_flow, valCmd.mConChi_flow) annotation (Line(points={{-280,-60},
          {-256,-60},{-256,24.2},{-82,24.2}},
                                           color={0,0,127}));
  connect(mEvaChiHea_flow, valCmd.mEvaChiHea_flow) annotation (Line(points={{-280,
          -80},{-254,-80},{-254,22.2},{-82,22.2}},   color={0,0,127}));
  connect(mConChiHea_flow, valCmd.mConChiHea_flow) annotation (Line(points={{-280,
          -100},{-252,-100},{-252,20.2},{-82,20.2}}, color={0,0,127}));
  connect(staPla.y1Chi, valCmd.u1Chi) annotation (Line(points={{-188,164},{-164,
          164},{-164,38},{-82,38}},color={255,0,255}));
  connect(staPla.y1ChiHea, valCmd.u1ChiHea) annotation (Line(points={{-188,154},
          {-166,154},{-166,36},{-82,36}},color={255,0,255}));
  connect(staPla.y1CooChiHea, valCmd.u1CooChiHea) annotation (Line(points={{-188,
          148},{-168,148},{-168,34},{-82,34}},     color={255,0,255}));
  connect(staPla.y1HeaCooChiHea, valCmd.u1HeaCooChiHea) annotation (Line(points={{-188,
          142},{-170,142},{-170,32},{-82,32}},      color={255,0,255}));
  connect(valCmd.yValEvaChi, yValEvaChi) annotation (Line(points={{-58,30},{0,
          30},{0,320},{280,320}}, color={0,0,127}));
  connect(valCmd.yValConChi, yValConChi) annotation (Line(points={{-58,28},{2,
          28},{2,300},{280,300}}, color={0,0,127}));
  connect(valCmd.yValConSwiChiHea, yValConSwiChiHea) annotation (Line(points={{-58,20},
          {280,20}},                           color={0,0,127}));
  connect(valCmd.yValEvaSwiChiHea, yValEvaSwiHea) annotation (Line(points={{-58,22},
          {240,22},{240,40},{280,40}},     color={0,0,127}));
  connect(valCmd.yValConChiHea, yValConChiHea) annotation (Line(points={{-58,24},
          {238,24},{238,60},{280,60}}, color={0,0,127}));
  connect(valCmd.yValEvaChiHea, yValEvaChiHea) annotation (Line(points={{-58,26},
          {236,26},{236,80},{280,80}}, color={0,0,127}));
  connect(dpConWatEva, ctlPumConWatEva.u_m) annotation (Line(points={{-280,-380},
          {-240,-380},{-240,-212},{200,-212},{200,-192}}, color={0,0,127}));
  connect(dpConWatCon, ctlPumConWatCon.u_m) annotation (Line(points={{-280,-360},
          {-242,-360},{-242,-150},{200,-150},{200,-132}}, color={0,0,127}));
  connect(cycTan.idxCycTan, valCmd.idxCycTan) annotation (Line(points={{-148,
          -120},{-140,-120},{-140,16.2},{-82,16.2}},
                                                  color={255,127,0}));
  connect(modConLoo.mode, valCmd.mode) annotation (Line(points={{-148,-160},{
          -144,-160},{-144,18.2},{-82,18.2}},
                                           color={255,127,0}));
  connect(TChiWatSup, staPla.TChiWatSup) annotation (Line(points={{-280,100},{-246,
          100},{-246,162},{-212,162}},              color={0,0,127}));
  connect(dpChiWatSet, staPla.dpChiWatSet) annotation (Line(points={{-280,180},{
          -246,180},{-246,158},{-212,158}},          color={0,0,127}));
  connect(dpChiWat, staPla.dpChiWat) annotation (Line(points={{-280,-320},{-238,
          -320},{-238,156},{-212,156}},         color={0,0,127}));
  connect(valCmd.y1PumChiWat,staPumChiWat.y1Ena)  annotation (Line(points={{-58,38},
          {-4,38},{-4,266},{58,266}},     color={255,0,255}));
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
  connect(valCmd.y1PumHeaWat,staPumHeaWat.y1Ena)  annotation (Line(points={{-58,36},
          {74,36},{74,6},{78,6}},     color={255,0,255}));
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
  connect(valCmd.y1PumConWatEva,staPumConWatEva.y1Ena)  annotation (Line(points={{-58,32},
          {-4,32},{-4,-114},{78,-114}},          color={255,0,255}));
  connect(valCmd.y1PumConWatCon,staPumConWatCon.y1Ena)  annotation (Line(points={{-58,34},
          {-2,34},{-2,-74},{78,-74}},                            color={255,0,
          255}));
  connect(staPla.y1Chi, y1Chi) annotation (Line(points={{-188,164},{-8,164},{-8,
          340},{280,340}}, color={255,0,255}));
  connect(staPla.y1ChiHea, y1ChiHea) annotation (Line(points={{-188,154},{6,154},
          {6,160},{280,160}}, color={255,0,255}));
  connect(staPla.y1CooChiHea, y1CooChiHea) annotation (Line(points={{-188,148},{
          6,148},{6,140},{280,140}},   color={255,0,255}));
  connect(staPla.y1HeaCooChiHea, y1HeaCooChiHea) annotation (Line(points={{-188,
          142},{4,142},{4,120},{280,120}},   color={255,0,255}));
  connect(staPla.y1ChiHea, dirHeaCoo.y1) annotation (Line(points={{-188,154},{-166,
          154},{-166,-10.4},{-122,-10.4}},      color={255,0,255}));
  connect(staPla.y1HeaCooChiHea, dirHeaCoo.y1HeaCoo) annotation (Line(points={{-188,
          142},{-170,142},{-170,-16},{-122,-16},{-122,-15.2}},      color={255,
          0,255}));
  connect(TChiWatSupSet, dirHeaCoo.TChiWatSupSet) annotation (Line(points={{
          -280,260},{-254,260},{-254,-20},{-122,-20}}, color={0,0,127}));
  connect(TEvaLvgChiHea, dirHeaCoo.TEvaLvg) annotation (Line(points={{-280,60},
          {-232,60},{-232,-24.8},{-122,-24.8}}, color={0,0,127}));
  connect(THeaWatPriRet, dirHeaCoo.THeaWatPriRet) annotation (Line(points={{-280,20},
          {-242,20},{-242,-29.6},{-122,-29.6}},          color={0,0,127}));
  connect(dirHeaCoo.mEvaChiSet_flow, valCmd.mEvaChiSet_flow) annotation (Line(
        points={{-98,-12.8},{-90,-12.8},{-90,30},{-82,30}}, color={0,0,127}));
  connect(dirHeaCoo.mEvaChiHeaSet_flow, valCmd.mEvaChiHeaSet_flow) annotation (
      Line(points={{-98,-20},{-86,-20},{-86,28},{-82,28}}, color={0,0,127}));
  connect(repCoo1.y, repCoo.u) annotation (Line(points={{22,-320},{40,-320},{40,
          -300},{58,-300}}, color={255,0,255}));
  connect(repCoo1.y, cvtSpeCoo.u)
    annotation (Line(points={{22,-320},{88,-320}}, color={255,0,255}));
  connect(repCoo1.y, repPumCoo.u) annotation (Line(points={{22,-320},{40,-320},
          {40,-340},{58,-340}}, color={255,0,255}));
  connect(dpHeaWatSet, staPla.dpHeaWatSet) annotation (Line(points={{-280,140},{
          -240,140},{-240,144},{-212,144}}, color={0,0,127}));
  connect(dpHeaWat, staPla.dpHeaWat) annotation (Line(points={{-280,-340},{-234,
          -340},{-234,142},{-212,142}}, color={0,0,127}));
  connect(THeaWatSup, staPla.THeaWatSup) annotation (Line(points={{-280,40},{-230,
          40},{-230,148},{-212,148}}, color={0,0,127}));
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
