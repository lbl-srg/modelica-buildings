within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block UpEnd "Sequence for ending stage-up process"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Boolean have_parChi=true
    "True: the plant has parallel chillers";

  parameter Real proOnTim(
    final unit="s",
    final quantity="Time") = 300
    "Threshold time to check if newly enabled chiller being operated by more than 5 minutes"
    annotation (Dialog(group="Enable next chiller"));
  parameter Real chaChiWatIsoTim(
    final unit="s",
    final quantity="Time")
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(group="Chilled water isolation valve"));
  parameter Real byPasSetTim(
    final unit="s",
    final quantity="Time")
    "Time to slowly reset minimum bypass flow"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real minFloSet[nChi](
    final unit=fill("m3/s", nChi),
    final quantity=fill("VolumeFlowRate", nChi),
    displayUnit=fill("m3/s", nChi))
    "Minimum chilled water flow through each chiller"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real maxFloSet[nChi](
    final unit=fill("m3/s", nChi),
    final quantity=fill("VolumeFlowRate", nChi),
    displayUnit=fill("m3/s", nChi))
    "Maximum chilled water flow through each chiller"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real aftByPasSetTim(
    final unit="s",
    final quantity="Time")=60
    "Time after minimum bypass flow being resetted to new setpoint"
    annotation (Dialog(group="Reset bypass"));
  parameter Real relFloDif=0.05
    "Relative error to the setpoint for checking if it has achieved flow rate setpoint"
    annotation (Dialog(tab="Advanced", group="Reset bypass"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-240,220},{-200,260}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp "Stage-up command"
    annotation (Placement(transformation(extent={{-240,190},{-200,230}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaChiWatIsoVal
    "Status of chiller chilled water isolation valve control: true=enabled valve is fully open"
    annotation (Placement(transformation(extent={{-240,160},{-200,200}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
     annotation (Placement(transformation(extent={{-240,130},{-200,170}}),
       iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-240,90},{-200,130}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Next disabling chiller when there is any stage up that need one chiller on and another off"
    annotation (Placement(transformation(extent={{-240,50},{-200,90}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water request status for each chiller"
    annotation (Placement(transformation(extent={{-240,10},{-200,50}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi)) "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-240,-30},{-200,10}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water request status for each chiller"
    annotation (Placement(transformation(extent={{-240,-90},{-200,-50}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-240,-120},{-200,-80}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-240,-190},{-200,-150}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinChiWat_setpoint(
    final unit="m3/s")
    "Minimum chiller water flow setpoint calculated from upstream process"
    annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{200,200},{240,240}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{200,40},{240,80}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{200,-60},{240,-20}}),
      iconTransformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinSet(
    final unit="m3/s") "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{200,-130},{240,-90}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSta
    "Flag to indicate if the staging process is finished"
    annotation (Placement(transformation(extent={{200,-210},{240,-170}}),
      iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput endStaTri
    "Staging end trigger"
    annotation (Placement(transformation(extent={{200,-250},{240,-210}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableChiller
    enaChi(
    final nChi=nChi,
    final proOnTim=proOnTim) "Enable next chiller"
    annotation (Placement(transformation(extent={{-100,180},{-80,200}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal
    disChiIsoVal(
    final nChi=nChi,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final iniValPos=1,
    final endValPos=0)
    "Disable isolation valve of the chiller being disabled"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl
    disHeaCon(
    final nChi=nChi,
    final thrTimEnb=0,
    final waiTim=0,
    final heaStaCha=false)
    "Disable head pressure control of the chiller being disabled"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint
    minChiWatSet(
    final nChi=nChi,
    final have_parChi=have_parChi,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet) "Reset minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass
    minBypSet(
    final aftByPasSetTim=aftByPasSetTim,
    final relFloDif=relFloDif)
    "Check if minimum bypass flow has been resetted"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=true) "True constant"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 "Logical and"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor curDisChi(final nin=nChi)
    "Current disabling chiller"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor curDisChi1(final nin=nChi)
    "Current disabling chiller"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi3[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiWatIso[nChi]
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi4
    "Logical switch"
    annotation (Placement(transformation(extent={{160,-170},{180,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiWatByp
    "Chilled water bypass flow setpoint"
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi5 "Logical switch"
    annotation (Placement(transformation(extent={{60,-240},{80,-220}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiWatByp1
    "Chilled water bypass flow setpoint"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Maintain ON signal when the chiller has been proven on"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Break algebraic loop"
    annotation (Placement(transformation(extent={{120,-240},{140,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{160,-240},{180,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Maintain ON signal when the chilled water isolation valve has been closed"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3
    "Maintain ON signal when the chiller head pressure control has been disabled"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Check if the disabled chiller is not requiring chilled water"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Check if the disabled chiller is not requiring condenser water"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-80,28},{-60,48}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{-78,-80},{-58,-60}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(
    final t=nChi) "Check if index is in the range"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(
    final t=1) "Check if index is in the range"
    annotation (Placement(transformation(extent={{0,140},{20,160}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Check if index is in the range"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi "Valid index"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1) "Dummy index so the extractor will not have out of range index"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
equation
  connect(uOnOff, not2.u)
    annotation (Line(points={{-220,110},{-162,110}}, color={255,0,255}));
  connect(nexDisChi, disChiIsoVal.nexChaChi)
    annotation (Line(points={{-220,70},{-180,70},{-180,8},{58,8}},
      color={255,127,0}));
  connect(uChiWatIsoVal,disChiIsoVal. uChiWatIsoVal)
    annotation (Line(points={{-220,-10},{50,-10},{50,5},{58,5}},
      color={0,0,127}));
  connect(and4.y,disChiIsoVal.uUpsDevSta)
    annotation (Line(points={{22,40},{30,40},{30,-5},{58,-5}},   color={255,0,255}));
  connect(and5.y, disHeaCon.uUpsDevSta)
    annotation (Line(points={{2,-70},{6,-70},{6,-46},{38,-46}},
      color={255,0,255}));
  connect(nexDisChi, disHeaCon.nexChaChi)
    annotation (Line(points={{-220,70},{-180,70},{-180,-90},{20,-90},{20,-54},{
          38,-54}},
                 color={255,127,0}));
  connect(disHeaCon.uChiHeaCon, uChiHeaCon)
    annotation (Line(points={{38,-58},{30,-58},{30,-100},{-220,-100}},
      color={255,0,255}));
  connect(con3.y, minChiWatSet.uStaDow)
    annotation (Line(points={{-138,-150},{16,-150},{16,-139},{38,-139}},
      color={255,0,255}));
  connect(minBypSet.VChiWat_flow, VChiWat_flow)
    annotation (Line(points={{38,-180},{-20,-180},{-20,-170},{-220,-170}},
      color={0,0,127}));
  connect(not2.y, booRep4.u)
    annotation (Line(points={{-138,110},{-130,110},{-130,60},{-122,60}},
      color={255,0,255}));
  connect(uChiHeaCon, logSwi3.u1)
    annotation (Line(points={{-220,-100},{150,-100},{150,-32},{158,-32}},
      color={255,0,255}));
  connect(disHeaCon.yChiHeaCon, logSwi3.u3)
    annotation (Line(points={{62,-56},{120,-56},{120,-48},{158,-48}},
      color={255,0,255}));
  connect(logSwi3.y, yChiHeaCon)
    annotation (Line(points={{182,-40},{220,-40}}, color={255,0,255}));
  connect(booRep4.y, logSwi3.u2)
    annotation (Line(points={{-98,60},{110,60},{110,-40},{158,-40}},
      color={255,0,255}));
  connect(booRep4.y, chiWatIso.u2)
    annotation (Line(points={{-98,60},{158,60}},  color={255,0,255}));
  connect(uChiWatIsoVal, chiWatIso.u1)
    annotation (Line(points={{-220,-10},{50,-10},{50,68},{158,68}},
      color={0,0,127}));
  connect(disChiIsoVal.yChiWatIsoVal, chiWatIso.u3)
    annotation (Line(points={{82,-6},{90,-6},{90,52},{158,52}},
      color={0,0,127}));
  connect(chiWatIso.y, yChiWatIsoVal)
    annotation (Line(points={{182,60},{220,60}}, color={0,0,127}));
  connect(not2.y, logSwi4.u2)
    annotation (Line(points={{-138,110},{-130,110},{-130,-160},{158,-160}},
      color={255,0,255}));
  connect(con2.y, logSwi4.u1)
    annotation (Line(points={{-58,-30},{10,-30},{10,-152},{158,-152}},
      color={255,0,255}));
  connect(minBypSet.yMinBypRes, logSwi4.u3)
    annotation (Line(points={{62,-180},{120,-180},{120,-168},{158,-168}},
      color={255,0,255}));
  connect(not2.y, chiWatByp.u2)
    annotation (Line(points={{-138,110},{-130,110},{-130,-110},{158,-110}},
      color={255,0,255}));
  connect(chiWatByp.y,yChiWatMinSet)
    annotation (Line(points={{182,-110},{220,-110}}, color={0,0,127}));
  connect(not2.y, logSwi5.u2)
    annotation (Line(points={{-138,110},{-130,110},{-130,-230},{58,-230}},
      color={255,0,255}));
  connect(logSwi4.y, logSwi5.u3)
    annotation (Line(points={{182,-160},{190,-160},{190,-204},{40,-204},
      {40,-238},{58,-238}}, color={255,0,255}));
  connect(logSwi5.y, yEndSta)
    annotation (Line(points={{82,-230},{100,-230},{100,-190},{220,-190}},
      color={255,0,255}));
  connect(nexEnaChi, enaChi.nexEnaChi)
    annotation (Line(points={{-220,240},{-126,240},{-126,199},{-102,199}},
      color={255,127,0}));
  connect(uStaUp, enaChi.uStaUp)
    annotation (Line(points={{-220,210},{-136,210},{-136,196},{-102,196}},
      color={255,0,255}));
  connect(uEnaChiWatIsoVal, enaChi.uEnaChiWatIsoVal)
    annotation (Line(points={{-220,180},{-160,180},{-160,192},{-102,192}},
      color={255,0,255}));
  connect(uChi, enaChi.uChi)
    annotation (Line(points={{-220,150},{-140,150},{-140,188},{-102,188}},
      color={255,0,255}));
  connect(uOnOff, enaChi.uOnOff)
    annotation (Line(points={{-220,110},{-190,110},{-190,184},{-102,184}},
      color={255,0,255}));
  connect(nexDisChi, enaChi.nexDisChi)
    annotation (Line(points={{-220,70},{-110,70},{-110,181},{-102,181}},
      color={255,127,0}));
  connect(enaChi.yChi, yChi)
    annotation (Line(points={{-78,198},{-40,198},{-40,220},{220,220}},
      color={255,0,255}));
  connect(uChi, minChiWatSet.uChi)
    annotation (Line(points={{-220,150},{-170,150},{-170,-126},{38,-126}},
      color={255,0,255}));
  connect(nexDisChi, minChiWatSet.nexDisChi)
    annotation (Line(points={{-220,70},{-180,70},{-180,-131},{38,-131}},
      color={255,127,0}));
  connect(uOnOff, minChiWatSet.uOnOff)
    annotation (Line(points={{-220,110},{-190,110},{-190,-137},{38,-137}},
      color={255,0,255}));
  connect(minChiWatSet.yChiWatMinFloSet, minBypSet.VMinChiWat_setpoint)
    annotation (Line(points={{62,-130},{70,-130},{70,-146},{30,-146},{30,-184},
          {38,-184}}, color={0,0,127}));
  connect(con3.y, minChiWatSet.uUpsDevSta)
    annotation (Line(points={{-138,-150},{16,-150},{16,-123},{38,-123}},
      color={255,0,255}));
  connect(minChiWatSet.yChiWatMinFloSet, chiWatByp1.u1)
    annotation (Line(points={{62,-130},{70,-130},{70,-122},{98,-122}},
      color={0,0,127}));
  connect(VMinChiWat_setpoint, chiWatByp1.u3)
    annotation (Line(points={{-220,-200},{80,-200},{80,-138},{98,-138}},
      color={0,0,127}));
  connect(VMinChiWat_setpoint, chiWatByp.u1)
    annotation (Line(points={{-220,-200},{140,-200},{140,-102},{158,-102}},
      color={0,0,127}));
  connect(chiWatByp1.y, chiWatByp.u3)
    annotation (Line(points={{122,-130},{150,-130},{150,-118},{158,-118}},
      color={0,0,127}));
  connect(nexEnaChi, minChiWatSet.nexEnaChi)
    annotation (Line(points={{-220,240},{-126,240},{-126,-129},{38,-129}},
      color={255,127,0}));
  connect(enaChi.yNewChiEna, lat1.u)
    annotation (Line(points={{-78,182},{-70,182},{-70,170},{-62,170}},
      color={255,0,255}));
  connect(lat1.y, and4.u1)
    annotation (Line(points={{-38,170},{-30,170},{-30,40},{-2,40}},
      color={255,0,255}));
  connect(lat1.y, minChiWatSet.uStaUp)
    annotation (Line(points={{-38,170},{-30,170},{-30,-121},{38,-121}},
      color={255,0,255}));
  connect(lat1.y, logSwi5.u1)
    annotation (Line(points={{-38,170},{-30,170},{-30,-222},{58,-222}},
      color={255,0,255}));
  connect(logSwi5.y, pre.u)
    annotation (Line(points={{82,-230},{118,-230}}, color={255,0,255}));
  connect(pre.y, edg1.u)
    annotation (Line(points={{142,-230},{158,-230}}, color={255,0,255}));
  connect(edg1.y, endStaTri)
    annotation (Line(points={{182,-230},{220,-230}}, color={255,0,255}));
  connect(edg1.y, lat1.clr)
    annotation (Line(points={{182,-230},{190,-230},{190,-250},{-50,-250},{-50,
          140},{-70,140},{-70,164},{-62,164}},  color={255,0,255}));
  connect(disChiIsoVal.yEnaChiWatIsoVal, lat2.u)
    annotation (Line(points={{82,6},{100,6},{100,-10},{118,-10}},
      color={255,0,255}));
  connect(lat2.y, and5.u2)
    annotation (Line(points={{142,-10},{160,-10},{160,-26},{-40,-26},{-40,-78},
          {-22,-78}},
                  color={255,0,255}));
  connect(edg1.y, lat2.clr)
    annotation (Line(points={{182,-230},{190,-230},{190,-250},{-50,-250},{-50,
          -16},{118,-16}},  color={255,0,255}));
  connect(disHeaCon.yEnaHeaCon, lat3.u)
    annotation (Line(points={{62,-44},{90,-44},{90,-80},{98,-80}}, color={255,0,255}));
  connect(lat3.y, chiWatByp1.u2)
    annotation (Line(points={{122,-80},{140,-80},{140,-94},{80,-94},{80,-130},
      {98,-130}}, color={255,0,255}));
  connect(lat3.y, minChiWatSet.uSubCha)
    annotation (Line(points={{122,-80},{140,-80},{140,-94},{20,-94},{20,-134},
      {38,-134}}, color={255,0,255}));
  connect(lat3.y, minBypSet.uUpsDevSta)
    annotation (Line(points={{122,-80},{140,-80},{140,-94},{20,-94},{20,-172},{
          38,-172}}, color={255,0,255}));
  connect(edg1.y, lat3.clr)
    annotation (Line(points={{182,-230},{190,-230},{190,-250},{-50,-250},
      {-50,-86},{98,-86}}, color={255,0,255}));
  connect(con3.y, disHeaCon.uEnaPla)
    annotation (Line(points={{-138,-150},{16,-150},{16,-42},{38,-42}},
      color={255,0,255}));
  connect(uChiWatReq, curDisChi.u)
    annotation (Line(points={{-220,30},{-162,30}}, color={255,0,255}));
  connect(uConWatReq, curDisChi1.u)
    annotation (Line(points={{-220,-70},{-162,-70}}, color={255,0,255}));
  connect(curDisChi.y, not1.u)
    annotation (Line(points={{-138,30},{-122,30}}, color={255,0,255}));
  connect(curDisChi1.y, not3.u)
    annotation (Line(points={{-138,-70},{-122,-70}}, color={255,0,255}));
  connect(nexDisChi, intLesEquThr.u) annotation (Line(points={{-220,70},{-110,70},
          {-110,100},{-2,100}}, color={255,127,0}));
  connect(nexDisChi, intGreEquThr.u) annotation (Line(points={{-220,70},{-110,70},
          {-110,150},{-2,150}}, color={255,127,0}));
  connect(intGreEquThr.y, and2.u1)
    annotation (Line(points={{22,150},{38,150}}, color={255,0,255}));
  connect(intLesEquThr.y, and2.u2) annotation (Line(points={{22,100},{30,100},{30,
          142},{38,142}}, color={255,0,255}));
  connect(and2.y, intSwi.u2) annotation (Line(points={{62,150},{80,150},{80,120},
          {98,120}}, color={255,0,255}));
  connect(nexDisChi, intSwi.u1) annotation (Line(points={{-220,70},{-110,70},{-110,
          128},{98,128}}, color={255,127,0}));
  connect(conInt.y, intSwi.u3) annotation (Line(points={{62,100},{90,100},{90,112},
          {98,112}}, color={255,127,0}));
  connect(intSwi.y, curDisChi.index) annotation (Line(points={{122,120},{130,
          120},{130,80},{-176,80},{-176,4},{-150,4},{-150,18}},
                                                          color={255,127,0}));
  connect(intSwi.y, curDisChi1.index) annotation (Line(points={{122,120},{130,120},
          {130,80},{-176,80},{-176,-86},{-150,-86},{-150,-82}}, color={255,127,0}));
  connect(not1.y, and1.u2)
    annotation (Line(points={{-98,30},{-82,30}}, color={255,0,255}));
  connect(and1.y, and4.u2) annotation (Line(points={{-58,38},{-30,38},{-30,32},
          {-2,32}},color={255,0,255}));
  connect(not3.y, and3.u1)
    annotation (Line(points={{-98,-70},{-80,-70}}, color={255,0,255}));
  connect(and3.y, and5.u1)
    annotation (Line(points={{-56,-70},{-22,-70}}, color={255,0,255}));
  connect(and2.y, and1.u1) annotation (Line(points={{62,150},{80,150},{80,120},
          {-90,120},{-90,38},{-82,38}},color={255,0,255}));
  connect(and2.y, and3.u2) annotation (Line(points={{62,150},{80,150},{80,120},{
          -90,120},{-90,-78},{-80,-78}}, color={255,0,255}));
  connect(minChiWatSet.yChaSet, minBypSet.uSetChaPro) annotation (Line(points={
          {62,-138},{66,-138},{66,-144},{24,-144},{24,-188},{38,-188}}, color={
          255,0,255}));
  connect(uStaUp, minBypSet.uStaPro) annotation (Line(points={{-220,210},{-136,
          210},{-136,-176},{38,-176}}, color={255,0,255}));
  connect(uStaUp, disChiIsoVal.uStaPro) annotation (Line(points={{-220,210},{
          -136,210},{-136,-8},{58,-8}}, color={255,0,255}));
  connect(uStaUp, disHeaCon.uStaPro) annotation (Line(points={{-220,210},{-136,
          210},{-136,-50},{38,-50}}, color={255,0,255}));
annotation (
  defaultComponentName="endUp",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-260},{200,260}}), graphics={
          Rectangle(
          extent={{-198,38},{198,-38}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{52,32},{194,24}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Close chilled water
isolation valve"),
          Rectangle(
          extent={{-198,-62},{198,-98}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{76,-64},{192,-72}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable head
pressure control"),
          Rectangle(
          extent={{-198,-102},{198,-198}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-182,-166},{-66,-174}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Reset minimum
bypass setpoint"),
          Rectangle(
          extent={{-198,-202},{198,-258}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-168,-212},{-52,-220}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="End stage-up process"),
          Rectangle(
          extent={{-198,238},{198,62}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{48,198},{190,190}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable next chiller")}),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-40,6},{40,-6}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,72},{2,6}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,90},{-20,72},{0,72},{20,72},{0,90}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,122},{-66,112}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="nexEnaChi"),
        Text(
          extent={{-98,104},{-76,92}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaUp"),
        Text(
          extent={{-98,86},{-46,72}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEnaChiWatIsoVal"),
        Text(
          extent={{-98,62},{-84,54}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChi"),
        Text(
          extent={{-98,42},{-76,34}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOnOff"),
        Text(
          extent={{-98,24},{-68,14}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="nexDisChi"),
        Text(
          extent={{-98,4},{-64,-10}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiWatReq"),
        Text(
          extent={{-98,-14},{-56,-26}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatIsoVal"),
        Text(
          extent={{-98,-34},{-64,-48}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uConWatReq"),
        Text(
          extent={{-98,-56},{-64,-70}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiHeaCon"),
        Text(
          extent={{-98,-74},{-56,-86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{56,-22},{98,-34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatMinSet"),
        Text(
          extent={{72,-62},{96,-74}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEndSta"),
        Text(
          extent={{64,18},{98,4}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yChiHeaCon"),
        Text(
          extent={{56,58},{98,46}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatIsoVal"),
        Text(
          extent={{82,96},{96,88}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yChi"),
        Text(
          extent={{-98,-90},{-30,-100}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinChiWat_setpoint"),
        Text(
          extent={{68,-82},{96,-96}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="endStaTri")}),
Documentation(info="<html>
<p>
Block that controls devices at the ending step of chiller staging up process.
This development is based on ASHRAE Guideline 36-2021,
section 5.20.4.16, item f and g. These sections specify the controls of
devices at the ending step of staging up process.
</p>
<p>
For the stage-up process that does not require a smaller chiller being disabled
and a larger chiller being enabled (<code>uOnOff=false</code>),
</p>
<ul>
<li>
Start the next stage chiller (<code>nexEnaChi</code>) after the chilled water
isolation valve is fully open (<code>uEnaChiWatIsoVal=true</code>).
This is implemented in block <code>enaChi</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableChiller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableChiller</a>
for more decriptions.
</li>
</ul>
<p>
For any stage change during which a smaller chiller is diabled and a larger chiller
is enabled (<code>uOnOff=true</code>), after starting the next stage chiller
specified above, do following:
</p>
<ol>
<li>
Wait 5 minutes (<code>proOnTim</code>) for the newly enabled chiller to prove that
is operating correctly, then shut off the small chiller (<code>nexDisChi</code>).
This is implemented in block <code>enaChi</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableChiller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableChiller</a>
for more decriptions.
</li>
<li>
When the controller of the smaller chiller being shut off indicates no request
for chilled water flow (<code>uChiWatReq=false</code>), slowly close the chiller's
chilled water isolation valve to avoid a sudden change in flow through other
operating chillers.
This is implemented in block <code>disChiIsoVal</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal</a>
for more decriptions.
</li>
<li>
When the controller of the smaller chiller being shut off indicates no request for
condenser water flow (<code>uConWatReq=false</code>), disable the chiller's head
pressure control loop.
This is implemented in block <code>disHeaCon</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl</a>
for more decriptions.
</li>
<li>
Change the minimum flow bypass setpoint to that appropriate for the new stage.
This is implemented in block <code>minChiWatSet</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint</a>
for more decriptions.
</li>
<li>
Block <code>minBypSet</code> will then check if the new chilled water flow setpoint
has been achieved. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass</a>
for more decriptions.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
September 22, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end UpEnd;
