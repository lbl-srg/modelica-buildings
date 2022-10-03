within Buildings.Obsolete.Examples.VAVReheat.BaseClasses;
model Guideline36
  "Variable air volume flow system with terminal reheat and Guideline 36 control sequence serving five thermal zones"
  extends Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC(
    damOut(
      dpDamper_nominal=10,
      dpFixed_nominal=10),
    amb(nPorts=3));

  parameter Modelica.Units.SI.VolumeFlowRate minZonPriFlo[numZon]=conVAV.VDisSetMin_flow
    "Minimum expected zone primary flow rate";
  parameter Modelica.Units.SI.Time samplePeriod=120
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";
  parameter Modelica.Units.SI.PressureDifference dpDisRetMax(displayUnit="Pa")=
       40 "Maximum return fan discharge static pressure setpoint";

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAV[numZon](
    V_flow_nominal=mCooVAV_flow_nominal/1.2,
    AFlo=AFlo,
    each final samplePeriod=samplePeriod,
    VDisSetMin_flow={max(1.5*VZonOA_flow_nominal[i], 0.15*mCooVAV_flow_nominal[
        i]/1.2) for i in 1:numZon},
    VDisHeaSetMax_flow=mHeaVAV_flow_nominal/1.2)
    "Controller for terminal unit"
    annotation (Placement(transformation(extent={{620,100},{640,120}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum TZonResReq(nin=numZon)
    "Number of zone temperature requests"
    annotation (Placement(transformation(extent={{300,360},{320,380}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum PZonResReq(nin=numZon)
    "Number of zone pressure requests"
    annotation (Placement(transformation(extent={{300,320},{320,340}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFreStaPum
    "Switch for freeze stat of pump"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFreHeaCoi(final k=1)
    "Flow rate signal for heating coil when freeze stat is on"
    annotation (Placement(transformation(extent={{-40,-106},{-20,-86}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU(
    kMinOut=0.03,
    final pMaxSet=410,
    final yFanMin=yFanMin,
    final VPriSysMax_flow=mAir_flow_nominal/1.2,
    final peaSysPop=divP*sum({ratP_A*AFlo[i] for i in 1:numZon}))
    "AHU controller"
    annotation (Placement(transformation(extent={{340,512},{420,640}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
    zonOutAirSet[numZon](
    final AFlo=AFlo,
    final have_occSen=fill(false, numZon),
    final have_winSen=fill(false, numZon),
    final desZonPop={ratP_A*AFlo[i] for i in 1:numZon},
    final minZonPriFlo=minZonPriFlo)
    "Zone level calculation of the minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{220,580},{240,600}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(final numZon=numZon) "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{280,570},{300,590}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(final nout=numZon)
    "Replicate design uncorrected minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{464,580},{484,600}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(final nout=numZon)
    "Replicate signal whether the outdoor airflow is required"
    annotation (Placement(transformation(extent={{464,550},{484,570}})));

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus zonSta[numZon]
    "Check zone temperature status"
    annotation (Placement(transformation(extent={{-220,268},{-200,296}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus zonGroSta(
    final numZon=numZon) "Check zone group status according to the zones status"
    annotation (Placement(transformation(extent={{-160,260},{-140,300}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    opeModSel(final numZon=numZon)
    annotation (Placement(transformation(extent={{-100,284},{-80,316}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures
    TZonSet[numZon](
    final have_occSen=fill(false, numZon),
    final have_winSen=fill(false, numZon))  "Zone setpoint"
    annotation (Placement(transformation(extent={{-100,180},{-80,208}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warCooTim[numZon](
    final k=fill(1800, numZon)) "Warm up and cool down time"
    annotation (Placement(transformation(extent={{-300,370},{-280,390}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant falSta[numZon](
    final k=fill(false, numZon))
    "All windows are closed, no zone has override switch"
    annotation (Placement(transformation(extent={{-300,330},{-280,350}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(nout=numZon)
    "Assume all zones have same occupancy schedule"
    annotation (Placement(transformation(extent={{-200,-190},{-180,-170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(nout=numZon)
    "Assume all zones have same occupancy schedule"
    annotation (Placement(transformation(extent={{-200,-150},{-180,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLimLev[numZon](
    final  k=fill(0, numZon)) "Demand limit level, assumes to be 0"
    annotation (Placement(transformation(extent={{-300,230},{-280,250}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=numZon)
    "All zones in same operation mode"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));

  Buildings.Examples.VAVReheat.BaseClasses.Controls.SystemHysteresis sysHysHea
    "Hysteresis and delay to switch heating on and off"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Examples.VAVReheat.BaseClasses.Controls.SystemHysteresis sysHysCoo
    "Hysteresis and delay to switch cooling on and off"
    annotation (Placement(transformation(extent={{20,-250},{40,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFreStaVal
    "Switch for freeze stat of valve"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Buildings.Examples.VAVReheat.BaseClasses.Controls.FreezeStat freSta(
      lockoutTime=3600) "Freeze stat for heating coil"
    annotation (Placement(transformation(extent={{-90,-120},{-70,-100}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TSupAHU(final nout=
        numZon) "Replicate AHU supply temperature" annotation (Placement(
        transformation(
        extent={{-11,-11},{11,11}},
        rotation=0,
        origin={511,91})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator opeMod(final nout=
        numZon) "Replicate operation mode" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={370,60})));
  Buildings.Controls.OBC.Utilities.OptimalStart optSta[numZon](
    each computeHeating=true,
    each computeCooling=true) "Optimal startup"
    annotation (Placement(transformation(extent={{-300,400},{-280,420}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator tZonNexOcc(nout=
        numZon) "Next occupancy for each zone"
    annotation (Placement(transformation(extent={{-340,372},{-320,392}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonSetHea[numZon](
    each k(
      unit="K",
      displayUnit="degC") = 293.15) "Heating setpoint for zone air"
    annotation (Placement(transformation(extent={{-340,460},{-320,480}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonSetCoo[numZon](
    each k(
      unit="K",
      displayUnit="degC") = 297.15) "Cooling setpoint for zone air"
    annotation (Placement(transformation(extent={{-340,420},{-320,440}})));
equation
  connect(conVAV.TDis, VAVBox.TSup) annotation (Line(points={{618,105},{608,105},
          {608,86},{774,86},{774,48},{762,48}},
                                           color={0,0,127}));
  connect(conVAV.yZonTemResReq, TZonResReq.u) annotation (Line(points={{642,
          111.667},{644,111.667},{644,218},{282,218},{282,370},{298,370}},
                                                             color={255,127,0}));
  connect(conVAV.yZonPreResReq, PZonResReq.u) annotation (Line(points={{642,
          108.333},{650,108.333},{650,228},{290,228},{290,330},{298,330}},
                                                             color={255,127,0}));
  connect(conVAV.VDis_flow, VAVBox.VSup_flow) annotation (Line(points={{618,
          108.333},{618,108},{614,108},{614,94},{778,94},{778,56},{762,56}},
                                                    color={0,0,127}));
  connect(yFreHeaCoi.y, swiFreStaPum.u1) annotation (Line(points={{-18,-96},{10,
          -96},{10,-102},{18,-102}}, color={0,0,127}));
  connect(zonToSys.ySumDesZonPop, conAHU.sumDesZonPop) annotation (Line(points={{302,589},
          {308,589},{308,609.778},{336,609.778}},           color={0,0,127}));
  connect(zonToSys.VSumDesPopBreZon_flow, conAHU.VSumDesPopBreZon_flow)
    annotation (Line(points={{302,586},{310,586},{310,604.444},{336,604.444}},
        color={0,0,127}));
  connect(zonToSys.VSumDesAreBreZon_flow, conAHU.VSumDesAreBreZon_flow)
    annotation (Line(points={{302,583},{312,583},{312,599.111},{336,599.111}},
        color={0,0,127}));
  connect(zonToSys.yDesSysVenEff, conAHU.uDesSysVenEff) annotation (Line(points={{302,580},
          {314,580},{314,593.778},{336,593.778}},           color={0,0,127}));
  connect(zonToSys.VSumUncOutAir_flow, conAHU.VSumUncOutAir_flow) annotation (
      Line(points={{302,577},{316,577},{316,588.444},{336,588.444}}, color={0,0,
          127}));
  connect(zonToSys.VSumSysPriAir_flow, conAHU.VSumSysPriAir_flow) annotation (
      Line(points={{302,571},{318,571},{318,583.111},{336,583.111}}, color={0,0,
          127}));
  connect(zonToSys.uOutAirFra_max, conAHU.uOutAirFra_max) annotation (Line(
        points={{302,574},{320,574},{320,577.778},{336,577.778}}, color={0,0,127}));
  connect(zonOutAirSet.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc) annotation (Line(
        points={{242,599},{270,599},{270,588},{278,588}},     color={0,0,127}));
  connect(zonOutAirSet.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow)
    annotation (Line(points={{242,596},{268,596},{268,586},{278,586}},
                                                     color={0,0,127}));
  connect(zonOutAirSet.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow)
    annotation (Line(points={{242,593},{266,593},{266,584},{278,584}},
        color={0,0,127}));
  connect(zonOutAirSet.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra) annotation (
     Line(points={{242,590},{264,590},{264,578},{278,578}},     color={0,0,127}));
  connect(zonOutAirSet.VUncOutAir_flow, zonToSys.VUncOutAir_flow) annotation (
      Line(points={{242,587},{262,587},{262,576},{278,576}},     color={0,0,127}));
  connect(zonOutAirSet.yPriOutAirFra, zonToSys.uPriOutAirFra)
    annotation (Line(points={{242,584},{260,584},{260,574},{278,574}},
                                                     color={0,0,127}));
  connect(zonOutAirSet.VPriAir_flow, zonToSys.VPriAir_flow) annotation (Line(
        points={{242,581},{258,581},{258,572},{278,572}},     color={0,0,127}));
  connect(conAHU.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{424,586.667},{440,586.667},{440,468},{270,468},{270,582},{278,
          582}},
        color={0,0,127}));
  connect(conAHU.VDesUncOutAir_flow, reaRep1.u) annotation (Line(points={{424,
          597.333},{440,597.333},{440,590},{462,590}},
                                              color={0,0,127}));
  connect(reaRep1.y, zonOutAirSet.VUncOut_flow_nominal) annotation (Line(points={{486,590},
          {490,590},{490,464},{210,464},{210,581},{218,581}},          color={0,
          0,127}));
  connect(conAHU.yReqOutAir, booRep1.u) annotation (Line(points={{424,565.333},
          {444,565.333},{444,560},{462,560}},color={255,0,255}));
  connect(booRep1.y, zonOutAirSet.uReqOutAir) annotation (Line(points={{486,560},
          {496,560},{496,460},{206,460},{206,593},{218,593}}, color={255,0,255}));
  connect(TZonResReq.y, conAHU.uZonTemResReq) annotation (Line(points={{322,370},
          {326,370},{326,526.222},{336,526.222}}, color={255,127,0}));
  connect(PZonResReq.y, conAHU.uZonPreResReq) annotation (Line(points={{322,330},
          {330,330},{330,520.889},{336,520.889}}, color={255,127,0}));
  connect(TOut.y, conAHU.TOut) annotation (Line(points={{-279,180},{-260,180},{
          -260,625.778},{336,625.778}},
                                   color={0,0,127}));
  connect(dpDisSupFan.p_rel, conAHU.ducStaPre) annotation (Line(points={{311,0},
          {160,0},{160,620.444},{336,620.444}}, color={0,0,127}));
  connect(TSup.T, conAHU.TSup) annotation (Line(points={{340,-29},{340,-20},{
          152,-20},{152,567.111},{336,567.111}},
                                             color={0,0,127}));
  connect(TRet.T, conAHU.TOutCut) annotation (Line(points={{100,151},{100,
          561.778},{336,561.778}},
                          color={0,0,127}));
  connect(VOut1.V_flow, conAHU.VOut_flow) annotation (Line(points={{-80,-29},{
          -80,-20},{-60,-20},{-60,546},{138,546},{138,545.778},{336,545.778}},
                                       color={0,0,127}));
  connect(TMix.T, conAHU.TMix) annotation (Line(points={{40,-29},{40,538.667},{
          336,538.667}},
                     color={0,0,127}));
  connect(conAHU.yOutDamPos, damOut.y) annotation (Line(points={{424,522.667},{
          448,522.667},{448,36},{-40,36},{-40,-28}},
                                                 color={0,0,127}));
  connect(conAHU.yRetDamPos, damRet.y) annotation (Line(points={{424,533.333},{
          442,533.333},{442,40},{-20,40},{-20,-10},{-12,-10}},
                                                     color={0,0,127}));
  connect(conAHU.ySupFanSpe, fanSup.y) annotation (Line(points={{424,618.667},{
          432,618.667},{432,-14},{310,-14},{310,-28}},
                                                   color={0,0,127}));
  connect(VAVBox.y_actual, conVAV.yDam_actual) annotation (Line(points={{762,40},
          {780,40},{780,90},{612,90},{612,106.667},{618,106.667}},
                                                    color={0,0,127}));
  connect(zonSta.yCooTim, zonGroSta.uCooTim) annotation (Line(points={{-198,295},
          {-176,295},{-176,291},{-162,291}}, color={0,0,127}));
  connect(zonSta.yWarTim, zonGroSta.uWarTim) annotation (Line(points={{-198,293},
          {-178,293},{-178,289},{-162,289}}, color={0,0,127}));
  connect(zonSta.yOccHeaHig, zonGroSta.uOccHeaHig) annotation (Line(points={{-198,
          288},{-180,288},{-180,285},{-162,285}}, color={255,0,255}));
  connect(zonSta.yHigOccCoo, zonGroSta.uHigOccCoo)
    annotation (Line(points={{-198,283},{-162,283}}, color={255,0,255}));
  connect(zonSta.THeaSetOff, zonGroSta.THeaSetOff) annotation (Line(points={{-198,
          280},{-182,280},{-182,277},{-162,277}}, color={0,0,127}));
  connect(zonSta.yUnoHeaHig, zonGroSta.uUnoHeaHig) annotation (Line(points={{-198,
          278},{-188,278},{-188,279},{-162,279}}, color={255,0,255}));
  connect(zonSta.yEndSetBac, zonGroSta.uEndSetBac) annotation (Line(points={{-198,
          276},{-188,276},{-188,275},{-162,275}}, color={255,0,255}));
  connect(zonSta.TCooSetOff, zonGroSta.TCooSetOff) annotation (Line(points={{-198,
          273},{-190,273},{-190,269},{-162,269}}, color={0,0,127}));
  connect(zonSta.yHigUnoCoo, zonGroSta.uHigUnoCoo)
    annotation (Line(points={{-198,271},{-162,271}}, color={255,0,255}));
  connect(zonSta.yEndSetUp, zonGroSta.uEndSetUp) annotation (Line(points={{-198,
          269},{-192,269},{-192,267},{-162,267}}, color={255,0,255}));
  connect(falSta.y, zonGroSta.uWin) annotation (Line(points={{-278,340},{-172,
          340},{-172,261},{-162,261}}, color={255,0,255}));
  connect(occSch.tNexOcc, reaRep.u) annotation (Line(points={{-299,-204},{-236,-204},
          {-236,-180},{-202,-180}},       color={0,0,127}));
  connect(reaRep.y, zonGroSta.tNexOcc) annotation (Line(points={{-178,-180},{-164,
          -180},{-164,295},{-162,295}}, color={0,0,127}));
  connect(occSch.occupied, booRep.u) annotation (Line(points={{-299,-216},{-220,
          -216},{-220,-140},{-202,-140}}, color={255,0,255}));
  connect(booRep.y, zonGroSta.uOcc) annotation (Line(points={{-178,-140},{-166,
          -140},{-166,297},{-162,297}}, color={255,0,255}));
  connect(falSta.y, zonGroSta.zonOcc) annotation (Line(points={{-278,340},{-172,
          340},{-172,299},{-162,299}}, color={255,0,255}));
  connect(zonGroSta.uGroOcc, opeModSel.uOcc) annotation (Line(points={{-138,299},
          {-136,299},{-136,314},{-102,314}}, color={255,0,255}));
  connect(zonGroSta.nexOcc, opeModSel.tNexOcc) annotation (Line(points={{-138,
          297},{-134,297},{-134,312},{-102,312}}, color={0,0,127}));
  connect(zonGroSta.yCooTim, opeModSel.maxCooDowTim) annotation (Line(points={{
          -138,293},{-132,293},{-132,310},{-102,310}}, color={0,0,127}));
  connect(zonGroSta.yWarTim, opeModSel.maxWarUpTim) annotation (Line(points={{-138,
          291},{-128,291},{-128,306},{-102,306}}, color={0,0,127}));
  connect(zonGroSta.yOccHeaHig, opeModSel.uOccHeaHig) annotation (Line(points={
          {-138,287},{-126,287},{-126,304},{-102,304}}, color={255,0,255}));
  connect(zonGroSta.yHigOccCoo, opeModSel.uHigOccCoo) annotation (Line(points={
          {-138,285},{-130,285},{-130,308},{-102,308}}, color={255,0,255}));
  connect(zonGroSta.yColZon, opeModSel.totColZon) annotation (Line(points={{-138,
          282},{-122,282},{-122,300},{-102,300}}, color={255,127,0}));
  connect(zonGroSta.ySetBac, opeModSel.uSetBac) annotation (Line(points={{-138,280},
          {-120,280},{-120,298},{-102,298}},      color={255,0,255}));
  connect(zonGroSta.yEndSetBac, opeModSel.uEndSetBac) annotation (Line(points={{-138,
          278},{-118,278},{-118,296},{-102,296}},       color={255,0,255}));
  connect(zonGroSta.TZonMin, opeModSel.TZonMin) annotation (Line(points={{-138,265},
          {-114,265},{-114,292},{-102,292}},      color={0,0,127}));
  connect(zonGroSta.yHotZon, opeModSel.totHotZon) annotation (Line(points={{-138,
          275},{-112,275},{-112,290},{-102,290}}, color={255,127,0}));
  connect(zonGroSta.ySetUp, opeModSel.uSetUp) annotation (Line(points={{-138,273},
          {-110,273},{-110,288},{-102,288}},      color={255,0,255}));
  connect(zonGroSta.yEndSetUp, opeModSel.uEndSetUp) annotation (Line(points={{-138,
          271},{-108,271},{-108,286},{-102,286}}, color={255,0,255}));
  connect(zonSta.THeaSetOn, TZonSet.TZonHeaSetOcc) annotation (Line(points={{
          -198,290},{-186,290},{-186,198},{-102,198}}, color={0,0,127}));
  connect(zonSta.THeaSetOff, TZonSet.TZonHeaSetUno) annotation (Line(points={{
          -198,280},{-182,280},{-182,196},{-102,196}}, color={0,0,127}));
  connect(zonSta.TCooSetOn, TZonSet.TZonCooSetOcc) annotation (Line(points={{
          -198,285},{-184,285},{-184,203},{-102,203}}, color={0,0,127}));
  connect(zonSta.TCooSetOff, TZonSet.TZonCooSetUno) annotation (Line(points={{
          -198,273},{-190,273},{-190,201},{-102,201}}, color={0,0,127}));
  connect(demLimLev.y, TZonSet.uCooDemLimLev) annotation (Line(points={{-278,
          240},{-220,240},{-220,188},{-102,188}}, color={255,127,0}));
  connect(demLimLev.y, TZonSet.uHeaDemLimLev) annotation (Line(points={{-278,
          240},{-220,240},{-220,186},{-102,186}}, color={255,127,0}));
  connect(opeModSel.yOpeMod, conAHU.uOpeMod) annotation (Line(points={{-78,300},
          {-18,300},{-18,531.556},{336,531.556}}, color={255,127,0}));
  connect(TZonSet[1].TZonHeaSet, conAHU.TZonHeaSet) annotation (Line(points={{-78,194},
          {-36,194},{-36,636.444},{336,636.444}},          color={0,0,127}));
  connect(TZonSet[1].TZonCooSet, conAHU.TZonCooSet) annotation (Line(points={{-78,202},
          {-26,202},{-26,631.111},{336,631.111}},          color={0,0,127}));
  connect(TZonSet.TZonHeaSet, conVAV.TZonHeaSet) annotation (Line(points={{-78,194},
          {608,194},{608,118.333},{618,118.333}},
                                               color={0,0,127}));
  connect(TZonSet.TZonCooSet, conVAV.TZonCooSet) annotation (Line(points={{-78,202},
          {600,202},{600,116.667},{618,116.667}},
                                               color={0,0,127}));
  connect(opeModSel.yOpeMod, intRep.u) annotation (Line(points={{-78,300},{-18,
          300},{-18,250},{-160,250},{-160,230},{-142,230}}, color={255,127,0}));
  connect(intRep.y, TZonSet.uOpeMod) annotation (Line(points={{-118,230},{-110,
          230},{-110,207},{-102,207}}, color={255,127,0}));
  connect(zonGroSta.yOpeWin, opeModSel.uOpeWin) annotation (Line(points={{-138,261},
          {-124,261},{-124,302},{-102,302}}, color={255,127,0}));
  connect(VAVBox.yVAV, conVAV.yDam) annotation (Line(points={{716,56},{688,56},
          {688,118.333},{642,118.333}},
                           color={0,0,127}));
  connect(VAVBox.yHea, conVAV.yVal) annotation (Line(points={{716,46},{680,46},
          {680,115},{642,115}},
                         color={0,0,127}));
  connect(freSta.y, swiFreStaPum.u2) annotation (Line(points={{-68,-110},{18,-110}},
                                      color={255,0,255}));
  connect(sysHysCoo.y, valCooCoi.y) annotation (Line(points={{42,-240},{160,-240},
          {160,-210},{166,-210},{166,-210},{208,-210}},       color={0,0,127}));
  connect(sysHysCoo.yPum, pumCooCoi.y) annotation (Line(points={{42,-247},{240,
          -247},{240,-120},{192,-120},{192,-120}}, color={0,0,127}));
  connect(conAHU.yCoo, sysHysCoo.u) annotation (Line(points={{424,544},{424,546},
          {452,546},{452,-262},{0,-262},{0,-240},{18,-240}}, color={0,0,127}));
  connect(conAHU.yHea, sysHysHea.u) annotation (Line(points={{424,554.667},{456,
          554.667},{456,-262},{-56,-262},{-56,-140},{-42,-140}}, color={0,0,127}));
  connect(sysHysHea.sysOn, conAHU.ySupFan) annotation (Line(points={{-42,-134},
          {-62,-134},{-62,-272},{458,-272},{458,629.333},{424,629.333}}, color=
          {255,0,255}));
  connect(swiFreStaPum.y, pumHeaCoi.y) annotation (Line(points={{42,-110},{80,
          -110},{80,-140},{152,-140},{152,-120},{140,-120}}, color={0,0,127}));
  connect(swiFreStaVal.u1, yFreHeaCoi.y) annotation (Line(points={{18,-142},{10,
          -142},{10,-96},{-18,-96}}, color={0,0,127}));
  connect(sysHysHea.y, swiFreStaVal.u3) annotation (Line(points={{-18,-140},{
          -10,-140},{-10,-158},{18,-158}}, color={0,0,127}));
  connect(sysHysHea.yPum, swiFreStaPum.u3) annotation (Line(points={{-18,-147},
          {-6,-147},{-6,-118},{18,-118}}, color={0,0,127}));
  connect(freSta.y, swiFreStaVal.u2) annotation (Line(points={{-68,-110},{0,-110},
          {0,-150},{18,-150}},                          color={255,0,255}));
  connect(swiFreStaVal.y, valHeaCoi.y) annotation (Line(points={{42,-150},{60,-150},
          {60,-210},{116,-210}},      color={0,0,127}));
  connect(sysHysCoo.sysOn, conAHU.ySupFan) annotation (Line(points={{18,-234},{
          -62,-234},{-62,-272},{458,-272},{458,629.333},{424,629.333}}, color={
          255,0,255}));
  connect(zonGroSta.TZon, TRoo) annotation (Line(points={{-162,263},{-208,263},{
          -208,262},{-256,262},{-256,320},{-400,320}}, color={0,0,127}));
  connect(zonSta.TZon, TRoo) annotation (Line(points={{-222,274},{-256,274},{-256,
          320},{-400,320}}, color={0,0,127}));
  connect(zonOutAirSet.TZon, TRoo) annotation (Line(points={{218,590},{-220,590},
          {-220,320},{-400,320}}, color={0,0,127}));
  connect(TMix.T, freSta.u) annotation (Line(points={{40,-29},{40,-20},{20,-20},
          {20,-70},{-100,-70},{-100,-110},{-92,-110}}, color={0,0,127}));
  connect(TRet.port_b, amb.ports[3]) annotation (Line(points={{90,140},{-100,140},
          {-100,-45},{-114,-45}}, color={0,127,255}));
  connect(TRoo, conVAV.TZon) annotation (Line(
      points={{-400,320},{-216,320},{-216,584},{192,584},{192,110},{618,110}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(zonOutAirSet.VDis_flow, VAVBox.VSup_flow) annotation (Line(points={{218,584},
          {186,584},{186,402},{778,402},{778,56},{762,56}},      color={0,0,127}));
  connect(VAVBox.TSup, zonOutAirSet.TDis) annotation (Line(points={{762,48},{
          774,48},{774,398},{180,398},{180,588},{218,588},{218,587}},
                                                                  color={0,0,127}));
  connect(TSup.T, TSupAHU.u) annotation (Line(points={{340,-29},{340,-20},{472,
          -20},{472,91},{497.8,91}},
                             color={0,0,127}));
  connect(TSupAHU.y, conVAV.TSupAHU)
    annotation (Line(points={{524.2,91},{536,91},{536,104},{618,104},{618,
          103.333}},                                      color={0,0,127}));
  connect(opeModSel.yOpeMod, opeMod.u) annotation (Line(points={{-78,300},{-18,300},
          {-18,60},{358,60}}, color={255,127,0}));
  connect(opeMod.y, conVAV.uOpeMod) annotation (Line(points={{382,60},{600,60},
          {600,101.667},{618,101.667}},
                             color={255,127,0}));
  connect(optSta.TZon, TRoo) annotation (Line(points={{-302,406},{-368,406},{-368,
          320},{-400,320}}, color={0,0,127}));
  connect(optSta.tOpt, zonSta.cooDowTim) annotation (Line(points={{-278,414},{-252,
          414},{-252,290},{-222,290}}, color={0,0,127}));
  connect(optSta.tOpt, zonSta.warUpTim) annotation (Line(points={{-278,414},{
          -252,414},{-252,286},{-222,286}},
                                       color={0,0,127}));
  connect(occSch.tNexOcc, tZonNexOcc.u) annotation (Line(points={{-299,-204},{-278,
          -204},{-278,-140},{-356,-140},{-356,382},{-342,382}}, color={0,0,127}));
  connect(tZonNexOcc.y, optSta.tNexOcc) annotation (Line(points={{-318,382},{-310,
          382},{-310,402},{-302,402}}, color={0,0,127}));
  connect(optSta.TSetZonCoo, TZonSetCoo.y) annotation (Line(points={{-302,414},
          {-314,414},{-314,430},{-318,430}}, color={0,0,127}));
  connect(optSta.TSetZonHea, TZonSetHea.y) annotation (Line(points={{-302,418},
          {-310,418},{-310,470},{-318,470}}, color={0,0,127}));
  annotation (
  defaultComponentName="hvac",
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-320},{1420,
            680}})),
    Documentation(info="<html>
<p>
This model consist of an HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC\">
Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</a>
for a description of the HVAC system.
</p>
<p>
The control is based on ASHRAE Guideline 36, and implemented
using the sequences from the library
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1</a> for
multi-zone VAV systems with economizer. 
The figures below shows the schematic diagram and controls of an HVAC system that supplies 5 zones:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavControlSchematics.png\" border=\"1\"/>
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
Note that this model, because of the frequent time sampling,
has longer computing time than
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
The reason is that the time integrator cannot make large steps
because it needs to set a time step each time the control samples
its input.
</p>
</html>", revisions="<html>
<ul>
<li>
December 20, 2021, by Michael Wetter:<br/>
Changed parameter declarations and added optimal start up.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2829\">issue #2829</a>.
</li>
<li>
November 9, 2021, by Baptiste:<br/>
Vectorized the terminal boxes to be expanded to any number of zones.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2735\">issue #2735</a>.
</li>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed assignment of parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
September 3, 2021, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2600\">issue #2600</a>.
</li>
<li>
August 24, 2021, by Michael Wetter:<br/>
Changed model to include the hydraulic configurations of the cooling coil,
heating coil and VAV terminal box.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2594\">issue #2594</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class and introduced floor areas in base class
to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 16, 2021, by Michael Wetter:<br/>
Refactored model to implement the economizer dampers directly in
<code>Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</code> rather than through the
model of a mixing box. Since the version of the Guideline 36 model has no exhaust air damper,
this leads to simpler equations.
<br/> This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2454\">issue #2454</a>.
</li>
<li>
March 15, 2021, by David Blum:<br/>
Change component name <code>yOutDam</code> to <code>yExhDam</code>
and update documentation graphic to include relief damper.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2399\">#2399</a>.
</li>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Changed design and control parameters for outdoor air flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>
</li>
<li>
June 15, 2020, by Jianjun Hu:<br/>
Upgraded sequence of specifying operating mode according to G36 official release.
</li>
<li>
April 20, 2020, by Jianjun Hu:<br/>
Exported actual VAV damper position as the measured input data for terminal controller.<br/>
This is
for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">issue #1873</a>
</li>
<li>
March 20, 2020, by Jianjun Hu:<br/>
Replaced the AHU controller with reimplemented one. The new controller separates the
zone level calculation from the system level calculation and does not include
vector-valued calculations.<br/>
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1829\">#1829</a>.
</li>
<li>
March 09, 2020, by Jianjun Hu:<br/>
Replaced the block that calculates operation mode and zone temperature setpoint,
with the new one that does not include vector-valued calculations.<br/>
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1709\">#1709</a>.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{240,172},{220,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{240,172},{220,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,100},{-158,60}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,96},{-2,82}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,-12},{-158,-52}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-78,60},{-118,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-46,96},{-12,62}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,86},{-22,72}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{42,100},{56,60}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{104,100},{118,60}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-138,100},{-124,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,20},{7,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={-98,23},
          rotation=90),
        Line(points={{106,60},{106,-6}}, color={0,0,255}),
        Line(points={{116,60},{116,-6}}, color={0,0,255}),
        Line(points={{106,34},{116,34}},   color={0,0,255}),
        Polygon(
          points={{-5,-4},{3,-4},{-1,4},{-5,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={107,16}),
        Ellipse(
          extent={{100,54},{112,42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{106,54},{100,48},{112,48},{106,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-5,4},{3,4},{-1,-4},{-5,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={107,24}),
        Line(points={{44,60},{44,-6}},   color={0,0,255}),
        Line(points={{54,60},{54,-6}},   color={0,0,255}),
        Line(points={{44,34},{54,34}},     color={0,0,255}),
        Polygon(
          points={{-5,-4},{3,-4},{-1,4},{-5,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={45,16}),
        Ellipse(
          extent={{38,54},{50,42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{44,54},{38,48},{50,48},{44,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-5,4},{3,4},{-1,-4},{-5,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={45,24}),
        Rectangle(
          extent={{320,172},{300,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{280,172},{260,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,172},{380,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{360,172},{340,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{240,20},{220,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{280,20},{260,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{320,20},{300,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{360,20},{340,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,20},{380,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{380,136},{400,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={390,153},
          rotation=90),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={350,153},
          rotation=90),
        Rectangle(
          extent={{340,136},{360,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{300,136},{320,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={310,153},
          rotation=90),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={270,153},
          rotation=90),
        Rectangle(
          extent={{260,136},{280,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{220,136},{240,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={230,153},
          rotation=90)}));
end Guideline36;
