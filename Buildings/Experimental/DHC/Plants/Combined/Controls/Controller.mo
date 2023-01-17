within Buildings.Experimental.DHC.Plants.Combined.Controls;
block Controller "Open-loop controller for validation purposes"
  extends BaseClasses.PartialController;

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)
    "CHW design mass flow rate (all units)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) CHW differential pressure setpoint"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal
    "HW design mass flow rate (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) HW differential pressure setpoint"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mConWatCon_flow_nominal(
    final min=0)
    "Design total CW mass flow rate through condenser barrels (all units)";
  parameter Modelica.Units.SI.MassFlowRate mConWatEva_flow_nominal(
    final min=0)
    "Design total CW mass flow rate through evaporator barrels (all units)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.PressureDifference dpConWatConSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) CW condenser loop differential pressure setpoint"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.PressureDifference dpConWatEvaSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) CW evaporator loop differential pressure setpoint"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));

  parameter Modelica.Units.SI.Time riseTimePum=30
    "Pump rise time of the filter (time to reach 99.6 % of the speed)"
    annotation (
      Dialog(
      tab="Dynamics",
      group="Filtered speed"));
  parameter Modelica.Units.SI.Time riseTimeVal=120
    "Pump rise time of the filter (time to reach 99.6 % of the opening)"
    annotation (
      Dialog(
      tab="Dynamics",
      group="Filtered opening"));


  Buildings.Controls.OBC.CDL.Logical.TrueDelay delPum(final delayTime=
        riseTimePum) "Delay command signal to allow for pump start time"
    annotation (Placement(transformation(extent={{-108,330},{-88,350}})));
  Buildings.Controls.OBC.CDL.Logical.Or y1
    "Boolean source for DO signals"
    annotation (Placement(transformation(extent={{-220,270},{-200,290}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi(nout=nChi)
    "Replicate signal"
    annotation (Placement(transformation(extent={{60,330},{80,350}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtValChi
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{-40,310},{-20,330}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delVal(final delayTime=
        riseTimeVal) "Delay command signal to allow for valve opening time"
    annotation (Placement(transformation(extent={{-150,270},{-130,290}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repChi2(nout=nChi)
    "Replicate signal"
    annotation (Placement(transformation(extent={{100,310},{120,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant valByp(
    k=0,
    y(start=0)) "Source signal for minimum flow bypass valve"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi4(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{60,150},{80,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi5(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repChi6(nout=nChiHea)
    "Replicate signal"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1CooChi(
    table=[0,0; 0.6,0; 0.6,1; 1,1],
    timeScale=3600,
    period=3600) "Boolean source for cooling switchover signal"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repHeaPum(nout=
        nHeaPum) "Replicate signal"
    annotation (Placement(transformation(extent={{220,-190},{240,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cstTHeaPumSet(k=max(
        TTanSet)) "Source signal for heat pump setpoint"
    annotation (Placement(transformation(extent={{-220,-210},{-200,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable coo(
    table=[0,0; 0.9,0; 0.9,1; 1,1],
    timeScale=3600,
    period=3600) "Boolean source for cooler circuit"
    annotation (Placement(transformation(extent={{-220,-310},{-200,-290}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repCoo(nout=nCoo)
    "Replicate signal"
    annotation (Placement(transformation(extent={{60,-310},{80,-290}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delVal1(final delayTime=
        riseTimeVal) "Delay command signal to allow for valve opening time"
    annotation (Placement(transformation(extent={{-170,-310},{-150,-290}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtValBypTan
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{90,-270},{110,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Not notCoo
    "Return true if cooler circuit Off"
    annotation (Placement(transformation(extent={{60,-270},{80,-250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtSpeCoo
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{90,-330},{110,-310}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumCoo(nout=
        nPumConWatCoo) "Replicate signal"
    annotation (Placement(transformation(extent={{60,-350},{80,-330}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1HeaCooChi(
    table=[0,0; 0.3,0; 0.3,1; 0.6,1; 0.6,0; 1,0],
    timeScale=3600,
    period=3600) "Boolean source for direct heat recovery switchover"
    annotation (Placement(transformation(extent={{-220,110},{-200,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi7(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repChi3(nout=nChiHea)
    "Replicate signal"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cstYValConWatChiByp(k=0)
    "Source signal for valve position"
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));
  BaseClasses.StagingPump staPumChiWat(
    final nPum=nPumChiWat,
    final nChi=nChi + nChiHea,
    final m_flow_nominal=mChiWat_flow_nominal)
    "CHW pump staging"
    annotation (Placement(transformation(extent={{60,250},{80,270}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlPumChiWat(
    k=0.1,
    Ti=60,
    r=dpChiWatSet_max,
    y_reset=1,
    y_neutral=0) "Pump speed controller"
    annotation (Placement(transformation(extent={{150,230},{170,250}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumChiWat(
    final nin=nPumChiWat)
    "Return true if any pump is commanded On"
    annotation (Placement(transformation(extent={{100,230},{120,250}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlPumHeaWat(
    k=0.1,
    Ti=60,
    r=dpHeaWatSet_max,
    y_reset=1,
    y_neutral=0) "Pump speed controller"
    annotation (Placement(transformation(extent={{190,-10},{210,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumHeaWat(nin=nPumHeaWat)
    "Return true if any pump is commanded On"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  BaseClasses.StagingPump staPumHeaWat(
    final nPum=nPumHeaWat,
    final nChi=nChiHea,
    final m_flow_nominal=mHeaWat_flow_nominal) "HW pump staging"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  BaseClasses.StagingPump staPumConWatCon(
    final nPum=nPumConWatCon,
    final nChi=nChi + nChiHea,
    final m_flow_nominal=mConWatCon_flow_nominal)
    "CW pump staging"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumConWatCon(nin=nPumConWatCon)
    "Return true if any pump is commanded On"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlPumConWatCon(
    k=0.1,
    Ti=60,
    final r=dpConWatConSet_max,
    y_reset=1,
    y_neutral=0) "Pump speed controller"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlPumConWatEva(
    k=0.1,
    Ti=60,
    final r=dpConWatEvaSet_max,
    y_reset=1,
    y_neutral=0) "Pump speed controller"
    annotation (Placement(transformation(extent={{170,-150},{190,-130}})));
  BaseClasses.StagingPump staPumConWatEva(
    final nPum=nPumConWatEva,
    final nChi=nChiHea,
    final m_flow_nominal=mConWatEva_flow_nominal) "CW pump staging"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumConWatEva(nin=nPumConWatEva)
    "Return true if any pump is commanded On"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Line dpConWatConSet
    "FIXME: CW condenser loop dp setpoint, currently constant, test linear with flow setpoint"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Constant"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Line dpConWatConSet1
    "FIXME: CW condenser loop dp setpoint, currently constant, test linear with flow setpoint"
    annotation (Placement(transformation(extent={{120,-66},{140,-46}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpConNom(final k=
        dpConWatConSet_max) "Constant"
    annotation (Placement(transformation(extent={{-100,-48},{-80,-28}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floConNom(final k=
        mConWatCon_flow_nominal) "Constant"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpEvaNom(final k=
        dpConWatEvaSet_max) "Constant"
    annotation (Placement(transformation(extent={{70,-88},{90,-68}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floEvaNom(final k=
        mConWatEva_flow_nominal) "Constant"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch selValConCasCoo[nChiHea]
    "Select only valve signals of chillers in cascading cooling mode"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(nout=nChiHea)
    "Replicate"
    annotation (Placement(transformation(extent={{-140,-118},{-120,-98}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch selValEvaCasHea[nChiHea]
    "Select only valve signals of chillers in cascading heating mode"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Not cas[nChiHea]
    "Return true if cascading" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={360,40})));
  Buildings.Controls.OBC.CDL.Logical.And casAndCoo[nChiHea]
    "Return true if cascading and cooling" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={360,0})));
  Buildings.Controls.OBC.CDL.Logical.Not hea[nChiHea] "Return true if heating"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={400,40})));
  Buildings.Controls.OBC.CDL.Logical.And casAndCoo1[nChiHea]
    "Return true if cascading and cooling" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={400,0})));
equation
  connect(delPum.y, repChi.u)
    annotation (Line(points={{-86,340},{58,340}}, color={255,0,255}));
  connect(repChi.y, y1Chi)
    annotation (Line(points={{82,340},{280,340}}, color={255,0,255}));
  connect(delVal.y, delPum.u) annotation (Line(points={{-128,280},{-120,280},{
          -120,340},{-110,340}}, color={255,0,255}));
  connect(repChi2.y, yValConChi)
    annotation (Line(points={{122,320},{240,320},{240,300},{280,300}},
                                                   color={0,0,127}));
  connect(valByp.y, yValChiWatMinByp)
    annotation (Line(points={{-198,200},{280,200}}, color={0,0,127}));
  connect(valByp.y, yValHeaWatMinByp) annotation (Line(points={{-198,200},{220,
          200},{220,-40},{280,-40}},   color={0,0,127}));
  connect(repChi4.y, y1ChiHea) annotation (Line(points={{82,160},{280,160}},
                           color={255,0,255}));
  connect(repChi6.y, yValConChiHea)
    annotation (Line(points={{142,60},{280,60}}, color={0,0,127}));
  connect(cvtValChi.y, repChi2.u)
    annotation (Line(points={{-18,320},{98,320}},color={0,0,127}));
  connect(cvtValChi.y, repChi6.u) annotation (Line(points={{-18,320},{0,320},{0,
          60},{118,60}}, color={0,0,127}));
  connect(repHeaPum.y, y1HeaPum)
    annotation (Line(points={{242,-180},{280,-180}},color={255,0,255}));
  connect(delPum.y, repHeaPum.u) annotation (Line(points={{-86,340},{20,340},{20,
          -192},{200,-192},{200,-180},{218,-180}},
                            color={255,0,255}));
  connect(cstTHeaPumSet.y, THeaPumSet)
    annotation (Line(points={{-198,-200},{280,-200}}, color={0,0,127}));
  connect(repCoo.y, y1Coo)
    annotation (Line(points={{82,-300},{280,-300}}, color={255,0,255}));
  connect(coo.y[1], delVal1.u)
    annotation (Line(points={{-198,-300},{-172,-300}}, color={255,0,255}));
  connect(delVal1.y, repCoo.u) annotation (Line(points={{-148,-300},{58,-300}},
                                 color={255,0,255}));
  connect(cvtValBypTan.y, yValBypTan) annotation (Line(points={{112,-260},{280,
          -260}},                       color={0,0,127}));
  connect(cvtValBypTan.u, notCoo.y)
    annotation (Line(points={{88,-260},{82,-260}}, color={255,0,255}));
  connect(coo.y[1], notCoo.u) annotation (Line(points={{-198,-300},{-180,-300},
          {-180,-260},{58,-260}}, color={255,0,255}));
  connect(cvtSpeCoo.y, yCoo) annotation (Line(points={{112,-320},{280,-320}},
                                 color={0,0,127}));
  connect(delVal1.y, cvtSpeCoo.u) annotation (Line(points={{-148,-300},{0,-300},
          {0,-320},{88,-320}}, color={255,0,255}));
  connect(repPumCoo.y, y1PumConWatCoo) annotation (Line(points={{82,-340},{280,
          -340}},                       color={255,0,255}));
  connect(delVal1.y, repPumCoo.u) annotation (Line(points={{-148,-300},{0,-300},
          {0,-340},{58,-340}},  color={255,0,255}));
  connect(delPum.y, repChi4.u) annotation (Line(points={{-86,340},{20,340},{20,
          160},{58,160}}, color={255,0,255}));
  connect(repChi5.y, y1CooChiHea)
    annotation (Line(points={{102,140},{280,140}}, color={255,0,255}));
  connect(repChi7.y, y1HeaCooChiHea)
    annotation (Line(points={{122,120},{280,120}}, color={255,0,255}));
  connect(y1CooChi.y[1], swi.u2) annotation (Line(points={{-198,160},{-180,160},
          {-180,100},{-162,100}}, color={255,0,255}));
  connect(swi.y, repChi3.u)
    annotation (Line(points={{-138,100},{118,100}}, color={0,0,127}));
  connect(repChi3.y, TChiHeaSet)
    annotation (Line(points={{142,100},{280,100}}, color={0,0,127}));
  connect(repChi6.y, yValEvaChiHea) annotation (Line(points={{142,60},{160,60},
          {160,80},{280,80}}, color={0,0,127}));
  connect(repChi2.y, yValEvaChi) annotation (Line(points={{122,320},{194,320},{
          194,320},{280,320}}, color={0,0,127}));
  connect(TChiWatSupSet, swi.u1) annotation (Line(points={{-280,260},{-232,260},
          {-232,108},{-162,108}},color={0,0,127}));
  connect(THeaWatSupSet, swi.u3) annotation (Line(points={{-280,220},{-250,220},
          {-250,92},{-162,92}}, color={0,0,127}));
  connect(cstYValConWatChiByp.y, yValConWatChiByp)
    annotation (Line(points={{-158,-220},{280,-220}}, color={0,0,127}));
  connect(u1Coo, y1.u1) annotation (Line(points={{-280,340},{-228,340},{-228,280},
          {-222,280}},      color={255,0,255}));
  connect(u1Hea, y1.u2) annotation (Line(points={{-280,300},{-234,300},{-234,272},
          {-222,272}},      color={255,0,255}));
  connect(y1.y, delVal.u)
    annotation (Line(points={{-198,280},{-152,280}}, color={255,0,255}));
  connect(y1.y, cvtValChi.u) annotation (Line(points={{-198,280},{-160,280},{
          -160,320},{-42,320}}, color={255,0,255}));
  connect(staPumChiWat.y1, y1PumChiWat) annotation (Line(points={{82,260},{176,260},
          {176,260},{280,260}}, color={255,0,255}));
  connect(yValEvaChi,staPumChiWat. yVal[1:nChi]) annotation (Line(points={{280,320},
          {50,320},{50,256},{58,256}}, color={0,0,127}));
  connect(yValEvaChiHea,staPumChiWat. yVal[nChi + 1:nChi + nChiHea])
    annotation (Line(points={{280,80},{50,80},{50,256},{58,256}}, color={0,0,127}));
  connect(ctlPumChiWat.y, yPumChiWat)
    annotation (Line(points={{172,240},{280,240}}, color={0,0,127}));
  connect(staPumChiWat.y1, anyPumChiWat.u) annotation (Line(points={{82,260},{90,
          260},{90,240},{98,240}}, color={255,0,255}));
  connect(anyPumChiWat.y, ctlPumChiWat.uEna) annotation (Line(points={{122,240},
          {130,240},{130,224},{156,224},{156,228}}, color={255,0,255}));
  connect(dpChiWatSet, ctlPumChiWat.u_s) annotation (Line(points={{-280,180},{140,
          180},{140,240},{148,240}}, color={0,0,127}));
  connect(staPumHeaWat.y1, y1PumHeaWat)
    annotation (Line(points={{122,20},{280,20}},color={255,0,255}));
  connect(anyPumHeaWat.y, ctlPumHeaWat.uEna) annotation (Line(points={{162,0},{170,
          0},{170,-16},{196,-16},{196,-12}}, color={255,0,255}));
  connect(ctlPumHeaWat.y, yPumHeaWat)
    annotation (Line(points={{212,0},{280,0}}, color={0,0,127}));
  connect(dpHeaWatSet, ctlPumHeaWat.u_s) annotation (Line(points={{-280,140},{
          -240,140},{-240,46},{180,46},{180,0},{188,0}},
                                                      color={0,0,127}));
  connect(yValConChiHea, staPumHeaWat.yVal) annotation (Line(points={{280,60},{240,
          60},{240,40},{40,40},{40,16},{98,16}}, color={0,0,127}));
  connect(staPumHeaWat.y1, anyPumHeaWat.u) annotation (Line(points={{122,20},{130,
          20},{130,0},{138,0}},
                              color={255,0,255}));
  connect(ctlPumConWatEva.y, yPumConWatEva)
    annotation (Line(points={{192,-140},{280,-140}}, color={0,0,127}));
  connect(ctlPumConWatCon.y, yPumConWatCon) annotation (Line(points={{52,-100},{
          280,-100}},                        color={0,0,127}));
  connect(staPumConWatCon.y1, y1PumConWatCon) annotation (Line(points={{-38,-80},
          {280,-80}},                     color={255,0,255}));
  connect(staPumConWatEva.y1, y1PumConWatEva)
    annotation (Line(points={{102,-120},{280,-120}},color={255,0,255}));
  connect(anyPumConWatCon.y, ctlPumConWatCon.uEna) annotation (Line(points={{2,-100},
          {10,-100},{10,-114},{36,-114},{36,-112}},           color={255,0,255}));
  connect(anyPumConWatEva.y, ctlPumConWatEva.uEna) annotation (Line(points={{
          142,-140},{150,-140},{150,-156},{176,-156},{176,-152}}, color={255,0,
          255}));
  connect(staPumConWatEva.y1, anyPumConWatEva.u) annotation (Line(points={{102,
          -120},{90,-120},{90,-140},{118,-140}}, color={255,0,255}));
  connect(staPumConWatCon.y1, anyPumConWatCon.u) annotation (Line(points={{-38,-80},
          {-30,-80},{-30,-100},{-22,-100}}, color={255,0,255}));
  connect(dpHeaWat, ctlPumHeaWat.u_m) annotation (Line(points={{-280,-100},{-198,
          -100},{-198,-20},{200,-20},{200,-12}}, color={0,0,127}));
  connect(mHeaWatPri_flow, staPumHeaWat.m_flow) annotation (Line(points={{-280,60},
          {-242,60},{-242,24},{98,24}}, color={0,0,127}));
  connect(dpChiWat, ctlPumChiWat.u_m) annotation (Line(points={{-280,-60},{-246,
          -60},{-246,220},{160,220},{160,228}}, color={0,0,127}));
  connect(yValConChi, staPumConWatCon.yVal[1:nChi]) annotation (Line(points={{280,
          300},{228,300},{228,-68},{-80,-68},{-80,-84},{-62,-84}}, color={0,0,127}));
  connect(mConWatEva_flow, staPumConWatEva.m_flow) annotation (Line(points={{-280,
          -20},{-252,-20},{-252,-116},{78,-116}}, color={0,0,127}));
  connect(mConWatCon_flow, staPumConWatCon.m_flow) annotation (Line(points={{-280,
          20},{-244,20},{-244,-76},{-62,-76}}, color={0,0,127}));
  connect(dpConWatCon, ctlPumConWatCon.u_m) annotation (Line(points={{-280,-140},
          {40,-140},{40,-112}}, color={0,0,127}));
  connect(dpConWatConSet.y, ctlPumConWatCon.u_s) annotation (Line(points={{2,-40},
          {16,-40},{16,-100},{28,-100}}, color={0,0,127}));
  connect(zer.y, dpConWatConSet.x1) annotation (Line(points={{-158,20},{-30,20},
          {-30,-32},{-22,-32}},
                           color={0,0,127}));
  connect(mConWatCon_flow, dpConWatConSet.u) annotation (Line(points={{-280,20},
          {-244,20},{-244,-40},{-22,-40}}, color={0,0,127}));
  connect(zer.y, dpConWatConSet1.x1) annotation (Line(points={{-158,20},{100,20},
          {100,-48},{118,-48}},
                           color={0,0,127}));
  connect(mConWatEva_flow, dpConWatConSet1.u) annotation (Line(points={{-280,
          -20},{-252,-20},{-252,-56},{118,-56}},
                                            color={0,0,127}));
  connect(dpConWatConSet1.y, ctlPumConWatEva.u_s) annotation (Line(points={{142,-56},
          {160,-56},{160,-140},{168,-140}},      color={0,0,127}));
  connect(dpConNom.y, dpConWatConSet.f2) annotation (Line(points={{-78,-38},{
          -40,-38},{-40,-48},{-22,-48}},
                                     color={0,0,127}));
  connect(floConNom.y, dpConWatConSet.x2) annotation (Line(points={{-78,0},{-68,
          0},{-68,-44},{-22,-44}}, color={0,0,127}));
  connect(dpEvaNom.y, dpConWatConSet1.f2) annotation (Line(points={{92,-78},{
          100,-78},{100,-64},{118,-64}},
                                     color={0,0,127}));
  connect(floEvaNom.y, dpConWatConSet1.x2) annotation (Line(points={{92,-40},{
          98,-40},{98,-60},{118,-60}},
                                    color={0,0,127}));
  connect(dpConWatEva, ctlPumConWatEva.u_m) annotation (Line(points={{-280,-180},
          {180,-180},{180,-152}}, color={0,0,127}));
  connect(mChiWatPri_flow, staPumChiWat.m_flow) annotation (Line(points={{-280,
          100},{-238,100},{-238,264},{58,264}}, color={0,0,127}));
  connect(yValConChiHea, selValConCasCoo.u1) annotation (Line(points={{280,60},
          {240,60},{240,40},{-120,40},{-120,-92},{-112,-92}}, color={0,0,127}));
  connect(selValConCasCoo.y, staPumConWatCon.yVal[nChi + 1:nChi + nChiHea])
    annotation (Line(points={{-88,-100},{-80,-100},{-80,-84},{-62,-84}}, color=
          {0,0,127}));
  connect(rep.y, selValConCasCoo.u3)
    annotation (Line(points={{-118,-108},{-112,-108}}, color={0,0,127}));
  connect(zer.y, rep.u) annotation (Line(points={{-158,20},{-150,20},{-150,-108},
          {-142,-108}}, color={0,0,127}));
  connect(selValEvaCasHea.y, staPumConWatEva.yVal) annotation (Line(points={{62,
          -160},{70,-160},{70,-124},{78,-124}}, color={0,0,127}));
  connect(yValEvaChiHea, selValEvaCasHea.u1) annotation (Line(points={{280,80},
          {240,80},{240,-152},{38,-152}}, color={0,0,127}));
  connect(rep.y, selValEvaCasHea.u3) annotation (Line(points={{-118,-108},{-114,
          -108},{-114,-168},{38,-168}}, color={0,0,127}));
  connect(y1HeaCooChi.y[1], repChi7.u)
    annotation (Line(points={{-198,120},{98,120}}, color={255,0,255}));
  connect(y1CooChi.y[1], repChi5.u) annotation (Line(points={{-198,160},{-180,
          160},{-180,140},{78,140}}, color={255,0,255}));
  connect(y1HeaCooChiHea, cas.u) annotation (Line(points={{280,120},{360,120},{
          360,52}}, color={255,0,255}));
  connect(y1CooChiHea, casAndCoo.u2) annotation (Line(points={{280,140},{342,
          140},{342,18},{352,18},{352,12}}, color={255,0,255}));
  connect(cas.y, casAndCoo.u1)
    annotation (Line(points={{360,28},{360,12}}, color={255,0,255}));
  connect(hea.y, casAndCoo1.u1)
    annotation (Line(points={{400,28},{400,12}}, color={255,0,255}));
  connect(y1CooChiHea, hea.u) annotation (Line(points={{280,140},{400,140},{400,
          52}}, color={255,0,255}));
  connect(cas.y, casAndCoo1.u2) annotation (Line(points={{360,28},{360,20},{392,
          20},{392,12}}, color={255,0,255}));
  connect(casAndCoo1.y, selValEvaCasHea.u2) annotation (Line(points={{400,-12},
          {400,-160},{38,-160}}, color={255,0,255}));
  connect(casAndCoo.y, selValConCasCoo.u2) annotation (Line(points={{360,-12},{
          358,-12},{358,-106},{-112,-106},{-112,-100}}, color={255,0,255}));
  connect(dpConNom.y, dpConWatConSet.f1) annotation (Line(points={{-78,-38},{
          -40,-38},{-40,-36},{-22,-36}}, color={0,0,127}));
  connect(dpEvaNom.y, dpConWatConSet1.f1) annotation (Line(points={{92,-78},{
          100,-78},{100,-52},{118,-52}}, color={0,0,127}));
annotation (
  defaultComponentName="ctl");
end Controller;
