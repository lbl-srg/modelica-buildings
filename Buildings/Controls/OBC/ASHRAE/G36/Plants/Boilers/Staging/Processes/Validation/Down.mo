within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Validation;
model Down
    "Validate sequence of staging down process"

  parameter Integer nBoi=2
    "Total number of boilers in the plant";

  parameter Integer nSta=3
    "Total number of stages";

  parameter Real delBoiEna(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 180
    "Time delay after boiler change process has been completed before turning off excess valves and pumps";

  parameter Real delEnaMinFloSet(
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=60
    "Enable delay after minimum flow setpoint is achieved in bypass valve";

  parameter Real delProSupTemSet(
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=300
    "Process time-out for hot water supply temperature setpoint reset";

  parameter Real TMinSupNonConBoi(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")=333.2
    "Minimum supply temperature required for non-condensing boilers";

  parameter Real sigDif(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")=0.1
    "Significant difference based on minimum resolution of temperature sensor";

  parameter Real chaIsoValTim(
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=60
    "Time to slowly change isolation valve, should be determined in the field";

  parameter Real boiChaProOnTim(
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=300
    "Enabled boiler operation time to indicate if it is proven on during a staging
    process where one boiler is turned on and the other is turned off";

  parameter Real relFloDif(
    final unit="1",
    final displayUnit="1")=0.05
    "Relative error to the flow setpoint for checking if it has been achieved";

  parameter Real delPreBoiEna(
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=30
    "Time delay after valve and pump change process has been completed before
    starting boiler change process";

  parameter Real VNom_flow(
    final unit="m3/s",
    final displayUnit="m3/s",
    final quantity="VolumeFlowRate") = 1
    "Nominal minimum flow rate";

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Down
    dowProCon(
    final have_priOnl=false,
    final have_heaPriPum=true,
    final nBoi=nBoi,
    final nSta=nSta,
    final delBoiEna=delBoiEna,
    final delPreBoiEna=delPreBoiEna,
    final delEnaMinFloSet=delEnaMinFloSet,
    final chaIsoValTim=chaIsoValTim,
    final boiChaProOnTim=boiChaProOnTim,
    final relFloDif=relFloDif)
    "Stage down process for primary-secondary plant with headered pumps"
    annotation (Placement(transformation(extent={{-160,166},{-140,206}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Down dowProCon1(
    final have_priOnl=false,
    final have_heaPriPum=false,
    final nBoi=nBoi,
    final nSta=nSta,
    final delBoiEna=delBoiEna,
    final delPreBoiEna=delPreBoiEna,
    final delEnaMinFloSet=delEnaMinFloSet,
    final chaIsoValTim=chaIsoValTim,
    final boiChaProOnTim=boiChaProOnTim,
    final relFloDif=relFloDif)
    "Stage down process for primary-secondary plant with dedicated pumps"
    annotation (Placement(transformation(extent={{210,166},{230,206}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Down dowProCon4(
    final have_priOnl=true,
    final have_heaPriPum=true,
    final nBoi=nBoi,
    final nSta=nSta,
    final delBoiEna=delBoiEna,
    final delPreBoiEna=delPreBoiEna,
    final delEnaMinFloSet=delEnaMinFloSet,
    final chaIsoValTim=chaIsoValTim,
    final boiChaProOnTim=boiChaProOnTim,
    final relFloDif=relFloDif)
    "Stage down process for primary-only plant with headered pumps"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-130}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yPumChaPro(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yPumChaPro1(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{250,150},{270,170}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro1(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{250,190},{270,210}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro4(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));

  CDL.Logical.And and2[nBoi]
    annotation (Placement(transformation(extent={{-210,120},{-190,140}})));
  CDL.Logical.And and1[nBoi]
    annotation (Placement(transformation(extent={{-210,90},{-190,110}})));
  CDL.Logical.And and3[nBoi]
    annotation (Placement(transformation(extent={{-210,60},{-190,80}})));
  CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{-270,140},{-250,160}})));
  CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-270,100},{-250,120}})));
  CDL.Routing.BooleanScalarReplicator booScaRep(nout=nBoi)
    annotation (Placement(transformation(extent={{-240,140},{-220,160}})));
  CDL.Routing.BooleanScalarReplicator booScaRep1(nout=nBoi)
    annotation (Placement(transformation(extent={{-240,100},{-220,120}})));
  CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{-268,60},{-248,80}})));
  CDL.Routing.BooleanScalarReplicator booScaRep2(nout=nBoi)
    annotation (Placement(transformation(extent={{-238,60},{-218,80}})));
  CDL.Logical.Or or7[nBoi]
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  CDL.Logical.Or or2[nBoi]
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  CDL.Integers.OnCounter onCouInt(y_start=0)
    annotation (Placement(transformation(extent={{-300,220},{-280,240}})));
  CDL.Logical.Or or6
    annotation (Placement(transformation(extent={{-332,220},{-312,240}})));
  CDL.Logical.And and4[nBoi]
    annotation (Placement(transformation(extent={{150,120},{170,140}})));
  CDL.Logical.And and5[nBoi]
    annotation (Placement(transformation(extent={{150,90},{170,110}})));
  CDL.Logical.And and6[nBoi]
    annotation (Placement(transformation(extent={{150,60},{170,80}})));
  CDL.Integers.Equal intEqu3
    annotation (Placement(transformation(extent={{90,140},{110,160}})));
  CDL.Integers.Equal intEqu4
    annotation (Placement(transformation(extent={{90,100},{110,120}})));
  CDL.Routing.BooleanScalarReplicator booScaRep3(nout=nBoi)
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
  CDL.Routing.BooleanScalarReplicator booScaRep4(nout=nBoi)
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  CDL.Integers.Equal intEqu5
    annotation (Placement(transformation(extent={{92,60},{112,80}})));
  CDL.Routing.BooleanScalarReplicator booScaRep5(nout=nBoi)
    annotation (Placement(transformation(extent={{122,60},{142,80}})));
  CDL.Logical.Or or1[nBoi]
    annotation (Placement(transformation(extent={{240,110},{260,130}})));
  CDL.Logical.Or or3[nBoi]
    annotation (Placement(transformation(extent={{200,110},{220,130}})));
  CDL.Integers.OnCounter onCouInt1(y_start=0)
    annotation (Placement(transformation(extent={{90,200},{110,220}})));
  CDL.Logical.Or or4
    annotation (Placement(transformation(extent={{60,200},{80,220}})));
  CDL.Logical.And and7[nBoi]
    annotation (Placement(transformation(extent={{-208,-220},{-188,-200}})));
  CDL.Logical.And and8[nBoi]
    annotation (Placement(transformation(extent={{-208,-250},{-188,-230}})));
  CDL.Logical.And and9[nBoi]
    annotation (Placement(transformation(extent={{-208,-280},{-188,-260}})));
  CDL.Integers.Equal intEqu6
    annotation (Placement(transformation(extent={{-268,-200},{-248,-180}})));
  CDL.Integers.Equal intEqu7
    annotation (Placement(transformation(extent={{-268,-240},{-248,-220}})));
  CDL.Routing.BooleanScalarReplicator booScaRep6(nout=nBoi)
    annotation (Placement(transformation(extent={{-238,-200},{-218,-180}})));
  CDL.Routing.BooleanScalarReplicator booScaRep7(nout=nBoi)
    annotation (Placement(transformation(extent={{-238,-240},{-218,-220}})));
  CDL.Integers.Equal intEqu8
    annotation (Placement(transformation(extent={{-266,-280},{-246,-260}})));
  CDL.Routing.BooleanScalarReplicator booScaRep8(nout=nBoi)
    annotation (Placement(transformation(extent={{-236,-280},{-216,-260}})));
  CDL.Logical.Or or5[nBoi]
    annotation (Placement(transformation(extent={{-118,-230},{-98,-210}})));
  CDL.Logical.Or or8[nBoi]
    annotation (Placement(transformation(extent={{-158,-230},{-138,-210}})));
  CDL.Integers.OnCounter onCouInt2(y_start=0)
    annotation (Placement(transformation(extent={{-300,-120},{-280,-100}})));
  CDL.Logical.Or or9
    annotation (Placement(transformation(extent={{-330,-120},{-310,-100}})));
  CDL.Integers.Subtract intSub
    annotation (Placement(transformation(extent={{-260,220},{-240,240}})));
  CDL.Integers.Sources.Constant conInt2(k=4)
    annotation (Placement(transformation(extent={{-300,260},{-280,280}})));
  CDL.Logical.Or or10[nBoi]
    annotation (Placement(transformation(extent={{-180,260},{-200,280}})));
  CDL.Routing.BooleanScalarReplicator booScaRep9(nout=nBoi)
    annotation (Placement(transformation(extent={{-140,270},{-160,290}})));
  CDL.Logical.Latch lat
    annotation (Placement(transformation(extent={{-260,290},{-240,310}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-220,290},{-200,310}})));
  CDL.Logical.Or or11[nBoi]
    annotation (Placement(transformation(extent={{-60,240},{-80,260}})));
  CDL.Integers.Subtract intSub1
    annotation (Placement(transformation(extent={{120,200},{140,220}})));
  CDL.Integers.Sources.Constant conInt6(k=4)
    annotation (Placement(transformation(extent={{80,240},{100,260}})));
  CDL.Logical.Latch lat1
    annotation (Placement(transformation(extent={{120,270},{140,290}})));
  CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{160,270},{180,290}})));
  CDL.Routing.BooleanScalarReplicator booScaRep10(nout=nBoi)
    annotation (Placement(transformation(extent={{200,270},{220,290}})));
  CDL.Logical.Or or13[nBoi]
    annotation (Placement(transformation(extent={{200,240},{180,260}})));
  CDL.Integers.Subtract intSub2
    annotation (Placement(transformation(extent={{-260,-120},{-240,-100}})));
  CDL.Integers.Sources.Constant conInt8(k=4)
    annotation (Placement(transformation(extent={{-300,-90},{-280,-70}})));
  CDL.Logical.Latch lat2
    annotation (Placement(transformation(extent={{-320,-50},{-300,-30}})));
  CDL.Logical.Not not3
    annotation (Placement(transformation(extent={{-280,-50},{-260,-30}})));
  CDL.Routing.BooleanScalarReplicator booScaRep11(nout=nBoi)
    annotation (Placement(transformation(extent={{-240,-50},{-220,-30}})));
  CDL.Logical.Or or12[nBoi]
    annotation (Placement(transformation(extent={{-180,-70},{-200,-50}})));
  CDL.Logical.Or or14[nBoi]
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-370,90},{-350,110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nBoi](
    final k={true,false})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-370,130},{-350,150}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-90,150},{-70,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-330,150},{-310,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-330,110},{-310,130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(final width=0.1/1800,
      final period=1800) "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-370,250},{-350,270}})));

  CDL.Logical.Pre pre8[nBoi](
    final pre_u_start=fill(true,nBoi)) "Zero order hold"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Logical pre block"
    annotation (Placement(transformation(extent={{-28,190},{-8,210}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-90,190},{-70,210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4[nBoi](
    final k={true,true})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-370,50},{-350,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=3)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-330,70},{-310,90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{12,100},{32,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6[nBoi](
    final k={true,false})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{12,140},{32,160}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg3
    "Falling edge detector"
    annotation (Placement(transformation(extent={{280,150},{300,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=1)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{52,160},{72,180}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{52,120},{72,140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(final width=0.1/1800,
      final period=1800) "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{12,230},{32,250}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre5
    "Logical pre block"
    annotation (Placement(transformation(extent={{320,150},{340,170}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre6
    "Logical pre block"
    annotation (Placement(transformation(extent={{340,190},{360,210}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg4
    "Falling edge detector"
    annotation (Placement(transformation(extent={{280,190},{300,210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9[nBoi](
    final k={true,true})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{12,60},{32,80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=3)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{52,80},{72,100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con20[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-370,-270},{-350,-250}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con21[nBoi](
    final k={true,
        false})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-370,-230},{-350,-210}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt16(
    final k=1)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-330,-210},{-310,-190}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt17(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-330,-250},{-310,-230}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(final width=0.1/1800,
      final period=1800) "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-370,-80},{-350,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con23(
    final k=VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{-220,-130},{-200,-110}})));

  CDL.Logical.Pre                                   pre4      [nBoi](
      pre_u_start=fill(true, nBoi))
    "Zero order hold"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre15
    "Logical pre block"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg13
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant  con24[nBoi](
    final k={true,true})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-370,-310},{-350,-290}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt19(
    final k=3)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-330,-290},{-310,-270}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con12(
    final k=1.1*VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{-90,-26},{-70,-6}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con17(
    final k=VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{-90,-66},{-70,-46}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Pass different instances of measured flow-rate after stage change"
    annotation (Placement(transformation(extent={{-50,-46},{-30,-26}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat10
    "Hold true signal after stage change"
    annotation (Placement(transformation(extent={{-130,-46},{-110,-26}})));

  CDL.Logical.Pre                        pre14
    "Logical pre block"
    annotation (Placement(transformation(extent={{-372,220},{-352,240}})));
  CDL.Logical.Sources.Constant con7(final k=false) "Constant false signal"
    annotation (Placement(transformation(extent={{-372,194},{-352,214}})));
  CDL.Logical.Sources.Constant con3(final k=false) "Constant false signal"
    annotation (Placement(transformation(extent={{12,170},{32,190}})));
  CDL.Logical.Pre                        pre3
    "Logical pre block"
    annotation (Placement(transformation(extent={{10,200},{30,220}})));
  CDL.Logical.Pre                        pre7
    "Logical pre block"
    annotation (Placement(transformation(extent={{-370,-120},{-350,-100}})));
  CDL.Logical.Sources.Constant con8(final k=false) "Constant false signal"
    annotation (Placement(transformation(extent={{-370,-146},{-350,-126}})));
  CDL.Logical.Pre pre9[nBoi](final pre_u_start=fill(true, nBoi))
                                       "Zero order hold"
    annotation (Placement(transformation(extent={{-140,230},{-160,250}})));
  CDL.Logical.Pre pre10
                      [nBoi](final pre_u_start=fill(true, nBoi))
                                       "Zero order hold"
    annotation (Placement(transformation(extent={{230,230},{210,250}})));
  CDL.Logical.Pre pre11
                      [nBoi](final pre_u_start=fill(true, nBoi))
                                       "Zero order hold"
    annotation (Placement(transformation(extent={{-140,-90},{-160,-70}})));
equation

  connect(yPumChaPro.y, falEdg.u)
    annotation (Line(points={{-98,160},{-92,160}}, color={255,0,255}));

  connect(falEdg.y, pre1.u) annotation (Line(points={{-68,160},{-46,160},{-46,
          140},{-42,140}}, color={255,0,255}));

  connect(yStaChaPro.y, falEdg1.u)
    annotation (Line(points={{-98,200},{-92,200}}, color={255,0,255}));

  connect(falEdg1.y, pre2.u)
    annotation (Line(points={{-68,200},{-30,200}}, color={255,0,255}));

  connect(yPumChaPro1.y, falEdg3.u)
    annotation (Line(points={{272,160},{278,160}}, color={255,0,255}));

  connect(falEdg3.y, pre5.u) annotation (Line(points={{302,160},{318,160}},
                      color={255,0,255}));

  connect(yStaChaPro1.y, falEdg4.u)
    annotation (Line(points={{272,200},{278,200}}, color={255,0,255}));

  connect(falEdg4.y,pre6. u)
    annotation (Line(points={{302,200},{338,200}}, color={255,0,255}));

  connect(yStaChaPro4.y, falEdg13.u)
    annotation (Line(points={{-98,-130},{-82,-130}},
                                                   color={255,0,255}));

  connect(falEdg13.y, pre15.u)
    annotation (Line(points={{-58,-130},{-42,-130}},
                                                   color={255,0,255}));

  connect(con12.y, swi2.u1) annotation (Line(points={{-68,-16},{-60,-16},{-60,-28},
          {-52,-28}},      color={0,0,127}));

  connect(con17.y, swi2.u3) annotation (Line(points={{-68,-56},{-60,-56},{-60,-44},
          {-52,-44}},      color={0,0,127}));

  connect(lat10.y, swi2.u2)
    annotation (Line(points={{-108,-36},{-52,-36}},color={255,0,255}));

  connect(pre15.y, lat10.u) annotation (Line(points={{-18,-130},{-12,-130},{-12,
          0},{-144,0},{-144,-36},{-132,-36}},  color={255,0,255}));

  connect(pre1.y, dowProCon.uPumChaPro) annotation (Line(points={{-18,140},{-10,
          140},{-10,120},{-80,120},{-80,140},{-166,140},{-166,166},{-162,166}},
        color={255,0,255}));

  connect(dowProCon.yStaChaPro, yStaChaPro.u) annotation (Line(points={{-138,196},
          {-126,196},{-126,200},{-122,200}}, color={255,0,255}));

  connect(dowProCon.yPumChaPro, yPumChaPro.u) annotation (Line(points={{-138,171},
          {-130,171},{-130,160},{-122,160}}, color={255,0,255}));

  connect(pre5.y, dowProCon1.uPumChaPro) annotation (Line(points={{342,160},{
          352,160},{352,144},{196,144},{196,166},{208,166}},
        color={255,0,255}));

  connect(dowProCon1.yStaChaPro, yStaChaPro1.u) annotation (Line(points={{232,196},
          {244,196},{244,200},{248,200}}, color={255,0,255}));

  connect(con23.y, dowProCon4.VMinHotWatSet_flow) annotation (Line(points={{-198,
          -120},{-172,-120},{-172,-135},{-162,-135}},                     color=
         {0,0,127}));

  connect(swi2.y, dowProCon4.VHotWat_flow) annotation (Line(points={{-28,-36},{
          -20,-36},{-20,-96},{-166,-96},{-166,-130},{-162,-130}},
                                                              color={0,0,127}));

  connect(dowProCon4.yStaChaPro, yStaChaPro4.u) annotation (Line(points={{-138,-140},
          {-126,-140},{-126,-130},{-122,-130}}, color={255,0,255}));

  connect(dowProCon1.yPumChaPro, yPumChaPro1.u) annotation (Line(points={{232,171},
          {240,171},{240,160},{248,160}}, color={255,0,255}));

  connect(pre2.y, dowProCon.uStaChaPro) annotation (Line(points={{-6,200},{0,
          200},{0,90},{-180,90},{-180,171},{-162,171}},
                                                     color={255,0,255}));
  connect(pre6.y, dowProCon1.uStaChaPro) annotation (Line(points={{362,200},{
          372,200},{372,130},{186,130},{186,171},{208,171}},
                                                         color={255,0,255}));
  connect(pre15.y, dowProCon4.uStaChaPro) annotation (Line(points={{-18,-130},{
          -12,-130},{-12,-196},{-128,-196},{-128,-184},{-172,-184},{-172,-165},
          {-162,-165}},                                        color={255,0,255}));
  connect(dowProCon.yHotWatIsoVal, pre8.u) annotation (Line(points={{-138,191},{
          -128,191},{-128,180},{-62,180}}, color={255,0,255}));
  connect(intEqu.y, booScaRep.u)
    annotation (Line(points={{-248,150},{-242,150}}, color={255,0,255}));
  connect(booScaRep.y, and2.u1) annotation (Line(points={{-218,150},{-214,150},{
          -214,130},{-212,130}}, color={255,0,255}));
  connect(intEqu1.y, booScaRep1.u)
    annotation (Line(points={{-248,110},{-242,110}}, color={255,0,255}));
  connect(booScaRep1.y, and1.u1) annotation (Line(points={{-218,110},{-216,110},
          {-216,100},{-212,100}}, color={255,0,255}));
  connect(intEqu2.y, booScaRep2.u)
    annotation (Line(points={{-246,70},{-240,70}}, color={255,0,255}));
  connect(booScaRep2.y, and3.u1)
    annotation (Line(points={{-216,70},{-212,70}}, color={255,0,255}));
  connect(and2.y, or2.u1) annotation (Line(points={{-188,130},{-176,130},{-176,120},
          {-162,120}}, color={255,0,255}));
  connect(and1.y, or2.u2) annotation (Line(points={{-188,100},{-176,100},{-176,112},
          {-162,112}}, color={255,0,255}));
  connect(and3.y, or7.u2) annotation (Line(points={{-188,70},{-122,70},{-122,112}},
        color={255,0,255}));
  connect(or2.y, or7.u1)
    annotation (Line(points={{-138,120},{-122,120}}, color={255,0,255}));
  connect(con7.y, onCouInt.reset) annotation (Line(points={{-350,204},{-290,204},
          {-290,218}}, color={255,0,255}));
  connect(or6.y, onCouInt.trigger)
    annotation (Line(points={{-310,230},{-302,230}}, color={255,0,255}));
  connect(pre14.y, or6.u2) annotation (Line(points={{-350,230},{-350,222},{-334,
          222}}, color={255,0,255}));
  connect(booPul.y, or6.u1) annotation (Line(points={{-348,260},{-340,260},{
          -340,230},{-334,230}},
                            color={255,0,255}));
  connect(pre2.y, pre14.u) annotation (Line(points={{-6,200},{0,200},{0,90},{
          -180,90},{-180,184},{-376,184},{-376,230},{-374,230}},
                                                            color={255,0,255}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-308,160},{-284,160},{-284,
          142},{-272,142}}, color={255,127,0}));
  connect(conInt1.y, intEqu1.u2) annotation (Line(points={{-308,120},{-284,120},
          {-284,102},{-272,102}}, color={255,127,0}));
  connect(conInt3.y, intEqu2.u2) annotation (Line(points={{-308,80},{-292,80},{-292,
          62},{-270,62}}, color={255,127,0}));
  connect(con2.y, and2.u2) annotation (Line(points={{-348,140},{-284,140},{-284,
          128},{-212,128},{-212,122}}, color={255,0,255}));
  connect(con1.y, and1.u2) annotation (Line(points={{-348,100},{-284,100},{-284,
          92},{-212,92}}, color={255,0,255}));
  connect(con4.y, and3.u2) annotation (Line(points={{-348,60},{-280,60},{-280,52},
          {-212,52},{-212,62}}, color={255,0,255}));
  connect(or7.y, dowProCon.uBoiSet) annotation (Line(points={{-98,120},{-92,120},
          {-92,144},{-172,144},{-172,186},{-162,186}},     color={255,0,255}));
  connect(intEqu3.y, booScaRep3.u)
    annotation (Line(points={{112,150},{118,150}}, color={255,0,255}));
  connect(booScaRep3.y, and4.u1) annotation (Line(points={{142,150},{146,150},{146,
          130},{148,130}}, color={255,0,255}));
  connect(intEqu4.y, booScaRep4.u)
    annotation (Line(points={{112,110},{118,110}}, color={255,0,255}));
  connect(booScaRep4.y, and5.u1) annotation (Line(points={{142,110},{144,110},{144,
          100},{148,100}}, color={255,0,255}));
  connect(intEqu5.y, booScaRep5.u)
    annotation (Line(points={{114,70},{120,70}}, color={255,0,255}));
  connect(booScaRep5.y, and6.u1)
    annotation (Line(points={{144,70},{148,70}}, color={255,0,255}));
  connect(and4.y, or3.u1) annotation (Line(points={{172,130},{184,130},{184,120},
          {198,120}}, color={255,0,255}));
  connect(and5.y, or3.u2) annotation (Line(points={{172,100},{184,100},{184,112},
          {198,112}}, color={255,0,255}));
  connect(and6.y, or1.u2)
    annotation (Line(points={{172,70},{238,70},{238,112}}, color={255,0,255}));
  connect(or3.y, or1.u1)
    annotation (Line(points={{222,120},{238,120}}, color={255,0,255}));
  connect(or4.y, onCouInt1.trigger)
    annotation (Line(points={{82,210},{88,210}}, color={255,0,255}));
  connect(pre3.y, or4.u2) annotation (Line(points={{32,210},{48,210},{48,202},{58,
          202}}, color={255,0,255}));
  connect(con3.y, onCouInt1.reset) annotation (Line(points={{34,180},{44,180},{44,
          188},{100,188},{100,198}}, color={255,0,255}));
  connect(booPul1.y, or4.u1) annotation (Line(points={{34,240},{48,240},{48,216},
          {52,216},{52,210},{58,210}}, color={255,0,255}));
  connect(pre6.y, pre3.u) annotation (Line(points={{362,200},{368,200},{368,260},
          {4,260},{4,220},{0,220},{0,210},{8,210}}, color={255,0,255}));
  connect(or1.y, dowProCon1.uBoiSet) annotation (Line(points={{262,120},{272,
          120},{272,140},{184,140},{184,186},{208,186}},color={255,0,255}));
  connect(or6.y, dowProCon.uStaDowPro) annotation (Line(points={{-310,230},{
          -306,230},{-306,252},{-180,252},{-180,188},{-176,188},{-176,181},{
          -162,181}},
        color={255,0,255}));
  connect(or4.y, dowProCon1.uStaDowPro) annotation (Line(points={{82,210},{82,
          228},{188,228},{188,181},{208,181}},color={255,0,255}));
  connect(conInt4.y, intEqu3.u2) annotation (Line(points={{74,170},{84,170},{84,
          160},{80,160},{80,142},{88,142}}, color={255,127,0}));
  connect(conInt5.y, intEqu4.u2) annotation (Line(points={{74,130},{84,130},{84,
          120},{80,120},{80,102},{88,102}}, color={255,127,0}));
  connect(conInt7.y, intEqu5.u2) annotation (Line(points={{74,90},{84,90},{84,62},
          {90,62}}, color={255,127,0}));
  connect(con6.y, and4.u2) annotation (Line(points={{34,150},{44,150},{44,48},{180,
          48},{180,122},{148,122}}, color={255,0,255}));
  connect(con5.y, and5.u2) annotation (Line(points={{34,110},{76,110},{76,100},{
          84,100},{84,92},{148,92}}, color={255,0,255}));
  connect(con9.y, and6.u2) annotation (Line(points={{34,70},{80,70},{80,52},{148,
          52},{148,62}}, color={255,0,255}));
  connect(dowProCon4.yHotWatIsoVal, pre4.u) annotation (Line(points={{-138,-145},
          {-136,-145},{-136,-152},{-122,-152},{-122,-160}}, color={255,0,255}));
  connect(intEqu6.y, booScaRep6.u)
    annotation (Line(points={{-246,-190},{-240,-190}}, color={255,0,255}));
  connect(booScaRep6.y, and7.u1) annotation (Line(points={{-216,-190},{-212,-190},
          {-212,-210},{-210,-210}}, color={255,0,255}));
  connect(intEqu7.y, booScaRep7.u)
    annotation (Line(points={{-246,-230},{-240,-230}}, color={255,0,255}));
  connect(booScaRep7.y, and8.u1) annotation (Line(points={{-216,-230},{-214,-230},
          {-214,-240},{-210,-240}}, color={255,0,255}));
  connect(intEqu8.y, booScaRep8.u)
    annotation (Line(points={{-244,-270},{-238,-270}}, color={255,0,255}));
  connect(booScaRep8.y, and9.u1)
    annotation (Line(points={{-214,-270},{-210,-270}}, color={255,0,255}));
  connect(and7.y, or8.u1) annotation (Line(points={{-186,-210},{-174,-210},{-174,
          -220},{-160,-220}}, color={255,0,255}));
  connect(and8.y, or8.u2) annotation (Line(points={{-186,-240},{-174,-240},{-174,
          -228},{-160,-228}}, color={255,0,255}));
  connect(and9.y, or5.u2) annotation (Line(points={{-186,-270},{-120,-270},{-120,
          -228}}, color={255,0,255}));
  connect(or8.y, or5.u1)
    annotation (Line(points={{-136,-220},{-120,-220}}, color={255,0,255}));
  connect(or9.y, onCouInt2.trigger)
    annotation (Line(points={{-308,-110},{-302,-110}}, color={255,0,255}));
  connect(pre7.y, or9.u2) annotation (Line(points={{-348,-110},{-348,-118},{-332,
          -118}}, color={255,0,255}));
  connect(con8.y, onCouInt2.reset) annotation (Line(points={{-348,-136},{-290,-136},
          {-290,-122}}, color={255,0,255}));
  connect(booPul4.y, or9.u1) annotation (Line(points={{-348,-70},{-348,-72},{-340,
          -72},{-340,-110},{-332,-110}}, color={255,0,255}));
  connect(or9.y, dowProCon4.uStaDowPro) annotation (Line(points={{-308,-110},{
          -308,-155},{-162,-155}},color={255,0,255}));
  connect(or5.y, dowProCon4.uBoiSet) annotation (Line(points={{-96,-220},{-88,
          -220},{-88,-192},{-192,-192},{-192,-150},{-162,-150}},
                                                               color={255,0,255}));
  connect(conInt16.y, intEqu6.u2) annotation (Line(points={{-308,-200},{-304,-198},
          {-270,-198}}, color={255,127,0}));
  connect(conInt17.y, intEqu7.u2) annotation (Line(points={{-308,-240},{-304,-238},
          {-270,-238}}, color={255,127,0}));
  connect(conInt19.y, intEqu8.u2) annotation (Line(points={{-308,-280},{-304,-278},
          {-268,-278}}, color={255,127,0}));
  connect(con21.y, and7.u2) annotation (Line(points={{-348,-220},{-340,-220},{-340,
          -260},{-288,-260},{-288,-292},{-180,-292},{-180,-276},{-176,-276},{-176,
          -244},{-180,-244},{-180,-218},{-210,-218}}, color={255,0,255}));
  connect(con20.y, and8.u2) annotation (Line(points={{-348,-260},{-340,-260},{-340,
          -264},{-276,-264},{-276,-248},{-210,-248}}, color={255,0,255}));
  connect(con24.y, and9.u2) annotation (Line(points={{-348,-300},{-284,-300},{-284,
          -288},{-210,-288},{-210,-278}}, color={255,0,255}));
  connect(booPul4.y, lat10.clr) annotation (Line(points={{-348,-70},{-166,-70},
          {-166,-42},{-132,-42}},color={255,0,255}));
  connect(pre15.y, pre7.u) annotation (Line(points={{-18,-130},{-12,-130},{-12,
          0},{-378,0},{-378,-110},{-372,-110}},                    color={255,0,
          255}));
  connect(onCouInt.y, intSub.u2) annotation (Line(points={{-278,230},{-272,230},
          {-272,224},{-262,224}}, color={255,127,0}));
  connect(conInt2.y, intSub.u1) annotation (Line(points={{-278,270},{-272,270},
          {-272,236},{-262,236}}, color={255,127,0}));
  connect(intSub.y, dowProCon.uStaSet) annotation (Line(points={{-238,230},{
          -232,230},{-232,176},{-162,176}}, color={255,127,0}));
  connect(intSub.y, intEqu.u1) annotation (Line(points={{-238,230},{-232,230},{
          -232,168},{-280,168},{-280,150},{-272,150}}, color={255,127,0}));
  connect(intSub.y, intEqu1.u1) annotation (Line(points={{-238,230},{-232,230},
          {-232,168},{-280,168},{-280,110},{-272,110}}, color={255,127,0}));
  connect(intSub.y, intEqu2.u1) annotation (Line(points={{-238,230},{-232,230},
          {-232,168},{-280,168},{-280,70},{-270,70}}, color={255,127,0}));
  connect(dowProCon.yBoi, pre9.u) annotation (Line(points={{-138,201},{-140,201},
          {-140,224},{-132,224},{-132,240},{-138,240}}, color={255,0,255}));
  connect(dowProCon1.yBoi, pre10.u) annotation (Line(points={{232,201},{232,202},
          {240,202},{240,240},{232,240}}, color={255,0,255}));
  connect(dowProCon4.yBoi, pre11.u) annotation (Line(points={{-138,-135},{-132,
          -135},{-132,-80},{-138,-80}}, color={255,0,255}));
  connect(pre9.y, or10.u2) annotation (Line(points={{-162,240},{-170,240},{-170,
          262},{-178,262}}, color={255,0,255}));
  connect(or10.y, dowProCon.uBoi) annotation (Line(points={{-202,270},{-210,270},
          {-210,196},{-162,196}}, color={255,0,255}));
  connect(booScaRep9.y, or10.u1) annotation (Line(points={{-162,280},{-170,280},
          {-170,270},{-178,270}}, color={255,0,255}));
  connect(lat.y, not1.u)
    annotation (Line(points={{-238,300},{-222,300}}, color={255,0,255}));
  connect(not1.y, booScaRep9.u) annotation (Line(points={{-198,300},{-132,300},
          {-132,280},{-138,280}}, color={255,0,255}));
  connect(con7.y, lat.clr) annotation (Line(points={{-350,204},{-290,204},{-290,
          212},{-228,212},{-228,284},{-272,284},{-272,294},{-262,294}}, color={
          255,0,255}));
  connect(intEqu1.y, lat.u) annotation (Line(points={{-248,110},{-248,180},{
          -380,180},{-380,300},{-262,300}}, color={255,0,255}));
  connect(pre8.y, or11.u2) annotation (Line(points={{-38,180},{-34,180},{-34,
          242},{-58,242}}, color={255,0,255}));
  connect(booScaRep9.y, or11.u1) annotation (Line(points={{-162,280},{-170,280},
          {-170,268},{-168,268},{-168,260},{-88,260},{-88,268},{-52,268},{-52,
          250},{-58,250}}, color={255,0,255}));
  connect(or11.y, dowProCon.uHotWatIsoVal) annotation (Line(points={{-82,250},{
          -128,250},{-128,220},{-172,220},{-172,191},{-162,191}}, color={255,0,
          255}));
  connect(onCouInt1.y, intSub1.u2) annotation (Line(points={{112,210},{112,208},
          {118,208},{118,204}}, color={255,127,0}));
  connect(conInt6.y, intSub1.u1) annotation (Line(points={{102,250},{118,250},{
          118,216}}, color={255,127,0}));
  connect(intSub1.y, dowProCon1.uStaSet) annotation (Line(points={{142,210},{
          192,210},{192,176},{208,176}}, color={255,127,0}));
  connect(intSub1.y, intEqu3.u1) annotation (Line(points={{142,210},{148,210},{
          148,168},{88,168},{88,150}}, color={255,127,0}));
  connect(intSub1.y, intEqu4.u1) annotation (Line(points={{142,210},{116,210},{
          116,110},{88,110}}, color={255,127,0}));
  connect(intSub1.y, intEqu5.u1) annotation (Line(points={{142,210},{192,210},{
          192,44},{76,44},{76,70},{90,70}}, color={255,127,0}));
  connect(con3.y, lat1.clr) annotation (Line(points={{34,180},{44,180},{44,274},
          {118,274}}, color={255,0,255}));
  connect(intEqu4.y, lat1.u) annotation (Line(points={{112,110},{112,132},{144,
          132},{144,148},{152,148},{152,300},{112,300},{112,280},{118,280}},
        color={255,0,255}));
  connect(lat1.y, not2.u)
    annotation (Line(points={{142,280},{158,280}}, color={255,0,255}));
  connect(not2.y, booScaRep10.u)
    annotation (Line(points={{182,280},{198,280}}, color={255,0,255}));
  connect(booScaRep10.y, or13.u1) annotation (Line(points={{222,280},{240,280},
          {240,244},{244,244},{244,224},{202,224},{202,250}}, color={255,0,255}));
  connect(pre10.y, or13.u2) annotation (Line(points={{208,240},{208,242},{202,
          242}}, color={255,0,255}));
  connect(or13.y, dowProCon1.uBoi) annotation (Line(points={{178,250},{172,250},
          {172,232},{200,232},{200,196},{208,196}}, color={255,0,255}));
  connect(conInt8.y, intSub2.u1) annotation (Line(points={{-278,-80},{-272,-80},
          {-272,-104},{-262,-104}}, color={255,127,0}));
  connect(onCouInt2.y, intSub2.u2) annotation (Line(points={{-278,-110},{-272,
          -110},{-272,-116},{-262,-116}}, color={255,127,0}));
  connect(intSub2.y, dowProCon4.uStaSet) annotation (Line(points={{-238,-110},{
          -232,-110},{-232,-160},{-162,-160}}, color={255,127,0}));
  connect(intSub2.y, intEqu6.u1) annotation (Line(points={{-238,-110},{-232,
          -110},{-232,-172},{-280,-172},{-280,-190},{-270,-190}}, color={255,
          127,0}));
  connect(intSub2.y, intEqu7.u1) annotation (Line(points={{-238,-110},{-232,
          -110},{-232,-172},{-280,-172},{-280,-230},{-270,-230}}, color={255,
          127,0}));
  connect(intSub2.y, intEqu8.u1) annotation (Line(points={{-238,-110},{-232,
          -110},{-232,-172},{-280,-172},{-280,-270},{-268,-270}}, color={255,
          127,0}));
  connect(con8.y, lat2.clr) annotation (Line(points={{-348,-136},{-336,-136},{
          -336,-46},{-322,-46}}, color={255,0,255}));
  connect(intEqu7.y, lat2.u) annotation (Line(points={{-246,-230},{-248,-230},{
          -248,-252},{-284,-252},{-284,-160},{-386,-160},{-386,-40},{-322,-40}},
        color={255,0,255}));
  connect(lat2.y, not3.u)
    annotation (Line(points={{-298,-40},{-282,-40}}, color={255,0,255}));
  connect(not3.y, booScaRep11.u)
    annotation (Line(points={{-258,-40},{-242,-40}}, color={255,0,255}));
  connect(pre11.y, or12.u2) annotation (Line(points={{-162,-80},{-178,-80},{
          -178,-68}}, color={255,0,255}));
  connect(booScaRep11.y, or12.u1) annotation (Line(points={{-218,-40},{-172,-40},
          {-172,-60},{-178,-60}}, color={255,0,255}));
  connect(dowProCon4.uBoi, or12.y) annotation (Line(points={{-162,-140},{-176,
          -140},{-176,-84},{-208,-84},{-208,-68},{-212,-68},{-212,-60},{-202,
          -60}}, color={255,0,255}));
  connect(pre4.y, or14.u1)
    annotation (Line(points={{-98,-160},{-82,-160}}, color={255,0,255}));
  connect(booScaRep11.y, or14.u2) annotation (Line(points={{-218,-40},{-172,-40},
          {-172,-116},{-128,-116},{-128,-112},{-92,-112},{-92,-168},{-82,-168}},
        color={255,0,255}));
  connect(or14.y, dowProCon4.uHotWatIsoVal) annotation (Line(points={{-58,-160},
          {-52,-160},{-52,-188},{-204,-188},{-204,-145},{-162,-145}}, color={
          255,0,255}));
annotation (
 experiment(
      StopTime=1200,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Boilers/Staging/Processes/Validation/Down.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Down\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Down</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 19, 2020 by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-380,-340},{380,340}})));
end Down;
