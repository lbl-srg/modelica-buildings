within Buildings.Experimental.DHC.Plants.Combined.Controls;
block Controller "Open-loop controller for validation purposes"
  extends BaseClasses.PartialController;

  parameter Modelica.Units.SI.MassFlowRate mPumChiWatUni_flow_nominal
    "CHW pump design mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));

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

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1PumChiWat_actual[nPumChiWat]
    "CHW pump status"
    annotation (Placement(transformation(extent={{
            -300,80},{-260,120}}), iconTransformation(extent={{-260,60},{-220,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mChiWatPri_flow(final unit="kg/s")
    "Primary CHW mass flow rate"
    annotation (Placement(
        transformation(extent={{-300,40},{-260,80}}),  iconTransformation(
          extent={{-260,30},{-220,70}})));

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
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumHeaWat(nout=
        nPumHeaWat) "Replicate signal"
    annotation (Placement(transformation(extent={{150,10},{170,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1CooChi(
    table=[0,0; 0.6,0; 0.6,1; 1,1],
    timeScale=3600,
    period=3600) "Boolean source for cooling switchover signal"
    annotation (Placement(transformation(extent={{-220,130},{-200,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumConWatCon(nout=
        nPumConWatCon) "Replicate signal"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtPumConWatCon
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "AND"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not and3 "True if heating mode"
    annotation (Placement(transformation(extent={{-170,-30},{-150,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumConWatEva(nout=
        nPumConWatEva) "Replicate signal"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtPumConWatEva
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{-30,-150},{-10,-130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repHeaPum(nout=
        nHeaPum) "Replicate signal"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cstTHeaPumSet(k=max(
        TTanSet)) "Source signal for heat pump setpoint"
    annotation (Placement(transformation(extent={{-220,-210},{-200,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtPumHeaWat
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtPumChiWat
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{100,230},{120,250}})));
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
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "On AND (Heating OR direct HR mode)"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Logical.Or  and6 "Heating OR direct HR mode"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delVal2(final delayTime=
        riseTimeVal)
    "Delay command signal to allow for switchover valve opening time"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delVal3(final delayTime=
        riseTimeVal)
    "Delay command signal to allow for switchover valve opening time"
    annotation (Placement(transformation(extent={{-170,130},{-150,150}})));
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

  BaseClasses.StagingPump         pumChiWatSta(
    final nPum=nPumChiWat,
    final nChi=nChi + nChiHea,
    final mPum_flow_nominal=mPumChiWatUni_flow_nominal) "CHW pump staging"
    annotation (Placement(transformation(extent={{60,250},{80,270}})));

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
  connect(repPumHeaWat.y, y1PumHeaWat) annotation (Line(points={{172,20},{280,
          20}},                      color={255,0,255}));
  connect(cvtValChi.y, repChi2.u)
    annotation (Line(points={{-18,320},{98,320}},color={0,0,127}));
  connect(cvtValChi.y, repChi6.u) annotation (Line(points={{-18,320},{0,320},{0,
          60},{118,60}}, color={0,0,127}));
  connect(repPumConWatCon.y, y1PumConWatCon)
    annotation (Line(points={{82,-80},{280,-80}}, color={255,0,255}));
  connect(and3.y, and2.u2) annotation (Line(points={{-148,-20},{-100,-20},{-100,
          -128},{-82,-128}},      color={255,0,255}));
  connect(delVal.y, and2.u1) annotation (Line(points={{-128,280},{-120,280},{
          -120,-120},{-82,-120}}, color={255,0,255}));
  connect(repPumConWatEva.y, y1PumConWatEva)
    annotation (Line(points={{82,-120},{280,-120}}, color={255,0,255}));
  connect(and2.y, repPumConWatEva.u)
    annotation (Line(points={{-58,-120},{58,-120}}, color={255,0,255}));
  connect(and2.y, cvtPumConWatEva.u) annotation (Line(points={{-58,-120},{-40,
          -120},{-40,-140},{-32,-140}}, color={255,0,255}));
  connect(cvtPumConWatEva.y, yPumConWatEva)
    annotation (Line(points={{-8,-140},{280,-140}}, color={0,0,127}));
  connect(repHeaPum.y, y1HeaPum)
    annotation (Line(points={{82,-180},{280,-180}}, color={255,0,255}));
  connect(delPum.y, repHeaPum.u) annotation (Line(points={{-86,340},{20,340},{
          20,-180},{58,-180}},
                            color={255,0,255}));
  connect(cstTHeaPumSet.y, THeaPumSet)
    annotation (Line(points={{-198,-200},{280,-200}}, color={0,0,127}));
  connect(cvtPumHeaWat.y, yPumHeaWat) annotation (Line(points={{202,0},{280,0}},
                            color={0,0,127}));
  connect(cvtPumChiWat.y, yPumChiWat)
    annotation (Line(points={{122,240},{280,240}}, color={0,0,127}));
  connect(delVal.y, cvtPumChiWat.u) annotation (Line(points={{-128,280},{-20,280},
          {-20,240},{98,240}},      color={255,0,255}));
  connect(delVal.y, repPumConWatCon.u) annotation (Line(points={{-128,280},{
          -120,280},{-120,-80},{58,-80}}, color={255,0,255}));
  connect(cvtPumConWatCon.y, yPumConWatCon)
    annotation (Line(points={{-8,-100},{280,-100}}, color={0,0,127}));
  connect(delVal.y, cvtPumConWatCon.u) annotation (Line(points={{-128,280},{
          -120,280},{-120,-100},{-32,-100}}, color={255,0,255}));
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
  connect(y1HeaCooChi.y[1], delVal2.u)
    annotation (Line(points={{-78,120},{-62,120}}, color={255,0,255}));
  connect(delPum.y, repChi4.u) annotation (Line(points={{-86,340},{20,340},{20,
          160},{58,160}}, color={255,0,255}));
  connect(repChi5.y, y1CooChiHea)
    annotation (Line(points={{102,140},{280,140}}, color={255,0,255}));
  connect(y1CooChi.y[1], delVal3.u)
    annotation (Line(points={{-198,140},{-172,140}}, color={255,0,255}));
  connect(delVal3.y, repChi5.u)
    annotation (Line(points={{-148,140},{78,140}}, color={255,0,255}));
  connect(delVal2.y, repChi7.u)
    annotation (Line(points={{-38,120},{98,120}}, color={255,0,255}));
  connect(repChi7.y, y1HeaCooChiHea)
    annotation (Line(points={{122,120},{280,120}}, color={255,0,255}));
  connect(y1CooChi.y[1], swi.u2) annotation (Line(points={{-198,140},{-180,140},
          {-180,100},{-162,100}}, color={255,0,255}));
  connect(swi.y, repChi3.u)
    annotation (Line(points={{-138,100},{118,100}}, color={0,0,127}));
  connect(repChi3.y, TChiHeaSet)
    annotation (Line(points={{142,100},{280,100}}, color={0,0,127}));
  connect(repChi6.y, yValEvaChiHea) annotation (Line(points={{142,60},{160,60},
          {160,80},{280,80}}, color={0,0,127}));
  connect(y1CooChi.y[1], and3.u) annotation (Line(points={{-198,140},{-180,140},
          {-180,-20},{-172,-20}}, color={255,0,255}));
  connect(and3.y, and6.u2) annotation (Line(points={{-148,-20},{40,-20},{40,-8},
          {48,-8}}, color={255,0,255}));
  connect(delVal2.y, and6.u1) annotation (Line(points={{-38,120},{-20,120},{-20,
          0},{48,0}}, color={255,0,255}));
  connect(and5.y, repPumHeaWat.u)
    annotation (Line(points={{122,20},{148,20}}, color={255,0,255}));
  connect(and6.y, and5.u2) annotation (Line(points={{72,0},{80,0},{80,12},{98,
          12}}, color={255,0,255}));
  connect(delPum.y, and5.u1) annotation (Line(points={{-86,340},{-86,339.444},{
          20,339.444},{20,20},{98,20}}, color={255,0,255}));
  connect(and5.y, cvtPumHeaWat.u) annotation (Line(points={{122,20},{140,20},{
          140,0},{178,0}}, color={255,0,255}));
  connect(repChi2.y, yValEvaChi) annotation (Line(points={{122,320},{194,320},{
          194,320},{280,320}}, color={0,0,127}));
  connect(TChiWatSupSet, swi.u1) annotation (Line(points={{-280,260},{-232,260},
          {-232,108},{-162,108}},color={0,0,127}));
  connect(THeaWatSupSet, swi.u3) annotation (Line(points={{-280,220},{-240,220},
          {-240,92},{-162,92}}, color={0,0,127}));
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
  connect(pumChiWatSta.y1, y1PumChiWat) annotation (Line(points={{82,260},{176,260},
          {176,260},{280,260}}, color={255,0,255}));
  connect(mChiWatPri_flow, pumChiWatSta.m_flow) annotation (Line(points={{-280,60},
          {-246,60},{-246,264},{58,264}}, color={0,0,127}));
  connect(yValEvaChi, pumChiWatSta.yVal[1:nChi]) annotation (Line(points={{280,320},
          {50,320},{50,256},{58,256}}, color={0,0,127}));
  connect(yValEvaChiHea, pumChiWatSta.yVal[nChi + 1:nChi + nChiHea])
    annotation (Line(points={{280,80},{50,80},{50,256},{58,256}}, color={0,0,127}));
annotation (
  defaultComponentName="ctl");
end Controller;
