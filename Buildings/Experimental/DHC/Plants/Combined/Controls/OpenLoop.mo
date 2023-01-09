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
    annotation (Placement(transformation(extent={{-108,230},{-88,250}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0,0; 0.2,0; 0.2,1; 1,1],
    timeScale=3600,
    period=3600)
    "Boolean source for DO signals"
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumChiWat(nout=
        nPumChiWat) "Replicate signal"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi(nout=nChi)
    "Replicate signal"
    annotation (Placement(transformation(extent={{60,230},{80,250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtValCon
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{-28,190},{-8,210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delVal(final delayTime=
        riseTimeVal) "Delay command signal to allow for valve opening time"
    annotation (Placement(transformation(extent={{-150,170},{-130,190}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi1(nout=nChi)
    "Replicate signal"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repChi2(nout=nChi)
    "Replicate signal"
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant valByp(
    k=0,
    y(start=0))
    "Source signal for minimum flow bypass valve"
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi4(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi5(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repChi6(nout=nChiHea)
    "Replicate signal"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPumHeaWat(nout=
        nPumHeaWat) "Replicate signal"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Coo(
    table=[0,1; 0.6,1; 0.6,0; 1,0],
    timeScale=3600,
    period=3600) "Boolean source for switchover signal"
    annotation (Placement(transformation(extent={{-200,70},{-180,90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repChi8(nout=
        nChiHea) "Replicate signal"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiCooCon(
    y(start={false}),
    table=[0,0; 0.8,0; 0.8,1; 1,1],
    timeScale=3600,
    period=3600)
    "Boolean source for direct heat recovery signal: true for direct, false for cascading heat recovery"
    annotation (Placement(transformation(extent={{-200,-210},{-180,-190}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "AND"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
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
equation
  connect(repPumChiWat.y, y1PumChiWat)
    annotation (Line(points={{82,180},{240,180}}, color={255,0,255}));
  connect(delPum.y, repChi.u)
    annotation (Line(points={{-86,240},{58,240}}, color={255,0,255}));
  connect(repChi.y, y1Chi)
    annotation (Line(points={{82,240},{240,240}}, color={255,0,255}));
  connect(y1.y[1], delVal.u)
    annotation (Line(points={{-178,180},{-152,180}}, color={255,0,255}));
  connect(delVal.y, delPum.u) annotation (Line(points={{-128,180},{-120,180},{
          -120,240},{-110,240}}, color={255,0,255}));
  connect(y1.y[1], repChi1.u) annotation (Line(points={{-178,180},{-160,180},{
          -160,220},{78,220}}, color={255,0,255}));
  connect(repChi1.y, y1ValEvaChi)
    annotation (Line(points={{102,220},{240,220}}, color={255,0,255}));
  connect(repChi2.y, yValConChi)
    annotation (Line(points={{122,200},{240,200}}, color={0,0,127}));
  connect(delVal.y, repPumChiWat.u)
    annotation (Line(points={{-128,180},{58,180}}, color={255,0,255}));
  connect(valByp.y, yValChiWatMinByp)
    annotation (Line(points={{-178,140},{240,140}}, color={0,0,127}));
  connect(valByp.y, yValHeaWatMinByp) annotation (Line(points={{-178,140},{210,
          140},{210,-40},{240,-40}},   color={0,0,127}));
  connect(repChi4.y, y1ChiHea) annotation (Line(points={{82,100},{156,100},{156,
          100},{240,100}}, color={255,0,255}));
  connect(repChi5.y, y1CooChiHea)
    annotation (Line(points={{102,80},{240,80}}, color={255,0,255}));
  connect(delPum.y, repChi4.u) annotation (Line(points={{-86,240},{40,240},{40,
          100},{58,100}}, color={255,0,255}));
  connect(y1Coo.y[1], repChi5.u)
    annotation (Line(points={{-178,80},{78,80}}, color={255,0,255}));
  connect(y1.y[1], repChi8.u) annotation (Line(points={{-178,180},{-160,180},{
          -160,220},{-40,220},{-40,60},{98,60}}, color={255,0,255}));
  connect(repChi8.y, y1ValEvaChiHea)
    annotation (Line(points={{122,60},{240,60}}, color={255,0,255}));
  connect(repChi6.y, yValConChiHea)
    annotation (Line(points={{142,40},{240,40}}, color={0,0,127}));
  connect(repPumHeaWat.y, y1PumHeaWat) annotation (Line(points={{82,0},{240,0}},
                                     color={255,0,255}));
  connect(delVal.y, repPumHeaWat.u) annotation (Line(points={{-128,180},{-80,
          180},{-80,0},{58,0}},     color={255,0,255}));
  connect(y1.y[1], cvtValCon.u) annotation (Line(points={{-178,180},{-160,180},
          {-160,200},{-30,200}}, color={255,0,255}));
  connect(cvtValCon.y, repChi2.u)
    annotation (Line(points={{-6,200},{98,200}}, color={0,0,127}));
  connect(cvtValCon.y, repChi6.u) annotation (Line(points={{-6,200},{0,200},{0,
          40},{118,40}}, color={0,0,127}));
  connect(y1ValChiCooCon.y[1], cvtValChiCooCon.u) annotation (Line(points={{-178,
          -200},{188,-200}},                          color={255,0,255}));
  connect(repPumConWatCon.y, y1PumConWatCon)
    annotation (Line(points={{82,-80},{240,-80}}, color={255,0,255}));
  connect(delVal.y, and1.u1) annotation (Line(points={{-128,180},{-120,180},{
          -120,-80},{-82,-80}}, color={255,0,255}));
  connect(y1Coo.y[1], and1.u2) annotation (Line(points={{-178,80},{-140,80},{
          -140,-88},{-82,-88}}, color={255,0,255}));
  connect(and1.y, repPumConWatCon.u)
    annotation (Line(points={{-58,-80},{58,-80}}, color={255,0,255}));
  connect(and1.y, cvtPumConWatCon.u) annotation (Line(points={{-58,-80},{-40,
          -80},{-40,-100},{-32,-100}}, color={255,0,255}));
  connect(cvtPumConWatCon.y, yPumConWatCon)
    annotation (Line(points={{-8,-100},{240,-100}}, color={0,0,127}));
  connect(y1Coo.y[1], and3.u) annotation (Line(points={{-178,80},{-140,80},{
          -140,-140},{-132,-140}}, color={255,0,255}));
  connect(and3.y, and2.u2) annotation (Line(points={{-108,-140},{-100,-140},{
          -100,-128},{-82,-128}}, color={255,0,255}));
  connect(delVal.y, and2.u1) annotation (Line(points={{-128,180},{-120,180},{
          -120,-120},{-82,-120}}, color={255,0,255}));
  connect(repPumConWatEva.y, y1PumConWatEva)
    annotation (Line(points={{82,-120},{240,-120}}, color={255,0,255}));
  connect(and2.y, repPumConWatEva.u)
    annotation (Line(points={{-58,-120},{58,-120}}, color={255,0,255}));
  connect(and2.y, cvtPumConWatEva.u) annotation (Line(points={{-58,-120},{-40,
          -120},{-40,-140},{-32,-140}}, color={255,0,255}));
  connect(cvtPumConWatEva.y, yPumConWatEva)
    annotation (Line(points={{-8,-140},{240,-140}}, color={0,0,127}));
annotation (
  defaultComponentName="ctl");
end OpenLoop;
