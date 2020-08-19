within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes;
block Up "Sequence for control devices when there is stage-up command"

  parameter Integer nChi=2 "Total number of chillers in the plant";
  parameter Integer totSta=6
    "Total number of stages, including the stages with a WSE, if applicable";
  parameter Boolean have_WSE=true
    "True: have waterside economizer";
  parameter Boolean have_PonyChiller=false
    "True: have pony chiller";
  parameter Boolean is_parChi=true
    "True: the plant has parallel chillers";
  parameter Boolean is_heaPum=true
    "True: headered condenser water pumps";
  parameter Real chiDemRedFac=0.75
    "Demand reducing factor of current operating chillers"
    annotation (Dialog(group="Limit chiller demand"));
  parameter Real holChiDemTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=300
    "Maximum time to wait for the actual demand less than percentage of current load"
    annotation (Dialog(group="Limit chiller demand"));
  parameter Real byPasSetTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=300
    "Time to reset minimum bypass flow"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real minFloSet[nChi](
    final unit=fill("m3/s",nChi),
    final quantity=fill("VolumeFlowRate",nChi),
    displayUnit=fill("m3/s",nChi))={0.0089,0.0089}
      "Minimum chilled water flow through each chiller"
    annotation (Evaluate=true, Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real maxFloSet[nChi](
    final unit=fill("m3/s",nChi),
    final quantity=fill("VolumeFlowRate",nChi),
    displayUnit=fill("m3/s",nChi))={0.025,0.025}
      "Maximum chilled water flow through each chiller"
    annotation (Evaluate=true, Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real aftByPasSetTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=60
    "Time to allow loop to stabilize after resetting minimum chilled water flow setpoint"
    annotation (Dialog(group="Reset bypass"));
  parameter Real staVec[totSta]={0,0.5,1,1.5,2,2.5}
    "Chiller stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(group="Enable condenser water pump"));
  parameter Real desConWatPumSpe[totSta]={0,0.5,0.75,0.6,0.75,0.9}
    "Design condenser water pump speed setpoints, the size should be double of total stage numbers"
    annotation (Dialog(group="Enable condenser water pump"));
  parameter Real desConWatPumNum[totSta]={0,1,1,2,2,2}
    "Design number of condenser water pumps that should be ON, the size should be double of total stage numbers"
    annotation (Dialog(group="Enable condenser water pump"));
  parameter Real thrTimEnb(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=10
    "Threshold time to enable head pressure control after condenser water pump being reset"
    annotation (Dialog(group="Enable head pressure control"));
  parameter Real waiTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=30
    "Waiting time after enabling next head pressure control"
    annotation (Dialog(group="Enable head pressure control"));
  parameter Real chaChiWatIsoTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=300
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(group="Enable CHW isolation valve"));
  parameter Real proOnTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=300
    "Threshold time to check after newly enabled chiller being operated"
    annotation (Dialog(group="Enable next chiller",enable=have_PonyChiller));
  parameter Real relSpeDif = 0.05
    "Relative error to the setpoint for checking if it has achieved speed setpoint"
    annotation (Dialog(tab="Advanced", group="Enable condenser water pump"));
  parameter Real relFloDif=0.05
    "Relative error to the setpoint for checking if it has achieved flow rate setpoint"
    annotation (Dialog(tab="Advanced", group="Reset bypass"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Chiller stage setpoint index"
    annotation (Placement(transformation(extent={{-280,230},{-240,270}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiSet[nChi]
    "Vector of chillers status setpoint"
    annotation (Placement(transformation(extent={{-280,200},{-240,240}}),
      iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa[nChi](
    final quantity=fill("HeatFlowRate", nChi),
    final unit=fill("W", nChi))
    "Current chiller load"
    annotation (Placement(transformation(extent={{-280,150},{-240,190}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-280,110},{-240,150}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-280,80},{-240,120}}),
      iconTransformation(extent={{-140,56},{-100,96}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiConIsoVal[nChi]
    "Chiller condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-280,40},{-240,80}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage, it would the same as chiller stage setpoint when it is not in staging process"
    annotation (Placement(transformation(extent={{-280,10},{-240,50}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water requst status for each chiller"
    annotation (Placement(transformation(extent={{-280,-30},{-240,10}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if have_WSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-280,-60},{-240,-20}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpeSet(
    final min=0,
    final max=1,
    final unit="1")
    "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{-280,-90},{-240,-50}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-280,-120},{-240,-80}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-280,-150},{-240,-110}}),
      iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water requst status for each chiller"
    annotation (Placement(transformation(extent={{-280,-240},{-240,-200}}),
      iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaPro
    "Indicate if it is in stage-up process: true=in stage-up process"
    annotation (Placement(transformation(extent={{240,180},{280,220}}),
      iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    final quantity=fill("HeatFlowRate", nChi),
    final unit=fill("W", nChi))
    "Chiller demand setpoint"
    annotation (Placement(transformation(extent={{240,140},{280,180}}),
      iconTransformation(extent={{100,130},{140,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinFloSet(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{240,70},{280,110}}),
      iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowStaUp
    "Tower stage up status: true=stage up cooling tower"
    annotation (Placement(transformation(extent={{240,30},{280,70}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum
    "Lead condenser water pump status"
    annotation (Placement(transformation(extent={{240,0},{280,40}}),
      iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDesConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Condenser water pump design speed at current stage"
    annotation (Placement(transformation(extent={{240,-30},{280,10}}),
      iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yConWatPumNum
    "Number of operating condenser water pumps"
    annotation (Placement(transformation(extent={{240,-60},{280,-20}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{240,-100},{280,-60}}),
      iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{240,-160},{280,-120}}),
      iconTransformation(extent={{100,-160},{140,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{240,-240},{280,-200}}),
      iconTransformation(extent={{100,-210},{140,-170}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Check if stage setpoint increases"
    annotation (Placement(transformation(extent={{-200,190},{-180,210}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller
    nexChi(final nChi=nChi) "Identify next enabling chiller"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand
    chiDemRed(
    final nChi=nChi,
    final chiDemRedFac=chiDemRedFac,
    final holChiDemTim=holChiDemTim) "Limit chiller demand"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint
    minChiWatFlo(
    final nChi=nChi,
    final is_parChi=is_parChi,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet) "Minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass
    minBypSet(
    final aftByPasSetTim=aftByPasSetTim,
    final relFloDif=relFloDif)
    "Check if minium bypass has been reset"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableCWPump
    enaNexCWP
    "Identify correct stage number for enabling next condenser water pump"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    conWatPumCon(
    final is_heaPum=is_heaPum,
    final have_WSE=have_WSE,
    final nChi=nChi,
    final totSta=totSta,
    final staVec=staVec,
    final desConWatPumSpe=desConWatPumSpe,
    final desConWatPumNum=desConWatPumNum,
    final relSpeDif=relSpeDif)
    "Enabling next condenser water pump or change pump speed"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl
    enaHeaCon(
    final nChi=nChi,
    final thrTimEnb=thrTimEnb,
    final waiTim=waiTim,
    final heaStaCha=true)
    "Enabling head pressure control for next enabling chiller"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal
    enaChiIsoVal(
    final nChi=nChi,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final iniValPos=0,
    final endValPos=1)
    "Enable chilled water isolation valve for next enabling chiller"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd
    endUp(
    final nChi=nChi,
    final is_parChi=is_parChi,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final maxFloSet=maxFloSet,
    final proOnTim=proOnTim,
    final minFloSet=minFloSet,
    final byPasSetTim=byPasSetTim,
    final aftByPasSetTim=aftByPasSetTim,
    final relFloDif=relFloDif) "End stage-up process"
    annotation (Placement(transformation(extent={{20,-230},{40,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-200,70},{-180,90}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(final nu=nChi) "Multiple or"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(final nu=nChi) "Multiple or"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{200,-150},{220,-130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,-180},{160,-160}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{200,-90},{220,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{200,80},{220,100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Maintain ON signal when chiller demand has been limited"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Maintain ON signal when minimum chilled water flow has been reset"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3
    "Maintain ON signal when condenser water pump has been enabled"
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat4
    "Maintain ON signal when chiller head pressure control has been enabled"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat5
    "Maintain ON signal when chilled water isolation valve has been open"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));

equation
  connect(lat.y,chiDemRed.uDemLim)
    annotation (Line(points={{-118,200},{-100,200},{-100,179},{-82,179}},
      color={255,0,255}));
  connect(chiDemRed.uChiLoa, uChiLoa)
    annotation (Line(points={{-82,175},{-180,175},{-180,170},{-260,170}},
      color={0,0,127}));
  connect(chiDemRed.uChi, uChi)
    annotation (Line(points={{-82,161},{-220,161},{-220,130},{-260,130}},
      color={255,0,255}));
  connect(lat.y, minBypSet.chaPro)
    annotation (Line(points={{-118,200},{-100,200},{-100,134},{58,134}},
      color={255,0,255}));
  connect(minBypSet.VChiWat_flow, VChiWat_flow)
    annotation (Line(points={{58,126},{-156,126},{-156,100},{-260,100}},
      color={0,0,127}));
  connect(lat.y, minChiWatFlo.uStaUp)
    annotation (Line(points={{-118,200},{-100,200},{-100,99},{18,99}},
      color={255,0,255}));
  connect(con.y, minChiWatFlo.uStaDow)
    annotation (Line(points={{-178,80},{-96,80},{-96,81},{18,81}},
      color={255,0,255}));
  connect(lat.y, enaNexCWP.uStaUp)
    annotation (Line(points={{-118,200},{-100,200},{-100,42},{-2,42}},
      color={255,0,255}));
  connect(conWatPumCon.uWSE, uWSE)
    annotation (Line(points={{58,-14},{-4,-14},{-4,-40},{-260,-40}},
      color={255,0,255}));
  connect(conWatPumCon.uConWatPumSpe, uConWatPumSpe)
    annotation (Line(points={{58,-19},{4,-19},{4,-100},{-260,-100}},
      color={0,0,127}));
  connect(enaNexCWP.yChiSta, conWatPumCon.uChiSta)
    annotation (Line(points={{22,40},{40,40},{40,-11},{58,-11}},
      color={255,127,0}));
  connect(lat.y, enaHeaCon.chaPro)
    annotation (Line(points={{-118,200},{-100,200},{-100,-86},{58,-86}},
      color={255,0,255}));
  connect(nexChi.yNexEnaChi, enaHeaCon.nexChaChi)
    annotation (Line(points={{-58,229},{-36,229},{-36,-94},{58,-94}},
      color={255,127,0}));
  connect(nexChi.yNexEnaChi, enaChiIsoVal.nexChaChi)
    annotation (Line(points={{-58,229},{-36,229},{-36,-142},{58,-142}},
      color={255,127,0}));
  connect(enaChiIsoVal.uChiWatIsoVal, uChiWatIsoVal)
    annotation (Line(points={{58,-145},{-96,-145},{-96,-160},{-260,-160}},
      color={0,0,127}));
  connect(lat.y, enaChiIsoVal.chaPro)
    annotation (Line(points={{-118,200},{-100,200},{-100,-158},{58,-158}},
      color={255,0,255}));
  connect(nexChi.yNexEnaChi, endUp.nexEnaChi)
    annotation (Line(points={{-58,229},{-36,229},{-36,-208},{18,-208}},
      color={255,127,0}));
  connect(lat.y, endUp.uStaUp)
    annotation (Line(points={{-118,200},{-100,200},{-100,-210},{18,-210}},
      color={255,0,255}));
  connect(uChi, endUp.uChi)
    annotation (Line(points={{-260,130},{-220,130},{-220,-214},{18,-214}},
      color={255,0,255}));
  connect(endUp.uChiWatReq, uChiWatReq)
    annotation (Line(points={{18,-220},{-260,-220}},
      color={255,0,255}));
  connect(endUp.uChiWatIsoVal, uChiWatIsoVal)
    annotation (Line(points={{18,-222},{-96,-222},{-96,-160},{-260,-160}},
      color={0,0,127}));
  connect(uConWatReq, endUp.uConWatReq)
    annotation (Line(points={{-260,-10},{-164,-10},{-164,-224},{18,-224}},
      color={255,0,255}));
  connect(VChiWat_flow, endUp.VChiWat_flow)
    annotation (Line(points={{-260,100},{-156,100},{-156,-228},{18,-228}},
      color={0,0,127}));
  connect(uConWatReq, mulOr1.u)
    annotation (Line(points={{-260,-10},{-164,-10},{-164,-20},{-82,-20}},
      color={255,0,255}));
  connect(uChi, mulOr.u)
    annotation (Line(points={{-260,130},{-220,130},{-220,10},{-82,10}},
      color={255,0,255}));
  connect(chiDemRed.yChiDem, yChiDem)
    annotation (Line(points={{-58,174},{100,174},{100,160},{260,160}},
      color={0,0,127}));
  connect(conWatPumCon.yLeaPum, yLeaPum)
    annotation (Line(points={{82,-1},{120,-1},{120,20},{260,20}}, color={255,0,255}));
  connect(endUp.yChi, yChi)
    annotation (Line(points={{42,-211},{220,-211},{220,-220},{260,-220}},
      color={255,0,255}));
  connect(endUp.yChiWatIsoVal, swi.u1)
    annotation (Line(points={{42,-215},{184,-215},{184,-132},{198,-132}},
      color={0,0,127}));
  connect(swi.y, yChiWatIsoVal)
    annotation (Line(points={{222,-140},{260,-140}}, color={0,0,127}));
  connect(endUp.yChiHeaCon, logSwi.u1)
    annotation (Line(points={{42,-219},{172,-219},{172,-72},{198,-72}},
      color={255,0,255}));
  connect(enaHeaCon.yChiHeaCon, logSwi.u3)
    annotation (Line(points={{82,-96},{120,-96},{120,-88},{198,-88}},
      color={255,0,255}));
  connect(logSwi.y, yChiHeaCon)
    annotation (Line(points={{222,-80},{260,-80}}, color={255,0,255}));
  connect(enaChiIsoVal.yEnaChiWatIsoVal, swi1.u2)
    annotation (Line(points={{82,-144},{100,-144},{100,90},{198,90}},
      color={255,0,255}));
  connect(endUp.yChiWatMinSet, swi1.u1)
    annotation (Line(points={{42,-223},{180,-223},{180,98},{198,98}},
      color={0,0,127}));
  connect(swi1.y, yChiWatMinFloSet)
    annotation (Line(points={{222,90},{260,90}}, color={0,0,127}));
  connect(enaChiIsoVal.yChiWatIsoVal, swi.u3)
    annotation (Line(points={{82,-156},{100,-156},{100,-148},{198,-148}},
      color={0,0,127}));
  connect(nexChi.yDisSmaChi, endUp.nexDisChi)
    annotation (Line(points={{-58,224},{-40,224},{-40,-218},{18,-218}},
      color={255,127,0}));
  connect(nexChi.yOnOff, minChiWatFlo.uOnOff)
    annotation (Line(points={{-58,220},{-44,220},{-44,83},{18,83}},
      color={255,0,255}));
  connect(nexChi.yOnOff, endUp.uOnOff)
    annotation (Line(points={{-58,220},{-44,220},{-44,-216},{18,-216}},
      color={255,0,255}));
  connect(con.y, enaNexCWP.uStaDow)
    annotation (Line(points={{-178,80},{-96,80},{-96,38},{-2,38}},
      color={255,0,255}));
  connect(lat.y, yStaPro)
    annotation (Line(points={{-118,200},{260,200}}, color={255,0,255}));
  connect(and2.y, enaHeaCon.uUpsDevSta)
    annotation (Line(points={{42,-70},{50,-70},{50,-82},{58,-82}},
      color={255,0,255}));
  connect(con.y, chiDemRed.uStaDow)
    annotation (Line(points={{-178,80},{-96,80},{-96,168},{-82,168}},
      color={255,0,255}));
  connect(con1.y, chiDemRed.yOpeParLoaRatMin)
    annotation (Line(points={{-178,140},{-140,140},{-140,171},{-82,171}},
      color={0,0,127}));
  connect(uChi, minChiWatFlo.uChi)
    annotation (Line(points={{-260,130},{-220,130},{-220,94},{18,94}},
      color={255,0,255}));
  connect(nexChi.yNexEnaChi, minChiWatFlo.nexEnaChi)
    annotation (Line(points={{-58,229},{-36,229},{-36,91},{18,91}},
      color={255,127,0}));
  connect(nexChi.yDisSmaChi, minChiWatFlo.nexDisChi)
    annotation (Line(points={{-58,224},{-40,224},{-40,89},{18,89}},
      color={255,127,0}));
  connect(con.y, minChiWatFlo.uSubCha)
    annotation (Line(points={{-178,80},{-96,80},{-96,86},{18,86}},
      color={255,0,255}));
  connect(nexChi.yOnOff, chiDemRed.uOnOff)
    annotation (Line(points={{-58,220},{-44,220},{-44,190},{-92,190},{-92,165},
      {-82,165}}, color={255,0,255}));
  connect(minChiWatFlo.yChiWatMinFloSet, minBypSet.VMinChiWat_setpoint)
    annotation (Line(points={{42,90},{50,90},{50,122},{58,122}},
      color={0,0,127}));
  connect(minChiWatFlo.yChiWatMinFloSet, swi1.u3)
    annotation (Line(points={{42,90},{50,90},{50,82},{198,82}},
      color={0,0,127}));
  connect(conWatPumCon.yDesConWatPumSpe, yDesConWatPumSpe)
    annotation (Line(points={{82,-7},{120,-7},{120,-10},{260,-10}},
      color={0,0,127}));
  connect(conWatPumCon.uChiConIsoVal, uChiConIsoVal)
    annotation (Line(points={{58,0},{48,0},{48,60},{-260,60}},
      color={255,0,255}));
  connect(mulOr.y, conWatPumCon.uLeaChiSta)
    annotation (Line(points={{-58,10},{44,10},{44,-5},{58,-5}},
      color={255,0,255}));
  connect(mulOr.y, conWatPumCon.uLeaChiEna)
    annotation (Line(points={{-58,10},{44,10},{44,-3},{58,-3}},
      color={255,0,255}));
  connect(mulOr1.y, conWatPumCon.uLeaConWatReq)
    annotation (Line(points={{-58,-20},{-8,-20},{-8,-8},{58,-8}},
      color={255,0,255}));
  connect(conWatPumCon.uConWatPumSpeSet, uConWatPumSpeSet)
    annotation (Line(points={{58,-17},{0,-17},{0,-70},{-260,-70}},
      color={0,0,127}));
  connect(conWatPumCon.yConWatPumNum, yConWatPumNum)
    annotation (Line(points={{82,-13},{220,-13},{220,-40},{260,-40}},
      color={255,127,0}));
  connect(minChiWatFlo.yChiWatMinFloSet, endUp.VMinChiWat_setpoint)
    annotation (Line(points={{42,90},{50,90},{50,70},{-92,70},{-92,-230},{18,-230}},
      color={0,0,127}));
  connect(chiDemRed.yChiDemRed, lat1.u) annotation (Line(points={{-58,166},{-32,
          166},{-32,150},{-22,150}}, color={255,0,255}));
  connect(lat1.y, minBypSet.uUpsDevSta) annotation (Line(points={{2,150},{10,150},
          {10,138},{58,138}}, color={255,0,255}));
  connect(lat1.y, minChiWatFlo.uUpsDevSta) annotation (Line(points={{2,150},{10,
          150},{10,97},{18,97}}, color={255,0,255}));
  connect(minBypSet.yMinBypRes, lat2.u) annotation (Line(points={{82,130},{90,130},
          {90,120},{98,120}}, color={255,0,255}));
  connect(lat2.y, yTowStaUp) annotation (Line(points={{122,120},{140,120},{140,50},
          {260,50}}, color={255,0,255}));
  connect(lat2.y, enaNexCWP.uUpsDevSta) annotation (Line(points={{122,120},{140,
          120},{140,64},{-20,64},{-20,48},{-2,48}}, color={255,0,255}));
  connect(lat2.y, and2.u2) annotation (Line(points={{122,120},{140,120},{140,64},
          {-20,64},{-20,-78},{18,-78}}, color={255,0,255}));
  connect(conWatPumCon.yPumSpeChe, lat3.u) annotation (Line(points={{82,-19},{110,
          -19},{110,-30},{118,-30}}, color={255,0,255}));
  connect(lat3.y, and2.u1) annotation (Line(points={{142,-30},{160,-30},{160,-48},
          {10,-48},{10,-70},{18,-70}}, color={255,0,255}));
  connect(enaHeaCon.yEnaHeaCon, lat4.u) annotation (Line(points={{82,-84},{110,-84},
          {110,-110},{118,-110}}, color={255,0,255}));
  connect(lat4.y, enaChiIsoVal.uUpsDevSta) annotation (Line(points={{142,-110},{
          160,-110},{160,-130},{40,-130},{40,-155},{58,-155}}, color={255,0,255}));
  connect(enaChiIsoVal.yEnaChiWatIsoVal, lat5.u) annotation (Line(points={{82,-144},
          {90,-144},{90,-170},{98,-170}}, color={255,0,255}));
  connect(lat5.y, booRep.u)
    annotation (Line(points={{122,-170},{138,-170}}, color={255,0,255}));
  connect(booRep.y, logSwi.u2) annotation (Line(points={{162,-170},{166,-170},{166,
          -80},{198,-80}}, color={255,0,255}));
  connect(booRep.y, swi.u2) annotation (Line(points={{162,-170},{166,-170},{166,
          -140},{198,-140}}, color={255,0,255}));
  connect(lat5.y, endUp.uEnaChiWatIsoVal) annotation (Line(points={{122,-170},{130,
          -170},{130,-192},{0,-192},{0,-212},{18,-212}}, color={255,0,255}));
  connect(endUp.endStaTri, lat.clr) annotation (Line(points={{42,-229},{60,-229},
          {60,-250},{-160,-250},{-160,194},{-142,194}}, color={255,0,255}));
  connect(endUp.endStaTri, lat1.clr) annotation (Line(points={{42,-229},{60,-229},
          {60,-250},{-160,-250},{-160,144},{-22,144}}, color={255,0,255}));
  connect(endUp.endStaTri, lat2.clr) annotation (Line(points={{42,-229},{60,-229},
          {60,-250},{-160,-250},{-160,114},{98,114}}, color={255,0,255}));
  connect(endUp.endStaTri, lat3.clr) annotation (Line(points={{42,-229},{60,-229},
          {60,-250},{-160,-250},{-160,-36},{118,-36}}, color={255,0,255}));
  connect(endUp.endStaTri, lat4.clr) annotation (Line(points={{42,-229},{60,-229},
          {60,-250},{-160,-250},{-160,-116},{118,-116}}, color={255,0,255}));
  connect(endUp.endStaTri, lat5.clr) annotation (Line(points={{42,-229},{60,-229},
          {60,-250},{-160,-250},{-160,-176},{98,-176}}, color={255,0,255}));
  connect(uStaSet, nexChi.uStaSet) annotation (Line(points={{-260,250},{-104,250},
          {-104,227},{-82,227}}, color={255,127,0}));
  connect(lat.y, nexChi.chaPro) annotation (Line(points={{-118,200},{-100,200},{
          -100,213},{-82,213}}, color={255,0,255}));
  connect(nexChi.uChiSet, uChiSet)
    annotation (Line(points={{-82,220},{-260,220}}, color={255,0,255}));
  connect(uStaSet, cha.u) annotation (Line(points={{-260,250},{-220,250},{-220,200},
          {-202,200}}, color={255,127,0}));
  connect(cha.up, lat.u) annotation (Line(points={{-178,206},{-160,206},{-160,200},
          {-142,200}}, color={255,0,255}));
  connect(uStaSet, enaNexCWP.uStaSet) annotation (Line(points={{-260,250},{-104,
          250},{-104,31},{-2,31}}, color={255,127,0}));
  connect(uChiSta, enaNexCWP.uChiSta) annotation (Line(points={{-260,30},{-180,30},
          {-180,35},{-2,35}}, color={255,127,0}));
  connect(enaHeaCon.uChiHeaCon, uChiHeaCon) annotation (Line(points={{58,-98},{-48,
          -98},{-48,-130},{-260,-130}}, color={255,0,255}));
  connect(uChiHeaCon, endUp.uChiHeaCon) annotation (Line(points={{-260,-130},{-48,
          -130},{-48,-226},{18,-226}}, color={255,0,255}));

annotation (
  defaultComponentName="upProCon",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-240,-260},{240,260}})),
    Icon(coordinateSystem(extent={{-100,-200},{100,200}}), graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,240},{120,200}},
          lineColor={0,0,255},
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
          lineColor={255,127,0},
          textString="uStaSet"),
        Text(
          extent={{-100,106},{-70,94}},
          lineColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{-96,58},{-32,44}},
          lineColor={255,0,255},
          textString="uChiConIsoVal"),
        Text(
          extent={{-96,-12},{-38,-26}},
          lineColor={255,0,255},
          textString="uConWatReq"),
        Text(
          extent={{-100,-44},{-64,-56}},
          lineColor={255,0,255},
          textString="uWSE"),
        Text(
          extent={{-98,-184},{-48,-196}},
          lineColor={255,0,255},
          textString="uChiWatReq"),
        Text(
          extent={{-96,128},{-60,116}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiLoa"),
        Text(
          extent={{-96,84},{-40,70}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{-96,-70},{-12,-88}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatPumSpeSet"),
        Text(
          extent={{-96,-102},{-22,-116}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatPumSpe"),
        Text(
          extent={{-96,-164},{-36,-176}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatIsoVal"),
        Text(
          extent={{60,198},{100,186}},
          lineColor={255,0,255},
          textString="yStaPro"),
        Text(
          extent={{52,78},{98,66}},
          lineColor={255,0,255},
          textString="yTowStaUp"),
        Text(
          extent={{58,38},{96,26}},
          lineColor={255,0,255},
          textString="yLeaPum"),
        Text(
          extent={{48,-82},{96,-96}},
          lineColor={255,0,255},
          textString="yChiHeaCon"),
        Text(
          extent={{76,-182},{100,-194}},
          lineColor={255,0,255},
          textString="yChi"),
        Text(
          extent={{60,158},{96,146}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiDem"),
        Text(
          extent={{28,118},{98,104}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatMinFloSet"),
        Text(
          extent={{18,-4},{98,-14}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDesConWatPumSpe"),
        Text(
          extent={{36,-130},{96,-146}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatIsoVal"),
        Text(
          extent={{34,-42},{96,-56}},
          lineColor={255,127,0},
          textString="yConWatPumNum"),
        Text(
          extent={{-100,168},{-60,156}},
          lineColor={255,0,255},
          textString="uChiSet"),
        Text(
          extent={{-98,26},{-56,14}},
          lineColor={255,127,0},
          textString="uChiSta"),
        Text(
          extent={{-98,-134},{-48,-146}},
          lineColor={255,0,255},
          textString="uChiHeaCon")}),
Documentation(info="<html>
<p>
Block that controls devices when there is a stage-up command. This sequence is for
water-cooled primary-only parallel chiller plants with headered chilled water pumps
and headered condenser water pumps, or air-cooled primary-only parallel chiller
plants with headered chilled water pumps.
This development is based on ASHRAE RP-1711 Advanced Sequences of Operation for
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft version, March 2020),
section 5.2.4.16, which specifies the step-by-step control of
devices during chiller staging up process.
</p>
<ol>
<li>
Identify the chiller(s) that should be enabled (and disabled, if <code>have_PonyChiller=true</code>).
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
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint</a>).
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
