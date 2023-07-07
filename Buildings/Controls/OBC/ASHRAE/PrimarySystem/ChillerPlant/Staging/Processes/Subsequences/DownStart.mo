within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block DownStart "Sequence for starting stage-down process"

  parameter Integer nChi "Total number of chillers";
  parameter Boolean have_parChi=true
    "Flag: true means that the plant has parallel chillers";
  parameter Boolean need_reduceChillerDemand=false
    "True: need limit chiller demand when chiller staging";
  parameter Real chiDemRedFac=0.75
    "Demand reducing factor of current operating chillers"
    annotation (Dialog(group="Demand limit", enable=need_reduceChillerDemand));
  parameter Real holChiDemTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=300
    "Maximum time to wait for the actual demand less than percentage of current load"
    annotation (Dialog(group="Demand limit", enable=need_reduceChillerDemand));
  parameter Real byPasSetTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h")
    "Time constant for resetting minimum bypass flow"
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
    final quantity="Time",
    displayUnit="h")=60
    "Time after setpoint achieved"
    annotation (Dialog(group="Reset bypass"));
  parameter Real waiTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=30
    "Waiting time after enabling next head pressure control"
    annotation (Dialog(group="Head pressure control"));
  parameter Real chaChiWatIsoTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h")
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(group="Chilled water isolation valve"));
  parameter Real proOnTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=300
    "Enabled chiller operation time to indicate if it is proven on"
    annotation (Dialog(group="Disable last chiller"));
  parameter Real relFloDif=0.05
    "Relative error to the setpoint for checking if it has achieved flow rate setpoint"
    annotation (Dialog(tab="Advanced", group="Reset bypass"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-200,190},{-160,230}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yOpeParLoaRatMin(
    final min=0,
    final max=1,
    final unit="1") if need_reduceChillerDemand
    "Current stage minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-200,160},{-160,200}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa[nChi](
    final quantity=fill("ElectricCurrent", nChi),
    final unit=fill("A", nChi))
    if need_reduceChillerDemand "Current chiller load"
    annotation (Placement(transformation(extent={{-200,130},{-160,170}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,70},{-160,110}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput clr
    "Clear stage down process"
    annotation (Placement(transformation(extent={{-200,30},{-160,70}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "True: if the stage change require enabling one chiller and disable another one"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-200,-50},{-160,-10}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi)) "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Next disabling chiller when there is any stage up that need one chiller on and another off"
    annotation (Placement(transformation(extent={{-200,-190},{-160,-150}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    final quantity=fill("ElectricCurrent", nChi),
    final unit=fill("A", nChi))
    if need_reduceChillerDemand "Chiller demand setpoint"
    annotation (Placement(transformation(extent={{180,120},{220,160}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinFloSet
    "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{180,50},{220,90}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{180,-30},{220,10}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{180,-90},{220,-50}}),
      iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{180,-120},{220,-80}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yReaDemLim
    "Release demand limit"
    annotation (Placement(transformation(extent={{180,-160},{220,-120}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand
    chiDemRed(
    final nChi=nChi,
    final chiDemRedFac=chiDemRedFac,
    final holChiDemTim=holChiDemTim) if need_reduceChillerDemand
    "Reduce chiller demand"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass
    minBypRes(
    final aftByPasSetTim=aftByPasSetTim,
    final relFloDif=relFloDif)
    "Slowly change the minimum flow bypass setpoint"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl
    enaHeaCon(
    final nChi=nChi,
    final thrTimEnb=0,
    final waiTim=waiTim,
    final heaStaCha=true)
    "Enable head pressure control of the chiller being enabled"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal
    enaChiIsoVal(
    final nChi=nChi,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final iniValPos=0,
    final endValPos=1) "Enable chiller chilled water isolation valve "
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller
    disChi(
    final nChi=nChi,
    final proOnTim=proOnTim) "Disable last chiller"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint
    minChiWatSet(
    final nChi=nChi,
    final have_parChi=have_parChi,
    final maxFloSet=maxFloSet,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet) "Reset minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch heaPreCon[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch chiDem[nChi]
    if need_reduceChillerDemand                             "Chiller demand"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch chiWatIsoVal[nChi]
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{120,-180},{140,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre(final pre_u_start=false)
    "Break algebraic loop"
    annotation (Placement(transformation(extent={{80,-180},{100,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Maintain ON signal when minimum chilled water setpoint has been set"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2 if need_reduceChillerDemand
    "Maintain ON signal when chiller demand has been limited"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3
    "Maintain ON signal when chiller head control has been enabled"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat4
    "Maintain ON signal when chilled water isolation valve has been enabled"
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 if not need_reduceChillerDemand
    "Dummy or"
    annotation (Placement(transformation(extent={{20,190},{40,210}})));

equation
  connect(chiDemRed.uChiLoa, uChiLoa)
    annotation (Line(points={{-22,175},{-100,175},{-100,150},{-180,150}},
      color={0,0,127}));
  connect(chiDemRed.uChi, uChi)
    annotation (Line(points={{-22,161},{-40,161},{-40,120},{-180,120}},color={255,0,255}));
  connect(con3.y, minChiWatSet.uStaUp)
    annotation (Line(points={{-78,90},{-60,90},{-60,79},{-2,79}}, color={255,0,255}));
  connect(minChiWatSet.uStaDow, uStaDow)
    annotation (Line(points={{-2,61},{-140,61},{-140,210},{-180,210}},
      color={255,0,255}));
  connect(minChiWatSet.uOnOff, uOnOff)
    annotation (Line(points={{-2,63},{-110,63},{-110,20},{-180,20}},
      color={255,0,255}));
  connect(uStaDow, minBypRes.chaPro)
    annotation (Line(points={{-180,210},{-140,210},{-140,114},{58,114}},
      color={255,0,255}));
  connect(VChiWat_flow, minBypRes.VChiWat_flow)
    annotation (Line(points={{-180,90},{-150,90},{-150,106},{58,106}},
      color={0,0,127}));
  connect(uStaDow, enaHeaCon.chaPro)
    annotation (Line(points={{-180,210},{-140,210},{-140,0},{-2,0}},
      color={255,0,255}));
  connect(enaHeaCon.nexChaChi, nexEnaChi)
    annotation (Line(points={{-2,-4},{-60,-4},{-60,-30},{-180,-30}},
      color={255,127,0}));
  connect(enaHeaCon.uChiHeaCon, uChiHeaCon)
    annotation (Line(points={{-2,-8},{-30,-8},{-30,-60},{-180,-60}},
      color={255,0,255}));
  connect(nexEnaChi, enaChiIsoVal.nexChaChi)
    annotation (Line(points={{-180,-30},{-60,-30},{-60,-92},{-2,-92}},
      color={255,127,0}));
  connect(enaChiIsoVal.uChiWatIsoVal, uChiWatIsoVal)
    annotation (Line(points={{-2,-95},{-100,-95},{-100,-100},{-180,-100}},
      color={0,0,127}));
  connect(uStaDow, enaChiIsoVal.chaPro)
    annotation (Line(points={{-180,210},{-140,210},{-140,-108},{-2,-108}},
      color={255,0,255}));
  connect(nexEnaChi, disChi.nexEnaChi)
    annotation (Line(points={{-180,-30},{-60,-30},{-60,-141},{-2,-141}},
      color={255,127,0}));
  connect(uStaDow, disChi.uStaDow)
    annotation (Line(points={{-180,210},{-140,210},{-140,-144},{-2,-144}},
      color={255,0,255}));
  connect(uChi, disChi.uChi)
    annotation (Line(points={{-180,120},{-40,120},{-40,-152},{-2,-152}},
      color={255,0,255}));
  connect(uOnOff, disChi.uOnOff)
    annotation (Line(points={{-180,20},{-110,20},{-110,-159},{-2,-159}},
      color={255,0,255}));
  connect(disChi.nexDisChi, nexDisChi)
    annotation (Line(points={{-2,-155},{-80,-155},{-80,-170},{-180,-170}},
      color={255,127,0}));
  connect(uStaDow, and2.u1)
    annotation (Line(points={{-180,210},{-140,210},{-140,200},{-102,200}},
      color={255,0,255}));
  connect(and2.y, chiDemRed.uDemLim)
    annotation (Line(points={{-78,200},{-40,200},{-40,179},{-22,179}},
      color={255,0,255}));
  connect(uOnOff, booRep4.u)
    annotation (Line(points={{-180,20},{58,20}}, color={255,0,255}));
  connect(booRep4.y, chiDem.u2)
    annotation (Line(points={{82,20},{120,20},{120,140},{138,140}},
      color={255,0,255}));
  connect(chiDemRed.yChiDem, chiDem.u1)
    annotation (Line(points={{2,174},{120,174},{120,148},{138,148}},
      color={0,0,127}));
  connect(uChiLoa, chiDem.u3)
    annotation (Line(points={{-180,150},{-100,150},{-100,132},{138,132}},
      color={0,0,127}));
  connect(booRep4.y, heaPreCon.u2)
    annotation (Line(points={{82,20},{120,20},{120,-10},{138,-10}},
      color={255,0,255}));
  connect(enaHeaCon.yChiHeaCon, heaPreCon.u1)
    annotation (Line(points={{22,-6},{80,-6},{80,-2},{138,-2}},
      color={255,0,255}));
  connect(uChiHeaCon, heaPreCon.u3)
    annotation (Line(points={{-180,-60},{-30,-60},{-30,-18},{138,-18}},
      color={255,0,255}));
  connect(booRep4.y, chiWatIsoVal.u2)
    annotation (Line(points={{82,20},{120,20},{120,-70},{138,-70}},
      color={255,0,255}));
  connect(enaChiIsoVal.yChiWatIsoVal, chiWatIsoVal.u1)
    annotation (Line(points={{22,-106},{40,-106},{40,-62},{138,-62}},
      color={0,0,127}));
  connect(uChiWatIsoVal, chiWatIsoVal.u3)
    annotation (Line(points={{-180,-100},{-100,-100},{-100,-78},{138,-78}},
      color={0,0,127}));
  connect(chiDem.y, yChiDem)
    annotation (Line(points={{162,140},{200,140}}, color={0,0,127}));
  connect(heaPreCon.y, yChiHeaCon)
    annotation (Line(points={{162,-10},{200,-10}}, color={255,0,255}));
  connect(chiWatIsoVal.y, yChiWatIsoVal)
    annotation (Line(points={{162,-70},{200,-70}}, color={0,0,127}));
  connect(disChi.yChi, yChi)
    annotation (Line(points={{22,-150},{140,-150},{140,-100},{200,-100}},
      color={255,0,255}));
  connect(disChi.yReaDemLim, yReaDemLim)
    annotation (Line(points={{22,-158},{60,-158},{60,-140},{200,-140}},
      color={255,0,255}));
  connect(yOpeParLoaRatMin, chiDemRed.yOpeParLoaRatMin)
    annotation (Line(points={{-180,180},{-110,180},{-110,171},{-22,171}},
      color={0,0,127}));
  connect(uStaDow, chiDemRed.uStaDow)
    annotation (Line(points={{-180,210},{-140,210},{-140,168},{-22,168}},
      color={255,0,255}));
  connect(uOnOff, chiDemRed.uOnOff)
    annotation (Line(points={{-180,20},{-110,20},{-110,165},{-22,165}},
      color={255,0,255}));
  connect(uChi, minChiWatSet.uChi)
    annotation (Line(points={{-180,120},{-40,120},{-40,74},{-2,74}},
      color={255,0,255}));
  connect(nexEnaChi, minChiWatSet.nexEnaChi)
    annotation (Line(points={{-180,-30},{-60,-30},{-60,71},{-2,71}},
      color={255,127,0}));
  connect(nexDisChi, minChiWatSet.nexDisChi)
    annotation (Line(points={{-180,-170},{-80,-170},{-80,69},{-2,69}},
      color={255,127,0}));
  connect(minChiWatSet.yChiWatMinFloSet, minBypRes.VMinChiWat_setpoint)
    annotation (Line(points={{22,70},{40,70},{40,102},{58,102}},
      color={0,0,127}));
  connect(con3.y, minChiWatSet.uUpsDevSta)
    annotation (Line(points={{-78,90},{-60,90},{-60,77},{-2,77}},
      color={255,0,255}));
  connect(minBypRes.yMinBypRes, lat1.u)
    annotation (Line(points={{82,110},{100,110},{100,80},{50,80},{50,50},{58,50}},
      color={255,0,255}));
  connect(lat1.y, enaHeaCon.uUpsDevSta)
    annotation (Line(points={{82,50},{100,50},{100,36},{-20,36},{-20,4},{-2,4}},
      color={255,0,255}));
  connect(chiDemRed.yChiDemRed, lat2.u)
    annotation (Line(points={{2,166},{10,166},{10,150},{18,150}},
      color={255,0,255}));
  connect(lat2.y, minBypRes.uUpsDevSta)
    annotation (Line(points={{42,150},{50,150},{50,118},{58,118}},
      color={255,0,255}));
  connect(lat2.y, minChiWatSet.uSubCha)
    annotation (Line(points={{42,150},{50,150},{50,108},{-20,108},{-20,66},{-2,66}},
      color={255,0,255}));
  connect(disChi.yReaDemLim, pre.u)
    annotation (Line(points={{22,-158},{60,-158},{60,-170},{78,-170}},
      color={255,0,255}));
  connect(pre.y, not1.u)
    annotation (Line(points={{102,-170},{118,-170}}, color={255,0,255}));
  connect(not1.y, and2.u2)
    annotation (Line(points={{142,-170},{160,-170},{160,-192},{-120,-192},
      {-120,192},{-102,192}}, color={255,0,255}));
  connect(minChiWatSet.yChiWatMinFloSet, yChiWatMinFloSet)
    annotation (Line(points={{22,70},{200,70}}, color={0,0,127}));
  connect(clr, lat2.clr)
    annotation (Line(points={{-180,50},{-130,50},{-130,144},{18,144}},
      color={255,0,255}));
  connect(clr, lat1.clr)
    annotation (Line(points={{-180,50},{-130,50},{-130,44},{58,44}},
      color={255,0,255}));
  connect(enaHeaCon.yEnaHeaCon, lat3.u)
    annotation (Line(points={{22,6},{30,6},{30,-40},{58,-40}}, color={255,0,255}));
  connect(lat3.y, enaChiIsoVal.uUpsDevSta)
    annotation (Line(points={{82,-40},{100,-40},{100,-60},{-20,-60},{-20,-105},
      {-2,-105}}, color={255,0,255}));
  connect(clr, lat3.clr)
    annotation (Line(points={{-180,50},{-130,50},{-130,-46},{58,-46}},
      color={255,0,255}));
  connect(enaChiIsoVal.yEnaChiWatIsoVal, lat4.u)
    annotation (Line(points={{22,-94},{50,-94},{50,-110},{58,-110}},
      color={255,0,255}));
  connect(lat4.y, disChi.uEnaChiWatIsoVal)
    annotation (Line(points={{82,-110},{120,-110},{120,-130},{-20,-130},
      {-20,-148},{-2,-148}}, color={255,0,255}));
  connect(clr, lat4.clr)
    annotation (Line(points={{-180,50},{-130,50},{-130,-116},{58,-116}},
      color={255,0,255}));
  connect(and2.y, or2.u1)
    annotation (Line(points={{-78,200},{18,200}}, color={255,0,255}));
  connect(con3.y, or2.u2) annotation (Line(points={{-78,90},{-60,90},{-60,192},{
          18,192}}, color={255,0,255}));
  connect(or2.y, minBypRes.uUpsDevSta) annotation (Line(points={{42,200},{50,200},
          {50,118},{58,118}}, color={255,0,255}));
  connect(or2.y, minChiWatSet.uSubCha) annotation (Line(points={{42,200},{50,200},
          {50,108},{-20,108},{-20,66},{-2,66}}, color={255,0,255}));

  connect(con3.y, enaHeaCon.uEnaPla) annotation (Line(points={{-78,90},{-70,90},
          {-70,8},{-2,8}}, color={255,0,255}));
annotation (
  defaultComponentName="staStaDow",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-200},{180,220}})),
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
          extent={{-2,-6},{2,-72}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-72},{-20,-72},{0,-90},{20,-72},{0,-72}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,-90},{-58,-102}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="nexDisChi"),
        Text(
          extent={{-98,-72},{-46,-86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatIsoVal"),
        Text(
          extent={{-98,28},{-46,16}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="vChiWat_flow"),
        Text(
          extent={{-98,86},{-58,74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yOpeParLoaRatMin",
          visible=need_reduceChillerDemand),
        Text(
          extent={{-100,66},{-64,56}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiLoa",
          visible=need_reduceChillerDemand),
        Text(
          extent={{-102,46},{-74,36}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChi"),
        Text(
          extent={{-98,102},{-64,90}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaDow"),
        Text(
          extent={{-100,-12},{-66,-22}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOnOff"),
        Text(
          extent={{-98,-32},{-54,-44}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="nexEnaChi"),
        Text(
          extent={{-98,-54},{-52,-64}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiHeaCon"),
        Text(
          extent={{64,98},{100,88}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiDem",
          visible=need_reduceChillerDemand),
        Text(
          extent={{60,-14},{96,-24}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiIsoVal"),
        Text(
          extent={{54,26},{96,14}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yChiHeaCon"),
        Text(
          extent={{66,-54},{104,-64}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yChi"),
        Text(
          extent={{54,-82},{96,-94}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yReaDemLim",
          visible=need_reduceChillerDemand),
        Text(
          extent={{32,66},{98,56}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatMinFloSet"),
        Text(
          extent={{-100,6},{-84,-4}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="clr")}),
Documentation(info="<html>
<p>
Block that controls devices at the first step of chiller staging down process.
This development is based on ASHRAE RP-1711 Advanced Sequences of Operation for
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft on March 23, 2020),
section 5.2.4.17, item 1 and 2. The sections specifies the first step of
staging down process.
</p>
<p>
For the stage-down process that requires a smaller chiller being enabled and a
larger chiller being disabled (<code>uOnOff=true</code>):
</p>
<ol>
<li>
Command operating chilers to reduce demand to 75% (<code>chiDemRedFac</code>) of
their current load or a percentage equal to current stage minimum cycling operative
partial load ratio (<code>yOpeParLoaRatMin</code>), whichever is greater. Wait until acutal
demand &lt; 80% of current load up to a maximum of 5 minutes (<code>holChiDemTim</code>)
before proceeding. This is implemented in block <code>chiDemRed</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand</a>
for more decriptions.
</li>
<li>
Slowly change the minimum chilled water flow setpoint to that approriate for the
stage transition (<code>minChiWatSet</code>). After new setpoint is achieved, wait
1 minutes (<code>aftByPasSetTim</code>) to allow loop to stabilize (<code>minBypRes</code>).
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint</a>
and
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass</a>
for more decriptions.
</li>
<li>
Enable head pressure control for the chiller being enabled. Wait 30 seconds (<code>waiTim</code>).
It is implemented in block <code>enaHeaCon</code>, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl</a>
for more decriptions.
</li>
<li>
Slowly open chilled water isolation valve of the smaller chiller being enabled.
Determine valve timing <code>chaChiWatIsoTim</code> in the field as that required
to prevent nuisance trips.
It is implemented in block <code>enaChiIsoVal</code>, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal</a>
for more decriptions.
</li>
<li>
Start the smaller chiller after its chilled water isolation valve is fully open.
Wait 5 minutes (<code>proOnTim</code>) after the newly enabled chiller to prove that
it is operating correctly, then shut off the larger chiller and release the demand
limit (<code>yReaDemLim=true</code>).
It is implemented in block <code>disChi</code>, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller</a>
for more decriptions.
</li>
</ol>
<p>
For staging down from any other stage (<code>uOnOff=false</code>), just shut off
the last stage chiller. This is implemented in block <code>disChi</code>, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller</a>
for more decriptions.
</p>
</html>", revisions="<html>
<ul>
<li>
September 19, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DownStart;
