within Buildings.Examples.VAVReheat.BaseClasses;
model Guideline36_RTU
  "Variable air volume flow system with terminal reheat and Guideline 36 control sequence serving five thermal zones"
  extends Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC_RTU(
    damOut(
      dpDamper_nominal=10,
      dpFixed_nominal=10),
    amb(nPorts=3));

//   parameter Modelica.Units.SI.VolumeFlowRate minZonPriFlo[numZon]=conVAV.VDisSetMin_flow
//     "Minimum expected zone primary flow rate";
  parameter Modelica.Units.SI.Time samplePeriod=120
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";
  parameter Modelica.Units.SI.PressureDifference dpDisRetMax(displayUnit="Pa")=40
    "Maximum return fan discharge static pressure setpoint";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warCooTim[numZon](
    final k=fill(1800, numZon))
    "Warm up and cool down time"
    annotation (Placement(transformation(extent={{-300,370},{-280,390}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant falSta[numZon](
    final k=fill(false, numZon))
    "All windows are closed, no zone has override switch"
    annotation (Placement(transformation(extent={{-300,330},{-280,350}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(nout=numZon)
    "Assume all zones have same occupancy schedule"
    annotation (Placement(transformation(extent={{-240,-190},{-220,-170}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(nout=numZon)
    "Assume all zones have same occupancy schedule"
    annotation (Placement(transformation(extent={{-240,-150},{-220,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLimLev[numZon](
    final  k=fill(0, numZon))
    "Demand limit level, assumes to be 0"
    annotation (Placement(transformation(extent={{-300,230},{-280,250}})));

  Buildings.Examples.VAVReheat.BaseClasses.Controls.FreezeStat freSta(
    lockoutTime=3600)
    "Freeze stat for heating coil"
    annotation (Placement(transformation(extent={{-90,-120},{-70,-100}})));

  Buildings.Controls.OBC.Utilities.OptimalStart optSta[numZon](
    each computeHeating=true,
    each computeCooling=true)
    "Optimal startup"
    annotation (Placement(transformation(extent={{-300,400},{-280,420}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator tZonNexOcc(
    nout=numZon)
    "Next occupancy for each zone"
    annotation (Placement(transformation(extent={{-340,372},{-320,392}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOccHeaSet[numZon](
    each k(
      unit="K",
      displayUnit="degC") = 293.15)
    "Occupied heating setpoint for zone air"
    annotation (Placement(transformation(extent={{-340,470},{-320,490}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOccCooSet[numZon](
    each k(
      unit="K",
      displayUnit="degC") = 297.15)
    "Occupied cooling setpoint for zone air"
    annotation (Placement(transformation(extent={{-340,430},{-320,450}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller conAHU(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final venStd=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_5A,
    final freSta=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat,
    final minOADes=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper,
    final buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.BarometricRelief,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final have_perZonRehBox=true,
    final VUncDesOutAir_flow=0.644,
    final VDesTotOutAir_flow=1.107,
    TiVal=800)
    "Air handler unit controller"
    annotation (Placement(transformation(extent={{460,460},{540,636}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.SumZone
    sumZon(
    final nZon=numZon,
    final nGro=1,
    final zonGroMat=[1,1,1,1,1],
    final zonGroMatTra=[1; 1; 1; 1; 1])
    "Sum up zone ventilation setpoints"
    annotation (Placement(transformation(extent={{240,580},{260,600}})));

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.OperationMode opeModSel(
    final nZon=numZon)
    "Operation mode"
    annotation (Placement(transformation(extent={{-40,380},{-20,420}})));

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatus zonSta[numZon]
    "Status of different zone temperature"
    annotation (Placement(transformation(extent={{-220,380},{-200,408}})));

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.GroupStatus groSta(
    final nBuiZon=numZon)
    "Zone group status"
    annotation (Placement(transformation(extent={{-120,380},{-100,420}})));

  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Setpoints TZonSet[numZon](
    final have_occSen=fill(false, numZon),
    final have_winSen=fill(false, numZon),
    final have_locAdj=fill(false, numZon))
    "Zone setpoint temperature"
    annotation (Placement(transformation(extent={{80,240},{100,280}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TUnoHeaSet[numZon](
    each k(
      unit="K",
      displayUnit="degC") = 285.15)
    "Unoccupied heating setpoint for zone air"
    annotation (Placement(transformation(extent={{-340,560},{-320,580}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TUnoCooSet[numZon](
    each k(
      unit="K",
      displayUnit="degC") = 303.15)
    "Unoccupied cooling setpoint for zone air"
    annotation (Placement(transformation(extent={{-340,520},{-320,540}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=numZon)
    "All zones in same operation mode"
    annotation (Placement(transformation(extent={{20,300},{40,320}})));

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Controller conVAV[numZon](
    final venStd=fill(Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1, numZon),
    final have_winSen=fill(false, numZon),
    final have_occSen=fill(false, numZon),
    final have_CO2Sen=fill(false, numZon),
    final VAreBreZon_flow={ratOAFlo_A*AFlo[i] for i in 1:numZon},
    final VPopBreZon_flow={ratP_A*AFlo[i]*ratOAFlo_P for i in 1:numZon},
    final VMin_flow={max(1.5*VZonOA_flow_nominal[i], 0.15*mCooVAV_flow_nominal[i]/1.2) for i in 1:numZon},
    final VCooMax_flow=mCooVAV_flow_nominal/1.2,
    final VHeaMin_flow=fill(0, numZon),
    final VHeaMax_flow=mHeaVAV_flow_nominal/1.2,
    final VAreMin_flow=fill(0, numZon),
    final VOccMin_flow=fill(0, numZon),
    floHys=fill(0.01, numZon))
    "Reheat box control"
    annotation (Placement(transformation(extent={{618,182},{638,222}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TSupAHU(
    final nout=numZon)
    "Replicate AHU supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0, origin={390,80})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TSupAHUSet(
    final nout=numZon)
    "Replicate AHU supply temperature setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0, origin={650,616})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant oveRid[numZon](
    final k=fill(0, numZon))
    "No override flow setpoint, no override damper position"
    annotation (Placement(transformation(extent={{380,160},{400,180}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=numZon)
    "Supply fan commanded on"
    annotation (Placement(transformation(extent={{640,538},{660,558}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant hotWatPla[numZon](
    final k=fill(true, numZon)) "Hot water plant status"
    annotation (Placement(transformation(extent={{500,160},{520,180}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum preRetReq(
    final nin=numZon)
    "Zone pressure reset request"
    annotation (Placement(transformation(extent={{760,260},{780,280}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum temResReq(
    final nin=numZon)
    "Zone temperature reset request"
    annotation (Placement(transformation(extent={{760,210},{780,230}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Reset back to normal after freeze protection"
    annotation (Placement(transformation(extent={{340,350},{360,370}})));

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneGroupSystem ahuMod(
    final nGro=1)
    "AHU operating mode"
    annotation (Placement(transformation(extent={{240,630},{260,650}})));

  Buildings.Controls.OBC.RooftopUnits.Controller RTUCon(
    final nCoiHea=nCoiHea,
    final nCoiCoo=nCoiCoo,
    final uThrCoi1=0.4,
    final minComSpe=0.25,
    final dUHys=0.2)
    "Controller for rooftop units"
    annotation (Placement(transformation(extent={{980,520},{1000,548}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLimLev1(
    final k=0)
    "Demand limit level, assumes to be 0"
    annotation (Placement(transformation(extent={{900,540},{920,560}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nCoiHea](
    final k=1:nCoiHea)
    "Constant integer signal"
    annotation (Placement(transformation(extent={{900,570},{920,590}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nCoiCoo](
    final k=fill(true, nCoiCoo))
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{900,640},{920,660}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[nCoiHea](
    each final uLow=0.5,
    each final uHigh=1)
    "Check if DXs are on"
    annotation (Placement(transformation(extent={{140,-170},{160,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1[nCoiCoo](
    each final uLow=0.5,
    each final uHigh=1)
    "Check if DXs are on"
    annotation (Placement(transformation(extent={{280,-160},{300,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timDXSta[nCoiHea](
    each final t=120)
    "Output DX heating coils proven on signal when status is enabled for two minutes"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nCoiCoo](
    each final realTrue=1,
    each final realFalse=0)
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{1070,534},{1090,554}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul[nCoiCoo]
    "Calculate compressor speed based on product of two inputs"
    annotation (Placement(transformation(extent={{1110,510},{1130,530}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timDXSta1[nCoiCoo](
    each final t=120)
    "Output DX cooling coils proven on signal when status is enabled for two minutes"
    annotation (Placement(transformation(extent={{320,-160},{340,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[2](
    final k={0,0})
    "Constant value"
    annotation (Placement(transformation(extent={{360,454},{380,474}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{180,-110},{200,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
  "Logical Not"
  annotation (Placement(transformation(extent={{280,-110},{300,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{320,-110},{340,-90}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nCoiHea)
    "Logical Multi Or"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nCoiCoo)
    "Logical Multi Or"
    annotation (Placement(transformation(extent={{240,-110},{260,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nCoiHea](
    final k=fill(true, nCoiHea))
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{900,610},{920,630}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[nCoiCoo](
    final k=1:nCoiCoo)
    "Constant integer signal"
    annotation (Placement(transformation(extent={{930,590},{950,610}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant falSta1
                                                            [numZon](final k=
        fill(true, numZon))
    "All windows are closed, no zone has override switch"
    annotation (Placement(transformation(extent={{-300,290},{-280,310}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(k=0)
    annotation (Placement(transformation(extent={{520,6},{540,26}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea5
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{464,-138},{484,-118}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2
    annotation (Placement(transformation(extent={{500,-124},{520,-104}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(each final uLow=0.5,
      each final uHigh=1) "Check if DXs are on"
    annotation (Placement(transformation(extent={{432,-138},{452,-118}})));
equation
  connect(occSch.tNexOcc, reaRep.u) annotation (Line(points={{-299,-204},{-280,
          -204},{-280,-180},{-242,-180}}, color={0,0,127}));
  connect(occSch.occupied, booRep.u) annotation (Line(points={{-299,-216},{-260,
          -216},{-260,-140},{-242,-140}}, color={255,0,255}));
  connect(TMix.T, freSta.u) annotation (Line(points={{40,-29},{40,-20},{20,-20},
          {20,-70},{-100,-70},{-100,-110},{-92,-110}}, color={0,0,127}));
  connect(TRet.port_b, amb.ports[3]) annotation (Line(points={{90,140},{-100,140},
          {-100,-45},{-114,-45}}, color={0,127,255}));
  connect(optSta.TZon, TRoo) annotation (Line(points={{-302,406},{-368,406},{-368,
          320},{-400,320}}, color={0,0,127}));
  connect(occSch.tNexOcc, tZonNexOcc.u) annotation (Line(points={{-299,-204},{
          -280,-204},{-280,-140},{-360,-140},{-360,382},{-342,382}}, color={0,0,127}));
  connect(tZonNexOcc.y, optSta.tNexOcc) annotation (Line(points={{-318,382},{-310,
          382},{-310,402},{-302,402}}, color={0,0,127}));
  connect(optSta.TSetZonCoo,TOccCooSet. y) annotation (Line(points={{-302,414},
          {-314,414},{-314,440},{-318,440}}, color={0,0,127}));
  connect(optSta.TSetZonHea,TOccHeaSet. y) annotation (Line(points={{-302,418},
          {-310,418},{-310,480},{-318,480}}, color={0,0,127}));
  connect(zonSta.yCooTim, groSta.uCooTim) annotation (Line(points={{-198,407},{
          -180,407},{-180,411},{-122,411}}, color={0,0,127}));
  connect(zonSta.yWarTim, groSta.uWarTim) annotation (Line(points={{-198,405},{
          -176,405},{-176,409},{-122,409}}, color={0,0,127}));
  connect(zonSta.yOccHeaHig, groSta.u1OccHeaHig) annotation (Line(points={{-198,
          400},{-172,400},{-172,405},{-122,405}}, color={255,0,255}));
  connect(zonSta.yHigOccCoo, groSta.u1HigOccCoo) annotation (Line(points={{-198,
          395},{-168,395},{-168,403},{-122,403}}, color={255,0,255}));
  connect(zonSta.yUnoHeaHig, groSta.u1UnoHeaHig) annotation (Line(points={{-198,
          390},{-164,390},{-164,399},{-122,399}}, color={255,0,255}));
  connect(zonSta.yEndSetBac, groSta.u1EndSetBac) annotation (Line(points={{-198,
          388},{-156,388},{-156,395},{-122,395}}, color={255,0,255}));
  connect(zonSta.yHigUnoCoo, groSta.u1HigUnoCoo) annotation (Line(points={{-198,
          383},{-148,383},{-148,391},{-122,391}}, color={255,0,255}));
  connect(zonSta.yEndSetUp, groSta.u1EndSetUp) annotation (Line(points={{-198,381},
          {-144,381},{-144,387},{-122,387}}, color={255,0,255}));
  connect(falSta.y, groSta.zonOcc) annotation (Line(points={{-278,340},{-140,
          340},{-140,419},{-122,419}}, color={255,0,255}));
  connect(optSta.tOpt, zonSta.cooDowTim) annotation (Line(points={{-278,414},{
          -260,414},{-260,405},{-222,405}}, color={0,0,127}));
  connect(optSta.tOpt, zonSta.warUpTim) annotation (Line(points={{-278,414},{
          -260,414},{-260,402},{-222,402}}, color={0,0,127}));
  connect(TOccHeaSet.y, zonSta.TOccHeaSet) annotation (Line(points={{-318,480},
          {-244,480},{-244,392},{-222,392}}, color={0,0,127}));
  connect(TOccCooSet.y, zonSta.TOccCooSet) annotation (Line(points={{-318,440},
          {-248,440},{-248,389},{-222,389}}, color={0,0,127}));
  connect(TUnoHeaSet.y, zonSta.TUnoHeaSet) annotation (Line(points={{-318,570},
          {-252,570},{-252,386},{-222,386}}, color={0,0,127}));
  connect(TUnoCooSet.y, zonSta.TUnoCooSet) annotation (Line(points={{-318,530},
          {-256,530},{-256,383},{-222,383}}, color={0,0,127}));
  connect(TRoo, zonSta.TZon) annotation (Line(points={{-400,320},{-240,320},{
          -240,396.2},{-222,396.2}}, color={0,0,127}));
  connect(TRoo, groSta.TZon) annotation (Line(points={{-400,320},{-136,320},{
          -136,383},{-122,383}}, color={0,0,127}));
  connect(booRep.y, groSta.u1Occ) annotation (Line(points={{-218,-140},{-188,-140},
          {-188,417},{-122,417}}, color={255,0,255}));
  connect(reaRep.y, groSta.tNexOcc) annotation (Line(points={{-218,-180},{-184,
          -180},{-184,415},{-122,415}}, color={0,0,127}));
  connect(groSta.uGroOcc, opeModSel.u1Occ) annotation (Line(points={{-98,419},{
          -60,419},{-60,418},{-42,418}}, color={255,0,255}));
  connect(groSta.nexOcc, opeModSel.tNexOcc) annotation (Line(points={{-98,417},
          {-60,417},{-60,416},{-42,416}}, color={0,0,127}));
  connect(groSta.yCooTim, opeModSel.maxCooDowTim) annotation (Line(points={{-98,
          413},{-60,413},{-60,414},{-42,414}}, color={0,0,127}));
  connect(groSta.yOccHeaHig, opeModSel.u1OccHeaHig) annotation (Line(points={{-98,
          407},{-64,407},{-64,408},{-42,408}}, color={255,0,255}));
  connect(groSta.yHigOccCoo, opeModSel.u1HigOccCoo) annotation (Line(points={{-98,
          405},{-60,405},{-60,412},{-42,412}}, color={255,0,255}));
  connect(groSta.yWarTim, opeModSel.maxWarUpTim) annotation (Line(points={{-98,
          411},{-64,411},{-64,410},{-42,410}}, color={0,0,127}));
  connect(groSta.yColZon, opeModSel.totColZon) annotation (Line(points={{-98,402},
          {-42,402}}, color={255,127,0}));
  connect(groSta.yOpeWin, opeModSel.uOpeWin) annotation (Line(points={{-98,381},
          {-64,381},{-64,404},{-42,404}}, color={255,127,0}));
  connect(groSta.ySetBac, opeModSel.u1SetBac) annotation (Line(points={{-98,400},
          {-68,400},{-68,398},{-42,398}}, color={255,0,255}));
  connect(groSta.yEndSetBac, opeModSel.u1EndSetBac) annotation (Line(points={{-98,
          398},{-72,398},{-72,396},{-42,396}}, color={255,0,255}));
  connect(groSta.TZonMin, opeModSel.TZonMin) annotation (Line(points={{-98,385},
          {-68,385},{-68,392},{-42,392}}, color={0,0,127}));
  connect(groSta.yHotZon, opeModSel.totHotZon) annotation (Line(points={{-98,
          395},{-84,395},{-84,388},{-42,388}}, color={255,127,0}));
  connect(groSta.ySetUp, opeModSel.u1SetUp) annotation (Line(points={{-98,393},
          {-76,393},{-76,384},{-42,384}}, color={255,0,255}));
  connect(groSta.yEndSetUp, opeModSel.u1EndSetUp) annotation (Line(points={{-98,
          391},{-80,391},{-80,382},{-42,382}}, color={255,0,255}));
  connect(opeModSel.yOpeMod, intRep.u) annotation (Line(points={{-18,400},{0,
          400},{0,310},{18,310}}, color={255,127,0}));
  connect(intRep.y, TZonSet.uOpeMod) annotation (Line(points={{42,310},{60,310},
          {60,278},{78,278}}, color={255,127,0}));
  connect(TOccCooSet.y, TZonSet.TOccCooSet) annotation (Line(points={{-318,440},
          {-248,440},{-248,274},{78,274}}, color={0,0,127}));
  connect(TUnoCooSet.y, TZonSet.TUnoCooSet) annotation (Line(points={{-318,530},
          {-256,530},{-256,271},{78,271}}, color={0,0,127}));
  connect(TOccHeaSet.y, TZonSet.TOccHeaSet) annotation (Line(points={{-318,480},
          {-244,480},{-244,266},{78,266}}, color={0,0,127}));
  connect(TUnoHeaSet.y, TZonSet.TUnoHeaSet) annotation (Line(points={{-318,570},
          {-252,570},{-252,263},{78,263}}, color={0,0,127}));
  connect(demLimLev.y, TZonSet.uCooDemLimLev) annotation (Line(points={{-278,
          240},{0,240},{0,252},{78,252}}, color={255,127,0}));
  connect(demLimLev.y, TZonSet.uHeaDemLimLev) annotation (Line(points={{-278,
          240},{0,240},{0,249},{78,249}}, color={255,127,0}));
  connect(TRoo, conVAV.TZon) annotation (Line(points={{-400,320},{-136,320},{
          -136,221},{616,221}}, color={0,0,127}));
  connect(TZonSet.TCooSet, conVAV.TCooSet) annotation (Line(points={{102,268},{
          160,268},{160,219},{616,219}}, color={0,0,127}));
  connect(TZonSet.THeaSet, conVAV.THeaSet) annotation (Line(points={{102,260},{
          156,260},{156,217},{616,217}}, color={0,0,127}));
  connect(intRep.y, conVAV.uOpeMod) annotation (Line(points={{42,310},{180,310},
          {180,210},{616,210}}, color={255,127,0}));
  connect(VAVBox.TSup, conVAV.TDis) annotation (Line(points={{762,48},{780,48},
          {780,120},{440,120},{440,204},{616,204}}, color={0,0,127}));
  connect(VAVBox.VSup_flow, conVAV.VDis_flow) annotation (Line(points={{762,56},
          {774,56},{774,112},{446,112},{446,202},{616,202}}, color={0,0,127}));
  connect(TSupAHU.y, conVAV.TSup) annotation (Line(points={{402,80},{452,80},{
          452,200},{616,200}}, color={0,0,127}));
  connect(conAHU.TAirSupSet, TSupAHUSet.u) annotation (Line(points={{544,616},{638,
          616}}, color={0,0,127}));
  connect(TSupAHUSet.y, conVAV.TSupSet) annotation (Line(points={{662,616},{680,
          616},{680,240},{460,240},{460,198},{616,198}}, color={0,0,127}));
  connect(oveRid.y, conVAV.oveFloSet) annotation (Line(points={{402,170},{466,
          170},{466,196},{616,196}}, color={255,127,0}));
  connect(oveRid.y, conVAV.oveDamPos) annotation (Line(points={{402,170},{466,
          170},{466,194},{616,194}}, color={255,127,0}));
  connect(falSta.y, conVAV.uHeaOff) annotation (Line(points={{-278,340},{-140,
          340},{-140,192},{616,192}}, color={255,0,255}));
  connect(conAHU.y1SupFan, booScaRep.u) annotation (Line(points={{544,548},{638,
          548}}, color={255,0,255}));
  connect(booScaRep.y, conVAV.u1Fan) annotation (Line(points={{662,548},{688,
          548},{688,234},{608,234},{608,185.2},{616,185.2}}, color={255,0,255}));
  connect(conVAV.VAdjPopBreZon_flow, sumZon.VAdjPopBreZon_flow) annotation (
          Line(points={{640,214},{720,214},{720,320},{200,320},{200,594},{238,594}},
          color={0,0,127}));
  connect(conVAV.VAdjAreBreZon_flow, sumZon.VAdjAreBreZon_flow) annotation (
          Line(points={{640,212},{728,212},{728,328},{208,328},{208,590},{238,590}},
          color={0,0,127}));
  connect(conVAV.VMinOA_flow, sumZon.VMinOA_flow) annotation (Line(points={{640,210},
          {736,210},{736,336},{224,336},{224,582},{238,582}}, color={0,0,127}));
  connect(VAVBox.VSup_flow, sumZon.VZonPri_flow) annotation (Line(points={{762,
          56},{774,56},{774,112},{216,112},{216,586},{238,586}}, color={0,0,127}));
  connect(conVAV.yVal, VAVBox.yHea) annotation (Line(points={{640,217},{660,217},
          {660,46},{716,46}}, color={0,0,127}));
  connect(conVAV.yDam, VAVBox.yVAV) annotation (Line(points={{640,219},{666,219},
          {666,56},{716,56}}, color={0,0,127}));
  connect(sumZon.VSumAdjPopBreZon_flow, conAHU.VSumAdjPopBreZon_flow) annotation (
          Line(points={{262,598},{364,598},{364,598},{456,598}}, color={0,0,127}));
  connect(sumZon.VSumAdjAreBreZon_flow, conAHU.VSumAdjAreBreZon_flow) annotation (
          Line(points={{262,594},{368,594},{368,594},{456,594}}, color={0,0,127}));
  connect(sumZon.VSumZonPri_flow, conAHU.VSumZonPri_flow) annotation (Line(
          points={{262,586},{372,586},{372,588},{456,588}}, color={0,0,127}));
  connect(sumZon.uOutAirFra_max, conAHU.uOutAirFra_max) annotation (Line(
          points={{262,582},{456,582}}, color={0,0,127}));
  connect(dpDisSupFan.p_rel, conAHU.dpDuc) annotation (Line(points={{397,0},{
          400,0},{400,22},{190,22},{190,624},{456,624}}, color={0,0,127}));
  connect(TOut.y, conAHU.TOut) annotation (Line(points={{-279,180},{140,180},{140,
          620},{456,620}}, color={0,0,127}));
  connect(TMix.T, conAHU.TAirMix) annotation (Line(points={{40,-29},{40,80},{240,
          80},{240,492},{456,492}}, color={0,0,127}));
  connect(VOut1.V_flow, conAHU.VAirOut_flow) annotation (Line(points={{-80,-29},
          {-80,100},{280,100},{280,562},{456,562}}, color={0,0,127}));
  connect(conAHU.yRetDam, damRet.y) annotation (Line(points={{544,574},{566,574},
          {566,40},{-20,40},{-20,-10},{-12,-10}}, color={0,0,127}));
  connect(conAHU.yOutDam, damOut.y) annotation (Line(points={{544,562},{560,562},
          {560,50},{-40,50},{-40,-28}}, color={0,0,127}));
  connect(conAHU.ySupFan, fanSup.y) annotation (Line(points={{544,543.6},{554,
          543.6},{554,-20},{390,-20},{390,-28}}, color={0,0,127}));
  connect(hotWatPla.y, conVAV.u1HotPla) annotation (Line(points={{522,170},{608,
          170},{608,183.2},{616,183.2}}, color={255,0,255}));
  connect(conAHU.y1SupFan, conAHU.u1SupFan) annotation (Line(points={{544,548},{
          602,548},{602,420},{420,420},{420,610},{456,610}}, color={255,0,255}));
  connect(conVAV.yZonTemResReq, temResReq.u) annotation (Line(points={{640,200},
          {744,200},{744,220},{758,220}}, color={255,127,0}));
  connect(conVAV.yZonPreResReq, preRetReq.u) annotation (Line(points={{640,198},
          {750,198},{750,270},{758,270}}, color={255,127,0}));
  connect(preRetReq.y, conAHU.uZonPreResReq) annotation (Line(points={{782,270},
          {800,270},{800,360},{404,360},{404,630},{456,630}}, color={255,127,0}));
  connect(temResReq.y, conAHU.uZonTemResReq) annotation (Line(points={{782,220},
          {808,220},{808,368},{412,368},{412,614},{456,614}}, color={255,127,0}));
  connect(freSta.y, falEdg.u) annotation (Line(points={{-68,-110},{-60,-110},{
          -60,360},{338,360}}, color={255,0,255}));
  connect(falEdg.y, conAHU.u1SofSwiRes) annotation (Line(points={{362,360},{396,
          360},{396,508},{456,508}}, color={255,0,255}));
  connect(opeModSel.yOpeMod, sumZon.uOpeMod[1]) annotation (Line(points={{-18,
          400},{180,400},{180,599},{238,599}}, color={255,127,0}));
  connect(opeModSel.yOpeMod, ahuMod.uOpeMod[1]) annotation (Line(points={{-18,400},
          {180,400},{180,640},{238,640}}, color={255,127,0}));
  connect(ahuMod.yAhuOpeMod, conAHU.uAhuOpeMod) annotation (Line(points={{262,640},
          {420,640},{420,634},{456,634}}, color={255,127,0}));
  connect(TUnoCooSet.y, groSta.TCooSetOff) annotation (Line(points={{-318,530},{
          -160,530},{-160,389},{-122,389}}, color={0,0,127}));
  connect(TUnoHeaSet.y, groSta.THeaSetOff) annotation (Line(points={{-318,570},{
          -152,570},{-152,397},{-122,397}}, color={0,0,127}));
  connect(TSup.T, conAHU.TAirSup) annotation (Line(points={{570,-29},{570,32},{
          340,32},{340,80},{286,80},{286,604},{456,604}}, color={0,0,127}));
  connect(TSup.T, TSupAHU.u) annotation (Line(points={{570,-29},{570,32},{340,
          32},{340,80},{378,80}}, color={0,0,127}));
  connect(conAHU.yCooCoi, RTUCon.uCooCoi) annotation (Line(points={{544,518},{
          900,518},{900,534.117},{978,534.117}},
                                         color={0,0,127}));
  connect(conAHU.yHeaCoi, RTUCon.uHeaCoi) annotation (Line(points={{544,512},{
          910,512},{910,532.25},{978,532.25}},
                                         color={0,0,127}));
  connect(RTUCon.uDemLimLev, demLimLev1.y) annotation (Line(points={{978,
          536.333},{978,536},{930,536},{930,550},{922,550}},
                                         color={255,127,0}));
  connect(x_pTphi.X[1], RTUCon.XOut) annotation (Line(points={{-279,100},{-160,
          100},{-160,160},{142,160},{142,380},{930,380},{930,528.75},{978,
          528.75}},                                                      color={0,0,127}));
  connect(RTUCon.TOut, TOut.y) annotation (Line(points={{978,530.5},{920,530.5},
          {920,390},{122,390},{122,180},{-279,180}},
                                                color={0,0,127}));
  connect(RTUCon.yDXCooCoi, booToRea.u) annotation (Line(points={{1002,544.5},{
          1050,544.5},{1050,544},{1068,544}},
                 color={255,0,255}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{1092,544},{1100,544},{
          1100,526},{1108,526}},
                            color={0,0,127}));
  connect(mul.y, CooCoi.speRat) annotation (Line(points={{1132,520},{1142,520},
          {1142,-70},{234,-70},{234,-48},{239,-48}},color={0,0,127}));
  connect(RTUCon.yDXHeaCoi, HeaCoi.on) annotation (Line(points={{1002,539.95},{
          1040,539.95},{1040,-200},{90,-200},{90,-48},{99,-48}},
                                                         color={255,0,255}));
  connect(hys1.y, timDXSta1.u) annotation (Line(points={{302,-150},{318,-150}},
          color={255,0,255}));
  connect(hys.y, timDXSta.u) annotation (Line(points={{162,-160},{178,-160}},
          color={255,0,255}));
  connect(CooCoi.P, hys1.u) annotation (Line(points={{261,-49},{261,-48},{268,
          -48},{268,-150},{278,-150}},
                                  color={0,0,127}));
  connect(HeaCoi.P, hys.u) annotation (Line(points={{121,-49},{130,-49},{130,-160},
          {138,-160}}, color={0,0,127}));
  connect(timDXSta1.passed, RTUCon.uDXCooCoi) annotation (Line(points={{342,
          -158},{950,-158},{950,546.833},{978,546.833}},
                                           color={255,0,255}));
  connect(timDXSta.passed, RTUCon.uDXHeaCoi) annotation (Line(points={{202,-168},
          {956,-168},{956,545.083},{978,545.083}},
                                           color={255,0,255}));
  for i in 1:nCoiCoo loop
  connect(CooCoi[i].TOut, TOut.y) annotation (Line(points={{239,-43},{234,-43},
            {234,70},{-220,70},{-220,180},{-279,180}},
                                                    color={0,0,127}));
  end for;
  for i in 1:nCoiHea loop
  connect(HeaCoi[i].TOut, TOut.y) annotation (Line(points={{99,-36},{80,-36},{80,
          70},{-220,70},{-220,180},{-279,180}}, color={0,0,127}));
  connect(HeaCoi[i].phi, Phi.y) annotation (Line(points={{99,-32},{90,-32},{90,60},
          {-240,60},{-240,140},{-279,140}}, color={0,0,127}));
  end for;
  connect(con[1].y, conAHU.uCooCoi_actual) annotation (Line(points={{382,464},{
          440,464},{440,466},{456,466}}, color={0,0,127}));
  connect(con[2].y, conAHU.uHeaCoi_actual) annotation (Line(points={{382,464},{
          440,464},{440,462},{456,462}}, color={0,0,127}));

  connect(mulOr.y, not1.u)
    annotation (Line(points={{82,-100},{138,-100}},color={255,0,255}));
  connect(not1.y, booToRea2.u)
    annotation (Line(points={{162,-100},{178,-100}},
                                                   color={255,0,255}));
  connect(RTUCon.yDXHeaCoi[1:nCoiHea], mulOr.u[1:nCoiHea]) annotation (Line(points={{1002,
          539.95},{1040,539.95},{1040,-200},{50,-200},{50,-100},{58,-100}},
          color={255,0,255}));
  connect(not2.y, booToRea3.u)
    annotation (Line(points={{302,-100},{318,-100}}, color={255,0,255}));
  connect(mulOr1.y, not2.u)
    annotation (Line(points={{262,-100},{278,-100}}, color={255,0,255}));
  connect(mulOr1.u[1:nCoiCoo], RTUCon.yDXCooCoi[1:nCoiCoo]) annotation (Line(points={{238,
          -100},{230,-100},{230,-180},{1050,-180},{1050,544.5},{1002,544.5}}, color={255,0,255}));
  connect(booToRea2.y, damPreInd.y) annotation (Line(points={{202,-100},{216,
          -100},{216,-70},{190,-70},{190,12},{110,12}},
                                                  color={0,0,127}));
  connect(booToRea3.y, damPreInd1.y) annotation (Line(points={{342,-100},{370,
          -100},{370,12},{250,12}},                   color={0,0,127}));
  connect(RTUCon.uCooCoiAva, con1.y) annotation (Line(points={{978,543.333},{
          978,544},{972,544},{972,650},{922,650}},
                                               color={255,0,255}));
  connect(RTUCon.uHeaCoiAva, con2.y) annotation (Line(points={{978,541.583},{
          978,542},{966,542},{966,620},{922,620}},
                                          color={255,0,255}));
  connect(RTUCon.uCooCoiSeq, conInt1.y) annotation (Line(points={{978,539.833},
          {960,539.833},{960,600},{952,600}},
                                        color={255,127,0}));
  connect(conInt.y, RTUCon.uHeaCoiSeq) annotation (Line(points={{922,580},{940,
          580},{940,538.083},{978,538.083}},
                                        color={255,127,0}));
  connect(RTUCon.TSupCoiHea, THeaCoi.T) annotation (Line(points={{978,525.25},{
          940,525.25},{940,420},{140,420},{140,-29}},  color={0,0,127}));
  connect(RTUCon.TSupCoiCoo, TCooCoi.T) annotation (Line(points={{978,523.5},{
          946,523.5},{946,410},{280,410},{280,-29}},   color={0,0,127}));
  connect(RTUCon.yComSpeCoo, mul.u2) annotation (Line(points={{1002,536.333},{
          1002,536},{1060,536},{1060,514},{1108,514}},
                                                  color={0,0,127}));
  connect(RTUCon.TSupCoiSet, conAHU.TAirSupSet) annotation (Line(points={{978,
          521.75},{978,520},{700,520},{700,640},{580,640},{580,616},{544,616}},
                      color={0,0,127}));
  connect(falSta1.y, groSta.u1Win) annotation (Line(points={{-278,300},{-128,
          300},{-128,380},{-122,380},{-122,381}}, color={255,0,255}));
  connect(con3.y, damPreInd2.y) annotation (Line(points={{542,16},{516,16},{516,
          12},{490,12}}, color={0,0,127}));
  connect(booToRea5.y, mul2.u2) annotation (Line(points={{486,-128},{486,-120},
          {498,-120}}, color={0,0,127}));
  connect(mul2.u1, RTUCon.yAuxHea) annotation (Line(points={{498,-108},{494,
          -108},{494,-92},{1002,-92},{1002,528.283}}, color={0,0,127}));
  connect(mul2.y, AuxHeaCoi.u) annotation (Line(points={{522,-114},{528,-114},{
          528,-54},{478,-54},{478,-34}}, color={0,0,127}));
  connect(hys2.y, booToRea5.u)
    annotation (Line(points={{454,-128},{462,-128}}, color={255,0,255}));
  connect(fanSup.y_actual, hys2.u) annotation (Line(points={{401,-33},{401,-128},
          {430,-128}}, color={0,0,127}));
  annotation (
  defaultComponentName="hvac",
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-320},{1420,
            680}})),
    Documentation(info="<html>
  <p>
  This model replaced an air handler unit (AHU) within a variable air flow (VAV) system,
  as introduced in 
  <a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Guideline36\">
  Buildings.Examples.VAVReheat.BaseClasses.Guideline36</a>, 
  with a rooftop unit (RTU). 
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  August 28, 2023, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
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
end Guideline36_RTU;
