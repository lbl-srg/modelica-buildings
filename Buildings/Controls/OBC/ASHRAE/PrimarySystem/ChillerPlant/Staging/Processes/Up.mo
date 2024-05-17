within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes;
block Up "Sequence for control devices when there is stage-up command"

  parameter Integer nChi=2 "Total number of chillers in the plant";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Integer totSta=6
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable";
  parameter Integer nChiSta=3
    "Total number of chiller stages, including stage zero but not the stages with a WSE, if applicable";
  parameter Boolean have_WSE=true
    "True: have waterside economizer";
  parameter Boolean have_ponyChiller=false
    "True: have pony chiller";
  parameter Boolean have_parChi=true
    "True: the plant has parallel chillers";
  parameter Boolean have_heaConWatPum=true
    "True: headered condenser water pumps";
  parameter Boolean have_fixSpeConWatPum=true
    "True: fixed speed condenser water pump";
  parameter Boolean need_reduceChillerDemand=false
    "True: need limit chiller demand when chiller staging";
  parameter Real chiDemRedFac=0.75
    "Demand reducing factor of current operating chillers"
    annotation (Dialog(group="Limit chiller demand", enable=need_reduceChillerDemand));
  parameter Real holChiDemTim(
    unit="s",
    displayUnit="s")=300
    "Maximum time to wait for the actual demand less than percentage of current load"
    annotation (Dialog(group="Limit chiller demand", enable=need_reduceChillerDemand));
  parameter Real byPasSetTim(
    unit="s",
    displayUnit="s")=300
    "Time to reset minimum bypass flow"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real minFloSet[nChi](
    final unit=fill("m3/s",nChi),
    displayUnit=fill("m3/s",nChi))={0.0089,0.0089}
      "Minimum chilled water flow through each chiller"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real maxFloSet[nChi](
    final unit=fill("m3/s",nChi),
    displayUnit=fill("m3/s",nChi))={0.025,0.025}
      "Maximum chilled water flow through each chiller"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real aftByPasSetTim(
    unit="s",
    displayUnit="s")=60
    "Time to allow loop to stabilize after resetting minimum chilled water flow setpoint"
    annotation (Dialog(group="Reset bypass"));
  parameter Real staVec[totSta]={0,0.5,1,1.5,2,2.5}
    "Chiller stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(group="Enable condenser water pump"));
  parameter Real desConWatPumSpe[totSta]={0,0.5,0.75,0.6,0.75,0.9}
    "Design condenser water pump speed setpoints, according to current chiller stage and WSE status"
    annotation (Dialog(group="Enable condenser water pump"));
  parameter Real desConWatPumNum[totSta]={0,1,1,2,2,2}
    "Design number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(group="Enable condenser water pump"));
  parameter Real desChiNum[nChiSta]={0,1,2}
    "Design number of chiller that should be ON, according to current chiller stage"
    annotation (Dialog(group="Enable condenser water pump", enable=have_fixSpeConWatPum));
  parameter Real thrTimEnb(
    unit="s",
    displayUnit="s")=10
    "Threshold time to enable head pressure control after condenser water pump being reset"
    annotation (Dialog(group="Enable head pressure control"));
  parameter Real waiTim(
    unit="s",
    displayUnit="s")=30
    "Waiting time after enabling next head pressure control"
    annotation (Dialog(group="Enable head pressure control"));
  parameter Real chaChiWatIsoTim(
    unit="s",
    displayUnit="s")=300
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(group="Enable CHW isolation valve"));
  parameter Real proOnTim(
    unit="s",
    displayUnit="s")=300
    "Threshold time to check after newly enabled chiller being operated"
    annotation (Dialog(group="Enable next chiller",enable=have_ponyChiller));
  parameter Real pumSpeChe = 0.05
    "Lower threshold value to check if condenser water pump has achieved setpoint"
    annotation (Dialog(tab="Advanced", group="Enable condenser water pump"));
  parameter Real relFloDif=0.05
    "Relative error to the setpoint for checking if it has achieved flow rate setpoint"
    annotation (Dialog(tab="Advanced", group="Reset bypass"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Chiller stage setpoint index"
    annotation (Placement(transformation(extent={{-280,180},{-240,220}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiSet[nChi]
    "Vector of chillers status setpoint"
    annotation (Placement(transformation(extent={{-280,150},{-240,190}}),
      iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa[nChi](
    final quantity=fill("ElectricCurrent", nChi),
    final unit=fill("A", nChi))
    if need_reduceChillerDemand
    "Current chiller load"
    annotation (Placement(transformation(extent={{-280,90},{-240,130}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-280,60},{-240,100}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-280,30},{-240,70}}),
      iconTransformation(extent={{-140,56},{-100,96}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiConIsoVal[nChi]
    "Chiller condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-280,-10},{-240,30}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage, it would be the same as chiller stage setpoint when it is not in staging process"
    annotation (Placement(transformation(extent={{-280,-30},{-240,10}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaPlaConPum
    "True: enable condenser water pump when the plant is just enabled"
    annotation (Placement(transformation(extent={{-280,-56},{-240,-16}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water requst status for each chiller"
    annotation (Placement(transformation(extent={{-280,-90},{-240,-50}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if have_WSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-280,-110},{-240,-70}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpeSet(
    final min=0,
    final max=1,
    final unit="1") if not have_fixSpeConWatPum
    "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{-280,-130},{-240,-90}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") if not have_fixSpeConWatPum
    "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-280,-150},{-240,-110}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaPlaConIso
    "True: enable condenser water pump when then plant is just enabled"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[nConWatPum] if have_fixSpeConWatPum
    "Status indicating if condenser water pump is running"
    annotation (Placement(transformation(extent={{-280,-210},{-240,-170}}),
      iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-280,-240},{-240,-200}}),
      iconTransformation(extent={{-140,-170},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-280,-270},{-240,-230}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water requst status for each chiller"
    annotation (Placement(transformation(extent={{-280,-300},{-240,-260}}),
      iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaPro
    "Indicate if it is in stage-up process: true=in stage-up process"
    annotation (Placement(transformation(extent={{240,170},{280,210}}),
      iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    final quantity=fill("ElectricCurrent", nChi),
    final unit=fill("A", nChi))
    if need_reduceChillerDemand
    "Chiller demand setpoint"
    annotation (Placement(transformation(extent={{240,90},{280,130}}),
      iconTransformation(extent={{100,130},{140,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinFloSet(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{240,20},{280,60}}),
      iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowStaUp
    "Tower stage up status: true=stage up cooling tower"
    annotation (Placement(transformation(extent={{240,-20},{280,20}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum
    "Lead condenser water pump status"
    annotation (Placement(transformation(extent={{240,-50},{280,-10}}),
      iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDesConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") if not have_fixSpeConWatPum
    "Condenser water pump design speed at current stage"
    annotation (Placement(transformation(extent={{240,-80},{280,-40}}),
      iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yConWatPumNum
    "Number of operating condenser water pumps"
    annotation (Placement(transformation(extent={{240,-110},{280,-70}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{240,-150},{280,-110}}),
      iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{240,-210},{280,-170}}),
      iconTransformation(extent={{100,-160},{140,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{240,-260},{280,-220}}),
      iconTransformation(extent={{100,-190},{140,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndStaTri
    "Staging end trigger"
    annotation (Placement(transformation(extent={{240,-320},{280,-280}}),
      iconTransformation(extent={{100,-210},{140,-170}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Check if stage setpoint increases"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller
    nexChi(final nChi=nChi) "Identify next enabling chiller"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand
    chiDemRed(
    final nChi=nChi,
    final chiDemRedFac=chiDemRedFac,
    final holChiDemTim=holChiDemTim) if need_reduceChillerDemand
    "Limit chiller demand"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint
    minChiWatFlo(
    final nChi=nChi,
    final have_parChi=have_parChi,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet) "Minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass
    minBypSet(
    final aftByPasSetTim=aftByPasSetTim,
    final relFloDif=relFloDif)
    "Check if minium bypass has been reset"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableCWPump
    enaNexCWP
    "Identify correct stage number for enabling next condenser water pump"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    conWatPumCon(
    final have_heaPum=have_heaConWatPum,
    final have_WSE=have_WSE,
    final fixSpe=have_fixSpeConWatPum,
    final nChi=nChi,
    final totSta=totSta,
    final nChiSta=nChiSta,
    final staVec=staVec,
    final desConWatPumSpe=desConWatPumSpe,
    final desConWatPumNum=desConWatPumNum,
    final desChiNum=desChiNum,
    final pumSpeChe=pumSpeChe)
    "Enabling next condenser water pump or change pump speed"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl
    enaHeaCon(
    final nChi=nChi,
    final thrTimEnb=thrTimEnb,
    final waiTim=waiTim,
    final heaStaCha=true)
    "Enabling head pressure control for next enabling chiller"
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal
    enaChiIsoVal(
    final nChi=nChi,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final iniValPos=0,
    final endValPos=1)
    "Enable chilled water isolation valve for next enabling chiller"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd
    endUp(
    final nChi=nChi,
    final have_parChi=have_parChi,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final maxFloSet=maxFloSet,
    final proOnTim=proOnTim,
    final minFloSet=minFloSet,
    final byPasSetTim=byPasSetTim,
    final aftByPasSetTim=aftByPasSetTim,
    final relFloDif=relFloDif) "End stage-up process"
    annotation (Placement(transformation(extent={{20,-280},{40,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(final nin=nChi) "Multiple or"
    annotation (Placement(transformation(extent={{-140,-62},{-120,-42}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(final nin=nChi) "Multiple or"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{200,-200},{220,-180}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,-230},{160,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{200,-140},{220,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{200,30},{220,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(final k=0)
    if need_reduceChillerDemand
    "Constant zero"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{20,-126},{40,-106}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1 if need_reduceChillerDemand
    "Maintain ON signal when chiller demand has been limited"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Maintain ON signal when minimum chilled water flow has been reset"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3
    "Maintain ON signal when condenser water pump has been enabled"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat4
    "Maintain ON signal when chiller head pressure control has been enabled"
    annotation (Placement(transformation(extent={{120,-170},{140,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat5
    "Maintain ON signal when chilled water isolation valve has been open"
    annotation (Placement(transformation(extent={{100,-230},{120,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 if not need_reduceChillerDemand
    "Dummy or"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-100,290},{-80,310}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1 "Logical switch"
    annotation (Placement(transformation(extent={{-40,230},{-20,250}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if the stage setpoint is zero"
    annotation (Placement(transformation(extent={{-140,270},{-120,290}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-220,290},{-200,310}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(final k=true)
    "Constant true"
    annotation (Placement(transformation(extent={{-200,220},{-180,240}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=1,
    final delayOnInit=true)
    "Check if it has passed initial time"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));
equation
  connect(lat.y,chiDemRed.uDemLim)
    annotation (Line(points={{-118,150},{-100,150},{-100,129},{-82,129}},
      color={255,0,255}));
  connect(chiDemRed.uChiLoa, uChiLoa)
    annotation (Line(points={{-82,125},{-180,125},{-180,110},{-260,110}},
      color={0,0,127}));
  connect(chiDemRed.uChi, uChi)
    annotation (Line(points={{-82,111},{-220,111},{-220,80},{-260,80}},
      color={255,0,255}));
  connect(lat.y, minBypSet.uStaPro) annotation (Line(points={{-118,150},{-100,
          150},{-100,84},{58,84}}, color={255,0,255}));
  connect(minBypSet.VChiWat_flow, VChiWat_flow)
    annotation (Line(points={{58,80},{-156,80},{-156,50},{-260,50}},
      color={0,0,127}));
  connect(lat.y, minChiWatFlo.uStaUp)
    annotation (Line(points={{-118,150},{-100,150},{-100,49},{18,49}},
      color={255,0,255}));
  connect(con.y, minChiWatFlo.uStaDow)
    annotation (Line(points={{-178,30},{-96,30},{-96,31},{18,31}},
      color={255,0,255}));
  connect(lat.y, enaNexCWP.uStaUp)
    annotation (Line(points={{-118,150},{-100,150},{-100,-8},{-2,-8}},
      color={255,0,255}));
  connect(conWatPumCon.uWSE, uWSE)
    annotation (Line(points={{58,-63},{-6,-63},{-6,-90},{-260,-90}},
      color={255,0,255}));
  connect(conWatPumCon.uConWatPumSpe, uConWatPumSpe)
    annotation (Line(points={{58,-67},{2,-67},{2,-130},{-260,-130}},
      color={0,0,127}));
  connect(enaNexCWP.yChiSta, conWatPumCon.uChiSta)
    annotation (Line(points={{22,-10},{36,-10},{36,-61},{58,-61}},
      color={255,127,0}));
  connect(lat.y, enaHeaCon.uStaPro) annotation (Line(points={{-118,150},{-100,
          150},{-100,-140},{58,-140}}, color={255,0,255}));
  connect(nexChi.yNexEnaChi, enaHeaCon.nexChaChi)
    annotation (Line(points={{-58,174},{-36,174},{-36,-144},{58,-144}},
      color={255,127,0}));
  connect(nexChi.yNexEnaChi, enaChiIsoVal.nexChaChi)
    annotation (Line(points={{-58,174},{-36,174},{-36,-192},{58,-192}},
      color={255,127,0}));
  connect(enaChiIsoVal.uChiWatIsoVal, uChiWatIsoVal)
    annotation (Line(points={{58,-195},{-96,-195},{-96,-250},{-260,-250}},
      color={0,0,127}));
  connect(lat.y, enaChiIsoVal.uStaPro) annotation (Line(points={{-118,150},{-100,
          150},{-100,-208},{58,-208}}, color={255,0,255}));
  connect(nexChi.yNexEnaChi, endUp.nexEnaChi)
    annotation (Line(points={{-58,174},{-36,174},{-36,-258},{18,-258}},
      color={255,127,0}));
  connect(lat.y, endUp.uStaUp)
    annotation (Line(points={{-118,150},{-100,150},{-100,-260},{18,-260}},
      color={255,0,255}));
  connect(uChi, endUp.uChi)
    annotation (Line(points={{-260,80},{-220,80},{-220,-264},{18,-264}},
      color={255,0,255}));
  connect(endUp.uChiWatReq, uChiWatReq)
    annotation (Line(points={{18,-270},{-168,-270},{-168,-280},{-260,-280}},
      color={255,0,255}));
  connect(endUp.uChiWatIsoVal, uChiWatIsoVal)
    annotation (Line(points={{18,-272},{-96,-272},{-96,-250},{-260,-250}},
      color={0,0,127}));
  connect(uConWatReq, endUp.uConWatReq)
    annotation (Line(points={{-260,-70},{-164,-70},{-164,-274},{18,-274}},
      color={255,0,255}));
  connect(VChiWat_flow, endUp.VChiWat_flow)
    annotation (Line(points={{-260,50},{-156,50},{-156,-278},{18,-278}},
      color={0,0,127}));
  connect(uConWatReq, mulOr1.u)
    annotation (Line(points={{-260,-70},{-82,-70}},
      color={255,0,255}));
  connect(uChi, mulOr.u)
    annotation (Line(points={{-260,80},{-220,80},{-220,-52},{-142,-52}},
      color={255,0,255}));
  connect(chiDemRed.yChiDem, yChiDem)
    annotation (Line(points={{-58,124},{100,124},{100,110},{260,110}},
      color={0,0,127}));
  connect(conWatPumCon.yLeaPum, yLeaPum)
    annotation (Line(points={{82,-51},{120,-51},{120,-30},{260,-30}}, color={255,0,255}));
  connect(endUp.yChi, yChi)
    annotation (Line(points={{42,-261},{220,-261},{220,-240},{260,-240}},
      color={255,0,255}));
  connect(endUp.yChiWatIsoVal, swi.u1)
    annotation (Line(points={{42,-265},{184,-265},{184,-182},{198,-182}},
      color={0,0,127}));
  connect(swi.y, yChiWatIsoVal)
    annotation (Line(points={{222,-190},{260,-190}}, color={0,0,127}));
  connect(endUp.yChiHeaCon, logSwi.u1)
    annotation (Line(points={{42,-269},{172,-269},{172,-122},{198,-122}},
      color={255,0,255}));
  connect(enaHeaCon.yChiHeaCon, logSwi.u3)
    annotation (Line(points={{82,-146},{120,-146},{120,-138},{198,-138}},
      color={255,0,255}));
  connect(logSwi.y, yChiHeaCon)
    annotation (Line(points={{222,-130},{260,-130}}, color={255,0,255}));
  connect(enaChiIsoVal.yEnaChiWatIsoVal, swi1.u2)
    annotation (Line(points={{82,-194},{100,-194},{100,40},{198,40}},
      color={255,0,255}));
  connect(endUp.yChiWatMinSet, swi1.u1)
    annotation (Line(points={{42,-273},{178,-273},{178,48},{198,48}},
      color={0,0,127}));
  connect(swi1.y, yChiWatMinFloSet)
    annotation (Line(points={{222,40},{260,40}}, color={0,0,127}));
  connect(enaChiIsoVal.yChiWatIsoVal, swi.u3)
    annotation (Line(points={{82,-206},{100,-206},{100,-198},{198,-198}},
      color={0,0,127}));
  connect(nexChi.yDisSmaChi, endUp.nexDisChi)
    annotation (Line(points={{-58,170.8},{-40,170.8},{-40,-268},{18,-268}},
      color={255,127,0}));
  connect(nexChi.yOnOff, minChiWatFlo.uOnOff)
    annotation (Line(points={{-58,167},{-44,167},{-44,33},{18,33}},
      color={255,0,255}));
  connect(nexChi.yOnOff, endUp.uOnOff)
    annotation (Line(points={{-58,167},{-44,167},{-44,-266},{18,-266}},
      color={255,0,255}));
  connect(con.y, enaNexCWP.uStaDow)
    annotation (Line(points={{-178,30},{-96,30},{-96,-12},{-2,-12}},
      color={255,0,255}));
  connect(lat.y, yStaPro)
    annotation (Line(points={{-118,150},{-100,150},{-100,190},{260,190}},
      color={255,0,255}));
  connect(and2.y, enaHeaCon.uUpsDevSta)
    annotation (Line(points={{42,-116},{50,-116},{50,-136},{58,-136}},
      color={255,0,255}));
  connect(con.y, chiDemRed.uStaDow)
    annotation (Line(points={{-178,30},{-96,30},{-96,118},{-82,118}},
      color={255,0,255}));
  connect(con1.y, chiDemRed.yOpeParLoaRatMin)
    annotation (Line(points={{-178,90},{-140,90},{-140,121},{-82,121}},
      color={0,0,127}));
  connect(uChi, minChiWatFlo.uChi)
    annotation (Line(points={{-260,80},{-220,80},{-220,44},{18,44}},
      color={255,0,255}));
  connect(nexChi.yNexEnaChi, minChiWatFlo.nexEnaChi)
    annotation (Line(points={{-58,174},{-36,174},{-36,41},{18,41}},
      color={255,127,0}));
  connect(nexChi.yDisSmaChi, minChiWatFlo.nexDisChi)
    annotation (Line(points={{-58,170.8},{-40,170.8},{-40,39},{18,39}},
      color={255,127,0}));
  connect(con.y, minChiWatFlo.uSubCha)
    annotation (Line(points={{-178,30},{-96,30},{-96,36},{18,36}},
      color={255,0,255}));
  connect(nexChi.yOnOff, chiDemRed.uOnOff)
    annotation (Line(points={{-58,167},{-44,167},{-44,140},{-92,140},{-92,115},
          {-82,115}},color={255,0,255}));
  connect(minChiWatFlo.yChiWatMinFloSet, minBypSet.VMinChiWat_setpoint)
    annotation (Line(points={{42,40},{50,40},{50,76},{58,76}},
      color={0,0,127}));
  connect(minChiWatFlo.yChiWatMinFloSet, swi1.u3)
    annotation (Line(points={{42,40},{50,40},{50,32},{198,32}},
      color={0,0,127}));
  connect(conWatPumCon.yDesConWatPumSpe, yDesConWatPumSpe)
    annotation (Line(points={{82,-57},{120,-57},{120,-60},{260,-60}},
      color={0,0,127}));
  connect(conWatPumCon.uChiConIsoVal, uChiConIsoVal)
    annotation (Line(points={{58,-50},{48,-50},{48,10},{-260,10}},
      color={255,0,255}));
  connect(mulOr.y, conWatPumCon.uLeaChiSta)
    annotation (Line(points={{-118,-52},{44,-52},{44,-54},{58,-54}},
      color={255,0,255}));
  connect(mulOr.y, conWatPumCon.uLeaChiEna)
    annotation (Line(points={{-118,-52},{58,-52}},
      color={255,0,255}));
  connect(mulOr1.y, conWatPumCon.uLeaConWatReq)
    annotation (Line(points={{-58,-70},{-10,-70},{-10,-56},{58,-56}},
      color={255,0,255}));
  connect(conWatPumCon.uConWatPumSpeSet, uConWatPumSpeSet)
    annotation (Line(points={{58,-65},{-2,-65},{-2,-110},{-260,-110}},
      color={0,0,127}));
  connect(conWatPumCon.yConWatPumNum, yConWatPumNum)
    annotation (Line(points={{82,-63},{220,-63},{220,-90},{260,-90}},
      color={255,127,0}));
  connect(minChiWatFlo.yChiWatMinFloSet, endUp.VMinChiWat_setpoint)
    annotation (Line(points={{42,40},{50,40},{50,20},{-92,20},{-92,-280},{18,-280}},
      color={0,0,127}));
  connect(chiDemRed.yChiDemRed, lat1.u) annotation (Line(points={{-58,116},{-32,
          116},{-32,100},{-22,100}}, color={255,0,255}));
  connect(lat1.y, minBypSet.uUpsDevSta) annotation (Line(points={{2,100},{10,100},
          {10,88},{58,88}},   color={255,0,255}));
  connect(lat1.y, minChiWatFlo.uUpsDevSta) annotation (Line(points={{2,100},{10,
          100},{10,47},{18,47}}, color={255,0,255}));
  connect(minBypSet.yMinBypRes, lat2.u) annotation (Line(points={{82,80},{90,80},
          {90,70},{98,70}},   color={255,0,255}));
  connect(lat2.y, yTowStaUp) annotation (Line(points={{122,70},{140,70},{140,0},
          {260,0}},  color={255,0,255}));
  connect(lat2.y, enaNexCWP.uUpsDevSta) annotation (Line(points={{122,70},{140,70},
          {140,14},{-20,14},{-20,-2},{-2,-2}},      color={255,0,255}));
  connect(lat2.y, and2.u2) annotation (Line(points={{122,70},{140,70},{140,14},{
          -20,14},{-20,-124},{18,-124}},color={255,0,255}));
  connect(conWatPumCon.yPumSpeChe, lat3.u) annotation (Line(points={{82,-69},{110,
          -69},{110,-80},{118,-80}}, color={255,0,255}));
  connect(lat3.y, and2.u1) annotation (Line(points={{142,-80},{160,-80},{160,-98},
          {10,-98},{10,-116},{18,-116}}, color={255,0,255}));
  connect(enaHeaCon.yEnaHeaCon, lat4.u) annotation (Line(points={{82,-134},{110,
          -134},{110,-160},{118,-160}}, color={255,0,255}));
  connect(lat4.y, enaChiIsoVal.uUpsDevSta) annotation (Line(points={{142,-160},{
          160,-160},{160,-180},{40,-180},{40,-205},{58,-205}}, color={255,0,255}));
  connect(enaChiIsoVal.yEnaChiWatIsoVal, lat5.u) annotation (Line(points={{82,-194},
          {90,-194},{90,-220},{98,-220}}, color={255,0,255}));
  connect(lat5.y, booRep.u)
    annotation (Line(points={{122,-220},{138,-220}}, color={255,0,255}));
  connect(booRep.y, logSwi.u2) annotation (Line(points={{162,-220},{166,-220},{166,
          -130},{198,-130}}, color={255,0,255}));
  connect(booRep.y, swi.u2) annotation (Line(points={{162,-220},{166,-220},{166,
          -190},{198,-190}}, color={255,0,255}));
  connect(lat5.y, endUp.uEnaChiWatIsoVal) annotation (Line(points={{122,-220},{130,
          -220},{130,-242},{0,-242},{0,-262},{18,-262}}, color={255,0,255}));
  connect(endUp.endStaTri, lat.clr) annotation (Line(points={{42,-279},{60,-279},
          {60,-300},{-160,-300},{-160,144},{-142,144}}, color={255,0,255}));
  connect(endUp.endStaTri, lat1.clr) annotation (Line(points={{42,-279},{60,-279},
          {60,-300},{-160,-300},{-160,94},{-22,94}},   color={255,0,255}));
  connect(endUp.endStaTri, lat2.clr) annotation (Line(points={{42,-279},{60,-279},
          {60,-300},{-160,-300},{-160,64},{98,64}},   color={255,0,255}));
  connect(endUp.endStaTri, lat3.clr) annotation (Line(points={{42,-279},{60,-279},
          {60,-300},{-160,-300},{-160,-86},{118,-86}}, color={255,0,255}));
  connect(endUp.endStaTri, lat4.clr) annotation (Line(points={{42,-279},{60,-279},
          {60,-300},{-160,-300},{-160,-166},{118,-166}}, color={255,0,255}));
  connect(uStaSet, nexChi.uStaSet) annotation (Line(points={{-260,200},{-104,200},
          {-104,177},{-82,177}}, color={255,127,0}));
  connect(nexChi.uChiSet, uChiSet)
    annotation (Line(points={{-82,170},{-260,170}}, color={255,0,255}));
  connect(uStaSet, cha.u) annotation (Line(points={{-260,200},{-220,200},{-220,150},
          {-202,150}}, color={255,127,0}));
  connect(uStaSet, enaNexCWP.uStaSet) annotation (Line(points={{-260,200},{-104,
          200},{-104,-19},{-2,-19}}, color={255,127,0}));
  connect(uChiSta, enaNexCWP.uChiSta) annotation (Line(points={{-260,-10},{-180,
          -10},{-180,-15},{-2,-15}}, color={255,127,0}));
  connect(enaHeaCon.uChiHeaCon, uChiHeaCon) annotation (Line(points={{58,-148},{
          -48,-148},{-48,-220},{-260,-220}}, color={255,0,255}));
  connect(uChiHeaCon, endUp.uChiHeaCon) annotation (Line(points={{-260,-220},{-48,
          -220},{-48,-276},{18,-276}}, color={255,0,255}));
  connect(conWatPumCon.uConWatPum, uConWatPum) annotation (Line(points={{58,-69},
          {6,-69},{6,-190},{-260,-190}}, color={255,0,255}));
  connect(endUp.endStaTri, lat5.clr) annotation (Line(points={{42,-279},{60,-279},
          {60,-300},{-160,-300},{-160,-226},{98,-226}}, color={255,0,255}));
  connect(lat.y, or2.u1)
    annotation (Line(points={{-118,150},{-22,150}}, color={255,0,255}));
  connect(con.y, or2.u2) annotation (Line(points={{-178,30},{-96,30},{-96,142},{
          -22,142}}, color={255,0,255}));
  connect(or2.y, minBypSet.uUpsDevSta) annotation (Line(points={{2,150},{10,150},
          {10,88},{58,88}},   color={255,0,255}));
  connect(or2.y, minChiWatFlo.uUpsDevSta) annotation (Line(points={{2,150},{10,150},
          {10,47},{18,47}}, color={255,0,255}));
  connect(intEqu.y, and1.u2) annotation (Line(points={{-118,280},{-110,280},{-110,
          292},{-102,292}}, color={255,0,255}));
  connect(conInt.y, intEqu.u1) annotation (Line(points={{-198,300},{-180,300},{-180,
          280},{-142,280}}, color={255,127,0}));
  connect(uStaSet, intEqu.u2) annotation (Line(points={{-260,200},{-220,200},{-220,
          272},{-142,272}}, color={255,127,0}));
  connect(cha.up, and1.u1) annotation (Line(points={{-178,156},{-170,156},{-170,
          300},{-102,300}}, color={255,0,255}));
  connect(and1.y, logSwi1.u3) annotation (Line(points={{-78,300},{-60,300},{-60,
          232},{-42,232}}, color={255,0,255}));
  connect(cha.up, logSwi1.u1) annotation (Line(points={{-178,156},{-170,156},{-170,
          248},{-42,248}}, color={255,0,255}));
  connect(logSwi1.y, lat.u) annotation (Line(points={{-18,240},{0,240},{0,210},{
          -160,210},{-160,150},{-142,150}}, color={255,0,255}));
  connect(uEnaPlaConPum, conWatPumCon.uEnaPla) annotation (Line(points={{-260,-36},
          {40,-36},{40,-58},{58,-58}}, color={255,0,255}));
  connect(uEnaPlaConIso, enaHeaCon.uEnaPla) annotation (Line(points={{-260,-160},
          {-52,-160},{-52,-132},{58,-132}}, color={255,0,255}));
  connect(endUp.endStaTri, yEndStaTri) annotation (Line(points={{42,-279},{60,-279},
          {60,-300},{260,-300}}, color={255,0,255}));
  connect(endUp.endStaTri, nexChi.endPro) annotation (Line(points={{42,-279},{
          60,-279},{60,-300},{-160,-300},{-160,163},{-82,163}}, color={255,0,
          255}));
  connect(con2.y, truDel.u)
    annotation (Line(points={{-178,230},{-142,230}}, color={255,0,255}));
  connect(truDel.y, logSwi1.u2) annotation (Line(points={{-118,230},{-80,230},{
          -80,240},{-42,240}}, color={255,0,255}));
  connect(minChiWatFlo.yChaSet, minBypSet.uSetChaPro) annotation (Line(points={
          {42,32},{46,32},{46,72},{58,72}}, color={255,0,255}));
annotation (
  defaultComponentName="upProCon",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-240,-320},{240,320}}), graphics={
          Rectangle(
          extent={{-238,318},{158,202}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-40,302},{138,260}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="The Change block in default has initial input of zero.
This is to avoid the initial edge.")}),
    Icon(coordinateSystem(extent={{-100,-200},{100,200}}), graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,240},{120,200}},
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
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,198},{-58,186}},
          textColor={255,127,0},
          textString="uStaSet"),
        Text(
          extent={{-100,106},{-70,94}},
          textColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{-96,58},{-32,44}},
          textColor={255,0,255},
          textString="uChiConIsoVal"),
        Text(
          extent={{-96,-12},{-38,-26}},
          textColor={255,0,255},
          textString="uConWatReq"),
        Text(
          extent={{-100,-34},{-64,-46}},
          textColor={255,0,255},
          textString="uWSE",
          visible=have_WSE),
        Text(
          extent={{-98,-184},{-48,-196}},
          textColor={255,0,255},
          textString="uChiWatReq"),
        Text(
          extent={{-96,128},{-60,116}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiLoa",
          visible=need_reduceChillerDemand),
        Text(
          extent={{-96,84},{-40,70}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{-96,-50},{-12,-68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatPumSpeSet",
          visible=not have_fixSpeConWatPum),
        Text(
          extent={{-96,-72},{-22,-86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatPumSpe",
          visible=not have_fixSpeConWatPum),
        Text(
          extent={{-96,-164},{-36,-176}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatIsoVal"),
        Text(
          extent={{60,198},{100,186}},
          textColor={255,0,255},
          textString="yStaPro"),
        Text(
          extent={{52,78},{98,66}},
          textColor={255,0,255},
          textString="yTowStaUp"),
        Text(
          extent={{58,38},{96,26}},
          textColor={255,0,255},
          textString="yLeaPum"),
        Text(
          extent={{48,-82},{96,-96}},
          textColor={255,0,255},
          textString="yChiHeaCon"),
        Text(
          extent={{76,-162},{100,-174}},
          textColor={255,0,255},
          textString="yChi"),
        Text(
          extent={{60,158},{96,146}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiDem",
          visible=need_reduceChillerDemand),
        Text(
          extent={{28,118},{98,104}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatMinFloSet"),
        Text(
          extent={{18,-4},{98,-14}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDesConWatPumSpe",
          visible=not have_fixSpeConWatPum),
        Text(
          extent={{36,-130},{96,-146}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatIsoVal"),
        Text(
          extent={{34,-42},{96,-56}},
          textColor={255,127,0},
          textString="yConWatPumNum"),
        Text(
          extent={{-100,168},{-60,156}},
          textColor={255,0,255},
          textString="uChiSet"),
        Text(
          extent={{-98,36},{-56,24}},
          textColor={255,127,0},
          textString="uChiSta"),
        Text(
          extent={{-98,-144},{-48,-156}},
          textColor={255,0,255},
          textString="uChiHeaCon"),
        Text(
          extent={{-96,-122},{-38,-136}},
          textColor={255,0,255},
          textString="uConWatPum",
          visible=have_fixSpeConWatPum),
        Text(
          extent={{-96,-92},{-30,-106}},
          textColor={255,0,255},
          textString="uEnaPlaConIso"),
        Text(
          extent={{-96,16},{-24,2}},
          textColor={255,0,255},
          textString="uEnaPlaConPum"),
        Text(
          extent={{50,-182},{98,-196}},
          textColor={255,0,255},
          textString="yEndStaTri"),
        Text(
          extent={{-100,146},{-60,134}},
          textColor={255,0,255},
          textString="endPro")}),
Documentation(info="<html>
<p>
Block that controls devices when there is a stage-up command. This sequence is for
water-cooled primary-only parallel chiller plants with headered chilled water pumps
and headered condenser water pumps, or air-cooled primary-only parallel chiller
plants with headered chilled water pumps.
This development is based on ASHRAE RP-1711 Advanced Sequences of Operation for
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft on March 23, 2020),
section 5.2.4.16, which specifies the step-by-step control of
devices during chiller staging up process.
</p>
<ol>
<li>
Identify the chiller(s) that should be enabled (and disabled, if <code>have_ponyChiller=true</code>).
This is implemented in block <code>nexChi</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller</a>
for more decriptions.
</li>
<li>
Command operating chillers to reduce demand to 75% (<code>chiDemRedFac</code>) of
their current load (<code>uChiLoa</code>). Wait until actual demand &lt; 80% of
current load up to a maximum of 5 minutes (<code>holChiDemTim</code>) before proceeding.
This is implemented in block <code>chiDemRed</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand</a>
for more decriptions.
</li>
<li>
Reset the minimum chilled water flow setpoint,
<ul>
<li>
For any stage change during which a smaller chiller is disabled and a larger chiller
is enabled, slowly change (<code>byPasSetTim</code>) the minimum chilled water flow
setpoint to the one that includes both chillers are enabled. After new setpoint is
achieved, wait 1 minute (<code>aftByPasSetTim</code>) to allow loop to stabilize.
</li>
<li>
For any other stage change, reset ((<code>byPasSetTim</code>)) the minimum chilled
water flow setpoint to the one that includes the new chiller. After new setpoint is
achieved, wait 1 minute (<code>aftByPasSetTim</code>) to allow loop to stabilize.
</li>
</ul>
The minimum flow setpoint is reset in block <code>minChiWatFlo</code>
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint</a>).
Block <code>minBypSet</code> checks if the new setpoint is achieved
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass</a>).
</li>
<li>
Start the next condenser water pump and/or change condenser water pump speed
to that required of the new stage. Wait 10 seconds (<code>thrTimEnb</code>).
Block <code>enaNexCWP</code> identifies chiller stage for the condenser water pump
control
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableCWPump\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableCWPump</a>)
and block <code>conWatPumCon</code> checks if the condenser water pumps have been reset
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller</a>).
</li>
<li>
Enabled head pressure control for the chiller being enabled. Wait 30 seconds (<code>waiTim</code>).
This is implemented in block <code>enaHeaCon</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl</a>
for more decriptions.
</li>
<li>
Slowly (<code>chaChiWatIsoTim</code>) open chilled water isolation valve of the chiller
being enabled. The valve timing should be determined in the fields.
This is implemented in block <code>enaChiIsoVal</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal</a>
for more decriptions.
</li>
<li>
End the staging up process:
<ul>
<li>
If the stage change does not require one chiller enabled and another chiller disabled,
start the next stage chiller after the isolation valve is fully open.
</li>
<li>
If the stage change does require one chiller enabled and another chiller disabled,
starting the next stage chiller after the isolation valve is fully open, then shut off
the smaller chiller, close the chiller's chilled water isolation valve, disable
the head pressure control loop, and change the minimum chilled water flow setpoint
to the one for the new stage.
</li>
<li>
Release the demand limit, which marks the end of the staging process.
</li>
</ul>
These are implemented in block <code>endUp</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd</a>
for more decriptions.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
September 23, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Up;
