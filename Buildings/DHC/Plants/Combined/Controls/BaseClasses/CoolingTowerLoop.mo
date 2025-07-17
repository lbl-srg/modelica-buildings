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
    annotation (Placement(transformation(extent={{-220,280},{-180,320}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput idxCycTan(
    final min=1,
    final max=2)
    "Index of active tank cycle"
    annotation (Placement(transformation(extent={{-220,230},{-180,270}}),
    iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatCooSup(
    final unit="K",
    displayUnit="degC")
    "Cooling tower loop CW supply temperature"
    annotation (Placement(transformation(extent={{-220,-190},{-180,-150}}),
        iconTransformation(extent={{-140,2},{-100,42}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatHexCoo_flow(
    final unit="kg/s")
    "CW mass flow rate through secondary side of HX"
    annotation (Placement(transformation(extent={{-220,-10},{-180,30}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput  QCooReq_flow(
    final unit="W")
    "Plant required cooling capacity (>0)"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatConChiEnt(
    final unit="K",
    displayUnit="degC")
    "Chiller and HRC entering CW temperature"
    annotation (Placement(transformation(extent={{-220,50},{-180,90}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatConChiLvg(
    final unit="K",
    displayUnit="degC")
    "Chiller and HRC leaving CW temperature"
    annotation (Placement(transformation(extent={{-220,30},{-180,70}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-220,80},{-180,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatCooRet(
    final unit="K",
    displayUnit="degC")
    "Cooling tower loop CW return temperature"
    annotation (Placement(transformation(extent={{-220,-210},{-180,-170}}),
        iconTransformation(extent={{-140,-18},{-100,22}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValBypTan(
    final unit="1")
    "TES tank bypass valve commanded position"
    annotation (Placement(transformation(extent={{-220,-90},{-180,-50}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatHexCooEnt(
    final unit="K",
    displayUnit="degC")
    "HX entering CW temperature"
    annotation (Placement(transformation(extent={{-220,-250},{-180,-210}}),
        iconTransformation(extent={{-140,-38},{-100,2}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatHexCooLvg(
    final unit="K",
    displayUnit="degC")
    "HX leaving CW temperature"
    annotation (Placement(transformation(extent={{-220,-270},{-180,-230}}),
        iconTransformation(extent={{-140,-58},{-100,-18}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatCoo[nPumConWatCoo]
    "Cooling tower pump Start command"
    annotation (Placement(transformation(extent={{180,50},{220,90}}),
        iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo
    "Cooling tower fan speed command"
    annotation (Placement(transformation(extent={{180,-70},{220,-30}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumConWatCoo
    "Cooling tower pump speed command"
    annotation (Placement(transformation(extent={{180,-230},{220,-190}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Coo[nCoo]
    "Cooling tower Start command"
    annotation (Placement(transformation(extent={{180,-130},{220,-90}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract delTemCon
    "Compute CW deltaT"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage mea(
    delta=5*60)
    "Moving mean"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract delTem1
    "Compute deltaT"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Add lifPlu
    "Add target lift"
    annotation (Placement(transformation(extent={{-120,76},{-100,96}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subApp(
    final p=-dTHexCoo_nominal)
    "Substract HX approach"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSupSetUnb(
    y(unit="K", displayUnit="degC"))
    "Compute tower supply temperature setpoint, unbounded"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0, origin={50,290})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant modRej(
    final k=Buildings.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Heat rejection mode index"
    annotation (Placement(transformation(extent={{-160,270},{-140,290}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isModRej
    "Heat rejection mode"
    annotation (Placement(transformation(extent={{-100,290},{-80,310}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extSet(
    final nin=2)
    "Extract setpoint value based on current mode"
    annotation (Placement(transformation(extent={{-40,260},{-20,280}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter ratDes(
    final k=abs(1/QChiWat_flow_nominal))
    "Ratio to design capacity"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.CDL.Reals.Line lif
    "Compute target chiller lift"
    annotation (Placement(transformation(extent={{-110,120},{-90,140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xLif[2](k={0.1,1})
    "x-value for lift reset"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yLif[2](
    final k={dTLifChi_min,dTLifChi_nominal})
    "y-value for lift reset"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Buildings.DHC.Plants.Combined.Controls.BaseClasses.StagingPump staPum(
    nPum=nPumConWatCoo,
    have_flowCriterion=false,
    yDow=0.4,
    yUp=0.8)
    "Stage pumps"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold cmpFlo(
    final t=0.025*mConWatHexCoo_flow_nominal,
    final h=0.025*mConWatHexCoo_flow_nominal/2)
    "Flow criterion to enable lead pump"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timFlo(
    t=60)
    "Timer for flow exceeding triggering limit"
    annotation (Placement(transformation(extent={{-130,0},{-110,20}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timFlo1(
    t=5*60)
    "Timer for flow exceeding triggering limit"
    annotation (Placement(transformation(extent={{-130,-40},{-110,-20}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold cmpOpe(
    t=0.99,
    h=0.005)
    "Valve opening criterion to enable lead pump"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timOpe(t=60)
    "Timer for valve opening exceeding triggering limit"
    annotation (Placement(transformation(extent={{-130,-80},{-110,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timOpe1(t=60)
    "Timer for valve opening exceeding triggering limit"
    annotation (Placement(transformation(extent={{-130,-120},{-110,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Valve opening criterion to disable lead pump"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Or dis "Disable condition"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And ena "Enable condition"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaLea "Enable lead pump"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract delTem2 "Compute deltaT"
    annotation (Placement(transformation(extent={{-160,-240},{-140,-220}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract delTem3 "Compute deltaT"
    annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addOff(final p=-1)
    "Add offset"
    annotation (Placement(transformation(extent={{-130,-240},{-110,-220}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addApp(
    final p=dTHexCoo_nominal)
    "Add HX approach"
    annotation (Placement(transformation(extent={{-40,-200},{-20,-180}})));
  Buildings.DHC.ETS.Combined.Controls.PIDWithEnable ctlPum1(
    k=0.01,
    Ti=60,
    final reverseActing=false)
    "Pump control loop #1"
    annotation (Placement(transformation(extent={{-10,-200},{10,-180}})));
  Buildings.DHC.ETS.Combined.Controls.PIDWithEnable ctlPum2(
    k=0.01,
    Ti=60,
    final reverseActing=false)
    "Pump control loop #1"
    annotation (Placement(transformation(extent={{-10,-240},{10,-220}})));
  Buildings.Controls.OBC.CDL.Reals.Min minCtlPum
    "Minimum loop output"
    annotation (Placement(transformation(extent={{30,-220},{50,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Line pum
    "Pump speed command"
    annotation (Placement(transformation(extent={{120,-220},{140,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xPum[2](k={0,1})
    "x-value for pump speed reset"
    annotation (Placement(transformation(extent={{90,-200},{110,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{90,-250},{110,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumMin[nPumConWatCoo](
     final k=yPumConWatCoo_min)
     "Minimum pump speed"
    annotation (Placement(transformation(extent={{30,-250},{50,-230}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extYPumMin(
    final nin=nPumConWatCoo)
    "Extract minimum pump speed value based on current pump stage"
    annotation (Placement(transformation(extent={{60,-250},{80,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Line fanMax
    "Compute maximum fan speed"
    annotation (Placement(transformation(extent={{80,140},{100,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xFan[2](k={0,0.5})
    "x-value for maximum fan speed reset"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yFan[2](
    final k={0.7,1.0})
    "y-value for maximum fan speed reset"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Buildings.DHC.ETS.Combined.Controls.PIDWithEnable ctlFan(
    k=0.05,
    Ti=60,
    final reverseActing=false)
    "Fan control loop"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Left limit of signal to avoid direct feedback"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90, origin={-60,-140})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant setMax(k=25 + 273.15)
    "Maximum setpoint"
    annotation (Placement(transformation(extent={{-70,180},{-50,200}})));
  Buildings.Controls.OBC.CDL.Reals.Min TSupSet(
    y(unit="K", displayUnit="degC"))
    "Compute tower supply temperature setpoint"
    annotation (Placement(transformation(extent={{-30,200},{-10,220}})));
  Buildings.Controls.OBC.CDL.Reals.Line fan
    "Compute fan speed"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xFan1[2](
    k={0,1})
    "x-value for fan speed reset"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yFan1(
    final k=0)
    "y-value for fan speed reset"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Flow criterion to disable lead pump"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep(
    final nout=nCoo)
    "Replicate"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not notDis "Not disabled"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And enaAndNotDis
    "Reset enable condition when disable is true to trigger latch block when (enable, disable) becomes (true, false) again"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Integers.Max comPum
    "Number of pumps commanded on, bounded by 1"
    annotation (Placement(transformation(extent={{0,-290},{20,-270}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-80,-290},{-60,-270}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant tanSet[2](
    final k=TTanSet[:,1])
    "Tank temperature setpoints"
    annotation (Placement(transformation(extent={{-160,220},{-140,240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hexApp[2](
    final k=fill(dTHexCoo_nominal, 2))
    "Design heat exchanger approach"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract setOth3[2]
    "Target setpoint in any mode other than heat rejection"
    annotation (Placement(transformation(extent={{-80,260},{-60,280}})));
equation
  connect(QCooReq_flow, ratDes.u)
    annotation (Line(points={{-200,150},{-162,150}}, color={0,0,127}));
  connect(ratDes.y, lif.u)
    annotation (Line(points={{-138,150},{-126,150},{-126,130},{-112,130}},
          color={0,0,127}));
  connect(xLif[1].y, lif.x1) annotation (Line(points={{-138,180},{-120,180},{-120,
          138},{-112,138}}, color={0,0,127}));
  connect(xLif[2].y, lif.x2) annotation (Line(points={{-138,180},{-120,180},{-120,
          126},{-112,126}}, color={0,0,127}));
  connect(yLif[1].y, lif.f1) annotation (Line(points={{-138,120},{-116,120},{-116,
          134},{-112,134}}, color={0,0,127}));
  connect(yLif[2].y, lif.f2) annotation (Line(points={{-138,120},{-116,120},{-116,
          122},{-112,122}}, color={0,0,127}));
  connect(TConWatConChiLvg, delTemCon.u1) annotation (Line(points={{-200,50},{-170,
          50},{-170,56},{-162,56}}, color={0,0,127}));
  connect(TConWatConChiEnt, delTemCon.u2) annotation (Line(points={{-200,70},{-174,
          70},{-174,44},{-162,44}}, color={0,0,127}));
  connect(delTemCon.y, mea.u)
    annotation (Line(points={{-138,50},{-122,50}}, color={0,0,127}));
  connect(lif.y, lifPlu.u1) annotation (Line(points={{-88,130},{-80,130},{-80,112},
          {-130,112},{-130,92},{-122,92}}, color={0,0,127}));
  connect(TChiWatSupSet, lifPlu.u2) annotation (Line(points={{-200,100},{-160,100},
          {-160,80},{-122,80}}, color={0,0,127}));
  connect(lifPlu.y, delTem1.u1) annotation (Line(points={{-98,86},{-82,86}},
          color={0,0,127}));
  connect(mea.y, delTem1.u2) annotation (Line(points={{-98,50},{-90,50},{-90,74},
          {-82,74}}, color={0,0,127}));
  connect(delTem1.y,subApp. u)
    annotation (Line(points={{-58,80},{-42,80}},  color={0,0,127}));
  connect(mode, isModRej.u1)
    annotation (Line(points={{-200,300},{-102,300}}, color={255,127,0}));
  connect(modRej.y, isModRej.u2) annotation (Line(points={{-138,280},{-120,280},
          {-120,292},{-102,292}}, color={255,127,0}));
  connect(isModRej.y, TSupSetUnb.u2)
    annotation (Line(points={{-78,300},{-60,300},{-60,290},{38,290}}, color={255,0,255}));
  connect(subApp.y, TSupSetUnb.u1) annotation (Line(points={{-18,80},{10,80},{10,
          298},{38,298}},  color={0,0,127}));
  connect(extSet.y, TSupSetUnb.u3) annotation (Line(points={{-18,270},{20,270},{
          20,282},{38,282}},    color={0,0,127}));
  connect(mConWatHexCoo_flow, cmpFlo.u) annotation (Line(points={{-200,10},{-162,
          10}},color={0,0,127}));
  connect(cmpFlo.y, timFlo.u)
    annotation (Line(points={{-138,10},{-132,10}},   color={255,0,255}));
  connect(yValBypTan, cmpOpe.u)
    annotation (Line(points={{-200,-70},{-162,-70}},   color={0,0,127}));
  connect(not1.y, timOpe1.u)
    annotation (Line(points={{-138,-110},{-132,-110}}, color={255,0,255}));
  connect(cmpOpe.y, timOpe.u)
    annotation (Line(points={{-138,-70},{-132,-70}},   color={255,0,255}));
  connect(cmpOpe.y, not1.u) annotation (Line(points={{-138,-70},{-134,-70},{-134,
          -90},{-170,-90},{-170,-110},{-162,-110}}, color={255,0,255}));
  connect(timFlo.passed, ena.u1) annotation (Line(points={{-108,2},{-104,2},{-104,
          10},{-92,10}}, color={255,0,255}));
  connect(timOpe.passed, ena.u2) annotation (Line(points={{-108,-78},{-100,-78},
          {-100,2},{-92,2}},   color={255,0,255}));
  connect(timFlo1.passed, dis.u1) annotation (Line(points={{-108,-38},{-104,-38},
          {-104,-60},{-92,-60}},  color={255,0,255}));
  connect(timOpe1.passed, dis.u2) annotation (Line(points={{-108,-118},{-96,-118},
          {-96,-68},{-92,-68}}, color={255,0,255}));
  connect(dis.y,enaLea. clr) annotation (Line(points={{-68,-60},{-40,-60},{-40,-36},
          {-32,-36}}, color={255,0,255}));
  connect(enaLea.y, staPum.y1Ena) annotation (Line(points={{-8,-30},{20,-30},{20,
          76},{118,76}},        color={255,0,255}));
  connect(TConWatCooRet, delTem3.u1) annotation (Line(points={{-200,-190},{-166,
          -190},{-166,-184},{-162,-184}}, color={0,0,127}));
  connect(TConWatCooSup, delTem3.u2) annotation (Line(points={{-200,-170},{-170,
          -170},{-170,-196},{-162,-196}}, color={0,0,127}));
  connect(TConWatHexCooEnt, delTem2.u1) annotation (Line(points={{-200,-230},{-166,
          -230},{-166,-224},{-162,-224}}, color={0,0,127}));
  connect(delTem2.y, addOff.u)
    annotation (Line(points={{-138,-230},{-132,-230}}, color={0,0,127}));
  connect(addApp.y, ctlPum1.u_s)
    annotation (Line(points={{-18,-190},{-12,-190}}, color={0,0,127}));
  connect(delTem3.y, ctlPum2.u_m) annotation (Line(points={{-138,-190},{-90,-190},
          {-90,-250},{0,-250},{0,-242}}, color={0,0,127}));
  connect(addOff.y, ctlPum2.u_s)
    annotation (Line(points={{-108,-230},{-12,-230}}, color={0,0,127}));
  connect(ctlPum1.y, minCtlPum.u1) annotation (Line(points={{12,-190},{20,-190},
          {20,-204},{28,-204}}, color={0,0,127}));
  connect(ctlPum2.y, minCtlPum.u2) annotation (Line(points={{12,-230},{20,-230},
          {20,-216},{28,-216}}, color={0,0,127}));
  connect(xPum[1].y, pum.x1) annotation (Line(points={{112,-190},{114,-190},{114,
          -202},{118,-202}}, color={0,0,127}));
  connect(xPum[2].y, pum.x2) annotation (Line(points={{112,-190},{114,-190},{114,
          -214},{118,-214}}, color={0,0,127}));
  connect(pum.y, yPumConWatCoo) annotation (Line(points={{142,-210},{200,-210}},
          color={0,0,127}));
  connect(one.y, pum.f2) annotation (Line(points={{112,-240},{114,-240},{114,-218},
          {118,-218}},color={0,0,127}));
  connect(minCtlPum.y, pum.u)
    annotation (Line(points={{52,-210},{118,-210}},color={0,0,127}));
  connect(idxCycTan,extSet. index) annotation (Line(points={{-200,250},{-30,250},
          {-30,258}}, color={255,127,0}));
  connect(yPumMin.y, extYPumMin.u)
    annotation (Line(points={{52,-240},{58,-240}}, color={0,0,127}));
  connect(extYPumMin.y, pum.f1) annotation (Line(points={{82,-240},{84,-240},{84,
          -206},{118,-206}},color={0,0,127}));
  connect(xFan[1].y, fanMax.x1) annotation (Line(points={{42,180},{60,180},{60,158},
          {78,158}}, color={0,0,127}));
  connect(xFan[2].y, fanMax.x2) annotation (Line(points={{42,180},{60,180},{60,146},
          {78,146}}, color={0,0,127}));
  connect(yFan[1].y, fanMax.f1) annotation (Line(points={{42,120},{70,120},{70,154},
          {78,154}}, color={0,0,127}));
  connect(yFan[2].y, fanMax.f2) annotation (Line(points={{42,120},{70,120},{70,142},
          {78,142}}, color={0,0,127}));
  connect(ratDes.y, fanMax.u)
    annotation (Line(points={{-138,150},{78,150}}, color={0,0,127}));
  connect(enaLea.y, pre1.u) annotation (Line(points={{-8,-30},{20,-30},{20,-70},
          {-60,-70},{-60,-128}}, color={255,0,255}));
  connect(TConWatCooSup, ctlFan.u_m) annotation (Line(points={{-200,-170},{50,-170},
          {50,-62}},  color={0,0,127}));
  connect(pum.y, staPum.y) annotation (Line(points={{142,-210},{150,-210},{150,50},
          {100,50},{100,64},{118,64}},  color={0,0,127}));
  connect(pre1.y, ctlPum1.uEna) annotation (Line(points={{-60,-152},{-60,-206},{
          -4,-206},{-4,-202}}, color={255,0,255}));
  connect(pre1.y, ctlPum2.uEna) annotation (Line(points={{-60,-152},{-60,-246},{
          -4,-246},{-4,-242}}, color={255,0,255}));
  connect(staPum.y1, y1PumConWatCoo)
    annotation (Line(points={{142,76},{170,76},{170,70},{200,70}}, color={255,0,255}));
  connect(setMax.y, TSupSet.u2) annotation (Line(points={{-48,190},{-40,190},{-40,
          204},{-32,204}}, color={0,0,127}));
  connect(TSupSetUnb.y, TSupSet.u1) annotation (Line(points={{62,290},{80,290},{
          80,230},{-40,230},{-40,216},{-32,216}}, color={0,0,127}));
  connect(TSupSet.y, ctlFan.u_s) annotation (Line(points={{-8,210},{0,210},{0,-50},
          {38,-50}}, color={0,0,127}));
  connect(TSupSet.y, addApp.u) annotation (Line(points={{-8,210},{0,210},{0,-90},
          {-80,-90},{-80,-190},{-42,-190}}, color={0,0,127}));
  connect(TConWatHexCooLvg, delTem2.u2) annotation (Line(points={{-200,-250},{-170,
          -250},{-170,-236},{-162,-236}}, color={0,0,127}));
  connect(TConWatHexCooLvg, ctlPum1.u_m) annotation (Line(points={{-200,-250},{-170,
          -250},{-170,-210},{0,-210},{0,-202}}, color={0,0,127}));
  connect(xFan1[1].y, fan.x1) annotation (Line(points={{102,-30},{114,-30},{114,
          -42},{118,-42}}, color={0,0,127}));
  connect(xFan1[2].y, fan.x2) annotation (Line(points={{102,-30},{114,-30},{114,
          -54},{118,-54}}, color={0,0,127}));
  connect(yFan1.y, fan.f1) annotation (Line(points={{102,-70},{116,-70},{116,-46},
          {118,-46}}, color={0,0,127}));
  connect(ctlFan.y, fan.u)
    annotation (Line(points={{62,-50},{118,-50}},  color={0,0,127}));
  connect(fan.y, yCoo)
    annotation (Line(points={{142,-50},{200,-50}}, color={0,0,127}));
  connect(fanMax.y, fan.f2) annotation (Line(points={{102,150},{110,150},{110,-58},
          {118,-58}}, color={0,0,127}));
  connect(enaLea.y, ctlFan.uEna) annotation (Line(points={{-8,-30},{20,-30},{20,
          -70},{46,-70},{46,-62}}, color={255,0,255}));
  connect(cmpFlo.y, not2.u) annotation (Line(points={{-138,10},{-134,10},{-134,-10},
          {-166,-10},{-166,-30},{-162,-30}}, color={255,0,255}));
  connect(not2.y, timFlo1.u)
    annotation (Line(points={{-138,-30},{-132,-30}}, color={255,0,255}));
  connect(rep.y, y1Coo)
    annotation (Line(points={{102,-110},{200,-110}}, color={255,0,255}));
  connect(enaLea.y, rep.u) annotation (Line(points={{-8,-30},{20,-30},{20,-110},
          {78,-110}}, color={255,0,255}));
  connect(ena.y, enaAndNotDis.u1)
    annotation (Line(points={{-68,10},{-62,10}}, color={255,0,255}));
  connect(notDis.y, enaAndNotDis.u2) annotation (Line(points={{-68,-20},{-66,-20},
          {-66,2},{-62,2}},   color={255,0,255}));
  connect(enaAndNotDis.y, enaLea.u) annotation (Line(points={{-38,10},{-36,10},{
          -36,-30},{-32,-30}}, color={255,0,255}));
  connect(dis.y, notDis.u) annotation (Line(points={{-68,-60},{-64,-60},{-64,-38},
          {-96,-38},{-96,-20},{-92,-20}}, color={255,0,255}));
  connect(comPum.y, extYPumMin.index) annotation (Line(points={{22,-280},{70,-280},
          {70,-252}}, color={255,127,0}));
  connect(staPum.nPumEna, comPum.u2) annotation (Line(points={{142,64},{160,64},
          {160,-300},{-10,-300},{-10,-286},{-2,-286}}, color={255,127,0}));
  connect(conInt.y, comPum.u1) annotation (Line(points={{-58,-280},{-20,-280},{-20,
          -274},{-2,-274}}, color={255,127,0}));
  connect(tanSet.y, setOth3.u1) annotation (Line(points={{-138,230},{-110,230},{
          -110,276},{-82,276}}, color={0,0,127}));
  connect(hexApp.y, setOth3.u2) annotation (Line(points={{-98,210},{-90,210},{-90,
          264},{-82,264}}, color={0,0,127}));
  connect(setOth3.y, extSet.u)
    annotation (Line(points={{-58,270},{-42,270}}, color={0,0,127}));
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
          textString="%name")}), Diagram(coordinateSystem(extent={{-180,-320},{180,
            320}})),
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
