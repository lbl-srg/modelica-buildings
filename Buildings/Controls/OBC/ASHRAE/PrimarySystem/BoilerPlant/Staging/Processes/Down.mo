within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes;
block Down
    "Sequence for control devices when there is stage-down command"

  parameter Boolean have_priOnl = false
    "True: The boiler plant is primary-only"
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

  parameter Real delEnaMinFloSet(
    final unit="s",
    displayUnit="s",
    final quantity="time")=60
    "Time delay after minimum flow setpoint is achieved in bypass valve"
    annotation (Evaluate=true,
      Dialog(group="Time and delay parameters",
        enable=have_priOnl));

  parameter Real chaIsoValTim(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 60
    "Time period to slowly change isolation valve position; Should be determined
    in the field"
    annotation (Evaluate=true,
      Dialog(group="Time and delay parameters",
        enable=have_heaPriPum));

  parameter Real delPreBoiEna(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 30
    "Time delay after valve position change and pump stage change process has been
    completed before starting boiler stage change process"
    annotation (Dialog(group="Time and delay parameters"));

  parameter Real boiChaProOnTim(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Minimum time period threshold for uninterrupted proven on signal from newly
    enabled boiler during a staging process where one boiler is turned on and
    another is turned off"
    annotation (Dialog(group="Time and delay parameters"));

  parameter Real delBoiEna(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 180
    "Time delay after boiler status change process has been completed before turning
    off excess isolation valves and pumps"
    annotation (Dialog(group="Time and delay parameters"));

  parameter Real relFloDif(
    final unit="1",
    displayUnit="1")=0.05
    "Relative error to the flow setpoint for checking if it has been achieved"
    annotation (Evaluate=true,
      Dialog(tab="Advanced",
        enable=have_priOnl));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDowPro
    "Rising edge indicating start of stage up process"
    annotation (Placement(
        transformation(extent={{-280,-20},{-240,20}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoi[nBoi]
    "Boiler proven on status vector"
    annotation (Placement(transformation(extent={{-280,60},{-240,100}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaChaPro
    "Signal indicating final completion of stage change process" annotation (
      Placement(transformation(extent={{-280,-150},{-240,-110}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumChaPro if not have_priOnl
    "Rising edge indicating all pump change processes have been completed and pumps have been proved on"
    annotation (Placement(transformation(extent={{-280,-210},{-240,-170}}),
      iconTransformation(extent={{-140,-200},{-100,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiSet[nBoi]
    "Boiler status setpoint vector from staging setpoint controller"
    annotation (Placement(transformation(extent={{-280,20},{-240,60}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Boiler stage setpoint index from staging setpoint controller"
    annotation (Placement(transformation(extent={{-280,-100},{-240,-60}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinHotWatSet_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    displayUnit="m3/s",
    final min=0) if have_priOnl
    "Minimum hot water flow rate setpoint"
    annotation (Placement(transformation(extent={{-280,180},{-240,220}}),
      iconTransformation(extent={{-140,120},{-100,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWat_flow(
    final min=0,
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    displayUnit="m3/s") if have_priOnl
    "Measured hot water flow rate through the minimum flow bypass valve"
    annotation (Placement(transformation(extent={{-280,220},{-240,260}}),
      iconTransformation(extent={{-140,160},{-100,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotWatIsoVal[nBoi](
    final min=fill(0, nBoi),
    final max=fill(1, nBoi),
    final unit=fill("1", nBoi)) if have_heaPriPum
    "Boiler hot water isolation valve position vector, indexed according to their
    respective boilers"
    annotation (Placement(transformation(extent={{-280,100},{-240,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoi[nBoi]
    "Boiler enable status vector"
    annotation (Placement(transformation(extent={{280,90},{320,130}}),
      iconTransformation(extent={{100,100},{140,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaChaPro
    "Rising edge indicating end of stage change process"
    annotation (Placement(transformation(extent={{280,30},{320,70}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumChaPro if not
    have_priOnl
    "Rising edge indicating start of pump change process"
    annotation (Placement(transformation(extent={{280,-260},{320,-220}}),
      iconTransformation(extent={{100,-140},{140,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOnOff
    "Signal indicating whether stage change involves simultaneous turning on
    and turning off of boilers"
    annotation (Placement(transformation(extent={{280,-130},{320,-90}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yNexEnaBoi
    "Boiler index of next boiler being enabled"
    annotation (Placement(transformation(extent={{280,-170},{320,-130}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLasDisBoi
    "Boiler index of last boiler enabled that will be disabled"
    annotation (Placement(transformation(extent={{280,-210},{320,-170}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatIsoVal[nBoi](
    final min=fill(0, nBoi),
    final max=fill(1, nBoi),
    final unit=fill("1", nBoi)) if have_heaPriPum
    "Boiler hot water isolation valve position vector, indexed according to their
    respective boilers"
    annotation (Placement(transformation(extent={{280,-90},{320,-50}}),
      iconTransformation(extent={{100,20},{140,60}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.ResetMinBypass minBypRes(
    final delEna=delEnaMinFloSet,
    final relFloDif=relFloDif) if have_priOnl
    "Reset process for minimum flow bypass valve setpoint"
    annotation (Placement(transformation(extent={{-170,10},{-150,30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.NextBoiler nexBoi(
    final nBoi=nBoi)
    "Identify boiler indices to be turned on and off during the stage change process"
    annotation (Placement(transformation(extent={{-170,-76},{-150,-56}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.HWIsoVal enaHotWatIsoVal(
    final nBoi=nBoi,
    final chaHotWatIsoTim=chaIsoValTim,
    final iniValPos=0,
    final endValPos=1) if have_heaPriPum
    "Open hot water isolation valve for boiler being enabled"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Check for completion of valve opening process and pump stage change process"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.DisableBoiler disBoi(
    final nBoi=nBoi,
    final proOnTim=boiChaProOnTim)
    "Diable boiler status in boiler status vector as per required stage change"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.HWIsoVal disHotWatIsoVal1(
    final nBoi=nBoi,
    final chaHotWatIsoTim=chaIsoValTim,
    final iniValPos=1,
    final endValPos=0) if have_heaPriPum
    "Close hot water valve for boiler being disabled"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));

  Buildings.Controls.OBC.CDL.Logical.And and3
    "Check for completion of valve closing process and pump change process"
    annotation (Placement(transformation(extent={{190,-10},{210,10}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Latch to retain stage-up edge signal till the stage change process is completed"
    annotation (Placement(transformation(extent={{-222,-10},{-202,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=delBoiEna)
    "Time delay after boiler status has been changed"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat3 if not have_priOnl
    "Hold process completion signal after pump enable process"
    annotation (Placement(transformation(extent={{-140,-200},{-120,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat4 if not have_priOnl
    "Hold process completion signal after pump disable process"
    annotation (Placement(transformation(extent={{160,-200},{180,-180}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 if not have_priOnl
    "Check for pump disable completion after start of pump disable process"
    annotation (Placement(transformation(extent={{132,-200},{152,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Detect change in process completion status and send out pulse signal"
    annotation (Placement(transformation(extent={{230,40},{250,60}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1 if not have_priOnl
    "Generate pulse to signal start of pump change process"
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg2 if not have_priOnl
    "Generate pulse to signal start of pump change process"
    annotation (Placement(transformation(extent={{140,-246},{160,-226}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2 if not have_priOnl
    "Check for pump change proces start signal"
    annotation (Placement(transformation(extent={{210,-250},{230,-230}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat5 if not have_heaPriPum
    "Latch to short valve opening process in dedicated pump configuration plants"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat6 if not have_heaPriPum
    "Latch to short valve closing process in dedicated pump configuration plants"
    annotation (Placement(transformation(extent={{150,30},{170,50}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi[nBoi] if have_heaPriPum
    "Pass valve position signal from valve opening controller once the opening process starts"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nBoi) if have_heaPriPum
    "Boolean replicator"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nBoi] if have_heaPriPum
    "Pass valve position signal from valve closing controller once the closing process starts"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nBoi) if have_heaPriPum
    "Boolean replicator"
    annotation (Placement(transformation(extent={{70,-160},{90,-140}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=delPreBoiEna)
    "Time delay after valve has been opened and pump status has been changed"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Pass process completion signal based on whether stage change involves turning off larger boiler or not"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1 if have_heaPriPum
    "Hold process completion signal after valve has been opened"
    annotation (Placement(transformation(extent={{-32,-120},{-12,-100}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=1) if not have_priOnl
    "Pass enable signal for plants that are not primary-only"
    annotation (Placement(transformation(extent={{-170,50},{-150,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) if have_priOnl
    "Boolean True signal"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 if not have_priOnl
    "Logical And"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));

equation
  connect(lat.y, minBypRes.uUpsDevSta) annotation (Line(points={{-200,0},{-196,
          0},{-196,28},{-172,28}},
                                color={255,0,255}));

  connect(lat.y, nexBoi.chaPro) annotation (Line(points={{-200,0},{-196,0},{-196,
          -73},{-172,-73}}, color={255,0,255}));

  connect(truDel.y,disHotWatIsoVal1. uUpsDevSta) annotation (Line(points={{122,0},
          {126,0},{126,-5},{148,-5}}, color={255,0,255}));

  connect(VHotWat_flow, minBypRes.VHotWat_flow) annotation (Line(points={{-260,
          240},{-176,240},{-176,16},{-172,16}},
                                           color={0,0,127}));

  connect(VMinHotWatSet_flow, minBypRes.VMinHotWatSet_flow) annotation (Line(
        points={{-260,200},{-180,200},{-180,12},{-172,12}}, color={0,0,127}));

  connect(uHotWatIsoVal, enaHotWatIsoVal.uHotWatIsoVal) annotation (Line(points={{-260,
          120},{-80,120},{-80,5},{-72,5}},       color={0,0,127}));

  connect(nexBoi.uBoiSet, uBoiSet) annotation (Line(points={{-172,-66},{-190,-66},
          {-190,40},{-260,40}},      color={255,0,255}));

  connect(uStaSet, nexBoi.uStaSet) annotation (Line(points={{-260,-80},{-234,-80},
          {-234,-59},{-172,-59}},      color={255,127,0}));

  connect(uStaDowPro, lat.u)
    annotation (Line(points={{-260,0},{-224,0}}, color={255,0,255}));

  connect(lat3.y, and1.u2) annotation (Line(points={{-118,-190},{-48,-190},{-48,
          -26},{-10,-26},{-10,-8},{-2,-8}}, color={255,0,255}));

  connect(uPumChaPro, lat3.u)
    annotation (Line(points={{-260,-190},{-142,-190}}, color={255,0,255}));

  connect(and4.y, lat4.u)
    annotation (Line(points={{154,-190},{158,-190}}, color={255,0,255}));

  connect(truDel.y, and4.u1) annotation (Line(points={{122,0},{126,0},{126,-190},
          {130,-190}}, color={255,0,255}));

  connect(uPumChaPro, and4.u2) annotation (Line(points={{-260,-190},{-160,-190},
          {-160,-210},{120,-210},{120,-198},{130,-198}}, color={255,0,255}));

  connect(lat4.y, and3.u2) annotation (Line(points={{182,-190},{184,-190},{184,
          -8},{188,-8}}, color={255,0,255}));

  connect(edg.y, yStaChaPro)
    annotation (Line(points={{252,50},{300,50}}, color={255,0,255}));

  connect(edg2.y, or2.u1) annotation (Line(points={{162,-236},{200,-236},{200,
          -240},{208,-240}}, color={255,0,255}));

  connect(edg1.y, or2.u2) annotation (Line(points={{-18,-240},{66,-240},{66,-248},
          {208,-248}},       color={255,0,255}));

  connect(or2.y, yPumChaPro)
    annotation (Line(points={{232,-240},{300,-240}}, color={255,0,255}));

  connect(nexBoi.yOnOff, yOnOff) annotation (Line(points={{-148,-66},{144,-66},{
          144,-110},{300,-110}},  color={255,0,255}));

  connect(truDel.y, edg2.u) annotation (Line(points={{122,0},{126,0},{126,-236},
          {138,-236}}, color={255,0,255}));

  connect(minBypRes.yMinBypRes, lat5.u) annotation (Line(points={{-148,20},{
          -110,20},{-110,40},{-72,40}},
                                   color={255,0,255}));

  connect(lat5.y, and1.u1) annotation (Line(points={{-48,40},{-6,40},{-6,0},{-2,
          0}}, color={255,0,255}));

  connect(truDel.y, lat6.u) annotation (Line(points={{122,0},{126,0},{126,40},{148,
          40}}, color={255,0,255}));

  connect(lat6.y, and3.u1) annotation (Line(points={{172,40},{180,40},{180,0},{188,
          0}}, color={255,0,255}));

  connect(enaHotWatIsoVal.yHotWatIsoVal, swi.u1) annotation (Line(points={{-48,
          -6},{-30,-6},{-30,-90},{26,-90},{26,-122},{38,-122}}, color={0,0,127}));

  connect(uHotWatIsoVal, swi.u3) annotation (Line(points={{-260,120},{30,120},{
          30,-138},{38,-138}}, color={0,0,127}));

  connect(booRep.y, swi.u2)
    annotation (Line(points={{22,-130},{38,-130}}, color={255,0,255}));

  connect(swi.y, swi1.u3) annotation (Line(points={{62,-130},{92,-130},{92,-118},
          {98,-118}}, color={0,0,127}));

  connect(disHotWatIsoVal1.yHotWatIsoVal, swi1.u1) annotation (Line(points={{
          172,-6},{180,-6},{180,-70},{92,-70},{92,-102},{98,-102}}, color={0,0,
          127}));

  connect(truDel.y, booRep1.u) annotation (Line(points={{122,0},{126,0},{126,-166},
          {60,-166},{60,-150},{68,-150}},       color={255,0,255}));

  connect(booRep1.y, swi1.u2) annotation (Line(points={{92,-150},{96,-150},{96,
          -110},{98,-110}}, color={255,0,255}));

  connect(swi1.y, yHotWatIsoVal) annotation (Line(points={{122,-110},{134,-110},
          {134,-90},{210,-90},{210,-70},{300,-70}}, color={0,0,127}));

  connect(and1.y, truDel1.u) annotation (Line(points={{22,0},{28,0},{28,60},{
          -10,60},{-10,100},{-2,100}},
                                   color={255,0,255}));

  connect(disHotWatIsoVal1.yEnaHotWatIsoVal, and3.u1) annotation (Line(points={{
          172,6},{180,6},{180,0},{188,0}}, color={255,0,255}));

  connect(minBypRes.yMinBypRes, booRep.u) annotation (Line(points={{-148,20},{
          -110,20},{-110,-130},{-2,-130}}, color={255,0,255}));

  connect(minBypRes.yMinBypRes, enaHotWatIsoVal.uUpsDevSta) annotation (Line(
        points={{-148,20},{-110,20},{-110,-5},{-72,-5}}, color={255,0,255}));

  connect(uHotWatIsoVal, disHotWatIsoVal1.uHotWatIsoVal) annotation (Line(
        points={{-260,120},{144,120},{144,5},{148,5}}, color={0,0,127}));

  connect(enaHotWatIsoVal.yEnaHotWatIsoVal, lat1.u) annotation (Line(points={{
          -48,6},{-40,6},{-40,-110},{-34,-110}}, color={255,0,255}));

  connect(lat1.y, and1.u1) annotation (Line(points={{-10,-110},{-6,-110},{-6,0},
          {-2,0}}, color={255,0,255}));

  connect(nexBoi.yOnOff, logSwi.u2) annotation (Line(points={{-148,-66},{34,-66},
          {34,-40},{38,-40}}, color={255,0,255}));

  connect(truDel1.y, logSwi.u1) annotation (Line(points={{22,100},{36,100},{36,-32},
          {38,-32}}, color={255,0,255}));

  connect(lat.y, logSwi.u3) annotation (Line(points={{-200,0},{-196,0},{-196,-48},
          {38,-48}}, color={255,0,255}));

  connect(nexBoi.yEnaSmaBoi, enaHotWatIsoVal.nexChaBoi) annotation (Line(points=
         {{-148,-75},{-76,-75},{-76,8},{-72,8}}, color={255,127,0}));

  connect(logSwi.y, disBoi.uUpsDevSta) annotation (Line(points={{62,-40},{70,-40},
          {70,-20},{50,-20},{50,2},{58,2}}, color={255,0,255}));

  connect(lat.y, disBoi.uStaDow) annotation (Line(points={{-200,0},{-196,0},{-196,
          -20},{44,-20},{44,6},{58,6}}, color={255,0,255}));

  connect(nexBoi.yEnaSmaBoi, disBoi.nexEnaBoi) annotation (Line(points={{-148,-75},
          {-76,-75},{-76,20},{50,20},{50,9},{58,9}}, color={255,127,0}));

  connect(uBoi, disBoi.uBoi) annotation (Line(points={{-260,80},{54,80},{54,-2},
          {58,-2}}, color={255,0,255}));

  connect(nexBoi.yLasDisBoi, disBoi.nexDisBoi) annotation (Line(points={{-148,-70},
          {26,-70},{26,-5},{58,-5}}, color={255,127,0}));

  connect(nexBoi.yOnOff, disBoi.uOnOff) annotation (Line(points={{-148,-66},{34,
          -66},{34,-9},{58,-9}}, color={255,0,255}));

  connect(disBoi.yBoiDisPro, truDel.u) annotation (Line(points={{82,-8},{90,-8},
          {90,0},{98,0}}, color={255,0,255}));

  connect(disBoi.yBoi, yBoi) annotation (Line(points={{82,0},{86,0},{86,110},{300,
          110}}, color={255,0,255}));

  connect(nexBoi.yLasDisBoi, disHotWatIsoVal1.nexChaBoi) annotation (Line(
        points={{-148,-70},{60,-70},{60,-60},{140,-60},{140,8},{148,8}}, color={
          255,127,0}));

  connect(and3.y, edg.u) annotation (Line(points={{212,0},{220,0},{220,50},{228,
          50}}, color={255,0,255}));

  connect(nexBoi.yOnOff, enaHotWatIsoVal.chaPro) annotation (Line(points={{-148,
          -66},{-80,-66},{-80,-8},{-72,-8}}, color={255,0,255}));

  connect(nexBoi.yOnOff, minBypRes.chaPro) annotation (Line(points={{-148,-66},{
          -140,-66},{-140,0},{-184,0},{-184,24},{-172,24}}, color={255,0,255}));

  connect(lat.y, disHotWatIsoVal1.chaPro) annotation (Line(points={{-200,0},{
          -196,0},{-196,-20},{44,-20},{44,-18},{146,-18},{146,-8},{148,-8}},
                                                                        color={255,
          0,255}));

  connect(lat.y, mulOr.u[1]) annotation (Line(points={{-200,0},{-196,0},{-196,60},
          {-172,60}}, color={255,0,255}));

  connect(mulOr.y, lat5.u) annotation (Line(points={{-148,60},{-110,60},{-110,40},
          {-72,40}}, color={255,0,255}));

  connect(mulOr.y, enaHotWatIsoVal.uUpsDevSta) annotation (Line(points={{-148,60},
          {-110,60},{-110,-5},{-72,-5}}, color={255,0,255}));

  connect(mulOr.y, booRep.u) annotation (Line(points={{-148,60},{-110,60},{-110,
          -130},{-2,-130}}, color={255,0,255}));

  connect(nexBoi.yEnaSmaBoi, yNexEnaBoi) annotation (Line(points={{-148,-75},{-76,
          -75},{-76,-86},{260,-86},{260,-150},{300,-150}}, color={255,127,0}));

  connect(con.y, and1.u2) annotation (Line(points={{-138,-160},{-48,-160},{-48,-26},
          {-10,-26},{-10,-8},{-2,-8}}, color={255,0,255}));
  connect(con.y, and3.u2) annotation (Line(points={{-138,-160},{52,-160},{52,-172},
          {184,-172},{184,-8},{188,-8}}, color={255,0,255}));
  connect(nexBoi.yLasDisBoi, yLasDisBoi) annotation (Line(points={{-148,-70},{60,
          -70},{60,-60},{140,-60},{140,-116},{254,-116},{254,-190},{300,-190}},
        color={255,127,0}));
  connect(uStaChaPro, lat.clr) annotation (Line(points={{-260,-130},{-230,-130},
          {-230,-6},{-224,-6}}, color={255,0,255}));
  connect(uStaChaPro, lat5.clr) annotation (Line(points={{-260,-130},{-230,-130},
          {-230,-110},{-90,-110},{-90,34},{-72,34}}, color={255,0,255}));
  connect(uStaChaPro, lat1.clr) annotation (Line(points={{-260,-130},{-230,-130},
          {-230,-110},{-90,-110},{-90,-116},{-34,-116}}, color={255,0,255}));
  connect(uStaChaPro, lat3.clr) annotation (Line(points={{-260,-130},{-230,-130},
          {-230,-196},{-142,-196}}, color={255,0,255}));
  connect(uStaChaPro, lat4.clr) annotation (Line(points={{-260,-130},{-230,-130},
          {-230,-110},{-90,-110},{-90,-180},{110,-180},{110,-214},{156,-214},{156,
          -196},{158,-196}}, color={255,0,255}));
  connect(uStaChaPro, lat6.clr) annotation (Line(points={{-260,-130},{-230,-130},
          {-230,-110},{-90,-110},{-90,70},{120,70},{120,34},{148,34}}, color={255,
          0,255}));

  connect(and2.y, edg1.u)
    annotation (Line(points={{-58,-240},{-42,-240}}, color={255,0,255}));
  connect(mulOr.y, and2.u1) annotation (Line(points={{-148,60},{-110,60},{-110,-240},
          {-82,-240}}, color={255,0,255}));
  connect(nexBoi.yOnOff, and2.u2) annotation (Line(points={{-148,-66},{-100,-66},
          {-100,-248},{-82,-248}}, color={255,0,255}));
annotation (
  defaultComponentName="dowProCon",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-240,-260},{280,260}})),
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
          fillPattern=FillPattern.Solid,
          rotation=180),
        Polygon(
          points={{0,160},{-40,120},{0,120},{40,120},{0,160}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid,
          rotation=180)}),
Documentation(info="<html>
<p>
Block that controls boiler status and isolation valve position, initiates status
change in devices like pumps and minimum flow bypass valve, and resets plant
parameters like minimum flow setpoint when there is a stage-down command.
This development is based on ASHRAE RP-1711, March 2020 draft,sections 5.3.3.11 - 5.3.3.18,
which specify the step-by-step control of devices during boiler staging down process.
</p>
<ol>
<li>
Identify the boiler(s) that should be disabled (and enabled). This is implemented in block <code>nexBoi</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.NextBoiler\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.NextBoiler</a>
for more decriptions.
</li>
<li>
If the stage change process involves disabling a larger boiler and enabling a smaller boiler,
<ul>
<li>
Slowly change the minimum hot water flow 
setpoint to the one that includes both boilers being enabled. After new setpoint is 
achieved, wait <code>delEnaMinFloSet</code> to allow loop to stabilize.
The minimum flow setpoint is reset in sequence
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.MinimumFlowBypass.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint</a>).
Block <code>minBypRes</code> checks if the new setpoint is achieved
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.ResetMinBypass\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.ResetMinBypass</a>).
</li>
<li>
Start the next hot water pump and/or open the hot water isolation valves using the
block <code>enaHotWatIsoVal</code> using sequence implemented in <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.HWIsoVal\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.HWIsoVal</a>
for the valves and initiating the pump change process with the rising edge signal <code>yPumChaPro</code>. 
Once the pumps have been reset, the controller receives a rising edge signal on the
input <code>uPumChaPro</code>.
</li>
<li>
After waiting for time <code>delPreBoiEna</code>, the boiler status <code>yBoi</code> 
is changed using the boiler status controller <code>disBoi</code> implemented in the sequence
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.DisableBoiler\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.DisableBoiler</a>.
</li>
</ul>
</li>
<li>
If the stage down process does not involve turning on a smaller boiler, start the
staging down process immediately by changing <code>yBoi</code> using <code>disBoi</code>.
</li>
<li>
Wait for time <code>delBoiEna</code> before closing the isolation valve for the
disabled boiler using <code>disHotWatIsoVal1</code> and initiating the pump stage
change process.
</li>
<li>
End the staging process after the valve has been closed and the pump change process
completion signal has been received. Send rising edge signal through <code>yStaChaPro</code>
to indicate the same.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
July 20, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Down;
