within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes;
block Up
    "Sequence for control devices when there is stage-up command"

  parameter Boolean have_priOnl = false
    "True: The boiler plant is primary-only;
    False: The boiler plant is primary-secondary"
    annotation (Dialog(group="Boiler plant parameters"));

  parameter Boolean have_heaPriPum = true
    "True: Headered hot water pumps;
     False: Dedicated hot water pumps"
    annotation (Dialog(group="Boiler plant parameters"));

  parameter Integer nBoi=3
    "Total number of boilers in the plant"
    annotation (Dialog(group="Boiler plant parameters"));

  parameter Integer nSta=5
    "Total number of stages"
    annotation (Dialog(group="Boiler plant parameters"));

  parameter Real TMinSupNonConBoi(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 333.2
    "Minimum supply temperature required for non-condensing boilers"
    annotation (Dialog(group="Boiler plant parameters"));

  parameter Real delProSupTemSet(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Process time-out for hot water supply temperature setpoint reset"
    annotation (Dialog(group="Time and delay parameters"));

  parameter Real delEnaMinFloSet(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 60
    "Enable delay after minimum flow setpoint is achieved in bypass valve"
    annotation (Evaluate=true,Dialog(group="Time and delay parameters",
      enable=have_priOnl));

  parameter Real chaIsoValTim(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 60
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(group="Time and delay parameters"));

  parameter Real delPreBoiEna(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 30
    "Time delay after valve and pump change process has been completed before
    starting boiler change process"
    annotation (Dialog(group="Time and delay parameters"));

  parameter Real boiChaProOnTim(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Enabled boiler operation time to indicate if it is proven on during a staging
    process where one boiler is turned on and the other is turned off"
    annotation (Dialog(group="Time and delay parameters"));

  parameter Real delBoiEna(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 180
    "Time delay after boiler change process has been completed before turning off
    excess valves and pumps"
    annotation (Dialog(group="Time and delay parameters"));

  parameter Real sigDif(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=0.1
    "Significant difference based on minimum resolution of temperature sensor"
    annotation (Dialog(tab="Advanced"));

  parameter Real relFloDif(
    final unit="1",
    displayUnit="1")=0.05
    "Relative error to the flow setpoint for checking if it has been achieved"
    annotation (Evaluate=true,Dialog(tab="Advanced",enable=have_priOnl));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPlaEna
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-280,-140},{-240,-100}}),
      iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUpPro
    "Pulse indicating start of stage up process"
    annotation (Placement(transformation(extent={{-280,-20},{-240,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumChaPro if not
    have_priOnl
    "Pulse indicating all pump change processes have been completed and pumps have been proved on"
    annotation (Placement(transformation(extent={{-280,-210},{-240,-170}}),
      iconTransformation(extent={{-140,-240},{-100,-200}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiSet[nBoi]
    "Boiler status setpoint: true=ON"
    annotation (Placement(transformation(extent={{-280,20},{-240,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaChaPro
    "Signal indicating final completion of stage change processes"
    annotation (Placement(transformation(extent={{-280,-170},{-240,-130}}),
      iconTransformation(extent={{-140,-200},{-100,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatIsoVal[nBoi]
    if have_heaPriPum
    "Hot water isolation valve status;
    True: Detected open;
    False: Detected closed"
    annotation (Placement(transformation(extent={{-280,100},{-240,140}}),
      iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoi[nBoi]
    "Boiler status;
    True: Proven on;
    False: Proven off"
    annotation (Placement(transformation(extent={{-280,60},{-240,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaTyp[nSta]
    "Boiler plant stage type vector"
    annotation (Placement(transformation(extent={{-280,-60},{-240,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Boiler stage setpoint index"
    annotation (Placement(transformation(extent={{-280,-100},{-240,-60}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinHotWatSet_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    displayUnit="m3/s",
    final min=0) if have_priOnl
    "Minimum hot water flow rate setpoint"
    annotation (Placement(transformation(extent={{-280,180},{-240,220}}),
      iconTransformation(extent={{-140,160},{-100,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWat_flow(
    final min=0,
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    displayUnit="m3/s") if have_priOnl
    "Measured hot water flow rate through the minimum flow bypass valve"
    annotation (Placement(transformation(extent={{-280,220},{-240,260}}),
      iconTransformation(extent={{-140,200},{-100,240}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSupSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if not have_priOnl
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-280,140},{-240,180}}),
      iconTransformation(extent={{-140,120},{-100,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoi[nBoi]
    "Boiler enabling status"
    annotation (Placement(transformation(extent={{340,90},{380,130}}),
      iconTransformation(extent={{100,100},{140,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaChaPro
    "Pulse indicating end of stage change process"
    annotation (Placement(transformation(extent={{340,-20},{380,20}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumChaPro if not
    have_priOnl
    "Pulse indicating start of pump change process"
    annotation (Placement(transformation(extent={{340,-260},{380,-220}}),
      iconTransformation(extent={{100,-140},{140,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOnOff
    "Signal indicating whether stage change involves simultaneous turning on
    and turning off of boilers"
    annotation (Placement(transformation(extent={{340,-130},{380,-90}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHotWatIsoVal[nBoi]
    if have_heaPriPum
    "Boiler hot water isolation valve signal;
    True: Commanded open;
    False: Commanded closed"
    annotation (Placement(transformation(extent={{340,-90},{380,-50}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yNexEnaBoi
    "Boiler index of next boiler being enabled"
    annotation (Placement(transformation(extent={{340,-170},{380,-130}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLasDisBoi
    "Boiler index of last boiler enabled that will be disabled"
    annotation (Placement(transformation(extent={{340,-210},{380,-170}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Not not1[nBoi] if have_heaPriPum
    "Logical not"
    annotation (Placement(transformation(extent={{10,-170},{30,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2[nBoi] if have_heaPriPum
    "Pass true status if boiler enable and stabilization is not complete"
    annotation (Placement(transformation(extent={{210,-90},{230,-70}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.ResetMinBypass minBypRes(
    final delEna=delEnaMinFloSet,
    final relFloDif=relFloDif) if have_priOnl
    "Reset process for minimum flow bypass valve setpoint"
    annotation (Placement(transformation(extent={{-170,10},{-150,30}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.ResetHotWaterSupplyTemperature hotWatSupTemRes(
    final nSta=nSta,
    final delPro=delProSupTemSet,
    final TMinSupNonConBoi=TMinSupNonConBoi,
    final sigDif=sigDif) if not have_priOnl
    "Reset process for hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-170,-30},{-150,-10}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.NextBoiler nexBoi(
    final nBoi=nBoi)
    "Identify boiler indices to be turned on and off during the stage change process"
    annotation (Placement(transformation(extent={{-170,-70},{-150,-50}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.HWIsoVal enaHotWatIsoVal(
    final reqAct=true,
    final nBoi=nBoi) if have_heaPriPum
    "Open hot water isolation valve for boiler being enabled"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Check for completion of valve opening process and pump change process"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.EnableBoiler enaBoi(
    final nBoi=nBoi,
    final proOnTim=boiChaProOnTim)
    "Change boiler status as per stage change required"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.HWIsoVal disHotWatIsoVal1(
    final reqAct=false,
    final nBoi=nBoi) if have_heaPriPum
    "Close hot water valve for boiler being disabled"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));

  Buildings.Controls.OBC.CDL.Logical.And and3
    "Check for completion of valve closing process and pump change process"
    annotation (Placement(transformation(extent={{210,40},{230,60}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Latch to retain stage-up edge signal till the stage change process is completed"
    annotation (Placement(transformation(extent={{-222,-10},{-202,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=delBoiEna)
    "Time delay after boiler status has been changed"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat3 if not have_priOnl
    "Hold process completion signal after pump enable process"
    annotation (Placement(transformation(extent={{-180,-200},{-160,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat4 if not have_priOnl
    "Hold process completion signal after pump disable process"
    annotation (Placement(transformation(extent={{160,-200},{180,-180}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 if not have_priOnl
    "Check for pump disable completion after start of pump disable process"
    annotation (Placement(transformation(extent={{132,-200},{152,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Detect change in process completion status and send out pulse signal"
    annotation (Placement(transformation(extent={{310,-10},{330,10}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1 if not have_priOnl
    "Generate pulse to signal start of pump change process"
    annotation (Placement(transformation(extent={{-90,-250},{-70,-230}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg2 if not have_priOnl
    "Generate pulse to signal start of pump change process"
    annotation (Placement(transformation(extent={{170,-240},{190,-220}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2 if not have_priOnl
    "Check for pump change proces start signal"
    annotation (Placement(transformation(extent={{210,-250},{230,-230}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat5 if not have_heaPriPum
    "Latch to short valve opening process in dedicated pump configuration plants"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat6 if not have_heaPriPum
    "Latch to short valve closing process in dedicated pump configuration plants"
    annotation (Placement(transformation(extent={{150,30},{170,50}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nBoi) if have_heaPriPum
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-32,-150},{-12,-130}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nBoi) if have_heaPriPum
    "Boolean replicator"
    annotation (Placement(transformation(extent={{150,-90},{170,-70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=delPreBoiEna)
    "Time delay after valve has been opened and pump status has been changed"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1 if have_heaPriPum
    "Hold process completion signal after valve has been opened"
    annotation (Placement(transformation(extent={{-32,-120},{-12,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) if have_priOnl
    "Boolean True signal for primary-only systems that don't require a pump change
    process completion signal"
    annotation (Placement(transformation(extent={{-180,-160},{-160,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Pass signal when plant is enabled or when stage-up process is initiated"
    annotation (Placement(transformation(extent={{-130,-130},{-110,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Hold status when plant enable is detected"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 if not have_priOnl
    "Signal pump change if a boiler has been disabled"
    annotation (Placement(transformation(extent={{140,-240},{160,-220}})));

  Buildings.Controls.OBC.CDL.Logical.And and5[nBoi] if have_heaPriPum
    "Pass valve position signal from valve open block during and after opening
    process is initiated"
    annotation (Placement(transformation(extent={{10,-100},{30,-80}})));

  Buildings.Controls.OBC.CDL.Logical.And and6[nBoi] if have_heaPriPum
    "Pass original valve position signal before valve opening process is initiated"
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3[nBoi] if have_heaPriPum
    "Pass valve position signal before and after valve opening process"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));

  Buildings.Controls.OBC.CDL.Logical.And and7[nBoi] if have_heaPriPum
    "Pass valve position signals from valve closing block once boiler operation
    is stabilized"
    annotation (Placement(transformation(extent={{250,-60},{270,-40}})));

  Buildings.Controls.OBC.CDL.Logical.And and8[nBoi] if have_heaPriPum
    "Pass valve position signals from valve opening block before boiler is enabled
    and stabilized"
    annotation (Placement(transformation(extent={{250,-90},{270,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Or or4[nBoi] if have_heaPriPum
    "Pass final valve position signals during various stage change process steps"
    annotation (Placement(transformation(extent={{300,-80},{320,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Or or5
    "Pass signal when plant is enabled or when stage-up process is initiated"
    annotation (Placement(transformation(extent={{-132,8},{-112,28}})));

  Buildings.Controls.OBC.CDL.Logical.Or or6
    "Pass final stage change process completion signal"
    annotation (Placement(transformation(extent={{280,-10},{300,10}})));

  Buildings.Controls.OBC.CDL.Logical.And and9
    "Signal stage change completion only after completion of valve closing process
    and pump change process, if the stage change involves simultaneous enable-disable
    of boilers"
    annotation (Placement(transformation(extent={{250,20},{270,40}})));

  Buildings.Controls.OBC.CDL.Logical.And and10
    "Signal stage change completion after boiler is enabled, if no boilers are
    simulatenously enabled-disabled"
    annotation (Placement(transformation(extent={{250,-30},{270,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical not"
    annotation (Placement(transformation(extent={{210,-20},{230,0}})));

  Buildings.Controls.OBC.CDL.Logical.And and11
    "Ensures stage change process completion signal is only sent out during stage-up
    process, and not whenever any simultaneous enable-disable is detected"
    annotation (Placement(transformation(extent={{212,10},{232,30}})));

equation
  connect(nexBoi.yNexEnaBoi, enaHotWatIsoVal.nexChaBoi) annotation (Line(points={{-148,
          -51},{-90,-51},{-90,8},{-72,8}},       color={255,127,0}));

  connect(lat.y, minBypRes.uUpsDevSta) annotation (Line(points={{-200,0},{-196,
          0},{-196,28},{-172,28}},
                                color={255,0,255}));

  connect(lat.y, minBypRes.chaPro) annotation (Line(points={{-200,0},{-196,0},{
          -196,24},{-172,24}},
                          color={255,0,255}));

  connect(lat.y, hotWatSupTemRes.uStaUp) annotation (Line(points={{-200,0},{
          -196,0},{-196,-13},{-172,-13}},
                                     color={255,0,255}));

  connect(enaBoi.yBoiEnaPro, truDel.u) annotation (Line(points={{82,-8},{90,-8},
          {90,0},{98,0}}, color={255,0,255}));

  connect(truDel.y,disHotWatIsoVal1. uUpsDevSta) annotation (Line(points={{122,0},
          {126,0},{126,-5},{148,-5}}, color={255,0,255}));

  connect(nexBoi.yDisSmaBoi,disHotWatIsoVal1. nexChaBoi) annotation (Line(
        points={{-148,-56},{140,-56},{140,8},{148,8}}, color={255,127,0}));

  connect(nexBoi.yOnOff,disHotWatIsoVal1. chaPro) annotation (Line(points={{-148,
          -60},{144,-60},{144,-8},{148,-8}}, color={255,0,255}));

  connect(nexBoi.yOnOff, enaBoi.uOnOff) annotation (Line(points={{-148,-60},{42,
          -60},{42,-6},{58,-6}}, color={255,0,255}));

  connect(nexBoi.yDisSmaBoi, enaBoi.nexDisBoi) annotation (Line(points={{-148,
          -56},{46,-56},{46,-9},{58,-9}},
                                     color={255,127,0}));

  connect(nexBoi.yNexEnaBoi, enaBoi.nexEnaBoi) annotation (Line(points={{-148,
          -51},{-90,-51},{-90,-40},{38,-40},{38,9},{58,9}},
                                                       color={255,127,0}));

  connect(VHotWat_flow, minBypRes.VHotWat_flow) annotation (Line(points={{-260,
          240},{-176,240},{-176,16},{-172,16}},
                                           color={0,0,127}));

  connect(VMinHotWatSet_flow, minBypRes.VMinHotWatSet_flow) annotation (Line(
        points={{-260,200},{-180,200},{-180,12},{-172,12}}, color={0,0,127}));

  connect(THotWatSupSet, hotWatSupTemRes.THotWatSup) annotation (Line(points={{-260,
          160},{-186,160},{-186,-17},{-172,-17}}, color={0,0,127}));

  connect(nexBoi.uBoiSet, uBoiSet) annotation (Line(points={{-172,-60},{-190,
          -60},{-190,40},{-260,40}}, color={255,0,255}));

  connect(uStaSet, nexBoi.uStaSet) annotation (Line(points={{-260,-80},{-234,
          -80},{-234,-53},{-172,-53}}, color={255,127,0}));

  connect(uStaSet, hotWatSupTemRes.uStaSet) annotation (Line(points={{-260,-80},
          {-234,-80},{-234,-27},{-172,-27}}, color={255,127,0}));

  connect(uStaTyp, hotWatSupTemRes.uStaTyp) annotation (Line(points={{-260,-40},
          {-186,-40},{-186,-23},{-172,-23}}, color={255,127,0}));

  connect(uStaUpPro, lat.u)
    annotation (Line(points={{-260,0},{-224,0}}, color={255,0,255}));

  connect(lat3.y, and1.u2) annotation (Line(points={{-158,-190},{-48,-190},{-48,
          -30},{-10,-30},{-10,-8},{-2,-8}}, color={255,0,255}));

  connect(uPumChaPro, lat3.u)
    annotation (Line(points={{-260,-190},{-182,-190}}, color={255,0,255}));

  connect(and4.y, lat4.u)
    annotation (Line(points={{154,-190},{158,-190}}, color={255,0,255}));

  connect(truDel.y, and4.u1) annotation (Line(points={{122,0},{126,0},{126,-190},
          {130,-190}}, color={255,0,255}));

  connect(uPumChaPro, and4.u2) annotation (Line(points={{-260,-190},{-200,-190},
          {-200,-210},{120,-210},{120,-198},{130,-198}}, color={255,0,255}));

  connect(lat4.y, and3.u2) annotation (Line(points={{182,-190},{204,-190},{204,42},
          {208,42}},     color={255,0,255}));

  connect(edg.y, yStaChaPro)
    annotation (Line(points={{332,0},{360,0}},   color={255,0,255}));

  connect(edg2.y, or2.u1) annotation (Line(points={{192,-230},{200,-230},{200,-240},
          {208,-240}},       color={255,0,255}));

  connect(edg1.y, or2.u2) annotation (Line(points={{-68,-240},{66,-240},{66,-248},
          {208,-248}},       color={255,0,255}));

  connect(enaBoi.yBoi, yBoi) annotation (Line(points={{82,8},{92,8},{92,110},{
          360,110}}, color={255,0,255}));

  connect(or2.y, yPumChaPro)
    annotation (Line(points={{232,-240},{360,-240}}, color={255,0,255}));

  connect(nexBoi.yOnOff, yOnOff) annotation (Line(points={{-148,-60},{190,-60},
          {190,-110},{360,-110}}, color={255,0,255}));

  connect(nexBoi.yNexEnaBoi, yNexEnaBoi) annotation (Line(points={{-148,-51},{-90,
          -51},{-90,-40},{148,-40},{148,-150},{360,-150}},
                                           color={255,127,0}));

  connect(lat5.y, and1.u1) annotation (Line(points={{-48,40},{-6,40},{-6,0},{-2,
          0}}, color={255,0,255}));

  connect(truDel.y, lat6.u) annotation (Line(points={{122,0},{126,0},{126,40},{148,
          40}}, color={255,0,255}));

  connect(lat6.y, and3.u1) annotation (Line(points={{172,40},{200,40},{200,50},{
          208,50}},
               color={255,0,255}));

  connect(truDel.y, booRep1.u) annotation (Line(points={{122,0},{128,0},{128,-80},
          {148,-80}},                           color={255,0,255}));

  connect(and1.y, truDel1.u) annotation (Line(points={{22,0},{28,0},{28,60},{
          -10,60},{-10,100},{-2,100}},
                                   color={255,0,255}));

  connect(truDel1.y, enaBoi.uUpsDevSta) annotation (Line(points={{22,100},{42,100},
          {42,2},{58,2}}, color={255,0,255}));

  connect(disHotWatIsoVal1.yEnaHotWatIsoVal, and3.u1) annotation (Line(points={{172,6},
          {188,6},{188,40},{200,40},{200,50},{208,50}},
                                           color={255,0,255}));

  connect(enaHotWatIsoVal.yEnaHotWatIsoVal, lat1.u) annotation (Line(points={{
          -48,6},{-40,6},{-40,-110},{-34,-110}}, color={255,0,255}));

  connect(lat1.y, and1.u1) annotation (Line(points={{-10,-110},{-6,-110},{-6,0},
          {-2,0}}, color={255,0,255}));

  connect(con.y, and1.u2) annotation (Line(points={{-158,-150},{-48,-150},{-48,-30},
          {-10,-30},{-10,-8},{-2,-8}}, color={255,0,255}));
  connect(con.y, and3.u2) annotation (Line(points={{-158,-150},{-48,-150},{-48,-30},
          {-10,-30},{-10,26},{204,26},{204,42},{208,42}},      color={255,0,255}));
  connect(lat2.y, or1.u1)
    annotation (Line(points={{-158,-120},{-132,-120}}, color={255,0,255}));
  connect(minBypRes.yMinBypRes, or1.u2) annotation (Line(points={{-148,20},{-146,
          20},{-146,-128},{-132,-128}}, color={255,0,255}));
  connect(hotWatSupTemRes.yHotWatSupTemRes, or1.u2) annotation (Line(points={{-148,
          -20},{-146,-20},{-146,-128},{-132,-128}}, color={255,0,255}));
  connect(or1.y, lat5.u) annotation (Line(points={{-108,-120},{-104,-120},{-104,
          40},{-72,40}}, color={255,0,255}));
  connect(or1.y, booRep.u) annotation (Line(points={{-108,-120},{-44,-120},{-44,
          -140},{-34,-140}},color={255,0,255}));
  connect(or1.y, enaHotWatIsoVal.uUpsDevSta) annotation (Line(points={{-108,-120},
          {-104,-120},{-104,-5},{-72,-5}}, color={255,0,255}));
  connect(nexBoi.yDisSmaBoi, yLasDisBoi) annotation (Line(points={{-148,-56},{136,
          -56},{136,-164},{328,-164},{328,-190},{360,-190}}, color={255,127,0}));
  connect(uStaChaPro, lat.clr) annotation (Line(points={{-260,-150},{-228,-150},
          {-228,-6},{-224,-6}}, color={255,0,255}));
  connect(uStaChaPro, lat2.clr) annotation (Line(points={{-260,-150},{-190,-150},
          {-190,-126},{-182,-126}}, color={255,0,255}));
  connect(uStaChaPro, lat3.clr) annotation (Line(points={{-260,-150},{-190,-150},
          {-190,-196},{-182,-196}}, color={255,0,255}));
  connect(uStaChaPro, lat5.clr) annotation (Line(points={{-260,-150},{-190,-150},
          {-190,-100},{-98,-100},{-98,34},{-72,34}}, color={255,0,255}));
  connect(uStaChaPro, lat6.clr) annotation (Line(points={{-260,-150},{-190,-150},
          {-190,-100},{-98,-100},{-98,70},{132,70},{132,34},{148,34}}, color={
          255,0,255}));
  connect(uStaChaPro, lat1.clr) annotation (Line(points={{-260,-150},{-190,-150},
          {-190,-100},{-98,-100},{-98,-116},{-34,-116}}, color={255,0,255}));
  connect(uStaChaPro, lat4.clr) annotation (Line(points={{-260,-150},{-190,-150},
          {-190,-100},{-98,-100},{-98,70},{132,70},{132,-168},{156,-168},{156,
          -196},{158,-196}}, color={255,0,255}));
  connect(and2.y, edg2.u)
    annotation (Line(points={{162,-230},{168,-230}}, color={255,0,255}));
  connect(truDel.y, and2.u1) annotation (Line(points={{122,0},{126,0},{126,-230},
          {138,-230}}, color={255,0,255}));
  connect(nexBoi.yOnOff, and2.u2) annotation (Line(points={{-148,-60},{-54,-60},
          {-54,-238},{138,-238}}, color={255,0,255}));
  connect(or1.y, edg1.u) annotation (Line(points={{-108,-120},{-104,-120},{-104,
          -240},{-92,-240}}, color={255,0,255}));
  connect(uPlaEna, lat2.u)
    annotation (Line(points={{-260,-120},{-182,-120}}, color={255,0,255}));
  connect(uHotWatIsoVal, enaHotWatIsoVal.uHotWatIsoVal) annotation (Line(points
        ={{-260,120},{-80,120},{-80,5},{-72,5}}, color={255,0,255}));
  connect(uHotWatIsoVal, disHotWatIsoVal1.uHotWatIsoVal) annotation (Line(
        points={{-260,120},{136,120},{136,5},{148,5}}, color={255,0,255}));
  connect(booRep.y, not1.u) annotation (Line(points={{-10,-140},{0,-140},{0,
          -160},{8,-160}}, color={255,0,255}));
  connect(booRep.y, and5.u2) annotation (Line(points={{-10,-140},{0,-140},{0,
          -98},{8,-98}}, color={255,0,255}));
  connect(enaHotWatIsoVal.yHotWatIsoVal, and5.u1) annotation (Line(points={{-48,
          -6},{-48,-20},{0,-20},{0,-90},{8,-90}}, color={255,0,255}));
  connect(not1.y, and6.u2) annotation (Line(points={{32,-160},{48,-160},{48,
          -148},{58,-148}}, color={255,0,255}));
  connect(uHotWatIsoVal, and6.u1) annotation (Line(points={{-260,120},{34,120},
          {34,-140},{58,-140}}, color={255,0,255}));
  connect(and5.y, or3.u1) annotation (Line(points={{32,-90},{32,-92},{96,-92},{96,
          -100},{98,-100}},    color={255,0,255}));
  connect(and6.y, or3.u2) annotation (Line(points={{82,-140},{96,-140},{96,-108},
          {98,-108}},                     color={255,0,255}));
  connect(disHotWatIsoVal1.yHotWatIsoVal, and7.u1) annotation (Line(points={{172,-6},
          {180,-6},{180,-50},{248,-50}},         color={255,0,255}));
  connect(booRep1.y, and7.u2) annotation (Line(points={{172,-80},{200,-80},{200,
          -58},{248,-58}}, color={255,0,255}));
  connect(booRep1.y, not2.u) annotation (Line(points={{172,-80},{208,-80}},
                           color={255,0,255}));
  connect(and8.y, or4.u2) annotation (Line(points={{272,-80},{272,-78},{298,-78}},
                      color={255,0,255}));
  connect(and7.y, or4.u1)
    annotation (Line(points={{272,-50},{272,-52},{288,-52},{288,-70},{298,-70}},
                                                   color={255,0,255}));
  connect(or4.y, yHotWatIsoVal) annotation (Line(points={{322,-70},{360,-70}},
                               color={255,0,255}));
  connect(uStaChaPro,nexBoi.uStaChaPro)  annotation (Line(points={{-260,-150},{-228,
          -150},{-228,-68},{-172,-68},{-172,-67}}, color={255,0,255}));
  connect(uBoi, enaBoi.uBoi) annotation (Line(points={{-260,80},{48,80},{48,-2},
          {58,-2}}, color={255,0,255}));
  connect(or5.y, enaHotWatIsoVal.chaPro) annotation (Line(points={{-110,18},{-88,
          18},{-88,-8},{-72,-8}}, color={255,0,255}));
  connect(or5.y, enaBoi.uStaUp) annotation (Line(points={{-110,18},{52,18},{52,6},
          {58,6}}, color={255,0,255}));
  connect(lat.y, or5.u1) annotation (Line(points={{-200,0},{-196,0},{-196,24},{-184,
          24},{-184,40},{-134,40},{-134,18}}, color={255,0,255}));
  connect(lat2.y, or5.u2) annotation (Line(points={{-158,-120},{-152,-120},{-152,
          -80},{-180,-80},{-180,-40},{-144,-40},{-144,-24},{-140,-24},{-140,4},{
          -144,4},{-144,10},{-134,10}}, color={255,0,255}));
  connect(and8.u1, not2.y)
    annotation (Line(points={{248,-80},{232,-80}}, color={255,0,255}));
  connect(or3.y, and8.u2) annotation (Line(points={{122,-100},{240,-100},{240,-88},
          {248,-88}}, color={255,0,255}));
  connect(or6.y, edg.u)
    annotation (Line(points={{302,0},{308,0}}, color={255,0,255}));
  connect(and9.y, or6.u1) annotation (Line(points={{272,30},{274,30},{274,0},{278,
          0}}, color={255,0,255}));
  connect(enaBoi.yBoiEnaPro, and10.u2) annotation (Line(points={{82,-8},{90,-8},
          {90,-26},{236,-26},{236,-28},{248,-28}}, color={255,0,255}));
  connect(and10.u1, not3.y) annotation (Line(points={{248,-20},{236,-20},{236,-10},
          {232,-10}}, color={255,0,255}));
  connect(nexBoi.yOnOff, not3.u) annotation (Line(points={{-148,-60},{190,-60},
          {190,-10},{208,-10}},color={255,0,255}));
  connect(and10.y, or6.u2) annotation (Line(points={{272,-20},{274,-20},{274,-8},
          {278,-8}}, color={255,0,255}));
  connect(and3.y, and9.u1) annotation (Line(points={{232,50},{240,50},{240,30},{
          248,30}},  color={255,0,255}));
  connect(nexBoi.yOnOff, and11.u1) annotation (Line(points={{-148,-60},{190,-60},
          {190,20},{210,20}}, color={255,0,255}));
  connect(and11.y, and9.u2) annotation (Line(points={{234,20},{240,20},{240,22},
          {248,22}}, color={255,0,255}));
  connect(lat.y, and11.u2) annotation (Line(points={{-200,0},{-196,0},{-196,84},
          {196,84},{196,12},{210,12}}, color={255,0,255}));
annotation (
  defaultComponentName="upProCon",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-240,-260},{340,260}})),
    Icon(coordinateSystem(extent={{-100,-200},{100,200}}), graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,260},{120,200}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-10,120},{10,-140}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,160},{-40,120},{0,120},{40,120},{0,160}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>
Block that controls boiler status and isolation valve position, initiates status
change in devices like pumps and minimum flow bypass valve, and resets plant
parameters like hot water supply temperature setpoint and minimum flow setpoint
when there is a stage-up command.
This development is based on ASHRAE Guideline 36, 2021, sections 5.21.3.11 - 5.21.3.18,
which specify the step-by-step control of devices during boiler staging up process.
</p>
<ol>
<li>
Identify the boiler(s) that should be enabled (and disabled). This is implemented in block <code>nexBoi</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.NextBoiler\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.NextBoiler</a>
for more decriptions.
</li>
<li>
Initiate the process to reset the minimum hot water flow setpoint for the minimum
flow bypass valve,
<ul>
<li>
For any stage change during which a smaller boiler is disabled and a larger boiler
is enabled, slowly change the minimum hot water flow 
setpoint to the one that includes both boilers being enabled. After new setpoint is 
achieved, wait <code>delEnaMinFloSet</code> to allow loop to stabilize.
</li>
<li>
For any other stage change, reset the minimum hot water flow setpoint to the one
that includes the new boiler. After new setpoint is 
achieved, wait <code>delEnaMinFloSet</code> to allow loop to stabilize.
</li>
</ul>
The minimum flow setpoint is reset in sequence
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.MinimumFlowBypass.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.MinimumFlowBypass.Subsequences.FlowSetpoint</a>).
Block <code>minBypRes</code> checks if the new setpoint is achieved
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.ResetMinBypass\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.ResetMinBypass</a>).
</li>
<li>
Start the next hot water pump and/or open the hot water isolation valves using the
block <code>enaHotWatIsoVal</code> using sequence implemented in <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.HWIsoVal\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.HWIsoVal</a>
for the valves and initiating the pump change process with the pulse signal <code>yPumChaPro</code>. 
Once the pumps have been reset, the controller receives a pulse signal on the
input <code>uPumChaPro</code>.
</li>
<li>
After waiting for time <code>delPreBoiEna</code>, the boiler status <code>yBoi</code> 
is changed using the boiler status controller <code>enaBoi</code> implemented in the sequence
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.EnableBoiler\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.EnableBoiler</a>.
</li>
<li>
If the stage up process does not involve turning off a smaller boiler, end the
staging up process by sending a pulse signal through <code>yStaChaPro</code>. Otherwise,
<ul>
<li>
Wait for time <code>delBoiEna</code> before closing the isolation valve for the
disabled boiler and initiating the pump change process.
</li>
<li>
End the staging process after the valve has been closed and the pump change process
completion signal has been received. Send pulse signal through <code>yStaChaPro</code>
to indicate the same.
</li>
</ul>
</ol>
</html>", revisions="<html>
<ul>
<li>
July 20, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Up;
