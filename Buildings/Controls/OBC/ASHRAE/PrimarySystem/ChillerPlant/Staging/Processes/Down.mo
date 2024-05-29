within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes;
block Down
  "Sequence for controlling devices when there is a stage-down command"

  parameter Integer nChi = 2 "Total number of chillers in the plant";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Integer totSta = 3
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
  parameter Boolean have_fixSpeConWatPum=false
    "True: fixed speed condenser water pump";
  parameter Boolean need_reduceChillerDemand=false
    "True: need limit chiller demand when chiller staging";
  parameter Real chiDemRedFac=0.75
    "Demand reducing factor of current operating chillers"
    annotation (Dialog(group="Disable last chiller", enable=have_ponyChiller and need_reduceChillerDemand));
  parameter Real holChiDemTim(
    unit="s",
    displayUnit="s")=300
    "Maximum time to wait for the actual demand less than percentage of current load"
    annotation (Dialog(group="Disable last chiller", enable=have_ponyChiller and need_reduceChillerDemand));
  parameter Real waiTim(
    unit="s",
    displayUnit="s")=30
    "Waiting time after enabling next head pressure control"
    annotation (Dialog(group="Disable last chiller", enable=have_ponyChiller));
  parameter Real proOnTim(
    unit="s",
    displayUnit="s")=300
    "Enabled chiller operation time to indicate if it is proven on"
    annotation (Dialog(group="Disable last chiller", enable=have_ponyChiller));
  parameter Real chaChiWatIsoTim(unit="s", displayUnit="s")
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(group="Disable CHW isolation valve"));
  parameter Real staVec[totSta]
    "Chiller stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(group="Disable condenser water pump"));
  parameter Real desConWatPumSpe[totSta]
    "Design condenser water pump speed setpoints, according to current chiller stage and WSE status"
    annotation (Dialog(group="Disable condenser water pump"));
  parameter Real desConWatPumNum[totSta]
    "Design number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(group="Disable condenser water pump"));
  parameter Real desChiNum[nChiSta]={0,1,2}
    "Design number of chiller that should be ON, according to current chiller stage"
    annotation (Dialog(group="Disable condenser water pump", enable=have_fixSpeConWatPum));
  parameter Real byPasSetTim(unit="s", displayUnit="s")
    "Time to reset minimum by-pass flow"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real minFloSet[nChi](
    unit=fill("m3/s",nChi),
    displayUnit=fill("m3/s",nChi))
    "Minimum chilled water flow through each chiller"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real maxFloSet[nChi](
    unit=fill("m3/s",nChi),
    displayUnit=fill("m3/s",nChi))
    "Maximum chilled water flow through each chiller"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real aftByPasSetTim(
    unit="s",
    displayUnit="s")=60
    "Time to allow loop to stabilize after resetting minimum chilled water flow setpoint"
    annotation (Dialog(group="Reset bypass"));
  parameter Real pumSpeChe = 0.05
    "Lower threshold value to check if condenser water pump has achieved setpoint"
    annotation (Dialog(tab="Advanced", group="Disable condenser water pump"));
  parameter Real relFloDif=0.05
    "Relative error to the setpoint for checking if it has achieved flow rate setpoint"
    annotation (Dialog(tab="Advanced", group="Reset bypass"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Chiller stage setpoint index"
    annotation (Placement(transformation(extent={{-320,360},{-280,400}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiSet[nChi]
    "Vector of chillers status setpoint"
    annotation (Placement(transformation(extent={{-320,320},{-280,360}}),
      iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yOpeParLoaRatMin(
    final min=0,
    final max=1,
    final unit="1") if need_reduceChillerDemand
    "Current stage minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-320,260},{-280,300}}),
      iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa[nChi](
    final quantity=fill("ElectricCurrent", nChi),
    final unit=fill("A", nChi)) if need_reduceChillerDemand
    "Current chiller load"
    annotation (Placement(transformation(extent={{-320,230},{-280,270}}),
      iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-320,200},{-280,240}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-320,170},{-280,210}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage, it would be the same as chiller stage setpoint when it is not in staging process"
    annotation (Placement(transformation(extent={{-320,140},{-280,180}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-320,110},{-280,150}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-320,80},{-280,120}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water requst status for each chiller"
    annotation (Placement(transformation(extent={{-320,-30},{-280,10}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water requst status for each chiller"
    annotation (Placement(transformation(extent={{-320,-140},{-280,-100}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiConIsoVal[nChi]
    "Chiller condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-320,-200},{-280,-160}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if have_WSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-320,-260},{-280,-220}}),
      iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpeSet(
    final min=0,
    final max=1,
    final unit="1") if not have_fixSpeConWatPum
    "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{-320,-300},{-280,-260}}),
      iconTransformation(extent={{-140,-170},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") if not have_fixSpeConWatPum
    "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-320,-360},{-280,-320}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[nConWatPum] if have_fixSpeConWatPum
    "Status indicating if condenser water pump is running"
    annotation (Placement(transformation(extent={{-320,-400},{-280,-360}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaPro
    "Indicate stage-down status: true=in stage-down process"
    annotation (Placement(transformation(extent={{280,340},{320,380}}),
      iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    final quantity=fill("ElectricCurrent", nChi),
    final unit=fill("A", nChi)) if need_reduceChillerDemand
    "Chiller demand setpoint"
    annotation (Placement(transformation(extent={{280,240},{320,280}}),
      iconTransformation(extent={{100,130},{140,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{280,200},{320,240}}),
      iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yReaDemLim
    if need_reduceChillerDemand
    "Release demand limit"
    annotation (Placement(transformation(extent={{280,160},{320,200}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{280,20},{320,60}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowStaDow
    "Tower stage down status: true=stage down cooling tower"
    annotation (Placement(transformation(extent={{280,-80},{320,-40}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{280,-120},{320,-80}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum
    "Lead condenser water pump status"
    annotation (Placement(transformation(extent={{280,-170},{320,-130}}),
      iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDesConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") if not have_fixSpeConWatPum
    "Condenser water pump design speed at current stage"
    annotation (Placement(transformation(extent={{280,-200},{320,-160}}),
      iconTransformation(extent={{100,-130},{140,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yConWatPumNum
    "Number of operating condenser water pumps"
    annotation (Placement(transformation(extent={{280,-240},{320,-200}}),
      iconTransformation(extent={{100,-150},{140,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinFloSet(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{280,-350},{320,-310}}),
      iconTransformation(extent={{100,-180},{140,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndStaTri
    "Staging end trigger"
    annotation (Placement(transformation(extent={{280,-390},{320,-350}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Check if stage setpoint dicreases"
    annotation (Placement(transformation(extent={{-240,350},{-220,370}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller
    nexChi(final nChi=nChi) "Identify next enabling chiller"
    annotation (Placement(transformation(extent={{-40,330},{-20,350}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart
    dowSta(
    final nChi=nChi,
    final have_parChi=have_parChi,
    final need_reduceChillerDemand=need_reduceChillerDemand,
    final chiDemRedFac=chiDemRedFac,
    final holChiDemTim=holChiDemTim,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet,
    final aftByPasSetTim=aftByPasSetTim,
    final relFloDif=relFloDif,
    final byPasSetTim=byPasSetTim,
    final waiTim=waiTim,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final proOnTim=proOnTim) "Start stage-down process"
    annotation (Placement(transformation(extent={{60,220},{80,240}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal
    disChiIsoVal(
    final nChi=nChi,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final iniValPos=1,
    final endValPos=0) "Disable isolation valve of the chiller being disabled"
    annotation (Placement(transformation(extent={{200,50},{220,70}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl
    disHeaCon(
    final nChi=nChi,
    final thrTimEnb=0,
    final waiTim=0,
    final heaStaCha=false)
    "Disable head pressure control of the chiller being disabled"
    annotation (Placement(transformation(extent={{200,-110},{220,-90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableCWPump
    disNexCWP
    "Identify correct stage number for disabling next condenser water pump"
    annotation (Placement(transformation(extent={{100,-170},{120,-150}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    conWatPumCon(
    final have_heaPum=have_heaConWatPum,
    final have_WSE=have_WSE,
    final fixSpe=have_fixSpeConWatPum,
    final nChi=nChi,
    final nConWatPum=nConWatPum,
    final totSta=totSta,
    final nChiSta=nChiSta,
    final staVec=staVec,
    final desConWatPumSpe=desConWatPumSpe,
    final desConWatPumNum=desConWatPumNum,
    final desChiNum=desChiNum,
    final pumSpeChe=pumSpeChe)
    "Enabling next condenser water pump or change pump speed"
    annotation (Placement(transformation(extent={{140,-192},{160,-172}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint
    minChiWatFlo(
    final nChi=nChi,
    final have_parChi=have_parChi,
    final maxFloSet=maxFloSet,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet) "Minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{100,-330},{120,-310}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass
    minBypSet(
    final aftByPasSetTim=aftByPasSetTim,
    final relFloDif=relFloDif)
    "Check if minium bypass has been reset"
    annotation (Placement(transformation(extent={{100,-380},{120,-360}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-240,-20},{-220,0}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor curDisChi(
    final nin=nChi)
    "Current disabling chiller"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesEquThr(
    final t=0.5) "Check if the disabled chiller has not chilled water request"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2 "Logical switch"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{140,10},{160,30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi]
    "Chilled water isolvation valve position"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-240,-130},{-220,-110}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor curDisChi1(
    final nin=nChi)
    "Current disabling chiller"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesEquThr1(
    final t=0.5)
    "Check if the disabled chiller is not requiring condenser water"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 "Logical and"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi [nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr  mulOr(
    final nin=nChi) "Multiple or"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(final nin=nChi) "Multiple or"
    annotation (Placement(transformation(extent={{-40,-230},{-20,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-180,350},{-160,370}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{200,-250},{220,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{200,-380},{220,-360}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Break algebraic loop"
    annotation (Placement(transformation(extent={{160,-380},{180,-360}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Maintain ON signal when condenser water pump has been disabled"
    annotation (Placement(transformation(extent={{240,-270},{260,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Maintain ON signal when chiller demand has been limited"
    annotation (Placement(transformation(extent={{120,150},{140,170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiWatMinSet
    "Chilled water minimum flow set"
    annotation (Placement(transformation(extent={{200,-340},{220,-320}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3
    "Maintain ON signal when chilled water isolation valve has been disabled"
    annotation (Placement(transformation(extent={{200,-40},{220,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat4
    "Maintain ON signal when chiller head pressure control has been disabled"
    annotation (Placement(transformation(extent={{200,-140},{220,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));

  CDL.Logical.And                        and6 "Logical and"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  CDL.Logical.And                        and7 "Logical and"
    annotation (Placement(transformation(extent={{-26,-130},{-6,-110}})));
equation
  connect(nexChi.yEnaSmaChi,dowSta. nexEnaChi)
    annotation (Line(points={{-18,331},{30,331},{30,226},{58,226}},
      color={255,127,0}));
  connect(dowSta.uChiWatIsoVal, uChiWatIsoVal)
    annotation (Line(points={{58,222},{-60,222},{-60,100},{-300,100}},
      color={0,0,127}));
  connect(nexChi.yLasDisChi,dowSta. nexDisChi)
    annotation (Line(points={{-18,334},{20,334},{20,220},{58,220}},
      color={255,127,0}));
  connect(uChiWatReq, booToRea1.u)
    annotation (Line(points={{-300,-10},{-242,-10}}, color={255,0,255}));
  connect(booToRea1.y, curDisChi.u)
    annotation (Line(points={{-218,-10},{-102,-10}},color={0,0,127}));
  connect(curDisChi.y, lesEquThr.u)
    annotation (Line(points={{-78,-10},{-62,-10}}, color={0,0,127}));
  connect(nexChi.yOnOff, logSwi2.u2)
    annotation (Line(points={{-18,337},{0,337},{0,20},{58,20}},
      color={255,0,255}));
  connect(and4.y, logSwi2.u1)
    annotation (Line(points={{-18,30},{40,30},{40,28},{58,28}},
      color={255,0,255}));
  connect(nexChi.yLasDisChi, curDisChi.index)
    annotation (Line(points={{-18,334},{20,334},{20,120},{-140,120},{-140,-30},
          {-90,-30},{-90,-22}},
                            color={255,127,0}));
  connect(logSwi2.y, and1.u1)
    annotation (Line(points={{82,20},{138,20}}, color={255,0,255}));
  connect(nexChi.yLasDisChi, disChiIsoVal.nexChaChi)
    annotation (Line(points={{-18,334},{20,334},{20,68},{198,68}},
      color={255,127,0}));
  connect(and1.y,disChiIsoVal.uUpsDevSta)
    annotation (Line(points={{162,20},{180,20},{180,55},{198,55}},
      color={255,0,255}));
  connect(nexChi.yOnOff, booRep4.u)
    annotation (Line(points={{-18,337},{0,337},{0,80},{58,80}}, color={255,0,255}));
  connect(booRep4.y, swi.u2)
    annotation (Line(points={{82,80},{138,80}}, color={255,0,255}));
  connect(uChiWatIsoVal, swi.u3)
    annotation (Line(points={{-300,100},{88,100},{88,72},{138,72}},
      color={0,0,127}));
  connect(dowSta.yChiWatIsoVal, swi.u1)
    annotation (Line(points={{82,228},{96,228},{96,88},{138,88}},
      color={0,0,127}));
  connect(swi.y, disChiIsoVal.uChiWatIsoVal)
    annotation (Line(points={{162,80},{180,80},{180,65},{198,65}},
      color={0,0,127}));
  connect(uConWatReq, booToRea2.u)
    annotation (Line(points={{-300,-120},{-242,-120}}, color={255,0,255}));
  connect(booToRea2.y, curDisChi1.u)
    annotation (Line(points={{-218,-120},{-102,-120}},
                                                     color={0,0,127}));
  connect(curDisChi1.y, lesEquThr1.u)
    annotation (Line(points={{-78,-120},{-62,-120}}, color={0,0,127}));
  connect(logSwi2.y, and5.u1)
    annotation (Line(points={{82,20},{90,20},{90,-50},{50,-50},{50,-120},{78,
          -120}},
      color={255,0,255}));
  connect(uChi,dowSta. uChi)
    annotation (Line(points={{-300,220},{-200,220},{-200,234},{58,234}},
      color={255,0,255}));
  connect(nexChi.yLasDisChi, curDisChi1.index)
    annotation (Line(points={{-18,334},{20,334},{20,120},{-140,120},{-140,-140},
          {-90,-140},{-90,-132}},
                              color={255,127,0}));
  connect(nexChi.yOnOff, booRep1.u)
    annotation (Line(points={{-18,337},{0,337},{0,-70},{58,-70}},
      color={255,0,255}));
  connect(booRep1.y, logSwi.u2)
    annotation (Line(points={{82,-70},{138,-70}}, color={255,0,255}));
  connect(dowSta.yChiHeaCon, logSwi.u1)
    annotation (Line(points={{82,232},{100,232},{100,-62},{138,-62}},
      color={255,0,255}));
  connect(nexChi.yLasDisChi, disHeaCon.nexChaChi)
    annotation (Line(points={{-18,334},{20,334},{20,-104},{198,-104}},
      color={255,127,0}));
  connect(logSwi.y, disHeaCon.uChiHeaCon)
    annotation (Line(points={{162,-70},{180,-70},{180,-108},{198,-108}},
      color={255,0,255}));
  connect(con.y,disNexCWP. uStaUp)
    annotation (Line(points={{-138,200},{-120,200},{-120,-158},{98,-158}},
      color={255,0,255}));
  connect(disNexCWP.yChiSta, conWatPumCon.uChiSta)
    annotation (Line(points={{122,-160},{130,-160},{130,-183},{138,-183}},
      color={255,127,0}));
  connect(mulOr1.y, conWatPumCon.uLeaConWatReq)
    annotation (Line(points={{-18,-220},{46,-220},{46,-178},{138,-178}},
      color={255,0,255}));
  connect(uChi, mulOr.u)
    annotation (Line(points={{-300,220},{-200,220},{-200,-200},{-82,-200}},
      color={255,0,255}));
  connect(uConWatReq, mulOr1.u)
    annotation (Line(points={{-300,-120},{-250,-120},{-250,-220},{-42,-220}},
      color={255,0,255}));
  connect(conWatPumCon.uWSE, uWSE)
    annotation (Line(points={{138,-185},{52,-185},{52,-240},{-300,-240}},
      color={255,0,255}));
  connect(conWatPumCon.uConWatPumSpe, uConWatPumSpe)
    annotation (Line(points={{138,-189},{64,-189},{64,-340},{-300,-340}},
      color={0,0,127}));
  connect(con.y, minChiWatFlo.uStaUp)
    annotation (Line(points={{-138,200},{-120,200},{-120,-311},{98,-311}},
      color={255,0,255}));
  connect(nexChi.yOnOff, minChiWatFlo.uOnOff)
    annotation (Line(points={{-18,337},{0,337},{0,-327},{98,-327}},
      color={255,0,255}));
  connect(dowSta.yChiDem, yChiDem)
    annotation (Line(points={{82,239},{179.5,239},{179.5,260},{300,260}},
      color={0,0,127}));
  connect(dowSta.yChi, yChi)
    annotation (Line(points={{82,224},{180,224},{180,220},{300,220}},
      color={255,0,255}));
  connect(disChiIsoVal.yChiWatIsoVal, yChiWatIsoVal)
    annotation (Line(points={{222,54},{250,54},{250,40},{300,40}},
      color={0,0,127}));
  connect(lat.y, minBypSet.uStaPro) annotation (Line(points={{-158,360},{-140,
          360},{-140,328},{-260,328},{-260,-366},{98,-366}}, color={255,0,255}));
  connect(VChiWat_flow, minBypSet.VChiWat_flow)
    annotation (Line(points={{-300,190},{-170,190},{-170,-370},{98,-370}},
      color={0,0,127}));
  connect(VChiWat_flow, dowSta.VChiWat_flow)
    annotation (Line(points={{-300,190},{-170,190},{-170,232},{58,232}},
      color={0,0,127}));
  connect(uChiLoa,dowSta. uChiLoa)
    annotation (Line(points={{-300,250},{-170,250},{-170,236},{58,236}},
      color={0,0,127}));
  connect(lat.y,dowSta. uStaDow)
    annotation (Line(points={{-158,360},{-140,360},{-140,328},{-260,328},{-260,240},
          {58,240}},        color={255,0,255}));
  connect(lat.y, disChiIsoVal.uStaPro) annotation (Line(points={{-158,360},{-140,
          360},{-140,328},{-260,328},{-260,52},{198,52}}, color={255,0,255}));
  connect(lat.y, and4.u2)
    annotation (Line(points={{-158,360},{-140,360},{-140,328},{-260,328},{-260,22},
          {-42,22}},       color={255,0,255}));
  connect(lat.y, logSwi2.u3)
    annotation (Line(points={{-158,360},{-140,360},{-140,328},{-260,328},{-260,12},
          {58,12}},       color={255,0,255}));
  connect(lat.y, disHeaCon.uStaPro) annotation (Line(points={{-158,360},{-140,
          360},{-140,328},{-260,328},{-260,-100},{198,-100}}, color={255,0,255}));
  connect(lat.y, minChiWatFlo.uStaDow)
    annotation (Line(points={{-158,360},{-140,360},{-140,328},{-260,328},{-260,-329},
          {98,-329}},         color={255,0,255}));
  connect(lat.y,disNexCWP. uStaDow)
    annotation (Line(points={{-158,360},{-140,360},{-140,328},{-260,328},{-260,-162},
          {98,-162}},         color={255,0,255}));
  connect(lat.y, yStaPro)
    annotation (Line(points={{-158,360},{300,360}},color={255,0,255}));
  connect(dowSta.yOpeParLoaRatMin, yOpeParLoaRatMin)
    annotation (Line(points={{58,238},{40,238},{40,280},{-300,280}},
      color={0,0,127}));
  connect(conWatPumCon.uChiConIsoVal, uChiConIsoVal)
    annotation (Line(points={{138,-172},{-140,-172},{-140,-180},{-300,-180}},
      color={255,0,255}));
  connect(mulOr.y, conWatPumCon.uLeaChiEna)
    annotation (Line(points={{-58,-200},{40,-200},{40,-174},{138,-174}},
      color={255,0,255}));
  connect(mulOr.y, conWatPumCon.uLeaChiSta)
    annotation (Line(points={{-58,-200},{40,-200},{40,-176},{138,-176}},
      color={255,0,255}));
  connect(conWatPumCon.yDesConWatPumSpe, yDesConWatPumSpe)
    annotation (Line(points={{162,-179},{240,-179},{240,-180},{300,-180}},
      color={0,0,127}));
  connect(conWatPumCon.uConWatPumSpeSet, uConWatPumSpeSet)
    annotation (Line(points={{138,-187},{58,-187},{58,-280},{-300,-280}},
      color={0,0,127}));
  connect(uChi, minChiWatFlo.uChi)
    annotation (Line(points={{-300,220},{-200,220},{-200,-316},{98,-316}},
      color={255,0,255}));
  connect(nexChi.yLasDisChi, minChiWatFlo.nexDisChi)
    annotation (Line(points={{-18,334},{20,334},{20,-321},{98,-321}},
      color={255,127,0}));
  connect(nexChi.yEnaSmaChi, minChiWatFlo.nexEnaChi)
    annotation (Line(points={{-18,331},{30,331},{30,-319},{98,-319}},
      color={255,127,0}));
  connect(con.y, minChiWatFlo.uSubCha)
    annotation (Line(points={{-138,200},{-120,200},{-120,-324},{98,-324}},
      color={255,0,255}));
  connect(edg1.y, lat.clr)
    annotation (Line(points={{222,-370},{260,-370},{260,-390},{-190,-390},{-190,
          354},{-182,354}},     color={255,0,255}));
  connect(conWatPumCon.yConWatPumNum, yConWatPumNum)
    annotation (Line(points={{162,-185},{220,-185},{220,-220},{300,-220}},
      color={255,127,0}));
  connect(conWatPumCon.yLeaPum, yLeaPum)
    annotation (Line(points={{162,-173},{220,-173},{220,-150},{300,-150}},
      color={255,0,255}));
  connect(disHeaCon.yChiHeaCon, yChiHeaCon)
    annotation (Line(points={{222,-106},{260,-106},{260,-100},{300,-100}},
      color={255,0,255}));
  connect(minBypSet.yMinBypRes, pre.u)
    annotation (Line(points={{122,-370},{158,-370}}, color={255,0,255}));
  connect(pre.y, edg1.u)
    annotation (Line(points={{182,-370},{198,-370}}, color={255,0,255}));
  connect(dowSta.yReaDemLim, yReaDemLim)
    annotation (Line(points={{82,221},{92,221},{92,180},{300,180}},
      color={255,0,255}));
  connect(dowSta.yReaDemLim, lat2.u)
    annotation (Line(points={{82,221},{92,221},{92,160},{118,160}},
      color={255,0,255}));
  connect(edg1.y, lat2.clr)
    annotation (Line(points={{222,-370},{260,-370},{260,-390},{-190,-390},
      {-190,154},{118,154}}, color={255,0,255}));
  connect(lat2.y, and4.u1)
    annotation (Line(points={{142,160},{160,160},{160,140},{-80,140},{-80,30},
      {-42,30}}, color={255,0,255}));
  connect(conWatPumCon.yPumSpeChe, and2.u1)
    annotation (Line(points={{162,-191},{180,-191},{180,-240},{198,-240}},
      color={255,0,255}));
  connect(and2.y, lat1.u)
    annotation (Line(points={{222,-240},{230,-240},{230,-260},{238,-260}},
      color={255,0,255}));
  connect(edg1.y, lat1.clr)
    annotation (Line(points={{222,-370},{260,-370},{260,-390},{-190,-390},
      {-190,-266},{238,-266}}, color={255,0,255}));
  connect(lat1.y, minChiWatFlo.uUpsDevSta)
    annotation (Line(points={{262,-260},{270,-260},{270,-290},{-40,-290},
      {-40,-313},{98,-313}}, color={255,0,255}));
  connect(lat1.y, minBypSet.uUpsDevSta)
    annotation (Line(points={{262,-260},{270,-260},{270,-290},{-40,-290},
      {-40,-362},{98,-362}}, color={255,0,255}));
  connect(dowSta.yChiWatMinFloSet, chiWatMinSet.u3)
    annotation (Line(points={{82,236},{170,236},{170,-338},{198,-338}},
      color={0,0,127}));
  connect(minChiWatFlo.yChiWatMinFloSet, chiWatMinSet.u1)
    annotation (Line(points={{122,-320},{140,-320},{140,-322},{198,-322}},
      color={0,0,127}));
  connect(lat1.y, chiWatMinSet.u2)
    annotation (Line(points={{262,-260},{270,-260},{270,-290},{160,-290},
      {160,-330},{198,-330}}, color={255,0,255}));
  connect(chiWatMinSet.y, yChiWatMinFloSet)
    annotation (Line(points={{222,-330},{300,-330}}, color={0,0,127}));
  connect(chiWatMinSet.y, minBypSet.VMinChiWat_setpoint)
    annotation (Line(points={{222,-330},{240,-330},{240,-350},{60,-350},{60,
          -374},{98,-374}}, color={0,0,127}));
  connect(nexChi.yOnOff, dowSta.uOnOff)
    annotation (Line(points={{-18,337},{0,337},{0,228},{58,228}},
      color={255,0,255}));
  connect(edg1.y, dowSta.clr)
    annotation (Line(points={{222,-370},{260,-370},{260,-390},{-190,-390},
      {-190,230},{58,230}}, color={255,0,255}));
  connect(disChiIsoVal.yEnaChiWatIsoVal, lat3.u)
    annotation (Line(points={{222,66},{240,66},{240,0},{180,0},{180,-30},
      {198,-30}}, color={255,0,255}));
  connect(edg1.y, lat3.clr)
    annotation (Line(points={{222,-370},{260,-370},{260,-390},{-190,-390},
      {-190,-36},{198,-36}}, color={255,0,255}));
  connect(disHeaCon.yEnaHeaCon, lat4.u)
    annotation (Line(points={{222,-94},{240,-94},{240,-114},{180,-114},{180,
          -130},{198,-130}},  color={255,0,255}));
  connect(lat4.y, yTowStaDow)
    annotation (Line(points={{222,-130},{250,-130},{250,-60},{300,-60}},
      color={255,0,255}));
  connect(lat4.y, disNexCWP.uUpsDevSta)
    annotation (Line(points={{222,-130},{250,-130},{250,-142},{80,-142},{80,-152},
      {98,-152}}, color={255,0,255}));
  connect(lat4.y, and2.u2)
    annotation (Line(points={{222,-130},{250,-130},{250,-142},{80,-142},{80,-248},
      {198,-248}}, color={255,0,255}));
  connect(edg1.y, lat4.clr)
    annotation (Line(points={{222,-370},{260,-370},{260,-390},{-190,-390},
      {-190,-136},{198,-136}}, color={255,0,255}));
  connect(uStaSet, nexChi.uStaSet)
    annotation (Line(points={{-300,380},{-60,380},{-60,347},{-42,347}},
      color={255,127,0}));
  connect(nexChi.uChiSet, uChiSet)
    annotation (Line(points={{-42,340},{-300,340}}, color={255,0,255}));
  connect(uStaSet, cha.u)
    annotation (Line(points={{-300,380},{-260,380},{-260,360},{-242,360}},
      color={255,127,0}));
  connect(cha.down, lat.u)
    annotation (Line(points={{-218,354},{-200,354},{-200,360},{-182,360}},
      color={255,0,255}));
  connect(uStaSet, disNexCWP.uStaSet)
    annotation (Line(points={{-300,380},{-130,380},{-130,-169},{98,-169}},
      color={255,127,0}));
  connect(uChiSta, disNexCWP.uChiSta)
    annotation (Line(points={{-300,160},{-150,160},{-150,-165},{98,-165}},
      color={255,127,0}));
  connect(dowSta.uChiHeaCon, uChiHeaCon) annotation (Line(points={{58,224},{
          -110,224},{-110,130},{-300,130}},
                                       color={255,0,255}));
  connect(uChiHeaCon, logSwi.u3) annotation (Line(points={{-300,130},{-110,130},
          {-110,-86},{120,-86},{120,-78},{138,-78}}, color={255,0,255}));
  connect(conWatPumCon.uConWatPum, uConWatPum) annotation (Line(points={{138,-191},
          {70,-191},{70,-380},{-300,-380}}, color={255,0,255}));
  connect(con.y, disHeaCon.uEnaPla) annotation (Line(points={{-138,200},{-120,
          200},{-120,-92},{198,-92}},
                                 color={255,0,255}));
  connect(con.y, conWatPumCon.uEnaPla) annotation (Line(points={{-138,200},{
          -120,200},{-120,-180},{138,-180}}, color={255,0,255}));
  connect(and5.y, and3.u1)
    annotation (Line(points={{102,-120},{118,-120}},color={255,0,255}));
  connect(and3.y, disHeaCon.uUpsDevSta) annotation (Line(points={{142,-120},{
          160,-120},{160,-96},{198,-96}}, color={255,0,255}));
  connect(lat3.y, and3.u2) annotation (Line(points={{222,-30},{240,-30},{240,
          -50},{110,-50},{110,-128},{118,-128}}, color={255,0,255}));
  connect(edg1.y, yEndStaTri)
    annotation (Line(points={{222,-370},{300,-370}}, color={255,0,255}));
  connect(edg1.y, nexChi.endPro) annotation (Line(points={{222,-370},{260,-370},
          {260,-390},{-190,-390},{-190,333},{-42,333}}, color={255,0,255}));
  connect(lesEquThr.y, and6.u1)
    annotation (Line(points={{-38,-10},{58,-10}}, color={255,0,255}));
  connect(and6.y, and1.u2) annotation (Line(points={{82,-10},{120,-10},{120,12},
          {138,12}}, color={255,0,255}));
  connect(nexChi.yDow, and6.u2) annotation (Line(points={{-18,347},{10,347},{10,
          -18},{58,-18}}, color={255,0,255}));
  connect(and7.y, and5.u2) annotation (Line(points={{-4,-120},{40,-120},{40,
          -128},{78,-128}}, color={255,0,255}));
  connect(lesEquThr1.y, and7.u1)
    annotation (Line(points={{-38,-120},{-28,-120}}, color={255,0,255}));
  connect(nexChi.yDow, and7.u2) annotation (Line(points={{-18,347},{10,347},{10,
          -18},{-32,-18},{-32,-128},{-28,-128}}, color={255,0,255}));
  connect(minChiWatFlo.yChaSet, minBypSet.uSetChaPro) annotation (Line(points={
          {122,-328},{140,-328},{140,-340},{80,-340},{80,-378},{98,-378}},
        color={255,0,255}));
annotation (
  defaultComponentName="dowProCon",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-280,-400},{280,400}})),
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
          extent={{-10,140},{10,-120}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-120},{-42,-120},{0,-160},{40,-120},{0,-120}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,198},{-58,186}},
          textColor={255,127,0},
          textString="uStaSet"),
        Text(
          extent={{-96,138},{-26,124}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yOpeParLoaRatMin",
          visible=need_reduceChillerDemand),
        Text(
          extent={{-96,116},{-60,104}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiLoa",
          visible=need_reduceChillerDemand),
        Text(
          extent={{-100,96},{-70,84}},
          textColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{-98,76},{-44,62}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{-100,-14},{-40,-26}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatIsoVal"),
        Text(
          extent={{-100,-44},{-50,-56}},
          textColor={255,0,255},
          textString="uChiWatReq"),
        Text(
          extent={{-98,-62},{-48,-76}},
          textColor={255,0,255},
          textString="uConWatReq"),
        Text(
          extent={{-98,-92},{-44,-108}},
          textColor={255,0,255},
          textString="uChiConIsoVal"),
        Text(
          extent={{-104,-124},{-68,-136}},
          textColor={255,0,255},
          textString="uWSE",
          visible=have_WSE),
        Text(
          extent={{-98,-162},{-32,-176}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatPumSpe",
          visible=not have_fixSpeConWatPum),
        Text(
          extent={{-98,-140},{-26,-158}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatPumSpeSet",
          visible=not have_fixSpeConWatPum),
        Text(
          extent={{60,198},{100,186}},
          textColor={255,0,255},
          textString="yStaPro"),
        Text(
          extent={{60,158},{96,146}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiDem",
          visible=need_reduceChillerDemand),
        Text(
          extent={{72,126},{96,114}},
          textColor={255,0,255},
          textString="yChi"),
        Text(
          extent={{36,50},{96,34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatIsoVal"),
        Text(
          extent={{42,8},{96,-4}},
          textColor={255,0,255},
          textString="yTowStaDow"),
        Text(
          extent={{48,-22},{96,-36}},
          textColor={255,0,255},
          textString="yChiHeaCon"),
        Text(
          extent={{58,-62},{96,-74}},
          textColor={255,0,255},
          textString="yLeaPum"),
        Text(
          extent={{18,-104},{98,-114}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDesConWatPumSpe",
          visible=not have_fixSpeConWatPum),
        Text(
          extent={{34,-122},{96,-136}},
          textColor={255,127,0},
          textString="yConWatPumNum"),
        Text(
          extent={{28,-150},{98,-164}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatMinFloSet"),
        Text(
          extent={{40,88},{96,74}},
          textColor={255,0,255},
          textString="yReaDemLim",
          visible=need_reduceChillerDemand),
        Text(
          extent={{-100,178},{-60,166}},
          textColor={255,0,255},
          textString="uChiSet"),
        Text(
          extent={{-100,46},{-58,34}},
          textColor={255,127,0},
          textString="uChiSta"),
        Text(
          extent={{-98,16},{-44,4}},
          textColor={255,0,255},
          textString="uChiHeaCon"),
        Text(
          extent={{-98,-182},{-42,-196}},
          textColor={255,0,255},
          textString="uConWatPum",
          visible=have_fixSpeConWatPum),
        Text(
          extent={{50,-180},{98,-194}},
          textColor={255,0,255},
          textString="yEndStaTri")}),
Documentation(info="<html>
<p>
Block that controls devices when there is a stage-down command. This sequence is for
water-cooled primary-only parallel chiller plants with headered chilled water pumps
and headered condenser water pumps, or air-cooled primary-only parallel chiller
plants with headered chilled water pumps.
This development is based on ASHRAE RP-1711 Advanced Sequences of Operation for
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft on March 23, 2020),
section 5.2.4.17, which specifies the step-by-step control of
devices during chiller staging down process.
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
Start the staging down process,
<ul>
<li>
For any stage change during which a smaller chiller is enabled and a larger chller
is disabled:
<ol type=\"i\">
<li>
Command operating chillers to reduce demand to 75% (<code>chiDemRedFac</code>) of
their current load (<code>uChiLoa</code>) or a percentage equal to current stage
minimum cycling operative partial load ratio <code>yOpeParLoaRatMin</code>, whichever is greater.
Wait until actual demand &lt; 80% of current load up to a maximum of 5 minutes
(<code>holChiDemTim</code>) before proceeding.
</li>
<li>
Slowly change the minimum flow bypass setpoint to the one that includes both
chillers are enabled. After new setpoint is achieved, wait 1 minute
(<code>aftByPasSetTim</code>) to allow loop stabilize.
</li>
<li>
Enable head pressure control for the chiller being enabled. Wait 30 seconds (<code>waiTim</code>).
</li>
<li>
Slowly (<code>chaChiWatIsoTim</code>) open chilled water isolation valve of the smaller
chiller being enabled. The valve timing should be determind in the field.
</li>
<li>
Start the smaller chiller after its chilled water isolation valve is fully open.
</li>
<li>
Wait 5 minutes (<code>proOnTim</code>) for the newly enabled chiller to prove that
it is operating correctly, then shut off the larger chiller and release the
demand limit.
</li>
</ol>
</li>
<li>
If staging down from any other stage, shut off the last stage chiller.
</li>
</ul>
These are implemented in block <code>dowSta</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart</a>
for more decriptions.
</li>
<li>
When the controller of the chiller being shut off indicates no request for chilled
water flow (<code>uChiWatReq=false</code>), slowly (<code>chaChiWatIsoTim</code>)
close the chiller's chilled water isolation valve to avoid a sudden change in flow
through other operating chillers.
This is implemented in block <code>disChiIsoVal</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal</a>
for more decriptions.
</li>

<li>
When the controller of the chiller being shut off indicates no request for condenser
water flow (<code>uConWatReq=false</code>), disable the chiller's head pressure control
loop.
This is implemented in block <code>disHeaCon</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl</a>
for more decriptions.
</li>

<li>
When the condenser water head pressure control valve is fully closed, shut off
the last lag condenser water pump or change the pump speed to that required of
the new stage.
Block <code>disNexCWP</code> identifies chiller stage for the condenser water pump
control
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableCWPump\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableCWPump</a>)
and block <code>conWatPumCon</code> checks if the condenser water pumps have been reset
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller</a>).
</li>

<li>
Change the chilled water minimum flow setpoint to that appropriate for the new
stage.
The minimum flow setpoint is reset in block <code>minChiWatFlo</code>
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint</a>).
Block <code>minBypSet</code> checks if the new setpoint is achieved
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass</a>).
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
end Down;
