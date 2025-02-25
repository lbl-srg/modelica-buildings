within Buildings.DHC.Plants.Combined.Controls.BaseClasses;
block CoolingTowerLoop "Cooling tower loop control"

  parameter Real mConWatHexCoo_flow_nominal(
    final quantity="MassFlowRate",
    final unit="kg/s")
    "Design total CW mass flow rate through condenser barrels (all units)";
  parameter Integer nCoo(final min=1, start=1)
    "Number of cooling tower cells operating at design conditions"
    annotation (Evaluate=true);
  parameter Integer nPumConWatCoo(final min=1, start=1)
    "Number of CW pumps serving cooling towers at design conditions"
    annotation (Evaluate=true);
  parameter Real QChiWat_flow_nominal(
    final quantity="HeatFlowRate",
    final unit="W")
    "Design plant cooling heat flow rate (all units)";
  parameter Real dTLifChi_min(
    final quantity="TemperatureDifference",
    final unit="K")
    "Minimum chiller lift at minimum load";
  parameter Real dTLifChi_nominal(
    final quantity="TemperatureDifference",
    final unit="K")
    "Design chiller lift";
  parameter Real TTanSet[2, 2](
    each final quantity="ThermodynamicTemperature",
    each final unit="K",
    each displayUnit="degC")
    "Tank temperature setpoints: 2 cycles with 2 setpoints";
  parameter Real dTHexCoo_nominal(
    final quantity="TemperatureDifference",
    final unit="K")
    "Design heat exchanger approach";
  parameter Real yPumConWatCoo_min[nPumConWatCoo](
    each final unit="1")= {0.2/i for i in 1:nPumConWatCoo}
    "Tower pump speed needed to maintain minimum tower flow (each pump stage)";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode(
    final min=Buildings.DHC.Plants.Combined.Controls.ModeCondenserLoop.tankCharge,
    final max=Buildings.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Condenser loop operating mode"
    annotation (Placement(transformation(extent={{-220,260},{-180,300}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput idxCycTan(
    final min=1,
    final max=2)
    "Index of active tank cycle"
    annotation (Placement(transformation(extent={{-220,220},{-180,260}}),
    iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatCooSup(
    final unit="K",
    displayUnit="degC")
    "Cooling tower loop CW supply temperature"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
        iconTransformation(extent={{-140,2},{-100,42}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatHexCoo_flow(
    final unit="kg/s")
    "CW mass flow rate through secondary side of HX"
    annotation (Placement(transformation(extent={{-220,0},{-180,40}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput  QCooReq_flow(
    final unit="W")
    "Plant required cooling capacity (>0)"
    annotation (Placement(transformation(extent={{-220,160},{-180,200}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatConChiEnt(
    final unit="K",
    displayUnit="degC")
    "Chiller and HRC entering CW temperature"
    annotation (Placement(transformation(extent={{-220,60},{-180,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatConChiLvg(
    final unit="K",
    displayUnit="degC")
    "Chiller and HRC leaving CW temperature"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatCooRet(
    final unit="K",
    displayUnit="degC")
    "Cooling tower loop CW return temperature"
    annotation (Placement(transformation(extent={{-220,-200},{-180,-160}}),
        iconTransformation(extent={{-140,-18},{-100,22}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValBypTan(
    final unit="1")
    "TES tank bypass valve commanded position"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatHexCooEnt(
    final unit="K",
    displayUnit="degC")
    "HX entering CW temperature"
    annotation (Placement(transformation(extent={{-220,-240},{-180,-200}}),
        iconTransformation(extent={{-140,-38},{-100,2}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatHexCooLvg(
    final unit="K",
    displayUnit="degC")
    "HX leaving CW temperature"
    annotation (Placement(transformation(extent={{-220,-260},{-180,-220}}),
        iconTransformation(extent={{-140,-58},{-100,-18}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatCoo[nPumConWatCoo]
    "Cooling tower pump Start command"
    annotation (Placement(transformation(extent={{180,60},{220,100}}),
        iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo
    "Cooling tower fan speed command"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumConWatCoo
    "Cooling tower pump speed command"
    annotation (Placement(transformation(extent={{180,-220},{220,-180}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Coo[nCoo]
    "Cooling tower Start command"
    annotation (Placement(transformation(extent={{180,-120},{220,-80}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract delTemCon
    "Compute CW deltaT"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage mea(
    delta=5*60)
    "Moving mean"
    annotation (Placement(transformation(extent={{-130,50},{-110,70}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract delTem1
    "Compute deltaT"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Reals.Add lifPlu
    "Add target lift"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subApp(
    final p=-dTHexCoo_nominal)
    "Substract HX approach"
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSupSetUnb(
    y(unit="K", displayUnit="degC"))
    "Compute tower supply temperature setpoint, unbounded"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0, origin={-20,280})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant modRej(
    final k=Buildings.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Heat rejection mode index"
    annotation (Placement(transformation(extent={{-150,250},{-130,270}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isModRej
    "Heat rejection mode"
    annotation (Placement(transformation(extent={{-110,270},{-90,290}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant setOth[2](
    final k=TTanSet[:, 1] .- dTHexCoo_nominal)
    "Target setpoint in any mode other than heat rejection"
    annotation (Placement(transformation(extent={{-110,210},{-90,230}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extSet(
    final nin=2)
    "Extract setpoint value based on current mode"
    annotation (Placement(transformation(extent={{-70,250},{-50,270}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter ratDes(
    final k=abs(1/QChiWat_flow_nominal))
    "Ratio to design capacity"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Reals.Line lif
    "Compute target chiller lift"
    annotation (Placement(transformation(extent={{-110,150},{-90,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xLif[2](k={0.1,1})
    "x-value for lift reset"
    annotation (Placement(transformation(extent={{-160,200},{-140,220}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yLif[2](
    final k={dTLifChi_min,dTLifChi_nominal})
    "y-value for lift reset"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.DHC.Plants.Combined.Controls.BaseClasses.StagingPump staPum(
    nPum=nPumConWatCoo,
    have_flowCriterion=false,
    yDow=0.4,
    yUp=0.8)
    "Stage pumps"
    annotation (Placement(transformation(extent={{120,70},{140,90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold cmpFlo(
    final t=0.025*mConWatHexCoo_flow_nominal,
    final h=0.025*mConWatHexCoo_flow_nominal/2)
    "Flow criterion to enable lead pump"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timFlo(
    t=60)
    "Timer for flow exceeding triggering limit"
    annotation (Placement(transformation(extent={{-130,10},{-110,30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timFlo1(
    t=5*60)
    "Timer for flow exceeding triggering limit"
    annotation (Placement(transformation(extent={{-130,-30},{-110,-10}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold cmpOpe(
    t=0.99,
    h=0.005)
    "Valve opening criterion to enable lead pump"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timOpe(t=60)
    "Timer for valve opening exceeding triggering limit"
    annotation (Placement(transformation(extent={{-130,-70},{-110,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timOpe1(t=60)
    "Timer for valve opening exceeding triggering limit"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Valve opening criterion to disable lead pump"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or dis "Disable condition"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And ena "Enable condition"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaLea "Enable lead pump"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract delTem2 "Compute deltaT"
    annotation (Placement(transformation(extent={{-160,-230},{-140,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract delTem3 "Compute deltaT"
    annotation (Placement(transformation(extent={{-160,-190},{-140,-170}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addOff(final p=-1)
    "Add offset"
    annotation (Placement(transformation(extent={{-130,-230},{-110,-210}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addApp(
    final p=dTHexCoo_nominal)
    "Add HX approach"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
  Buildings.DHC.ETS.Combined.Controls.PIDWithEnable ctlPum1(
    k=0.01,
    Ti=60,
    final reverseActing=false)
    "Pump control loop #1"
    annotation (Placement(transformation(extent={{-10,-190},{10,-170}})));
  Buildings.DHC.ETS.Combined.Controls.PIDWithEnable ctlPum2(
    k=0.01,
    Ti=60,
    final reverseActing=false)
    "Pump control loop #1"
    annotation (Placement(transformation(extent={{-10,-230},{10,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Min minCtlPum
    "Minimum loop output"
    annotation (Placement(transformation(extent={{30,-210},{50,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Line pum
    "Pump speed command"
    annotation (Placement(transformation(extent={{120,-210},{140,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xPum[2](k={0,1})
    "x-value for pump speed reset"
    annotation (Placement(transformation(extent={{90,-190},{110,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{90,-240},{110,-220}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumMin[nPumConWatCoo](
     final k=yPumConWatCoo_min)
     "Minimum pump speed"
    annotation (Placement(transformation(extent={{30,-240},{50,-220}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extYPumMin(
    final nin=nPumConWatCoo)
    "Extract minimum pump speed value based on current pump stage"
    annotation (Placement(transformation(extent={{60,-240},{80,-220}})));
  Buildings.Controls.OBC.CDL.Reals.Line fanMax
    "Compute maximum fan speed"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xFan[2](k={0,0.5})
    "x-value for maximum fan speed reset"
    annotation (Placement(transformation(extent={{20,200},{40,220}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yFan[2](
    final k={0.7,1.0})
    "y-value for maximum fan speed reset"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Buildings.DHC.ETS.Combined.Controls.PIDWithEnable ctlFan(
    k=0.05,
    Ti=60,
    final reverseActing=false)
    "Fan control loop"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Left limit of signal to avoid direct feedback"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90, origin={-60,-130})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant setMax(k=25 + 273.15)
    "Maximum setpoint"
    annotation (Placement(transformation(extent={{-70,210},{-50,230}})));
  Buildings.Controls.OBC.CDL.Reals.Min TSupSet(
    y(unit="K", displayUnit="degC"))
    "Compute tower supply temperature setpoint"
    annotation (Placement(transformation(extent={{-30,210},{-10,230}})));
  Buildings.Controls.OBC.CDL.Reals.Line fan
    "Compute fan speed"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xFan1[2](
    k={0,1})
    "x-value for fan speed reset"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yFan1(
    final k=0)
    "y-value for fan speed reset"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Flow criterion to disable lead pump"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep(
    final nout=nCoo)
    "Replicate"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not notDis "Not disabled"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Buildings.Controls.OBC.CDL.Logical.And enaAndNotDis
    "Reset enable condition when disable is true to trigger latch block when (enable, disable) becomes (true, false) again"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Integers.Max comPum
    "Number of pumps commanded on, bounded by 1"
    annotation (Placement(transformation(extent={{0,-280},{20,-260}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-80,-280},{-60,-260}})));

equation
  connect(QCooReq_flow, ratDes.u)
    annotation (Line(points={{-200,180},{-162,180}}, color={0,0,127}));
  connect(ratDes.y, lif.u)
    annotation (Line(points={{-138,180},{-126,180},{-126,160},{-112,160}},
          color={0,0,127}));
  connect(xLif[1].y, lif.x1) annotation (Line(points={{-138,210},{-120,210},{-120,
          168},{-112,168}}, color={0,0,127}));
  connect(xLif[2].y, lif.x2) annotation (Line(points={{-138,210},{-120,210},{-120,
          156},{-112,156}}, color={0,0,127}));
  connect(yLif[1].y, lif.f1) annotation (Line(points={{-138,150},{-116,150},{-116,
          164},{-112,164}}, color={0,0,127}));
  connect(yLif[2].y, lif.f2) annotation (Line(points={{-138,150},{-116,150},{-116,
          152},{-112,152}}, color={0,0,127}));
  connect(TConWatConChiLvg, delTemCon.u1) annotation (Line(points={{-200,60},{-170,
          60},{-170,66},{-162,66}}, color={0,0,127}));
  connect(TConWatConChiEnt, delTemCon.u2) annotation (Line(points={{-200,80},{-174,
          80},{-174,54},{-162,54}}, color={0,0,127}));
  connect(delTemCon.y, mea.u)
    annotation (Line(points={{-138,60},{-132,60}}, color={0,0,127}));
  connect(lif.y, lifPlu.u1) annotation (Line(points={{-88,160},{-80,160},{-80,136},
          {-140,136},{-140,126},{-132,126}},      color={0,0,127}));
  connect(TChiWatSupSet, lifPlu.u2) annotation (Line(points={{-200,120},{-140,120},
          {-140,114},{-132,114}},    color={0,0,127}));
  connect(lifPlu.y, delTem1.u1) annotation (Line(points={{-108,120},{-104,120},{
          -104,96},{-102,96}},  color={0,0,127}));
  connect(mea.y, delTem1.u2) annotation (Line(points={{-108,60},{-104,60},{-104,
          84},{-102,84}},  color={0,0,127}));
  connect(delTem1.y,subApp. u)
    annotation (Line(points={{-78,90},{-72,90}},  color={0,0,127}));
  connect(mode, isModRej.u1)
    annotation (Line(points={{-200,280},{-112,280}}, color={255,127,0}));
  connect(modRej.y, isModRej.u2) annotation (Line(points={{-128,260},{-120,260},
          {-120,272},{-112,272}}, color={255,127,0}));
  connect(isModRej.y, TSupSetUnb.u2)
    annotation (Line(points={{-88,280},{-32,280}}, color={255,0,255}));
  connect(subApp.y, TSupSetUnb.u1) annotation (Line(points={{-48,90},{-40,90},{-40,
          288},{-32,288}}, color={0,0,127}));
  connect(setOth.y,extSet. u) annotation (Line(points={{-88,220},{-80,220},{-80,
          260},{-72,260}}, color={0,0,127}));
  connect(extSet.y, TSupSetUnb.u3) annotation (Line(points={{-48,260},{-36,260},
          {-36,272},{-32,272}}, color={0,0,127}));
  connect(mConWatHexCoo_flow, cmpFlo.u) annotation (Line(points={{-200,20},{-162,
          20}},color={0,0,127}));
  connect(cmpFlo.y, timFlo.u)
    annotation (Line(points={{-138,20},{-132,20}},   color={255,0,255}));
  connect(yValBypTan, cmpOpe.u)
    annotation (Line(points={{-200,-60},{-162,-60}},   color={0,0,127}));
  connect(not1.y, timOpe1.u)
    annotation (Line(points={{-138,-100},{-132,-100}}, color={255,0,255}));
  connect(cmpOpe.y, timOpe.u)
    annotation (Line(points={{-138,-60},{-132,-60}},   color={255,0,255}));
  connect(cmpOpe.y, not1.u) annotation (Line(points={{-138,-60},{-134,-60},{-134,
          -80},{-170,-80},{-170,-100},{-162,-100}}, color={255,0,255}));
  connect(timFlo.passed, ena.u1) annotation (Line(points={{-108,12},{-104,12},{-104,
          20},{-92,20}}, color={255,0,255}));
  connect(timOpe.passed, ena.u2) annotation (Line(points={{-108,-68},{-100,-68},
          {-100,12},{-92,12}}, color={255,0,255}));
  connect(timFlo1.passed, dis.u1) annotation (Line(points={{-108,-28},{-104,-28},
          {-104,-50},{-92,-50}},  color={255,0,255}));
  connect(timOpe1.passed, dis.u2) annotation (Line(points={{-108,-108},{-96,-108},
          {-96,-58},{-92,-58}}, color={255,0,255}));
  connect(dis.y,enaLea. clr) annotation (Line(points={{-68,-50},{-40,-50},{-40,-26},
          {-32,-26}}, color={255,0,255}));
  connect(enaLea.y, staPum.y1Ena) annotation (Line(points={{-8,-20},{20,-20},{20,
          86},{118,86}},        color={255,0,255}));
  connect(TConWatCooRet, delTem3.u1) annotation (Line(points={{-200,-180},{-166,
          -180},{-166,-174},{-162,-174}}, color={0,0,127}));
  connect(TConWatCooSup, delTem3.u2) annotation (Line(points={{-200,-160},{-170,
          -160},{-170,-186},{-162,-186}}, color={0,0,127}));
  connect(TConWatHexCooEnt, delTem2.u1) annotation (Line(points={{-200,-220},{-166,
          -220},{-166,-214},{-162,-214}}, color={0,0,127}));
  connect(delTem2.y, addOff.u)
    annotation (Line(points={{-138,-220},{-132,-220}}, color={0,0,127}));
  connect(addApp.y, ctlPum1.u_s)
    annotation (Line(points={{-18,-180},{-12,-180}}, color={0,0,127}));
  connect(delTem3.y, ctlPum2.u_m) annotation (Line(points={{-138,-180},{-90,-180},
          {-90,-240},{0,-240},{0,-232}}, color={0,0,127}));
  connect(addOff.y, ctlPum2.u_s)
    annotation (Line(points={{-108,-220},{-12,-220}}, color={0,0,127}));
  connect(ctlPum1.y, minCtlPum.u1) annotation (Line(points={{12,-180},{20,-180},
          {20,-194},{28,-194}}, color={0,0,127}));
  connect(ctlPum2.y, minCtlPum.u2) annotation (Line(points={{12,-220},{20,-220},
          {20,-206},{28,-206}}, color={0,0,127}));
  connect(xPum[1].y, pum.x1) annotation (Line(points={{112,-180},{114,-180},{114,
          -192},{118,-192}}, color={0,0,127}));
  connect(xPum[2].y, pum.x2) annotation (Line(points={{112,-180},{114,-180},{114,
          -204},{118,-204}}, color={0,0,127}));
  connect(pum.y, yPumConWatCoo) annotation (Line(points={{142,-200},{200,-200}},
          color={0,0,127}));
  connect(one.y, pum.f2) annotation (Line(points={{112,-230},{114,-230},{114,-208},
          {118,-208}},color={0,0,127}));
  connect(minCtlPum.y, pum.u)
    annotation (Line(points={{52,-200},{118,-200}},color={0,0,127}));
  connect(idxCycTan,extSet. index) annotation (Line(points={{-200,240},{-60,240},
          {-60,248}}, color={255,127,0}));
  connect(yPumMin.y, extYPumMin.u)
    annotation (Line(points={{52,-230},{58,-230}}, color={0,0,127}));
  connect(extYPumMin.y, pum.f1) annotation (Line(points={{82,-230},{84,-230},{84,
          -196},{118,-196}},color={0,0,127}));
  connect(xFan[1].y, fanMax.x1) annotation (Line(points={{42,210},{50,210},{50,188},
          {58,188}}, color={0,0,127}));
  connect(xFan[2].y, fanMax.x2) annotation (Line(points={{42,210},{50,210},{50,176},
          {58,176}}, color={0,0,127}));
  connect(yFan[1].y, fanMax.f1) annotation (Line(points={{42,150},{54,150},{54,184},
          {58,184}}, color={0,0,127}));
  connect(yFan[2].y, fanMax.f2) annotation (Line(points={{42,150},{54,150},{54,172},
          {58,172}}, color={0,0,127}));
  connect(ratDes.y, fanMax.u)
    annotation (Line(points={{-138,180},{58,180}}, color={0,0,127}));
  connect(enaLea.y, pre1.u) annotation (Line(points={{-8,-20},{20,-20},{20,-60},
          {-60,-60},{-60,-118}}, color={255,0,255}));
  connect(TConWatCooSup, ctlFan.u_m) annotation (Line(points={{-200,-160},{50,-160},
          {50,-52}},  color={0,0,127}));
  connect(pum.y, staPum.y) annotation (Line(points={{142,-200},{150,-200},{150,60},
          {100,60},{100,74},{118,74}},  color={0,0,127}));
  connect(pre1.y, ctlPum1.uEna) annotation (Line(points={{-60,-142},{-60,-196},{
          -4,-196},{-4,-192}}, color={255,0,255}));
  connect(pre1.y, ctlPum2.uEna) annotation (Line(points={{-60,-142},{-60,-236},{
          -4,-236},{-4,-232}}, color={255,0,255}));
  connect(staPum.y1, y1PumConWatCoo)
    annotation (Line(points={{142,86},{170,86},{170,80},{200,80}}, color={255,0,255}));
  connect(setMax.y, TSupSet.u2) annotation (Line(points={{-48,220},{-44,220},{-44,
          214},{-32,214}}, color={0,0,127}));
  connect(TSupSetUnb.y, TSupSet.u1) annotation (Line(points={{-8,280},{0,280},{0,
          240},{-34,240},{-34,226},{-32,226}}, color={0,0,127}));
  connect(TSupSet.y, ctlFan.u_s) annotation (Line(points={{-8,220},{0,220},{0,-40},
          {38,-40}}, color={0,0,127}));
  connect(TSupSet.y, addApp.u) annotation (Line(points={{-8,220},{0,220},{0,-80},
          {-80,-80},{-80,-180},{-42,-180}}, color={0,0,127}));
  connect(TConWatHexCooLvg, delTem2.u2) annotation (Line(points={{-200,-240},{-170,
          -240},{-170,-226},{-162,-226}}, color={0,0,127}));
  connect(TConWatHexCooLvg, ctlPum1.u_m) annotation (Line(points={{-200,-240},{-170,
          -240},{-170,-200},{0,-200},{0,-192}}, color={0,0,127}));
  connect(xFan1[1].y, fan.x1) annotation (Line(points={{102,-20},{114,-20},{114,
          -32},{118,-32}}, color={0,0,127}));
  connect(xFan1[2].y, fan.x2) annotation (Line(points={{102,-20},{114,-20},{114,
          -44},{118,-44}}, color={0,0,127}));
  connect(yFan1.y, fan.f1) annotation (Line(points={{102,-60},{116,-60},{116,-36},
          {118,-36}}, color={0,0,127}));
  connect(ctlFan.y, fan.u)
    annotation (Line(points={{62,-40},{118,-40}},  color={0,0,127}));
  connect(fan.y, yCoo)
    annotation (Line(points={{142,-40},{200,-40}}, color={0,0,127}));
  connect(fanMax.y, fan.f2) annotation (Line(points={{82,180},{110,180},{110,-48},
          {118,-48}}, color={0,0,127}));
  connect(enaLea.y, ctlFan.uEna) annotation (Line(points={{-8,-20},{20,-20},{20,
          -60},{46,-60},{46,-52}}, color={255,0,255}));
  connect(cmpFlo.y, not2.u) annotation (Line(points={{-138,20},{-134,20},{-134,0},
          {-166,0},{-166,-20},{-162,-20}}, color={255,0,255}));
  connect(not2.y, timFlo1.u)
    annotation (Line(points={{-138,-20},{-132,-20}}, color={255,0,255}));
  connect(rep.y, y1Coo)
    annotation (Line(points={{102,-100},{200,-100}}, color={255,0,255}));
  connect(enaLea.y, rep.u) annotation (Line(points={{-8,-20},{20,-20},{20,-100},
          {78,-100}}, color={255,0,255}));
  connect(ena.y, enaAndNotDis.u1)
    annotation (Line(points={{-68,20},{-62,20}}, color={255,0,255}));
  connect(notDis.y, enaAndNotDis.u2) annotation (Line(points={{-68,-10},{-66,-10},
          {-66,12},{-62,12}}, color={255,0,255}));
  connect(enaAndNotDis.y, enaLea.u) annotation (Line(points={{-38,20},{-36,20},{
          -36,-20},{-32,-20}}, color={255,0,255}));
  connect(dis.y, notDis.u) annotation (Line(points={{-68,-50},{-64,-50},{-64,-28},
          {-96,-28},{-96,-10},{-92,-10}}, color={255,0,255}));
  connect(comPum.y, extYPumMin.index) annotation (Line(points={{22,-270},{70,-270},
          {70,-242}}, color={255,127,0}));
  connect(staPum.nPumEna, comPum.u2) annotation (Line(points={{142,74},{160,74},
          {160,-290},{-10,-290},{-10,-276},{-2,-276}}, color={255,127,0}));
  connect(conInt.y, comPum.u1) annotation (Line(points={{-58,-270},{-20,-270},{-20,
          -264},{-2,-264}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(extent={{-100,-180},{100,180}}),
                   graphics={
        Rectangle(
          extent={{-100,-180},{100,180}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,190},{150,230}},
          textString="%name")}), Diagram(coordinateSystem(extent={{-180,-300},{180,
            300}})),
    Documentation(info="<html>
<p>
This block implements the control logic for the CT pumps and
CT fans.
</p>
<h4>CT supply temperature setpoint</h4>
<p>
When Heat Rejection mode is enabled, the setpoint is equal to
<i>min(25&nbsp;°C, TChiWatSupSet + dTLif - dTConWat - dTHexCoo_nominal)</i>, where
<i>TChiWatSupSet</i> is the CHW supply temperature setpoint,
<i>dTLif</i> is the target chiller lift (see below),
<i>dTConWat</i> is the chiller condenser Delta-T averaged over
a <i>5</i>-minute moving window, and
<i>dTHexCoo_nominal</i> is the design heat exchanger approach.
The target chiller lift is reset from the minimum chiller lift
to the design chiller lift when the plant required cooling capacity
varies from  <i>10&nbsp;%</i> to <i>100&nbsp;%</i> of the design value.
</p>
<p>
In any other mode the setpoint is equal to the minimum setpoint value
of the active tank cycle minus the design heat exchanger approach.
</p>
<h4>CT pumps</h4>
<p>
The lead pump is enabled whenever the TES tank bypass valve commanded
position is lower than <i>1</i> for <i>1&nbsp;</i>min and the
CW mass flow rate through the secondary side of the cooling heat exchanger
is higher than <i>2.5&nbsp;%</i> of design condition for <i>1&nbsp;</i>min.
The lead pump is disabled whenever the TES tank bypass valve commanded
position is equal to <i>1</i> for <i>1&nbsp;</i>min or the
CW mass flow rate through the secondary side of the cooling heat exchanger
is lower than <i>2.5&nbsp;%</i> of design condition for <i>5&nbsp;</i>min.
</p>
<p>
The lag pump is enabled whenever the pump speed command (common to all pumps)
is higher than <i>80&nbsp;%</i> for <i>5&nbsp;</i>min.
The lag pump is disabled whenever the pump speed command
is lower than <i>80&nbsp;%</i> for <i>5&nbsp;</i>min or the lead pump
is disabled.
</p>
<p>
The pump speed command is the lower of that output by two loops, each loop
being enabled whenever any pump is proven on.
The first loop maintains the heat exchanger leaving CW
temperature on plant side at setpoint.
The setpoint is equal to the CT supply temperature setpoint plus
the design HX approach.
The second loop maintains the Delta-T across the primary side (CT loop)
of the HX at a setpoint equal to the Delta-T across the secondary
side (plant side) of the HX minus <i>1&nbsp;</i>K.
(This loop keeps the primary and secondary HX flow rates close to each other
and prevents pump speed runaway when target CT supply temperature setpoint
cannot be met.)
The output of each loop is mapped to the minimum pump speed at <i>80&nbsp;%</i>
to <i>100&nbsp;%</i> at <i>100&nbsp;%</i>.
The minimum pump speed is provided as a parameter for each pump stage since
different speeds are required for each stage to maintain minimum tower flow.
</p>
<h4>CT fans</h4>
<p>
When any of the CT pumps is commanded On, a control loop maintains the
tower water supply temperature at setpoint by resetting the tower fan speed
from <i>0&nbsp;%</i> to a maximum value varying between <i>70&nbsp;%</i>
and <i>100&nbsp;%</i> when the plant required cooling capacity
varies from  <i>0&nbsp;%</i> to <i>50&nbsp;%</i> of the design value.
Otherwise, the loop is disabled and its output set to <i>0&nbsp;%</i>.
</p>
<p>
Note that the fan cycling On and Off is implicitly modeled
in the cooling tower component which uses a low limit of the control signal
to switch to a free convection regime at zero fan power.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingTowerLoop;
