within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Validation;
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

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Down dowProCon(
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

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Down dowProCon1(
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

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Down dowProCon4(
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
    annotation (Placement(transformation(extent={{-120,-146},{-100,-126}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-334,70},{-314,90}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3[nBoi](
    final pre_u_start={true,true})
    "Logical pre block"
    annotation (Placement(transformation(extent={{-260,180},{-240,200}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{-220,100},{-200,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nBoi](
    final k={true,false})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-260,120},{-240,140}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-90,150},{-70,170}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Switch between stage 2 and stage 3 setpoints"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-260,50},{-240,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-368,0},{-348,20}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Detect first triggering pulse and subsequent stage change completion signals"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi[nBoi]
    "Pass initial valve position and switch to signal from controller"
    annotation (Placement(transformation(extent={{-220,270},{-200,290}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi))
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-370,250},{-350,270}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nBoi](
    final k={1,1})
    "Initial isolation valve positions"
    annotation (Placement(transformation(extent={{-300,280},{-280,300}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[nBoi](
    final samplePeriod=fill(10, nBoi))
    "Zero order hold"
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

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{-300,100},{-280,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4[nBoi](
    final k={true,true})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-334,130},{-314,150}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{-320,20},{-300,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=3)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-370,40},{-350,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg2
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-164,110},{-144,130}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1[nBoi]
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{36,70},{56,90}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4[nBoi](
    final pre_u_start={true,true})
    "Logical pre block"
    annotation (Placement(transformation(extent={{110,180},{130,200}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi4[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{150,100},{170,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6[nBoi](
    final k={true,false})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{110,120},{130,140}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg3
    "Falling edge detector"
    annotation (Placement(transformation(extent={{280,150},{300,170}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2
    "Switch between stage 2 and stage 3 setpoints"
    annotation (Placement(transformation(extent={{150,30},{170,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=1)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{110,50},{130,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Detect first triggering pulse and subsequent stage change completion signals"
    annotation (Placement(transformation(extent={{240,110},{260,130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi))
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{0,250},{20,270}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre5
    "Logical pre block"
    annotation (Placement(transformation(extent={{330,130},{350,150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre6
    "Logical pre block"
    annotation (Placement(transformation(extent={{340,190},{360,210}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg4
    "Falling edge detector"
    annotation (Placement(transformation(extent={{280,190},{300,210}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi5[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{70,100},{90,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9[nBoi](
    final k={true,true})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{36,130},{56,150}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=3)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg5
    "Falling edge detector"
    annotation (Placement(transformation(extent={{206,110},{226,130}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat3[nBoi]
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{330,60},{350,80}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{280,60},{300,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con20[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-334,-266},{-314,-246}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre13[nBoi](
    final pre_u_start={true,true})
    "Logical pre block"
    annotation (Placement(transformation(extent={{-260,-160},{-240,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi13[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{-220,-236},{-200,-216}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con21[nBoi](
    final k={true,
        false})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-260,-216},{-240,-196}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi8
    "Switch between stage 2 and stage 3 setpoints"
    annotation (Placement(transformation(extent={{-220,-306},{-200,-286}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt16(
    final k=1)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-260,-286},{-240,-266}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt17(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-370,-336},{-350,-316}})));

  Buildings.Controls.OBC.CDL.Logical.Or or5
    "Detect first triggering pulse and subsequent stage change completion signals"
    annotation (Placement(transformation(extent={{-130,-226},{-110,-206}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi4[nBoi]
    "Pass initial valve position and switch to signal from controller"
    annotation (Placement(transformation(extent={{-220,-66},{-200,-46}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi))
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-370,-86},{-350,-66}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con22[nBoi](
    final k={1,1})
    "Initial isolation valve positions"
    annotation (Placement(transformation(extent={{-300,-56},{-280,-36}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con23(
    final k=VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{-180,-56},{-160,-36}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol4[nBoi](
    final samplePeriod=fill(10, nBoi))
    "Zero order hold"
    annotation (Placement(transformation(extent={{-60,-166},{-40,-146}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre15
    "Logical pre block"
    annotation (Placement(transformation(extent={{-28,-146},{-8,-126}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg13
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-90,-146},{-70,-126}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi14[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{-300,-236},{-280,-216}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant  con24[nBoi](
    final k={true,true})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-334,-206},{-314,-186}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi9
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{-320,-316},{-300,-296}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt19(
    final k=3)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-370,-296},{-350,-276}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg14
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-164,-226},{-144,-206}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat9[nBoi]
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{-50,-280},{-30,-260}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-90,-280},{-70,-260}})));

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

  Buildings.Controls.OBC.CDL.Logical.Pre pre7
    "Logical pre block"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre8
    "Logical pre block"
    annotation (Placement(transformation(extent={{240,60},{260,80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre9
    "Logical pre block"
    annotation (Placement(transformation(extent={{-130,-280},{-110,-260}})));

equation

  connect(con2.y, logSwi1.u1) annotation (Line(points={{-238,130},{-230,130},{
          -230,118},{-222,118}},
                            color={255,0,255}));

  connect(yPumChaPro.y, falEdg.u)
    annotation (Line(points={{-98,160},{-92,160}}, color={255,0,255}));

  connect(conInt.y, intSwi.u1) annotation (Line(points={{-238,60},{-230,60},{
          -230,48},{-222,48}},
                          color={255,127,0}));

  connect(booPul.y, swi.u2) annotation (Line(points={{-348,260},{-240,260},{
          -240,280},{-222,280}},
                            color={255,0,255}));

  connect(con.y, swi.u1) annotation (Line(points={{-278,290},{-230,290},{-230,
          288},{-222,288}},
                       color={0,0,127}));

  connect(zerOrdHol.y, swi.u3) annotation (Line(points={{-38,180},{-34,180},{-34,
          260},{-230,260},{-230,272},{-222,272}},
                                             color={0,0,127}));

  connect(falEdg.y, pre1.u) annotation (Line(points={{-68,160},{-46,160},{-46,
          140},{-42,140}}, color={255,0,255}));

  connect(yStaChaPro.y, falEdg1.u)
    annotation (Line(points={{-98,200},{-92,200}}, color={255,0,255}));

  connect(con1.y, logSwi2.u3) annotation (Line(points={{-312,80},{-306,80},{
          -306,102},{-302,102}}, color={255,0,255}));

  connect(con4.y, logSwi2.u1) annotation (Line(points={{-312,140},{-308,140},{-308,
          118},{-302,118}},      color={255,0,255}));

  connect(booPul.y, logSwi2.u2) annotation (Line(points={{-348,260},{-340,260},
          {-340,110},{-302,110}}, color={255,0,255}));

  connect(logSwi2.y, logSwi1.u3) annotation (Line(points={{-278,110},{-272,110},
          {-272,102},{-222,102}}, color={255,0,255}));

  connect(conInt1.y, intSwi1.u3) annotation (Line(points={{-346,10},{-330,10},{-330,
          22},{-322,22}},     color={255,127,0}));

  connect(conInt3.y, intSwi1.u1) annotation (Line(points={{-348,50},{-330,50},{-330,
          38},{-322,38}},      color={255,127,0}));

  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{-298,30},{-230,30},{-230,
          32},{-222,32}},      color={255,127,0}));

  connect(booPul[1].y, intSwi1.u2) annotation (Line(points={{-348,260},{-340,260},
          {-340,30},{-322,30}},      color={255,0,255}));

  connect(falEdg1.y, pre2.u)
    annotation (Line(points={{-68,200},{-30,200}}, color={255,0,255}));

  connect(booPul[1].y, falEdg2.u) annotation (Line(points={{-348,260},{-340,260},
          {-340,96},{-168,96},{-168,120},{-166,120}}, color={255,0,255}));

  connect(falEdg2.y, or2.u1)
    annotation (Line(points={{-142,120},{-132,120}}, color={255,0,255}));

  connect(booRep.y, lat1.u)
    annotation (Line(points={{-58,70},{-42,70}},  color={255,0,255}));

  connect(lat1.y, logSwi1.u2) annotation (Line(points={{-18,70},{-10,70},{-10,
          50},{-160,50},{-160,74},{-226,74},{-226,110},{-222,110}}, color={255,
          0,255}));

  connect(lat1[1].y, intSwi.u2) annotation (Line(points={{-18,70},{-10,70},{-10,
          50},{-160,50},{-160,74},{-226,74},{-226,40},{-222,40}}, color={255,0,
          255}));

  connect(con1[1].y, lat1[1].clr) annotation (Line(points={{-312,80},{-150,80},
          {-150,54},{-50,54},{-50,64},{-42,64}},   color={255,0,255}));

  connect(con1[1].y, lat1[2].clr) annotation (Line(points={{-312,80},{-150,80},
          {-150,54},{-50,54},{-50,64},{-42,64}},   color={255,0,255}));

  connect(con6.y,logSwi4. u1) annotation (Line(points={{132,130},{140,130},{140,
          118},{148,118}},  color={255,0,255}));

  connect(yPumChaPro1.y, falEdg3.u)
    annotation (Line(points={{272,160},{278,160}}, color={255,0,255}));

  connect(conInt4.y, intSwi2.u1) annotation (Line(points={{132,60},{140,60},{140,
          48},{148,48}}, color={255,127,0}));

  connect(falEdg3.y, pre5.u) annotation (Line(points={{302,160},{324,160},{324,140},
          {328,140}}, color={255,0,255}));

  connect(yStaChaPro1.y, falEdg4.u)
    annotation (Line(points={{272,200},{278,200}}, color={255,0,255}));

  connect(con5.y,logSwi5. u3) annotation (Line(points={{58,80},{64,80},{64,102},
          {68,102}},             color={255,0,255}));

  connect(con9.y,logSwi5. u1) annotation (Line(points={{58,140},{62,140},{62,118},
          {68,118}},             color={255,0,255}));

  connect(booPul1.y, logSwi5.u2) annotation (Line(points={{22,260},{30,260},{30,
          110},{68,110}}, color={255,0,255}));

  connect(logSwi5.y,logSwi4. u3) annotation (Line(points={{92,110},{98,110},{98,
          102},{148,102}},        color={255,0,255}));

  connect(conInt5.y,intSwi3. u3) annotation (Line(points={{22,10},{40,10},{40,22},
          {48,22}},           color={255,127,0}));

  connect(conInt7.y,intSwi3. u1) annotation (Line(points={{22,50},{40,50},{40,38},
          {48,38}},            color={255,127,0}));

  connect(intSwi3.y, intSwi2.u3) annotation (Line(points={{72,30},{140,30},{140,
          32},{148,32}}, color={255,127,0}));

  connect(booPul1[1].y, intSwi3.u2) annotation (Line(points={{22,260},{30,260},{
          30,30},{48,30}}, color={255,0,255}));

  connect(falEdg4.y,pre6. u)
    annotation (Line(points={{302,200},{338,200}}, color={255,0,255}));

  connect(booPul1[1].y, falEdg5.u) annotation (Line(points={{22,260},{30,260},{30,
          96},{202,96},{202,120},{204,120}}, color={255,0,255}));

  connect(falEdg5.y,or1. u1)
    annotation (Line(points={{228,120},{238,120}},   color={255,0,255}));

  connect(booRep1.y, lat3.u)
    annotation (Line(points={{302,70},{328,70}}, color={255,0,255}));

  connect(lat3.y,logSwi4. u2) annotation (Line(points={{352,70},{360,70},{360,
          50},{210,50},{210,74},{144,74},{144,110},{148,110}},      color={255,
          0,255}));
  connect(lat3[1].y, intSwi2.u2) annotation (Line(points={{352,70},{360,70},{
          360,50},{210,50},{210,74},{144,74},{144,40},{148,40}},
                                                             color={255,0,255}));

  connect(con5[1].y,lat3 [1].clr) annotation (Line(points={{58,80},{220,80},{
          220,54},{320,54},{320,64},{328,64}},     color={255,0,255}));

  connect(con5[1].y,lat3 [2].clr) annotation (Line(points={{58,80},{220,80},{
          220,54},{320,54},{320,64},{328,64}},     color={255,0,255}));

  connect(con21.y, logSwi13.u1) annotation (Line(points={{-238,-206},{-230,-206},
          {-230,-218},{-222,-218}},
                           color={255,0,255}));

  connect(conInt16.y, intSwi8.u1) annotation (Line(points={{-238,-276},{-230,-276},
          {-230,-288},{-222,-288}},
                         color={255,127,0}));

  connect(booPul4.y, swi4.u2) annotation (Line(points={{-348,-76},{-240,-76},{-240,
          -56},{-222,-56}},color={255,0,255}));

  connect(con22.y, swi4.u1) annotation (Line(points={{-278,-46},{-230,-46},{-230,
          -48},{-222,-48}},
                      color={0,0,127}));

  connect(zerOrdHol4.y, swi4.u3) annotation (Line(points={{-38,-156},{-34,-156},
          {-34,-76},{-230,-76},{-230,-64},{-222,-64}},
                                               color={0,0,127}));

  connect(yStaChaPro4.y, falEdg13.u)
    annotation (Line(points={{-98,-136},{-92,-136}},
                                                   color={255,0,255}));

  connect(con20.y, logSwi14.u3) annotation (Line(points={{-312,-256},{-306,-256},
          {-306,-234},{-302,-234}},
                           color={255,0,255}));

  connect(con24.y, logSwi14.u1) annotation (Line(points={{-312,-196},{-310,-196},
          {-310,-218},{-302,-218}},
                           color={255,0,255}));

  connect(booPul4.y, logSwi14.u2) annotation (Line(points={{-348,-76},{-340,-76},
          {-340,-226},{-302,-226}},
                               color={255,0,255}));

  connect(logSwi14.y, logSwi13.u3) annotation (Line(points={{-278,-226},{-272,-226},
          {-272,-234},{-222,-234}},
                                color={255,0,255}));

  connect(conInt17.y, intSwi9.u3) annotation (Line(points={{-348,-326},{-330,-326},
          {-330,-314},{-322,-314}},
                         color={255,127,0}));

  connect(conInt19.y, intSwi9.u1) annotation (Line(points={{-348,-286},{-330,-286},
          {-330,-298},{-322,-298}},
                         color={255,127,0}));

  connect(intSwi9.y, intSwi8.u3) annotation (Line(points={{-298,-306},{-230,-306},
          {-230,-304},{-222,-304}},
                         color={255,127,0}));

  connect(booPul4[1].y, intSwi9.u2) annotation (Line(points={{-348,-76},{-340,-76},
          {-340,-306},{-322,-306}},
                              color={255,0,255}));

  connect(falEdg13.y, pre15.u)
    annotation (Line(points={{-68,-136},{-30,-136}},
                                                   color={255,0,255}));

  connect(booPul4[1].y, falEdg14.u) annotation (Line(points={{-348,-76},{-340,-76},
          {-340,-240},{-168,-240},{-168,-216},{-166,-216}},
                                                  color={255,0,255}));

  connect(falEdg14.y, or5.u1)
    annotation (Line(points={{-142,-216},{-132,-216}},
                                                   color={255,0,255}));

  connect(booRep4.y, lat9.u)
    annotation (Line(points={{-68,-270},{-52,-270}},
                                                 color={255,0,255}));

  connect(lat9.y, logSwi13.u2) annotation (Line(points={{-28,-270},{-20,-270},{
          -20,-286},{-160,-286},{-160,-262},{-226,-262},{-226,-226},{-222,-226}},
                                                           color={255,0,255}));

  connect(lat9[1].y, intSwi8.u2) annotation (Line(points={{-28,-270},{-20,-270},
          {-20,-286},{-160,-286},{-160,-262},{-226,-262},{-226,-296},{-222,-296}},
                                                             color={255,0,255}));

  connect(con20[1].y, lat9[1].clr) annotation (Line(points={{-312,-256},{-150,
          -256},{-150,-282},{-60,-282},{-60,-276},{-52,-276}},
                                           color={255,0,255}));

  connect(con20[1].y, lat9[2].clr) annotation (Line(points={{-312,-256},{-150,
          -256},{-150,-282},{-60,-282},{-60,-276},{-52,-276}},
                                           color={255,0,255}));

  connect(con12.y, swi2.u1) annotation (Line(points={{-68,-16},{-60,-16},{-60,-28},
          {-52,-28}},      color={0,0,127}));

  connect(con17.y, swi2.u3) annotation (Line(points={{-68,-56},{-60,-56},{-60,-44},
          {-52,-44}},      color={0,0,127}));

  connect(lat10.y, swi2.u2)
    annotation (Line(points={{-108,-36},{-52,-36}},color={255,0,255}));

  connect(pre15.y, lat10.u) annotation (Line(points={{-6,-136},{0,-136},{0,-80},
          {-140,-80},{-140,-36},{-132,-36}},   color={255,0,255}));

  connect(booPul4[1].y, lat10.clr) annotation (Line(points={{-348,-76},{-240,-76},
          {-240,-82},{-136,-82},{-136,-42},{-132,-42}},
                                                    color={255,0,255}));

  connect(swi.y, dowProCon.uHotWatIsoVal) annotation (Line(points={{-198,280},{-170,
          280},{-170,192},{-162,192}}, color={0,0,127}));

  connect(dowProCon.yBoi, pre3.u) annotation (Line(points={{-138,198},{-130,198},
          {-130,250},{-270,250},{-270,190},{-262,190}}, color={255,0,255}));

  connect(logSwi1.y, dowProCon.uBoiSet) annotation (Line(points={{-198,110},{-180,
          110},{-180,184},{-162,184}}, color={255,0,255}));

  connect(or2.y, dowProCon.uStaDowPro) annotation (Line(points={{-108,120},{-100,
          120},{-100,104},{-176,104},{-176,180},{-162,180}}, color={255,0,255}));

  connect(intSwi.y, dowProCon.uStaSet) annotation (Line(points={{-198,40},{-172,
          40},{-172,176},{-162,176}}, color={255,127,0}));

  connect(pre1.y, dowProCon.uPumChaPro) annotation (Line(points={{-18,140},{-10,
          140},{-10,120},{-80,120},{-80,140},{-166,140},{-166,168},{-162,168}},
        color={255,0,255}));

  connect(dowProCon.yStaChaPro, yStaChaPro.u) annotation (Line(points={{-138,194},
          {-126,194},{-126,200},{-122,200}}, color={255,0,255}));

  connect(dowProCon.yHotWatIsoVal, zerOrdHol.u) annotation (Line(points={{-138,190},
          {-130,190},{-130,180},{-62,180}}, color={0,0,127}));

  connect(dowProCon.yPumChaPro, yPumChaPro.u) annotation (Line(points={{-138,174},
          {-130,174},{-130,160},{-122,160}}, color={255,0,255}));

  connect(dowProCon1.yBoi, pre4.u) annotation (Line(points={{232,198},{240,198},
          {240,250},{100,250},{100,190},{108,190}}, color={255,0,255}));

  connect(logSwi4.y, dowProCon1.uBoiSet) annotation (Line(points={{172,110},{190,
          110},{190,184},{208,184}}, color={255,0,255}));

  connect(or1.y, dowProCon1.uStaDowPro) annotation (Line(points={{262,120},{270,
          120},{270,104},{194,104},{194,180},{208,180}}, color={255,0,255}));

  connect(intSwi2.y, dowProCon1.uStaSet) annotation (Line(points={{172,40},{198,
          40},{198,176},{208,176}}, color={255,127,0}));

  connect(pre5.y, dowProCon1.uPumChaPro) annotation (Line(points={{352,140},{360,
          140},{360,120},{310,120},{310,140},{202,140},{202,168},{208,168}},
        color={255,0,255}));

  connect(dowProCon1.yStaChaPro, yStaChaPro1.u) annotation (Line(points={{232,194},
          {244,194},{244,200},{248,200}}, color={255,0,255}));

  connect(con23.y, dowProCon4.VMinHotWatSet_flow) annotation (Line(points={{-158,
          -46},{-150,-46},{-150,-66},{-170,-66},{-170,-136},{-162,-136}}, color=
         {0,0,127}));

  connect(swi2.y, dowProCon4.VHotWat_flow) annotation (Line(points={{-28,-36},{-20,
          -36},{-20,-96},{-166,-96},{-166,-132},{-162,-132}}, color={0,0,127}));

  connect(swi4.y, dowProCon4.uHotWatIsoVal) annotation (Line(points={{-198,-56},
          {-190,-56},{-190,-144},{-162,-144}},                         color={0,
          0,127}));

  connect(logSwi13.y, dowProCon4.uBoiSet) annotation (Line(points={{-198,-226},{
          -180,-226},{-180,-152},{-162,-152}}, color={255,0,255}));

  connect(or5.y, dowProCon4.uStaDowPro) annotation (Line(points={{-108,-216},{-104,
          -216},{-104,-232},{-176,-232},{-176,-156},{-162,-156}}, color={255,0,255}));

  connect(intSwi8.y, dowProCon4.uStaSet) annotation (Line(points={{-198,-296},{-172,
          -296},{-172,-160},{-162,-160}}, color={255,127,0}));

  connect(dowProCon4.yBoi, pre13.u) annotation (Line(points={{-138,-138},{-130,
          -138},{-130,-86},{-270,-86},{-270,-150},{-262,-150}},
                                                          color={255,0,255}));

  connect(dowProCon4.yStaChaPro, yStaChaPro4.u) annotation (Line(points={{-138,-142},
          {-126,-142},{-126,-136},{-122,-136}}, color={255,0,255}));

  connect(dowProCon4.yHotWatIsoVal, zerOrdHol4.u) annotation (Line(points={{-138,
          -146},{-130,-146},{-130,-156},{-62,-156}}, color={0,0,127}));

  connect(dowProCon1.yPumChaPro, yPumChaPro1.u) annotation (Line(points={{232,174},
          {240,174},{240,160},{248,160}}, color={255,0,255}));

  connect(pre2.y, dowProCon.uStaChaPro) annotation (Line(points={{-6,200},{0,200},
          {0,100},{-184,100},{-184,172},{-162,172}}, color={255,0,255}));
  connect(pre6.y, dowProCon1.uStaChaPro) annotation (Line(points={{362,200},{
          370,200},{370,100},{186,100},{186,172},{208,172}},
                                                         color={255,0,255}));
  connect(pre15.y, dowProCon4.uStaChaPro) annotation (Line(points={{-6,-136},{0,
          -136},{0,-236},{-184,-236},{-184,-164},{-162,-164}}, color={255,0,255}));
  connect(pre3.y, dowProCon.uBoi) annotation (Line(points={{-238,190},{-180,190},
          {-180,188},{-162,188}}, color={255,0,255}));
  connect(pre7.y, booRep.u)
    annotation (Line(points={{-98,70},{-82,70}}, color={255,0,255}));
  connect(pre2.y, pre7.u) annotation (Line(points={{-6,200},{0,200},{0,90},{
          -140,90},{-140,70},{-122,70}}, color={255,0,255}));
  connect(pre7.y, or2.u2) annotation (Line(points={{-98,70},{-90,70},{-90,94},{
          -140,94},{-140,112},{-132,112}}, color={255,0,255}));
  connect(pre4.y, dowProCon1.uBoi) annotation (Line(points={{132,190},{190,190},
          {190,188},{208,188}}, color={255,0,255}));
  connect(pre8.y, booRep1.u)
    annotation (Line(points={{262,70},{278,70}}, color={255,0,255}));
  connect(pre8.y, or1.u2) annotation (Line(points={{262,70},{270,70},{270,90},{
          232,90},{232,112},{238,112}}, color={255,0,255}));
  connect(pre6.y, pre8.u) annotation (Line(points={{362,200},{370,200},{370,100},
          {226,100},{226,70},{238,70}}, color={255,0,255}));
  connect(pre13.y, dowProCon4.uBoi) annotation (Line(points={{-238,-150},{-200,
          -150},{-200,-148},{-162,-148}}, color={255,0,255}));
  connect(booRep4.u, pre9.y)
    annotation (Line(points={{-92,-270},{-108,-270}}, color={255,0,255}));
  connect(pre15.y, pre9.u) annotation (Line(points={{-6,-136},{0,-136},{0,-236},
          {-140,-236},{-140,-270},{-132,-270}}, color={255,0,255}));
  connect(pre9.y, or5.u2) annotation (Line(points={{-108,-270},{-100,-270},{
          -100,-240},{-136,-240},{-136,-224},{-132,-224}}, color={255,0,255}));
annotation (
 experiment(
      StopTime=900,
      Interval=1,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/Processes/Validation/Down.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Down</a>.
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
