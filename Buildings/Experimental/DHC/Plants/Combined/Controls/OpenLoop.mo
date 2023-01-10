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
    annotation (Placement(transformation(extent={{-108,270},{-88,290}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0,0; 0.1,0; 0.1,1; 1,1],
    timeScale=3600,
    period=3600)
    "Boolean source for DO signals"
    annotation (Placement(transformation(extent={{-220,210},{-200,230}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumChiWat(nout=
        nPumChiWat) "Replicate signal"
    annotation (Placement(transformation(extent={{60,210},{80,230}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi(nout=nChi)
    "Replicate signal"
    annotation (Placement(transformation(extent={{60,270},{80,290}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtValCon
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{-28,230},{-8,250}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delVal(final delayTime=
        riseTimeVal) "Delay command signal to allow for valve opening time"
    annotation (Placement(transformation(extent={{-150,210},{-130,230}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi1(nout=nChi)
    "Replicate signal"
    annotation (Placement(transformation(extent={{80,250},{100,270}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repChi2(nout=nChi)
    "Replicate signal"
    annotation (Placement(transformation(extent={{100,230},{120,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant valByp(
    k=0,
    y(start=0)) "Source signal for minimum flow bypass valve"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi4(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi5(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repChi6(nout=nChiHea)
    "Replicate signal"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumHeaWat(nout=
        nPumHeaWat) "Replicate signal"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1CooChi(
    table=[0,0; 0.6,0; 0.6,1; 1,1],
    timeScale=3600,
    period=3600) "Boolean source for switchover signal"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi8(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumConWatCon(nout=
        nPumConWatCon) "Replicate signal"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtPumConWatCon
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "AND"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not and3 "True if heating mode"
    annotation (Placement(transformation(extent={{-130,-150},{-110,-130}})));
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
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtPumChiWat
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{90,190},{110,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable coo(
    table=[0,0; 0.8,0; 0.8,1; 1,1],
    timeScale=3600,
    period=3600) "Boolean source for cooler circuit"
    annotation (Placement(transformation(extent={{-220,-290},{-200,-270}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repCoo(nout=nCoo)
    "Replicate signal"
    annotation (Placement(transformation(extent={{60,-290},{80,-270}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delVal1(final delayTime=
        riseTimeVal) "Delay command signal to allow for valve opening time"
    annotation (Placement(transformation(extent={{-170,-290},{-150,-270}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtValBypTan
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{90,-250},{110,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Not notCoo
    "Return true if cooler circuit Off"
    annotation (Placement(transformation(extent={{60,-250},{80,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtSpeCoo
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{90,-310},{110,-290}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumCoo(nout=
        nPumConWatCoo) "Replicate signal"
    annotation (Placement(transformation(extent={{60,-330},{80,-310}})));
equation
  connect(repPumChiWat.y, y1PumChiWat)
    annotation (Line(points={{82,220},{280,220}}, color={255,0,255}));
  connect(delPum.y, repChi.u)
    annotation (Line(points={{-86,280},{58,280}}, color={255,0,255}));
  connect(repChi.y, y1Chi)
    annotation (Line(points={{82,280},{280,280}}, color={255,0,255}));
  connect(y1.y[1], delVal.u)
    annotation (Line(points={{-198,220},{-152,220}}, color={255,0,255}));
  connect(delVal.y, delPum.u) annotation (Line(points={{-128,220},{-120,220},{-120,
          280},{-110,280}},      color={255,0,255}));
  connect(y1.y[1], repChi1.u) annotation (Line(points={{-198,220},{-160,220},{
          -160,260},{78,260}}, color={255,0,255}));
  connect(repChi1.y, y1ValEvaChi)
    annotation (Line(points={{102,260},{280,260}}, color={255,0,255}));
  connect(repChi2.y, yValConChi)
    annotation (Line(points={{122,240},{280,240}}, color={0,0,127}));
  connect(delVal.y, repPumChiWat.u)
    annotation (Line(points={{-128,220},{58,220}}, color={255,0,255}));
  connect(valByp.y, yValChiWatMinByp)
    annotation (Line(points={{-198,160},{280,160}}, color={0,0,127}));
  connect(valByp.y, yValHeaWatMinByp) annotation (Line(points={{-198,160},{210,
          160},{210,-40},{280,-40}},   color={0,0,127}));
  connect(repChi4.y, y1ChiHea) annotation (Line(points={{82,120},{280,120}},
                           color={255,0,255}));
  connect(repChi5.y, y1CooChiHea)
    annotation (Line(points={{102,100},{280,100}},
                                                 color={255,0,255}));
  connect(delPum.y, repChi4.u) annotation (Line(points={{-86,280},{40,280},{40,
          120},{58,120}}, color={255,0,255}));
  connect(y1.y[1], repChi8.u) annotation (Line(points={{-198,220},{-160,220},{
          -160,240},{-40,240},{-40,80},{98,80}}, color={255,0,255}));
  connect(repChi8.y, y1ValEvaChiHea)
    annotation (Line(points={{122,80},{280,80}}, color={255,0,255}));
  connect(repChi6.y, yValConChiHea)
    annotation (Line(points={{142,60},{280,60}}, color={0,0,127}));
  connect(repPumHeaWat.y, y1PumHeaWat) annotation (Line(points={{82,20},{182,20},
          {182,20},{280,20}},        color={255,0,255}));
  connect(y1.y[1], cvtValCon.u) annotation (Line(points={{-198,220},{-160,220},
          {-160,240},{-30,240}}, color={255,0,255}));
  connect(cvtValCon.y, repChi2.u)
    annotation (Line(points={{-6,240},{98,240}}, color={0,0,127}));
  connect(cvtValCon.y, repChi6.u) annotation (Line(points={{-6,240},{0,240},{0,
          60},{118,60}}, color={0,0,127}));
  connect(repPumConWatCon.y, y1PumConWatCon)
    annotation (Line(points={{82,-80},{280,-80}}, color={255,0,255}));
  connect(and3.y, and2.u2) annotation (Line(points={{-108,-140},{-100,-140},{
          -100,-128},{-82,-128}}, color={255,0,255}));
  connect(delVal.y, and2.u1) annotation (Line(points={{-128,220},{-120,220},{
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
    annotation (Line(points={{82,-180},{182,-180},{182,-180},{280,-180}},
                                                    color={255,0,255}));
  connect(delPum.y, repHeaPum.u) annotation (Line(points={{-86,280},{20,280},{
          20,-180},{58,-180}},
                            color={255,0,255}));
  connect(cstTHeaPumSet.y, THeaPumSet)
    annotation (Line(points={{-198,-200},{280,-200}}, color={0,0,127}));
  connect(and2.y, repPumHeaWat.u) annotation (Line(points={{-58,-120},{0,-120},
          {0,20},{58,20}}, color={255,0,255}));
  connect(cvtPumHeaWat.y, yPumHeaWat) annotation (Line(points={{112,0},{190,0},
          {190,0},{280,0}}, color={0,0,127}));
  connect(and2.y, cvtPumHeaWat.u) annotation (Line(points={{-58,-120},{0,-120},
          {0,0},{88,0}}, color={255,0,255}));
  connect(cvtPumChiWat.y, yPumChiWat)
    annotation (Line(points={{112,200},{280,200}}, color={0,0,127}));
  connect(delVal.y, cvtPumChiWat.u) annotation (Line(points={{-128,220},{-20,
          220},{-20,200},{88,200}}, color={255,0,255}));
  connect(delVal.y, repPumConWatCon.u) annotation (Line(points={{-128,220},{
          -120,220},{-120,-80},{58,-80}}, color={255,0,255}));
  connect(cvtPumConWatCon.y, yPumConWatCon)
    annotation (Line(points={{-8,-100},{280,-100}}, color={0,0,127}));
  connect(delVal.y, cvtPumConWatCon.u) annotation (Line(points={{-128,220},{
          -120,220},{-120,-100},{-32,-100}}, color={255,0,255}));
  connect(y1CooChi.y[1], and3.u) annotation (Line(points={{-198,100},{-140,100},
          {-140,-140},{-132,-140}}, color={255,0,255}));
  connect(y1CooChi.y[1], repChi5.u)
    annotation (Line(points={{-198,100},{78,100}}, color={255,0,255}));
  connect(repCoo.y, y1Coo)
    annotation (Line(points={{82,-280},{280,-280}}, color={255,0,255}));
  connect(coo.y[1], delVal1.u)
    annotation (Line(points={{-198,-280},{-172,-280}}, color={255,0,255}));
  connect(delVal1.y, repCoo.u) annotation (Line(points={{-148,-280},{-46,-280},
          {-46,-280},{58,-280}}, color={255,0,255}));
  connect(cvtValBypTan.y, yValBypTan) annotation (Line(points={{112,-240},{190,
          -240},{190,-240},{280,-240}}, color={0,0,127}));
  connect(cvtValBypTan.u, notCoo.y)
    annotation (Line(points={{88,-240},{82,-240}}, color={255,0,255}));
  connect(coo.y[1], notCoo.u) annotation (Line(points={{-198,-280},{-180,-280},
          {-180,-240},{58,-240}}, color={255,0,255}));
  connect(cvtSpeCoo.y, yCoo) annotation (Line(points={{112,-300},{190,-300},{
          190,-300},{280,-300}}, color={0,0,127}));
  connect(delVal1.y, cvtSpeCoo.u) annotation (Line(points={{-148,-280},{0,-280},
          {0,-300},{88,-300}}, color={255,0,255}));
  connect(repPumCoo.y, y1PumConWatCoo) annotation (Line(points={{82,-320},{176,
          -320},{176,-320},{280,-320}}, color={255,0,255}));
  connect(delVal1.y, repPumCoo.u) annotation (Line(points={{-148,-280},{-0,-280},
          {-0,-320},{58,-320}}, color={255,0,255}));
annotation (
  defaultComponentName="ctl");
end OpenLoop;
