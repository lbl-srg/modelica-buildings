within Buildings.Experimental.DHC.Plants.Combined.Controls;
block OpenLoop "Open-loop controller for validation purposes"
  extends BaseClasses.PartialController;

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

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0,0; 0.1,0; 0.1,1; 1,1],
    timeScale=3600,
    period=3600)
    "Boolean source for DO signals"
    annotation (Placement(transformation(extent={{-220,270},{-200,290}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumChiWat(nout=
        nPumChiWat) "Replicate signal"
    annotation (Placement(transformation(extent={{60,270},{80,290}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi(nout=nChi)
    "Replicate signal"
    annotation (Placement(transformation(extent={{60,330},{80,350}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtValCon
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{-28,290},{-8,310}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delVal(final delayTime=
        riseTimeVal) "Delay command signal to allow for valve opening time"
    annotation (Placement(transformation(extent={{-150,270},{-130,290}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi1(nout=nChi)
    "Replicate signal"
    annotation (Placement(transformation(extent={{80,310},{100,330}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repChi2(nout=nChi)
    "Replicate signal"
    annotation (Placement(transformation(extent={{100,290},{120,310}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant valByp(
    k=0,
    y(start=0)) "Source signal for minimum flow bypass valve"
    annotation (Placement(transformation(extent={{-220,210},{-200,230}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi4(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi5(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repChi6(nout=nChiHea)
    "Replicate signal"
    annotation (Placement(transformation(extent={{120,110},{140,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumHeaWat(nout=
        nPumHeaWat) "Replicate signal"
    annotation (Placement(transformation(extent={{152,-10},{172,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1CooChi(
    table=[0,0; 0.6,0; 0.6,1; 1,1],
    timeScale=3600,
    period=3600) "Boolean source for switchover signal"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi8(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{100,130},{120,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumConWatCon(nout=
        nPumConWatCon) "Replicate signal"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtPumConWatCon
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{-30,-130},{-10,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "AND"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Not and3 "True if heating mode"
    annotation (Placement(transformation(extent={{-170,-170},{-150,-150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumConWatEva(nout=
        nPumConWatEva) "Replicate signal"
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtPumConWatEva
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{-30,-170},{-10,-150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repHeaPum(nout=
        nHeaPum) "Replicate signal"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cstTHeaPumSet(k=max(
        TTanSet)) "Source signal for heat pump setpoint"
    annotation (Placement(transformation(extent={{-220,-230},{-200,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtPumHeaWat
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{182,-30},{202,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtPumChiWat
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{90,250},{110,270}})));
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
    table=[0,0; 0.3,0; 0.3,1; 1,1],
    timeScale=3600,
    period=3600) "Boolean source for direct heat recovery"
    annotation (Placement(transformation(extent={{-220,70},{-200,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not and1 "True if cascading mode"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "AND"
    annotation (Placement(transformation(extent={{30,170},{50,190}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 "AND"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi3(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or  and6 "OR"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delVal2(final delayTime=
        riseTimeVal) "Delay command signal to allow for valve opening time"
    annotation (Placement(transformation(extent={{-150,70},{-130,90}})));
  Buildings.Controls.OBC.CDL.Logical.And and7 "AND"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
equation
  connect(repPumChiWat.y, y1PumChiWat)
    annotation (Line(points={{82,280},{280,280}}, color={255,0,255}));
  connect(delPum.y, repChi.u)
    annotation (Line(points={{-86,340},{58,340}}, color={255,0,255}));
  connect(repChi.y, y1Chi)
    annotation (Line(points={{82,340},{280,340}}, color={255,0,255}));
  connect(y1.y[1], delVal.u)
    annotation (Line(points={{-198,280},{-152,280}}, color={255,0,255}));
  connect(delVal.y, delPum.u) annotation (Line(points={{-128,280},{-120,280},{
          -120,340},{-110,340}}, color={255,0,255}));
  connect(y1.y[1], repChi1.u) annotation (Line(points={{-198,280},{-160,280},{
          -160,320},{78,320}}, color={255,0,255}));
  connect(repChi1.y, y1ValEvaChi)
    annotation (Line(points={{102,320},{280,320}}, color={255,0,255}));
  connect(repChi2.y, yValConChi)
    annotation (Line(points={{122,300},{280,300}}, color={0,0,127}));
  connect(delVal.y, repPumChiWat.u)
    annotation (Line(points={{-128,280},{58,280}}, color={255,0,255}));
  connect(valByp.y, yValChiWatMinByp)
    annotation (Line(points={{-198,220},{280,220}}, color={0,0,127}));
  connect(valByp.y, yValHeaWatMinByp) annotation (Line(points={{-198,220},{220,
          220},{220,-60},{280,-60}},   color={0,0,127}));
  connect(repChi4.y, y1ChiHea) annotation (Line(points={{82,180},{280,180}},
                           color={255,0,255}));
  connect(repChi5.y, y1CooChiHea)
    annotation (Line(points={{102,160},{280,160}},
                                                 color={255,0,255}));
  connect(y1.y[1], repChi8.u) annotation (Line(points={{-198,280},{-160,280},{
          -160,300},{-40,300},{-40,140},{98,140}},
                                                 color={255,0,255}));
  connect(repChi8.y, y1ValEvaChiHea)
    annotation (Line(points={{122,140},{280,140}},
                                                 color={255,0,255}));
  connect(repChi6.y, yValConChiHea)
    annotation (Line(points={{142,120},{280,120}},
                                                 color={0,0,127}));
  connect(repPumHeaWat.y, y1PumHeaWat) annotation (Line(points={{174,0},{280,0}},
                                     color={255,0,255}));
  connect(y1.y[1], cvtValCon.u) annotation (Line(points={{-198,280},{-160,280},
          {-160,300},{-30,300}}, color={255,0,255}));
  connect(cvtValCon.y, repChi2.u)
    annotation (Line(points={{-6,300},{98,300}}, color={0,0,127}));
  connect(cvtValCon.y, repChi6.u) annotation (Line(points={{-6,300},{0,300},{0,
          120},{118,120}},
                         color={0,0,127}));
  connect(repPumConWatCon.y, y1PumConWatCon)
    annotation (Line(points={{82,-100},{280,-100}},
                                                  color={255,0,255}));
  connect(and3.y, and2.u2) annotation (Line(points={{-148,-160},{-100,-160},{
          -100,-148},{-82,-148}}, color={255,0,255}));
  connect(delVal.y, and2.u1) annotation (Line(points={{-128,280},{-120,280},{
          -120,-140},{-82,-140}}, color={255,0,255}));
  connect(repPumConWatEva.y, y1PumConWatEva)
    annotation (Line(points={{82,-140},{280,-140}}, color={255,0,255}));
  connect(and2.y, repPumConWatEva.u)
    annotation (Line(points={{-58,-140},{58,-140}}, color={255,0,255}));
  connect(and2.y, cvtPumConWatEva.u) annotation (Line(points={{-58,-140},{-40,
          -140},{-40,-160},{-32,-160}}, color={255,0,255}));
  connect(cvtPumConWatEva.y, yPumConWatEva)
    annotation (Line(points={{-8,-160},{280,-160}}, color={0,0,127}));
  connect(repHeaPum.y, y1HeaPum)
    annotation (Line(points={{82,-200},{280,-200}}, color={255,0,255}));
  connect(delPum.y, repHeaPum.u) annotation (Line(points={{-86,340},{20,340},{
          20,-200},{58,-200}},
                            color={255,0,255}));
  connect(cstTHeaPumSet.y, THeaPumSet)
    annotation (Line(points={{-198,-220},{280,-220}}, color={0,0,127}));
  connect(cvtPumHeaWat.y, yPumHeaWat) annotation (Line(points={{204,-20},{280,
          -20}},            color={0,0,127}));
  connect(cvtPumChiWat.y, yPumChiWat)
    annotation (Line(points={{112,260},{280,260}}, color={0,0,127}));
  connect(delVal.y, cvtPumChiWat.u) annotation (Line(points={{-128,280},{-20,
          280},{-20,260},{88,260}}, color={255,0,255}));
  connect(delVal.y, repPumConWatCon.u) annotation (Line(points={{-128,280},{
          -120,280},{-120,-100},{58,-100}},
                                          color={255,0,255}));
  connect(cvtPumConWatCon.y, yPumConWatCon)
    annotation (Line(points={{-8,-120},{280,-120}}, color={0,0,127}));
  connect(delVal.y, cvtPumConWatCon.u) annotation (Line(points={{-128,280},{
          -120,280},{-120,-120},{-32,-120}}, color={255,0,255}));
  connect(y1CooChi.y[1], and3.u) annotation (Line(points={{-198,160},{-180,160},
          {-180,-160},{-172,-160}}, color={255,0,255}));
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
  connect(and4.y, repChi4.u)
    annotation (Line(points={{52,180},{58,180}}, color={255,0,255}));
  connect(and1.y, and4.u2) annotation (Line(points={{-58,180},{10,180},{10,172},
          {28,172}}, color={255,0,255}));
  connect(delPum.y, and4.u1) annotation (Line(points={{-86,340},{20,340},{20,
          180},{28,180}}, color={255,0,255}));
  connect(delPum.y, and5.u1) annotation (Line(points={{-86,340},{-86,339.565},{
          20,339.565},{20,80},{28,80}}, color={255,0,255}));
  connect(and5.y, repChi3.u)
    annotation (Line(points={{52,80},{78,80}}, color={255,0,255}));
  connect(repChi3.y, y1ChiHeaCoo)
    annotation (Line(points={{102,80},{280,80}}, color={255,0,255}));
  connect(repChi6.y, yValConChiHeaCoo) annotation (Line(points={{142,120},{160,
          120},{160,40},{280,40}}, color={0,0,127}));
  connect(y1HeaCooChi.y[1], delVal2.u)
    annotation (Line(points={{-198,80},{-152,80}}, color={255,0,255}));
  connect(delVal2.y, and1.u) annotation (Line(points={{-128,80},{-100,80},{-100,
          180},{-82,180}}, color={255,0,255}));
  connect(delVal2.y, and5.u2) annotation (Line(points={{-128,80},{10,80},{10,72},
          {28,72}}, color={255,0,255}));
  connect(and5.y, and6.u1) annotation (Line(points={{52,80},{60,80},{60,0},{70,
          0}}, color={255,0,255}));
  connect(and4.y, and6.u2) annotation (Line(points={{52,180},{56,180},{56,-8},{
          70,-8}}, color={255,0,255}));
  connect(and3.y, and7.u2) annotation (Line(points={{-148,-160},{-140,-160},{
          -140,-20},{100,-20},{100,-8},{108,-8}}, color={255,0,255}));
  connect(and6.y, and7.u1)
    annotation (Line(points={{94,0},{108,0}}, color={255,0,255}));
  connect(and7.y, repPumHeaWat.u)
    annotation (Line(points={{132,0},{150,0}}, color={255,0,255}));
  connect(and7.y, cvtPumHeaWat.u) annotation (Line(points={{132,0},{140,0},{140,
          -20},{180,-20}}, color={255,0,255}));
  connect(y1CooChi.y[1], repChi5.u)
    annotation (Line(points={{-198,160},{78,160}}, color={255,0,255}));
  connect(repChi8.y, y1ValEvaChiHeaCoo) annotation (Line(points={{122,140},{240,
          140},{240,60},{280,60}}, color={255,0,255}));
annotation (
  defaultComponentName="ctl");
end OpenLoop;
