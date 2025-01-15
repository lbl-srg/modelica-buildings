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
    annotation (Placement(transformation(extent={{-260,260},{-220,300}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp "Stage-up command"
    annotation (Placement(transformation(extent={{-260,230},{-220,270}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaChiWatIsoVal
    "Status of chiller chilled water isolation valve control: true=enabled valve is fully open"
    annotation (Placement(transformation(extent={{-260,200},{-220,240}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
     annotation (Placement(transformation(extent={{-260,170},{-220,210}}),
       iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-260,130},{-220,170}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Next disabling chiller when there is any stage up that need one chiller on and another off"
    annotation (Placement(transformation(extent={{-260,90},{-220,130}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water request status for each chiller"
    annotation (Placement(transformation(extent={{-260,50},{-220,90}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi)) "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-260,10},{-220,50}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water request status for each chiller"
    annotation (Placement(transformation(extent={{-260,-50},{-220,-10}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-260,-80},{-220,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-260,-220},{-220,-180}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinChiWat_setpoint(
    final unit="m3/s")
    "Minimum chiller water flow setpoint calculated from upstream process"
    annotation (Placement(transformation(extent={{-260,-250},{-220,-210}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{220,240},{260,280}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{220,80},{260,120}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
      iconTransformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinSet(
    final unit="m3/s") "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{220,-100},{260,-60}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSta
    "Flag to indicate if the staging process is finished"
    annotation (Placement(transformation(extent={{220,-240},{260,-200}}),
      iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput endStaTri
    "Staging end trigger"
    annotation (Placement(transformation(extent={{220,-280},{260,-240}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableChiller
    enaChi(
    final nChi=nChi,
    final proOnTim=proOnTim) "Enable next chiller"
    annotation (Placement(transformation(extent={{-80,220},{-60,240}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal
    disChiIsoVal(
    final nChi=nChi,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final iniValPos=1,
    final endValPos=0)
    "Disable isolation valve of the chiller being disabled"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl
    disHeaCon(
    final nChi=nChi,
    final thrTimEnb=0,
    final waiTim=0,
    final heaStaCha=false)
    "Disable head pressure control of the chiller being disabled"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint
    minChiWatSet(
    final nChi=nChi,
    final have_parChi=have_parChi,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet) "Reset minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass
    minBypSet(
    final aftByPasSetTim=aftByPasSetTim,
    final relFloDif=relFloDif)
    "Check if minimum bypass flow has been resetted"
    annotation (Placement(transformation(extent={{60,-220},{80,-200}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=true) "True constant"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 "Logical and"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor curDisChi(final nin=nChi)
    "Current disabling chiller"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor curDisChi1(final nin=nChi)
    "Current disabling chiller"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi3[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiWatIso[nChi]
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{180,90},{200,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi4
    "Logical switch"
    annotation (Placement(transformation(extent={{180,-200},{200,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiWatByp
    "Chilled water bypass flow setpoint"
    annotation (Placement(transformation(extent={{180,-90},{200,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi5 "Logical switch"
    annotation (Placement(transformation(extent={{80,-270},{100,-250}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiWatByp1
    "Chilled water bypass flow setpoint"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Maintain ON signal when the chiller has been proven on"
    annotation (Placement(transformation(extent={{-40,200},{-20,220}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Break algebraic loop"
    annotation (Placement(transformation(extent={{140,-270},{160,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{180,-270},{200,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Maintain ON signal when the chilled water isolation valve has been closed"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3
    "Maintain ON signal when the chiller head pressure control has been disabled"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Check if the disabled chiller is not requiring chilled water"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Check if the disabled chiller is not requiring condenser water"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-60,68},{-40,88}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{-58,-40},{-38,-20}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(
    final t=nChi) "Check if index is in the range"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(
    final t=1) "Check if index is in the range"
    annotation (Placement(transformation(extent={{20,180},{40,200}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Check if index is in the range"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi "Valid index"
    annotation (Placement(transformation(extent={{120,150},{140,170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Dummy index so the extractor will not have out of range index"
    annotation (Placement(transformation(extent={{60,130},{80,150}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat4 "Use the new setpoint"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg "Staging up process starts"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));
  Buildings.Controls.OBC.CDL.Logical.And and6 "Upstream step is done"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And and7 "Check if the process requires chillers ON and OFF"
    annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat5
    "Use the setpoint when the process requires chiller ON and OFF"
    annotation (Placement(transformation(extent={{180,-160},{200,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));

equation
  connect(lat.y, not2.u)
    annotation (Line(points={{-178,150},{-142,150}}, color={255,0,255}));
  connect(nexDisChi, disChiIsoVal.nexChaChi)
    annotation (Line(points={{-240,110},{-180,110},{-180,48},{78,48}},
      color={255,127,0}));
  connect(uChiWatIsoVal,disChiIsoVal. uChiWatIsoVal)
    annotation (Line(points={{-240,30},{70,30},{70,45},{78,45}},
      color={0,0,127}));
  connect(and4.y,disChiIsoVal.uUpsDevSta)
    annotation (Line(points={{22,80},{50,80},{50,35},{78,35}}, color={255,0,255}));
  connect(and5.y, disHeaCon.uUpsDevSta)
    annotation (Line(points={{22,-30},{26,-30},{26,-6},{58,-6}},
      color={255,0,255}));
  connect(nexDisChi, disHeaCon.nexChaChi)
    annotation (Line(points={{-240,110},{-180,110},{-180,-50},{40,-50},{40,-14},
          {58,-14}}, color={255,127,0}));
  connect(disHeaCon.uChiHeaCon, uChiHeaCon)
    annotation (Line(points={{58,-18},{50,-18},{50,-60},{-240,-60}},
      color={255,0,255}));
  connect(con3.y, minChiWatSet.uStaDow)
    annotation (Line(points={{-138,-110},{36,-110},{36,-99},{58,-99}},
      color={255,0,255}));
  connect(minBypSet.VChiWat_flow, VChiWat_flow)
    annotation (Line(points={{58,-210},{0,-210},{0,-200},{-240,-200}},
      color={0,0,127}));
  connect(not2.y, booRep4.u)
    annotation (Line(points={{-118,150},{-110,150},{-110,100},{38,100}},
      color={255,0,255}));
  connect(uChiHeaCon, logSwi3.u1)
    annotation (Line(points={{-240,-60},{170,-60},{170,8},{178,8}},
      color={255,0,255}));
  connect(disHeaCon.yChiHeaCon, logSwi3.u3)
    annotation (Line(points={{82,-16},{140,-16},{140,-8},{178,-8}},
      color={255,0,255}));
  connect(logSwi3.y, yChiHeaCon)
    annotation (Line(points={{202,0},{240,0}},     color={255,0,255}));
  connect(booRep4.y, logSwi3.u2)
    annotation (Line(points={{62,100},{130,100},{130,0},{178,0}},
      color={255,0,255}));
  connect(booRep4.y, chiWatIso.u2)
    annotation (Line(points={{62,100},{178,100}}, color={255,0,255}));
  connect(uChiWatIsoVal, chiWatIso.u1)
    annotation (Line(points={{-240,30},{70,30},{70,108},{178,108}},
      color={0,0,127}));
  connect(disChiIsoVal.yChiWatIsoVal, chiWatIso.u3)
    annotation (Line(points={{102,34},{110,34},{110,92},{178,92}},
      color={0,0,127}));
  connect(chiWatIso.y, yChiWatIsoVal)
    annotation (Line(points={{202,100},{240,100}}, color={0,0,127}));
  connect(not2.y, logSwi4.u2)
    annotation (Line(points={{-118,150},{-110,150},{-110,-190},{178,-190}},
      color={255,0,255}));
  connect(con2.y, logSwi4.u1)
    annotation (Line(points={{-38,10},{30,10},{30,-182},{178,-182}},
      color={255,0,255}));
  connect(minBypSet.yMinBypRes, logSwi4.u3)
    annotation (Line(points={{82,-210},{140,-210},{140,-198},{178,-198}},
      color={255,0,255}));
  connect(chiWatByp.y,yChiWatMinSet)
    annotation (Line(points={{202,-80},{240,-80}},   color={0,0,127}));
  connect(not2.y, logSwi5.u2)
    annotation (Line(points={{-118,150},{-110,150},{-110,-260},{78,-260}},
      color={255,0,255}));
  connect(logSwi4.y, logSwi5.u3)
    annotation (Line(points={{202,-190},{210,-190},{210,-240},{60,-240},{60,-268},
          {78,-268}}, color={255,0,255}));
  connect(logSwi5.y, yEndSta)
    annotation (Line(points={{102,-260},{120,-260},{120,-220},{240,-220}},
      color={255,0,255}));
  connect(nexEnaChi, enaChi.nexEnaChi)
    annotation (Line(points={{-240,280},{-106,280},{-106,239},{-82,239}},
      color={255,127,0}));
  connect(uStaUp, enaChi.uStaUp)
    annotation (Line(points={{-240,250},{-116,250},{-116,236},{-82,236}},
      color={255,0,255}));
  connect(uEnaChiWatIsoVal, enaChi.uEnaChiWatIsoVal)
    annotation (Line(points={{-240,220},{-180,220},{-180,232},{-82,232}},
      color={255,0,255}));
  connect(uChi, enaChi.uChi)
    annotation (Line(points={{-240,190},{-150,190},{-150,228},{-82,228}},
      color={255,0,255}));
  connect(lat.y, enaChi.uOnOff) annotation (Line(points={{-178,150},{-170,150},{
          -170,224},{-82,224}}, color={255,0,255}));
  connect(nexDisChi, enaChi.nexDisChi)
    annotation (Line(points={{-240,110},{-90,110},{-90,221},{-82,221}},
      color={255,127,0}));
  connect(enaChi.yChi, yChi)
    annotation (Line(points={{-58,238},{-20,238},{-20,260},{240,260}},
      color={255,0,255}));
  connect(uChi, minChiWatSet.uChi)
    annotation (Line(points={{-240,190},{-150,190},{-150,-86},{58,-86}},
      color={255,0,255}));
  connect(nexDisChi, minChiWatSet.nexDisChi)
    annotation (Line(points={{-240,110},{-180,110},{-180,-91},{58,-91}},
      color={255,127,0}));
  connect(lat.y, minChiWatSet.uOnOff) annotation (Line(points={{-178,150},{-170,
          150},{-170,-97},{58,-97}},   color={255,0,255}));
  connect(minChiWatSet.yChiWatMinFloSet, minBypSet.VMinChiWat_setpoint)
    annotation (Line(points={{82,-90},{96,-90},{96,-112},{50,-112},{50,-214},{58,
          -214}},     color={0,0,127}));
  connect(con3.y, minChiWatSet.uUpsDevSta)
    annotation (Line(points={{-138,-110},{36,-110},{36,-83},{58,-83}},
      color={255,0,255}));
  connect(minChiWatSet.yChiWatMinFloSet, chiWatByp1.u1)
    annotation (Line(points={{82,-90},{96,-90},{96,-82},{118,-82}},
      color={0,0,127}));
  connect(VMinChiWat_setpoint, chiWatByp1.u3)
    annotation (Line(points={{-240,-230},{112,-230},{112,-98},{118,-98}},
      color={0,0,127}));
  connect(nexEnaChi, minChiWatSet.nexEnaChi)
    annotation (Line(points={{-240,280},{-106,280},{-106,-89},{58,-89}},
      color={255,127,0}));
  connect(enaChi.yNewChiEna, lat1.u)
    annotation (Line(points={{-58,222},{-50,222},{-50,210},{-42,210}},
      color={255,0,255}));
  connect(lat1.y, and4.u1)
    annotation (Line(points={{-18,210},{-10,210},{-10,80},{-2,80}},
      color={255,0,255}));
  connect(lat1.y, minChiWatSet.uStaUp)
    annotation (Line(points={{-18,210},{-10,210},{-10,-81},{58,-81}},
      color={255,0,255}));
  connect(lat1.y, logSwi5.u1)
    annotation (Line(points={{-18,210},{-10,210},{-10,-252},{78,-252}},
      color={255,0,255}));
  connect(logSwi5.y, pre.u)
    annotation (Line(points={{102,-260},{138,-260}},color={255,0,255}));
  connect(pre.y, edg1.u)
    annotation (Line(points={{162,-260},{178,-260}}, color={255,0,255}));
  connect(edg1.y, endStaTri)
    annotation (Line(points={{202,-260},{240,-260}}, color={255,0,255}));
  connect(edg1.y, lat1.clr)
    annotation (Line(points={{202,-260},{210,-260},{210,-280},{-30,-280},{-30,180},
          {-50,180},{-50,204},{-42,204}}, color={255,0,255}));
  connect(disChiIsoVal.yEnaChiWatIsoVal, lat2.u)
    annotation (Line(points={{102,46},{120,46},{120,30},{138,30}},
      color={255,0,255}));
  connect(lat2.y, and5.u2)
    annotation (Line(points={{162,30},{180,30},{180,14},{-20,14},{-20,-38},{-2,-38}},
                    color={255,0,255}));
  connect(edg1.y, lat2.clr)
    annotation (Line(points={{202,-260},{210,-260},{210,-280},{-30,-280},{-30,24},
          {138,24}},  color={255,0,255}));
  connect(disHeaCon.yEnaHeaCon, lat3.u)
    annotation (Line(points={{82,-4},{110,-4},{110,-40},{118,-40}},   color={255,0,255}));
  connect(lat3.y, minChiWatSet.uSubCha)
    annotation (Line(points={{142,-40},{160,-40},{160,-54},{40,-54},{40,-94},{58,
          -94}},  color={255,0,255}));
  connect(lat3.y, minBypSet.uUpsDevSta)
    annotation (Line(points={{142,-40},{160,-40},{160,-54},{40,-54},{40,-202},{58,
          -202}}, color={255,0,255}));
  connect(con3.y, disHeaCon.uEnaPla)
    annotation (Line(points={{-138,-110},{36,-110},{36,-2},{58,-2}},
      color={255,0,255}));
  connect(uChiWatReq, curDisChi.u)
    annotation (Line(points={{-240,70},{-142,70}}, color={255,0,255}));
  connect(uConWatReq, curDisChi1.u)
    annotation (Line(points={{-240,-30},{-142,-30}}, color={255,0,255}));
  connect(curDisChi.y, not1.u)
    annotation (Line(points={{-118,70},{-102,70}}, color={255,0,255}));
  connect(curDisChi1.y, not3.u)
    annotation (Line(points={{-118,-30},{-102,-30}}, color={255,0,255}));
  connect(nexDisChi, intLesEquThr.u) annotation (Line(points={{-240,110},{-90,110},
          {-90,140},{18,140}},  color={255,127,0}));
  connect(nexDisChi, intGreEquThr.u) annotation (Line(points={{-240,110},{-90,110},
          {-90,190},{18,190}},  color={255,127,0}));
  connect(intGreEquThr.y, and2.u1)
    annotation (Line(points={{42,190},{58,190}}, color={255,0,255}));
  connect(intLesEquThr.y, and2.u2) annotation (Line(points={{42,140},{50,140},{50,
          182},{58,182}}, color={255,0,255}));
  connect(and2.y, intSwi.u2) annotation (Line(points={{82,190},{100,190},{100,160},
          {118,160}},color={255,0,255}));
  connect(nexDisChi, intSwi.u1) annotation (Line(points={{-240,110},{-90,110},{-90,
          168},{118,168}},color={255,127,0}));
  connect(conInt.y, intSwi.u3) annotation (Line(points={{82,140},{110,140},{110,
          152},{118,152}}, color={255,127,0}));
  connect(intSwi.y, curDisChi.index) annotation (Line(points={{142,160},{150,160},
          {150,120},{-160,120},{-160,40},{-130,40},{-130,58}}, color={255,127,0}));
  connect(intSwi.y, curDisChi1.index) annotation (Line(points={{142,160},{150,160},
          {150,120},{-160,120},{-160,-46},{-130,-46},{-130,-42}}, color={255,127,0}));
  connect(not1.y, and1.u2)
    annotation (Line(points={{-78,70},{-62,70}}, color={255,0,255}));
  connect(and1.y, and4.u2) annotation (Line(points={{-38,78},{-10,78},{-10,72},{
          -2,72}}, color={255,0,255}));
  connect(not3.y, and3.u1)
    annotation (Line(points={{-78,-30},{-60,-30}}, color={255,0,255}));
  connect(and3.y, and5.u1)
    annotation (Line(points={{-36,-30},{-2,-30}},  color={255,0,255}));
  connect(and2.y, and1.u1) annotation (Line(points={{82,190},{100,190},{100,160},
          {-70,160},{-70,78},{-62,78}},color={255,0,255}));
  connect(and2.y, and3.u2) annotation (Line(points={{82,190},{100,190},{100,160},
          {-70,160},{-70,-38},{-60,-38}},color={255,0,255}));
  connect(minChiWatSet.yChaSet, minBypSet.uSetChaPro) annotation (Line(points={{82,-98},
          {88,-98},{88,-106},{44,-106},{44,-218},{58,-218}},  color={255,0,255}));
  connect(uStaUp, minBypSet.uStaPro) annotation (Line(points={{-240,250},{-116,250},
          {-116,-206},{58,-206}}, color={255,0,255}));
  connect(uStaUp, disChiIsoVal.uStaPro) annotation (Line(points={{-240,250},{-116,
          250},{-116,32},{78,32}}, color={255,0,255}));
  connect(uStaUp, disHeaCon.uStaPro) annotation (Line(points={{-240,250},{-116,250},
          {-116,-10},{58,-10}}, color={255,0,255}));
  connect(uOnOff, lat.u) annotation (Line(points={{-240,150},{-202,150}},
          color={255,0,255}));
  connect(edg1.y, lat.clr) annotation (Line(points={{202,-260},{210,-260},{210,-280},
          {-210,-280},{-210,144},{-202,144}}, color={255,0,255}));
  connect(edg.y, lat4.clr) annotation (Line(points={{-78,-170},{20,-170},{20,-136},
          {58,-136}}, color={255,0,255}));
  connect(edg1.y, lat3.clr) annotation (Line(points={{202,-260},{210,-260},{210,
          -280},{-30,-280},{-30,-46},{118,-46}}, color={255,0,255}));
  connect(uStaUp, edg.u) annotation (Line(points={{-240,250},{-116,250},{-116,-170},
          {-102,-170}}, color={255,0,255}));
  connect(uStaUp, and6.u2) annotation (Line(points={{-240,250},{-116,250},{-116,
          -138},{-62,-138}}, color={255,0,255}));
  connect(lat3.y, and6.u1) annotation (Line(points={{142,-40},{160,-40},{160,-54},
          {-80,-54},{-80,-130},{-62,-130}}, color={255,0,255}));
  connect(and6.y, lat4.u)
    annotation (Line(points={{-38,-130},{58,-130}}, color={255,0,255}));
  connect(lat4.y, chiWatByp1.u2) annotation (Line(points={{82,-130},{104,-130},{
          104,-90},{118,-90}}, color={255,0,255}));
  connect(and7.y, lat5.u)
    annotation (Line(points={{142,-150},{178,-150}}, color={255,0,255}));
  connect(edg.y, lat5.clr) annotation (Line(points={{-78,-170},{160,-170},{160,-156},
          {178,-156}}, color={255,0,255}));
  connect(lat.y, and7.u1) annotation (Line(points={{-178,150},{-170,150},{-170,-150},
          {118,-150}}, color={255,0,255}));
  connect(and6.y, and7.u2) annotation (Line(points={{-38,-130},{0,-130},{0,-158},
          {118,-158}}, color={255,0,255}));
  connect(chiWatByp1.y, chiWatByp.u1) annotation (Line(points={{142,-90},{150,-90},
          {150,-72},{178,-72}}, color={0,0,127}));
  connect(lat5.y, chiWatByp.u2) annotation (Line(points={{202,-150},{210,-150},{
          210,-120},{160,-120},{160,-80},{178,-80}}, color={255,0,255}));
  connect(VMinChiWat_setpoint, chiWatByp.u3) annotation (Line(points={{-240,-230},
          {170,-230},{170,-88},{178,-88}}, color={0,0,127}));
annotation (
  defaultComponentName="endUp",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-220,-300},{220,300}}), graphics={
          Rectangle(
          extent={{-218,78},{218,2}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{72,72},{214,54}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Close chilled water
isolation valve"),
          Rectangle(
          extent={{-218,-22},{218,-58}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{100,-24},{216,-40}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable head
pressure control"),
          Rectangle(
          extent={{-218,-202},{218,-298}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-130,-100},{-12,-116}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Reset minimum
bypass setpoint"),
          Rectangle(
          extent={{-218,-62},{218,-198}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-148,-172},{-32,-180}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="End stage-up process"),
          Rectangle(
          extent={{-218,278},{218,102}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{68,238},{210,230}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable next chiller")}),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
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
