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
    annotation (Placement(transformation(extent={{360,166},{380,206}})));

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
    annotation (Placement(transformation(extent={{400,150},{420,170}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro1(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{400,180},{420,200}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro4(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And and2[nBoi]
    "Pass stage-1 boiler setpoints only when stage setpoint is 1"
    annotation (Placement(transformation(extent={{-280,120},{-260,140}})));

  Buildings.Controls.OBC.CDL.Logical.And and1[nBoi]
    "Pass stage-2 boiler setpoints only when stage setpoint is 2"
    annotation (Placement(transformation(extent={{-280,80},{-260,100}})));

  Buildings.Controls.OBC.CDL.Logical.And and3[nBoi]
    "Pass stage-3 boiler setpoints only when stage setpoint is 3"
    annotation (Placement(transformation(extent={{-280,20},{-260,40}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if next stage setpoint is 1"
    annotation (Placement(transformation(extent={{-360,140},{-340,160}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if next stage setpoint is 2"
    annotation (Placement(transformation(extent={{-360,90},{-340,110}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-320,140},{-300,160}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-320,90},{-300,110}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    "Check if next stage setpoint is 3"
    annotation (Placement(transformation(extent={{-360,40},{-340,60}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep2(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-320,40},{-300,60}})));

  Buildings.Controls.OBC.CDL.Logical.Or or7[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{-240,100},{-220,120}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt(
    final y_start=0)
    "Count number of stage changes initiated"
    annotation (Placement(transformation(extent={{-440,220},{-420,240}})));

  Buildings.Controls.OBC.CDL.Logical.Or or6
    "Generate stage change signal when simulation is initiated or previous change is completed"
    annotation (Placement(transformation(extent={{-470,220},{-450,240}})));

  Buildings.Controls.OBC.CDL.Logical.And and4[nBoi]
    "Pass stage-1 boiler setpoints only when stage setpoint is 1"
    annotation (Placement(transformation(extent={{240,140},{260,160}})));

  Buildings.Controls.OBC.CDL.Logical.And and5[nBoi]
    "Pass stage-2 boiler setpoints only when stage setpoint is 2"
    annotation (Placement(transformation(extent={{240,100},{260,120}})));

  Buildings.Controls.OBC.CDL.Logical.And and6[nBoi]
    "Pass stage-3 boiler setpoints only when stage setpoint is 3"
    annotation (Placement(transformation(extent={{240,60},{260,80}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Check if next stage setpoint is 1"
    annotation (Placement(transformation(extent={{172,140},{192,160}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4
    "Check if next stage setpoint is 2"
    annotation (Placement(transformation(extent={{172,100},{192,120}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep3(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{200,140},{220,160}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep4(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{200,100},{220,120}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu5
    "Check if next stage setpoint is 3"
    annotation (Placement(transformation(extent={{174,60},{194,80}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep5(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{200,60},{220,80}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{320,110},{340,130}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{280,120},{300,140}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt1(
    final y_start=0)
    "Count number of stage changes initiated"
    annotation (Placement(transformation(extent={{100,200},{120,220}})));

  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Generate stage change signal when simulation is initiated or previous change is completed"
    annotation (Placement(transformation(extent={{60,200},{80,220}})));

  Buildings.Controls.OBC.CDL.Logical.And and7[nBoi]
    "Pass stage-1 boiler setpoints only when stage setpoint is 1"
    annotation (Placement(transformation(extent={{-280,-200},{-260,-180}})));

  Buildings.Controls.OBC.CDL.Logical.And and8[nBoi]
    "Pass stage-2 boiler setpoints only when stage setpoint is 2"
    annotation (Placement(transformation(extent={{-280,-250},{-260,-230}})));

  Buildings.Controls.OBC.CDL.Logical.And and9[nBoi]
    "Pass stage-3 boiler setpoints only when stage setpoint is 3"
    annotation (Placement(transformation(extent={{-280,-280},{-260,-260}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu6
    "Check if next stage setpoint is 1"
    annotation (Placement(transformation(extent={{-350,-200},{-330,-180}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu7
    "Check if next stage setpoint is 2"
    annotation (Placement(transformation(extent={{-350,-240},{-330,-220}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep6(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-320,-200},{-300,-180}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep7(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-320,-240},{-300,-220}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu8
    "Check if next stage setpoint is 3"
    annotation (Placement(transformation(extent={{-348,-280},{-328,-260}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep8(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-320,-280},{-300,-260}})));

  Buildings.Controls.OBC.CDL.Logical.Or or5[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{-200,-260},{-180,-240}})));

  Buildings.Controls.OBC.CDL.Logical.Or or8[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{-240,-220},{-220,-200}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt2(
    final y_start=0)
    "Count number of stage changes initiated"
    annotation (Placement(transformation(extent={{-430,-140},{-410,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Or or9
    "Generate stage change signal when simulation is initiated or previous change is completed"
    annotation (Placement(transformation(extent={{-460,-140},{-440,-120}})));

  Buildings.Controls.OBC.CDL.Integers.Subtract intSub
    "Count down next stage change based on number of changes initiated"
    annotation (Placement(transformation(extent={{-400,220},{-380,240}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=3)
    "Highest available stage"
    annotation (Placement(transformation(extent={{-440,260},{-420,280}})));

  Buildings.Controls.OBC.CDL.Integers.Subtract intSub1
    "Count down next stage change based on number of changes initiated"
    annotation (Placement(transformation(extent={{130,200},{150,220}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6(
    final k=3)
    "Highest available stage"
    annotation (Placement(transformation(extent={{78,240},{98,260}})));

  Buildings.Controls.OBC.CDL.Integers.Subtract intSub2
    "Count down next stage change based on number of changes initiated"
    annotation (Placement(transformation(extent={{-390,-140},{-370,-120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt8(
    final k=3)
    "Highest available stage"
    annotation (Placement(transformation(extent={{-430,-100},{-410,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-440,70},{-420,90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nBoi](
    final k={true,false})
    "Boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-440,120},{-420,140}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-90,150},{-70,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-400,140},{-380,160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-400,90},{-380,110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=1/1800,
    final period=1800,
    final shift=1)
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-508,250},{-488,270}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre8[nBoi](
    final pre_u_start=fill(true,nBoi))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-80,260},{-100,280}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{-40,130},{-60,150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Logical pre block"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-90,190},{-70,210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-440,10},{-420,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-400,40},{-380,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6[nBoi](
    final k={true,false}) "Boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg3
    "Falling edge detector"
    annotation (Placement(transformation(extent={{440,150},{460,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=1)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{130,140},{150,160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{130,100},{150,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=1/1800,
    final period=1800,
    final shift=1)
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre5
    "Logical pre block"
    annotation (Placement(transformation(extent={{490,130},{470,150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre6
    "Logical pre block"
    annotation (Placement(transformation(extent={{470,180},{490,200}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg4
    "Falling edge detector"
    annotation (Placement(transformation(extent={{440,180},{460,200}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9[nBoi](
    final k={true,true}) "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=3)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{130,60},{150,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con20[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-440,-260},{-420,-240}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con21[nBoi](
    final k={true,false}) "Boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-440,-220},{-420,-200}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt16(
    final k=1)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-400,-200},{-380,-180}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt17(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-400,-240},{-380,-220}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    final width=1/1800,
    final period=1800,
    final shift=1)
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-500,-80},{-480,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con23(
    final k=VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{-280,-140},{-260,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4[nBoi](
    pre_u_start=fill(true, nBoi))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre15
    "Logical pre block"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg13
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant  con24[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-440,-310},{-420,-290}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt19(
    final k=3)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-400,-280},{-380,-260}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con12(
    final k=1.1*VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{-280,-70},{-260,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con17(
    final k=VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{-280,-110},{-260,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Pass different instances of measured flow-rate after stage change"
    annotation (Placement(transformation(extent={{-240,-90},{-220,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat10
    "Hold true signal after stage change"
    annotation (Placement(transformation(extent={{-320,-90},{-300,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre14
    "Logical pre block for additional delay on next stage change process start signal"
    annotation (Placement(transformation(extent={{-510,220},{-490,240}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con7(
    final k=false) "Constant false signal"
    annotation (Placement(transformation(extent={{-510,190},{-490,210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(
    final k=false)
    "Constant false signal"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3
    "Logical pre block for additional delay on next stage change process start signal"
    annotation (Placement(transformation(extent={{20,200},{40,220}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre7
    "Logical pre block"
    annotation (Placement(transformation(extent={{-500,-150},{-480,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con8(
    final k=false)
    "Constant false signal"
    annotation (Placement(transformation(extent={{-500,-180},{-480,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre9[nBoi](
    final pre_u_start=fill(true, nBoi))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-80,230},{-100,250}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre10[nBoi](
    final pre_u_start=fill(true, nBoi))
    "Logical pre block"
    annotation (Placement(transformation(extent={{380,220},{360,240}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre11[nBoi](
    final pre_u_start=fill(true, nBoi))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-140,-110},{-160,-90}})));

equation

  connect(yPumChaPro.y, falEdg.u)
    annotation (Line(points={{-98,160},{-92,160}}, color={255,0,255}));

  connect(falEdg.y, pre1.u) annotation (Line(points={{-68,160},{-38,160},{-38,140}},
                           color={255,0,255}));

  connect(yStaChaPro.y, falEdg1.u)
    annotation (Line(points={{-98,200},{-92,200}}, color={255,0,255}));

  connect(falEdg1.y, pre2.u)
    annotation (Line(points={{-68,200},{-42,200}}, color={255,0,255}));

  connect(yPumChaPro1.y, falEdg3.u)
    annotation (Line(points={{422,160},{438,160}}, color={255,0,255}));

  connect(falEdg3.y, pre5.u) annotation (Line(points={{462,160},{496,160},{496,140},
          {492,140}}, color={255,0,255}));

  connect(yStaChaPro1.y, falEdg4.u)
    annotation (Line(points={{422,190},{438,190}}, color={255,0,255}));

  connect(falEdg4.y,pre6. u)
    annotation (Line(points={{462,190},{468,190}}, color={255,0,255}));

  connect(yStaChaPro4.y, falEdg13.u)
    annotation (Line(points={{-98,-140},{-82,-140}},
                                                   color={255,0,255}));

  connect(falEdg13.y, pre15.u)
    annotation (Line(points={{-58,-140},{-42,-140}},
                                                   color={255,0,255}));

  connect(con12.y, swi2.u1) annotation (Line(points={{-258,-60},{-250,-60},{-250,
          -72},{-242,-72}},color={0,0,127}));

  connect(con17.y, swi2.u3) annotation (Line(points={{-258,-100},{-250,-100},{-250,
          -88},{-242,-88}},color={0,0,127}));

  connect(lat10.y, swi2.u2)
    annotation (Line(points={{-298,-80},{-242,-80}},
                                                   color={255,0,255}));

  connect(pre15.y, lat10.u) annotation (Line(points={{-18,-140},{-10,-140},{-10,
          -40},{-332,-40},{-332,-80},{-322,-80}},
                                               color={255,0,255}));

  connect(pre1.y, dowProCon.uPumChaPro) annotation (Line(points={{-62,140},{-168,
          140},{-168,166},{-162,166}},
        color={255,0,255}));

  connect(dowProCon.yStaChaPro, yStaChaPro.u) annotation (Line(points={{-138,196},
          {-126,196},{-126,200},{-122,200}}, color={255,0,255}));

  connect(dowProCon.yPumChaPro, yPumChaPro.u) annotation (Line(points={{-138,171},
          {-138,160},{-122,160}},            color={255,0,255}));

  connect(pre5.y, dowProCon1.uPumChaPro) annotation (Line(points={{468,140},{340,
          140},{340,166},{358,166}},
        color={255,0,255}));

  connect(dowProCon1.yStaChaPro, yStaChaPro1.u) annotation (Line(points={{382,196},
          {390,196},{390,190},{398,190}}, color={255,0,255}));

  connect(con23.y, dowProCon4.VMinHotWatSet_flow) annotation (Line(points={{-258,
          -130},{-224,-130},{-224,-135},{-162,-135}},                     color=
         {0,0,127}));

  connect(swi2.y, dowProCon4.VHotWat_flow) annotation (Line(points={{-218,-80},{
          -210,-80},{-210,-130},{-162,-130}},                 color={0,0,127}));

  connect(dowProCon4.yStaChaPro, yStaChaPro4.u) annotation (Line(points={{-138,-140},
          {-122,-140}},                         color={255,0,255}));

  connect(dowProCon1.yPumChaPro, yPumChaPro1.u) annotation (Line(points={{382,171},
          {390,171},{390,160},{398,160}}, color={255,0,255}));

  connect(pre2.y, dowProCon.uStaChaPro) annotation (Line(points={{-18,200},{-10,
          200},{-10,122},{-162,122},{-162,171}},     color={255,0,255}));
  connect(pre6.y, dowProCon1.uStaChaPro) annotation (Line(points={{492,190},{500,
          190},{500,280},{330,280},{330,171},{358,171}}, color={255,0,255}));
  connect(pre15.y, dowProCon4.uStaChaPro) annotation (Line(points={{-18,-140},{-10,
          -140},{-10,-194},{-166,-194},{-166,-165},{-162,-165}},
                                                               color={255,0,255}));
  connect(dowProCon.yHotWatIsoVal, pre8.u) annotation (Line(points={{-138,191},{
          -128,191},{-128,184},{-56,184},{-56,270},{-78,270}},
                                           color={255,0,255}));
  connect(intEqu.y, booScaRep.u)
    annotation (Line(points={{-338,150},{-322,150}}, color={255,0,255}));
  connect(booScaRep.y, and2.u1) annotation (Line(points={{-298,150},{-290,150},{
          -290,130},{-282,130}}, color={255,0,255}));
  connect(intEqu1.y, booScaRep1.u)
    annotation (Line(points={{-338,100},{-322,100}}, color={255,0,255}));
  connect(booScaRep1.y, and1.u1) annotation (Line(points={{-298,100},{-292,100},
          {-292,90},{-282,90}},   color={255,0,255}));
  connect(intEqu2.y, booScaRep2.u)
    annotation (Line(points={{-338,50},{-322,50}}, color={255,0,255}));
  connect(booScaRep2.y, and3.u1)
    annotation (Line(points={{-298,50},{-290,50},{-290,30},{-282,30}},
                                                   color={255,0,255}));
  connect(and2.y, or2.u1) annotation (Line(points={{-258,130},{-250,130},{-250,110},
          {-242,110}}, color={255,0,255}));
  connect(and1.y, or2.u2) annotation (Line(points={{-258,90},{-250,90},{-250,102},
          {-242,102}}, color={255,0,255}));
  connect(and3.y, or7.u2) annotation (Line(points={{-258,30},{-210,30},{-210,62},
          {-202,62}},
        color={255,0,255}));
  connect(or2.y, or7.u1)
    annotation (Line(points={{-218,110},{-210,110},{-210,70},{-202,70}},
                                                     color={255,0,255}));
  connect(con7.y, onCouInt.reset) annotation (Line(points={{-488,200},{-430,200},
          {-430,218}}, color={255,0,255}));
  connect(or6.y, onCouInt.trigger)
    annotation (Line(points={{-448,230},{-442,230}}, color={255,0,255}));
  connect(pre14.y, or6.u2) annotation (Line(points={{-488,230},{-488,222},{-472,
          222}}, color={255,0,255}));
  connect(booPul.y, or6.u1) annotation (Line(points={{-486,260},{-478,260},{-478,
          230},{-472,230}}, color={255,0,255}));
  connect(pre2.y, pre14.u) annotation (Line(points={{-18,200},{-10,200},{-10,300},
          {-514,300},{-514,230},{-512,230}},                color={255,0,255}));
  connect(con2.y, and2.u2) annotation (Line(points={{-418,130},{-364,130},{-364,
          122},{-282,122}},            color={255,0,255}));
  connect(con1.y, and1.u2) annotation (Line(points={{-418,80},{-356,80},{-356,82},
          {-282,82}},     color={255,0,255}));
  connect(con4.y, and3.u2) annotation (Line(points={{-418,20},{-292,20},{-292,22},
          {-282,22}},           color={255,0,255}));
  connect(or7.y, dowProCon.uBoiSet) annotation (Line(points={{-178,70},{-172,70},
          {-172,186},{-162,186}},                          color={255,0,255}));
  connect(intEqu3.y, booScaRep3.u)
    annotation (Line(points={{194,150},{198,150}}, color={255,0,255}));
  connect(booScaRep3.y, and4.u1) annotation (Line(points={{222,150},{238,150}},
                           color={255,0,255}));
  connect(intEqu4.y, booScaRep4.u)
    annotation (Line(points={{194,110},{198,110}}, color={255,0,255}));
  connect(booScaRep4.y, and5.u1) annotation (Line(points={{222,110},{238,110}},
                           color={255,0,255}));
  connect(intEqu5.y, booScaRep5.u)
    annotation (Line(points={{196,70},{198,70}}, color={255,0,255}));
  connect(booScaRep5.y, and6.u1)
    annotation (Line(points={{222,70},{238,70}}, color={255,0,255}));
  connect(and4.y, or3.u1) annotation (Line(points={{262,150},{270,150},{270,130},
          {278,130}}, color={255,0,255}));
  connect(and5.y, or3.u2) annotation (Line(points={{262,110},{270,110},{270,122},
          {278,122}}, color={255,0,255}));
  connect(and6.y, or1.u2)
    annotation (Line(points={{262,70},{318,70},{318,112}}, color={255,0,255}));
  connect(or3.y, or1.u1)
    annotation (Line(points={{302,130},{312,130},{312,120},{318,120}},
                                                   color={255,0,255}));
  connect(or4.y, onCouInt1.trigger)
    annotation (Line(points={{82,210},{98,210}}, color={255,0,255}));
  connect(con3.y, onCouInt1.reset) annotation (Line(points={{42,150},{110,150},{
          110,198}},                 color={255,0,255}));
  connect(pre6.y, pre3.u) annotation (Line(points={{492,190},{500,190},{500,280},
          {10,280},{10,210},{18,210}},              color={255,0,255}));
  connect(or1.y, dowProCon1.uBoiSet) annotation (Line(points={{342,120},{350,120},
          {350,186},{358,186}},                         color={255,0,255}));
  connect(or6.y, dowProCon.uStaDowPro) annotation (Line(points={{-448,230},{-444,
          230},{-444,252},{-314,252},{-314,181},{-162,181}},
        color={255,0,255}));
  connect(or4.y, dowProCon1.uStaDowPro) annotation (Line(points={{82,210},{90,210},
          {90,181},{358,181}},                color={255,0,255}));
  connect(con6.y, and4.u2) annotation (Line(points={{102,130},{230,130},{230,142},
          {238,142}},               color={255,0,255}));
  connect(con5.y, and5.u2) annotation (Line(points={{102,90},{230,90},{230,102},
          {238,102}},                color={255,0,255}));
  connect(con9.y, and6.u2) annotation (Line(points={{102,50},{230,50},{230,62},{
          238,62}},      color={255,0,255}));
  connect(dowProCon4.yHotWatIsoVal, pre4.u) annotation (Line(points={{-138,-145},
          {-138,-144},{-130,-144},{-130,-170},{-122,-170}}, color={255,0,255}));
  connect(intEqu6.y, booScaRep6.u)
    annotation (Line(points={{-328,-190},{-322,-190}}, color={255,0,255}));
  connect(booScaRep6.y, and7.u1) annotation (Line(points={{-298,-190},{-282,-190}},
                                    color={255,0,255}));
  connect(intEqu7.y, booScaRep7.u)
    annotation (Line(points={{-328,-230},{-322,-230}}, color={255,0,255}));
  connect(booScaRep7.y, and8.u1) annotation (Line(points={{-298,-230},{-292,-230},
          {-292,-240},{-282,-240}}, color={255,0,255}));
  connect(intEqu8.y, booScaRep8.u)
    annotation (Line(points={{-326,-270},{-322,-270}}, color={255,0,255}));
  connect(booScaRep8.y, and9.u1)
    annotation (Line(points={{-298,-270},{-282,-270}}, color={255,0,255}));
  connect(and7.y, or8.u1) annotation (Line(points={{-258,-190},{-250,-190},{-250,
          -210},{-242,-210}}, color={255,0,255}));
  connect(and8.y, or8.u2) annotation (Line(points={{-258,-240},{-250,-240},{-250,
          -218},{-242,-218}}, color={255,0,255}));
  connect(and9.y, or5.u2) annotation (Line(points={{-258,-270},{-210,-270},{-210,
          -258},{-202,-258}},
                  color={255,0,255}));
  connect(or8.y, or5.u1)
    annotation (Line(points={{-218,-210},{-210,-210},{-210,-250},{-202,-250}},
                                                       color={255,0,255}));
  connect(or9.y, onCouInt2.trigger)
    annotation (Line(points={{-438,-130},{-432,-130}}, color={255,0,255}));
  connect(pre7.y, or9.u2) annotation (Line(points={{-478,-140},{-470,-140},{-470,
          -138},{-462,-138}},
                  color={255,0,255}));
  connect(con8.y, onCouInt2.reset) annotation (Line(points={{-478,-170},{-420,-170},
          {-420,-142}}, color={255,0,255}));
  connect(booPul4.y, or9.u1) annotation (Line(points={{-478,-70},{-472,-70},{-472,
          -130},{-462,-130}},            color={255,0,255}));
  connect(or9.y, dowProCon4.uStaDowPro) annotation (Line(points={{-438,-130},{-434,
          -130},{-434,-155},{-162,-155}},
                                  color={255,0,255}));
  connect(or5.y, dowProCon4.uBoiSet) annotation (Line(points={{-178,-250},{-172,
          -250},{-172,-150},{-162,-150}},                      color={255,0,255}));
  connect(con21.y, and7.u2) annotation (Line(points={{-418,-210},{-282,-210},{-282,
          -198}},                                     color={255,0,255}));
  connect(con20.y, and8.u2) annotation (Line(points={{-418,-250},{-292,-250},{-292,
          -248},{-282,-248}},                         color={255,0,255}));
  connect(con24.y, and9.u2) annotation (Line(points={{-418,-300},{-282,-300},{-282,
          -278}},                         color={255,0,255}));
  connect(booPul4.y, lat10.clr) annotation (Line(points={{-478,-70},{-340,-70},{
          -340,-86},{-322,-86}}, color={255,0,255}));
  connect(pre15.y, pre7.u) annotation (Line(points={{-18,-140},{-10,-140},{-10,-40},
          {-516,-40},{-516,-140},{-502,-140}},                     color={255,0,
          255}));
  connect(onCouInt.y, intSub.u2) annotation (Line(points={{-418,230},{-410,230},
          {-410,224},{-402,224}}, color={255,127,0}));
  connect(conInt2.y, intSub.u1) annotation (Line(points={{-418,270},{-410,270},{
          -410,236},{-402,236}},  color={255,127,0}));
  connect(intSub.y, dowProCon.uStaSet) annotation (Line(points={{-378,230},{-370,
          230},{-370,176},{-162,176}},      color={255,127,0}));
  connect(dowProCon.yBoi, pre9.u) annotation (Line(points={{-138,201},{-130,201},
          {-130,220},{-60,220},{-60,240},{-78,240}},    color={255,0,255}));
  connect(dowProCon1.yBoi, pre10.u) annotation (Line(points={{382,201},{390,201},
          {390,230},{382,230}},           color={255,0,255}));
  connect(dowProCon4.yBoi, pre11.u) annotation (Line(points={{-138,-135},{-130,-135},
          {-130,-100},{-138,-100}},     color={255,0,255}));
  connect(onCouInt1.y, intSub1.u2) annotation (Line(points={{122,210},{122,208},
          {128,208},{128,204}}, color={255,127,0}));
  connect(conInt6.y, intSub1.u1) annotation (Line(points={{100,250},{128,250},{128,
          216}},     color={255,127,0}));
  connect(intSub1.y, dowProCon1.uStaSet) annotation (Line(points={{152,210},{320,
          210},{320,176},{358,176}},     color={255,127,0}));
  connect(conInt8.y, intSub2.u1) annotation (Line(points={{-408,-90},{-402,-90},
          {-402,-124},{-392,-124}}, color={255,127,0}));
  connect(onCouInt2.y, intSub2.u2) annotation (Line(points={{-408,-130},{-402,-130},
          {-402,-136},{-392,-136}},       color={255,127,0}));
  connect(intSub2.y, dowProCon4.uStaSet) annotation (Line(points={{-368,-130},{-360,
          -130},{-360,-160},{-162,-160}},      color={255,127,0}));
  connect(pre9.y, dowProCon.uBoi) annotation (Line(points={{-102,240},{-166,240},
          {-166,196},{-162,196}}, color={255,0,255}));
  connect(pre8.y, dowProCon.uHotWatIsoVal) annotation (Line(points={{-102,270},{
          -172,270},{-172,191},{-162,191}}, color={255,0,255}));
  connect(pre10.y, dowProCon1.uBoi) annotation (Line(points={{358,230},{350,230},
          {350,196},{358,196}}, color={255,0,255}));
  connect(conInt.y, intEqu.u1)
    annotation (Line(points={{-378,150},{-362,150}}, color={255,127,0}));
  connect(conInt1.y, intEqu1.u1)
    annotation (Line(points={{-378,100},{-362,100}}, color={255,127,0}));
  connect(conInt3.y, intEqu2.u1)
    annotation (Line(points={{-378,50},{-362,50}}, color={255,127,0}));
  connect(intSub.y, intEqu.u2) annotation (Line(points={{-378,230},{-370,230},{-370,
          142},{-362,142}}, color={255,127,0}));
  connect(intSub.y, intEqu1.u2) annotation (Line(points={{-378,230},{-370,230},{
          -370,92},{-362,92}}, color={255,127,0}));
  connect(intSub.y, intEqu2.u2) annotation (Line(points={{-378,230},{-370,230},{
          -370,42},{-362,42}}, color={255,127,0}));
  connect(conInt7.y, intEqu5.u1)
    annotation (Line(points={{152,70},{172,70}}, color={255,127,0}));
  connect(conInt5.y, intEqu4.u1)
    annotation (Line(points={{152,110},{170,110}}, color={255,127,0}));
  connect(conInt4.y, intEqu3.u1)
    annotation (Line(points={{152,150},{170,150}}, color={255,127,0}));
  connect(intSub1.y, intEqu5.u2) annotation (Line(points={{152,210},{160,210},{160,
          62},{172,62}}, color={255,127,0}));
  connect(intSub1.y, intEqu4.u2) annotation (Line(points={{152,210},{160,210},{160,
          102},{170,102}}, color={255,127,0}));
  connect(intSub1.y, intEqu3.u2) annotation (Line(points={{152,210},{160,210},{160,
          142},{170,142}}, color={255,127,0}));
  connect(pre3.y, or4.u1)
    annotation (Line(points={{42,210},{58,210}}, color={255,0,255}));
  connect(booPul1.y, or4.u2) annotation (Line(points={{42,180},{52,180},{52,202},
          {58,202}}, color={255,0,255}));
  connect(pre11.y, dowProCon4.uBoi) annotation (Line(points={{-162,-100},{-180,-100},
          {-180,-140},{-162,-140}}, color={255,0,255}));
  connect(pre4.y, dowProCon4.uHotWatIsoVal) annotation (Line(points={{-98,-170},
          {-90,-170},{-90,-80},{-190,-80},{-190,-145},{-162,-145}}, color={255,0,
          255}));
  connect(conInt16.y, intEqu6.u1)
    annotation (Line(points={{-378,-190},{-352,-190}}, color={255,127,0}));
  connect(conInt17.y, intEqu7.u1)
    annotation (Line(points={{-378,-230},{-352,-230}}, color={255,127,0}));
  connect(conInt19.y, intEqu8.u1)
    annotation (Line(points={{-378,-270},{-350,-270}}, color={255,127,0}));
  connect(intSub2.y, intEqu6.u2) annotation (Line(points={{-368,-130},{-360,-130},
          {-360,-198},{-352,-198}}, color={255,127,0}));
  connect(intSub2.y, intEqu7.u2) annotation (Line(points={{-368,-130},{-360,-130},
          {-360,-238},{-352,-238}}, color={255,127,0}));
  connect(intSub2.y, intEqu8.u2) annotation (Line(points={{-368,-130},{-360,-130},
          {-360,-278},{-350,-278}}, color={255,127,0}));
annotation (
 experiment(
      StopTime=1200,
      Interval=1,
      Tolerance=1e-06),
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
        coordinateSystem(preserveAspectRatio=false, extent={{-520,-340},{520,340}})));
end Down;
