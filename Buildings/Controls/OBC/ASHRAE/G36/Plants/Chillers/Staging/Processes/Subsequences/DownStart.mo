within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences;
block DownStart "Sequence for starting stage-down process"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Boolean have_airCoo=false
    "True: the plant has air cooled chiller";
  parameter Boolean have_parChi=true
    "Flag: true means that the plant has parallel chillers";
  parameter Boolean need_reduceChillerDemand=false
    "True: need limit chiller demand when chiller staging";
  parameter Real chiDemRedFac=0.75
    "Demand reducing factor of current operating chillers"
    annotation (Dialog(group="Demand limit", enable=need_reduceChillerDemand));
  parameter Real holChiDemTim(unit="s")=300
    "Maximum time to wait for the actual demand less than percentage of current load"
    annotation (Dialog(group="Demand limit", enable=need_reduceChillerDemand));
  parameter Real byPasSetTim(unit="s")
    "Time constant for resetting minimum bypass flow"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real minFloSet[nChi](unit=fill("m3/s", nChi), each displayUnit="m3/s")
    "Minimum chilled water flow through each chiller"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real maxFloSet[nChi](unit=fill("m3/s", nChi), each displayUnit="m3/s")
    "Maximum chilled water flow through each chiller"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Real aftByPasSetTim(unit="s")=60
    "Time after setpoint achieved"
    annotation (Dialog(group="Reset bypass"));
  parameter Real waiTim(unit="s")=30
    "Waiting time after enabling next head pressure control"
    annotation (Dialog(group="Head pressure control"));
  parameter Boolean have_isoValEndSwi=false
    "True: chiller chilled water isolatiove valve have the end switch feedback"
    annotation (Dialog(group="Chilled water isolation valve"));
  parameter Real chaChiWatIsoTim(start=120, unit="s")
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(group="Chilled water isolation valve", enable=not have_isoValEndSwi));
  parameter Real proOnTim(unit="s")=300
    "Enabled chiller operation time to indicate if it is proven on"
    annotation (Dialog(group="Disable last chiller"));
  parameter Real relFloDif=0.05
    "Relative error to the setpoint for checking if it has achieved flow rate setpoint"
    annotation (Dialog(tab="Advanced", group="Reset bypass"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-200,190},{-160,230}}),
      iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yOpeParLoaRatMin(
    final min=0,
    final max=1,
    final unit="1") if need_reduceChillerDemand
    "Current stage minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-200,160},{-160,200}}),
      iconTransformation(extent={{-140,102},{-100,142}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa(
    final quantity="HeatFlowRate",
    final unit="W") if need_reduceChillerDemand "Current chiller load"
    annotation (Placement(transformation(extent={{-200,130},{-160,170}}),
        iconTransformation(extent={{-140,82},{-100,122}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,62},{-100,102}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,70},{-160,110}}),
      iconTransformation(extent={{-140,42},{-100,82}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput clr
    "Clear stage down process"
    annotation (Placement(transformation(extent={{-200,30},{-160,70}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "True: if the stage change require enabling one chiller and disable another one"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-200,-50},{-160,-10}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    if not have_airCoo
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiIsoOpe[nChi] if have_isoValEndSwi
    "Chiller chilled water isolation valve open end switch. True: the valve is fully open"
    annotation (Placement(transformation(extent={{-200,-110},{-160,-70}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiIsoClo[nChi] if have_isoValEndSwi
    "Chiller chilled water isolation valve close end switch. True: the valve is fully closed"
    annotation (Placement(transformation(extent={{-200,-150},{-160,-110}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Next disabling chiller when there is any stage up that need one chiller on and another off"
    annotation (Placement(transformation(extent={{-200,-190},{-160,-150}}),
      iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem(
    final quantity="HeatFlowRate",
    final unit="W") if need_reduceChillerDemand
    "Chiller demand setpoint"
    annotation (Placement(transformation(extent={{180,120},{220,160}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinFloSet
    "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{180,50},{220,90}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    if not have_airCoo
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{180,-30},{220,10}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiWatIsoVal[nChi]
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
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.ReduceDemand
    chiDemRed(
    final nChi=nChi,
    final chiDemRedFac=chiDemRedFac,
    final holChiDemTim=holChiDemTim) if need_reduceChillerDemand
    "Reduce chiller demand"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.ResetMinBypass
    minBypRes(
    final byPasSetTim=byPasSetTim,
    final aftByPasSetTim=aftByPasSetTim,
    final relFloDif=relFloDif)
    "Slowly change the minimum flow bypass setpoint"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.HeadControl
    enaHeaCon(
    final nChi=nChi,
    final thrTimEnb=0,
    final waiTim=waiTim,
    final heaStaCha=true) if not have_airCoo
    "Enable head pressure control of the chiller being enabled"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.CHWIsoVal enaChiIsoVal(
    final have_isoValEndSwi=have_isoValEndSwi,
    final nChi=nChi,
    final chaChiWatIsoTim=chaChiWatIsoTim)
    "Enable chiller chilled water isolation valve "
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.DisableChiller disChi(
    final nChi=nChi,
    final proOnTim=proOnTim) "Disable last chiller"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.MinimumFlowBypass.FlowSetpoint
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
  Buildings.Controls.OBC.CDL.Logical.Switch heaPreCon[nChi] if not have_airCoo
    "Logical switch"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiDem if need_reduceChillerDemand
    "Chiller demand"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiWatIsoVal[nChi]
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
  Buildings.Controls.OBC.CDL.Logical.Latch lat3 if not have_airCoo
    "Maintain ON signal when chiller head control has been enabled"
    annotation (Placement(transformation(extent={{60,-38},{80,-18}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat4
    "Maintain ON signal when chilled water isolation valve has been enabled"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 if not need_reduceChillerDemand
    "Dummy or"
    annotation (Placement(transformation(extent={{20,190},{40,210}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1 if have_airCoo
    "To be disabled when it is air chilled"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

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
  connect(uStaDow, minBypRes.uStaPro) annotation (Line(points={{-180,210},{-140,
          210},{-140,114},{58,114}}, color={255,0,255}));
  connect(VChiWat_flow, minBypRes.VChiWat_flow)
    annotation (Line(points={{-180,90},{-150,90},{-150,110},{58,110}},
      color={0,0,127}));
  connect(uStaDow, enaHeaCon.uStaPro) annotation (Line(points={{-180,210},{-140,
          210},{-140,0},{-2,0}}, color={255,0,255}));
  connect(enaHeaCon.nexChaChi, nexEnaChi)
    annotation (Line(points={{-2,-4},{-60,-4},{-60,-30},{-180,-30}},
      color={255,127,0}));
  connect(enaHeaCon.uChiHeaCon, uChiHeaCon)
    annotation (Line(points={{-2,-8},{-30,-8},{-30,-60},{-180,-60}},
      color={255,0,255}));
  connect(nexEnaChi, enaChiIsoVal.nexChaChi)
    annotation (Line(points={{-180,-30},{-60,-30},{-60,-92},{38,-92}},
      color={255,127,0}));
  connect(uStaDow, enaChiIsoVal.uStaPro) annotation (Line(points={{-180,210},{-140,
          210},{-140,-108},{38,-108}}, color={255,0,255}));
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
  connect(chiDemRed.yChiDem, chiDem.u1)
    annotation (Line(points={{2,174},{120,174},{120,148},{138,148}},
      color={0,0,127}));
  connect(uChiLoa, chiDem.u3)
    annotation (Line(points={{-180,150},{-100,150},{-100,132},{138,132}},
      color={0,0,127}));
  connect(booRep4.y, heaPreCon.u2)
    annotation (Line(points={{82,20},{110,20},{110,-10},{138,-10}},
      color={255,0,255}));
  connect(enaHeaCon.yChiHeaCon, heaPreCon.u1)
    annotation (Line(points={{22,-6},{80,-6},{80,-2},{138,-2}},
      color={255,0,255}));
  connect(uChiHeaCon, heaPreCon.u3)
    annotation (Line(points={{-180,-60},{-30,-60},{-30,-18},{138,-18}},
      color={255,0,255}));
  connect(booRep4.y, chiWatIsoVal.u2)
    annotation (Line(points={{82,20},{110,20},{110,-70},{138,-70}},
      color={255,0,255}));
  connect(chiDem.y, yChiDem)
    annotation (Line(points={{162,140},{200,140}}, color={0,0,127}));
  connect(heaPreCon.y, yChiHeaCon)
    annotation (Line(points={{162,-10},{200,-10}}, color={255,0,255}));
  connect(chiWatIsoVal.y, y1ChiWatIsoVal)
    annotation (Line(points={{162,-70},{200,-70}}, color={0,0,127}));
  connect(disChi.yChi, yChi)
    annotation (Line(points={{22,-150},{140,-150},{140,-100},{200,-100}},
      color={255,0,255}));
  connect(disChi.yRelDemLim, yReaDemLim)
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
    annotation (Line(points={{22,70},{40,70},{40,106},{58,106}},
      color={0,0,127}));
  connect(con3.y, minChiWatSet.uUpsDevSta)
    annotation (Line(points={{-78,90},{-60,90},{-60,77},{-2,77}},
      color={255,0,255}));
  connect(lat1.y, enaHeaCon.uUpsDevSta)
    annotation (Line(points={{82,50},{100,50},{100,36},{-10,36},{-10,4},{-2,4}},
      color={255,0,255}));
  connect(chiDemRed.yChiDemRed, lat2.u)
    annotation (Line(points={{2,166},{10,166},{10,150},{18,150}},
      color={255,0,255}));
  connect(lat2.y, minBypRes.uUpsDevSta)
    annotation (Line(points={{42,150},{50,150},{50,118},{58,118}},
      color={255,0,255}));
  connect(lat2.y, minChiWatSet.uSubCha)
    annotation (Line(points={{42,150},{50,150},{50,120},{-20,120},{-20,66},{-2,
          66}}, color={255,0,255}));
  connect(disChi.yRelDemLim, pre.u)
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
    annotation (Line(points={{22,6},{30,6},{30,-28},{58,-28}}, color={255,0,255}));
  connect(lat3.y, enaChiIsoVal.uUpsDevSta)
    annotation (Line(points={{82,-28},{100,-28},{100,-44},{-20,-44},{-20,-105},{
          38,-105}}, color={255,0,255}));
  connect(clr, lat3.clr)
    annotation (Line(points={{-180,50},{-130,50},{-130,-34},{58,-34}},
      color={255,0,255}));
  connect(lat4.y, disChi.uEnaChiWatIsoVal)
    annotation (Line(points={{122,-110},{130,-110},{130,-130},{-20,-130},{-20,-148},
          {-2,-148}}, color={255,0,255}));
  connect(clr, lat4.clr)
    annotation (Line(points={{-180,50},{-130,50},{-130,-116},{98,-116}},
      color={255,0,255}));
  connect(and2.y, or2.u1)
    annotation (Line(points={{-78,200},{18,200}}, color={255,0,255}));
  connect(con3.y, or2.u2) annotation (Line(points={{-78,90},{-60,90},{-60,192},{
          18,192}}, color={255,0,255}));
  connect(or2.y, minBypRes.uUpsDevSta) annotation (Line(points={{42,200},{50,
          200},{50,118},{58,118}}, color={255,0,255}));
  connect(or2.y, minChiWatSet.uSubCha) annotation (Line(points={{42,200},{50,
          200},{50,120},{-20,120},{-20,66},{-2,66}}, color={255,0,255}));
  connect(con3.y, enaHeaCon.uEnaPla) annotation (Line(points={{-78,90},{-70,90},
          {-70,8},{-2,8}}, color={255,0,255}));
  connect(minChiWatSet.yChaSet, minBypRes.uSetChaPro) annotation (Line(points={
          {22,62},{30,62},{30,102},{58,102}}, color={255,0,255}));
  connect(or1.y, enaChiIsoVal.uUpsDevSta) annotation (Line(points={{22,-60},{30,
          -60},{30,-105},{38,-105}}, color={255,0,255}));
  connect(con3.y, or1.u2) annotation (Line(points={{-78,90},{-70,90},{-70,-68},{
          -2,-68}}, color={255,0,255}));
  connect(lat1.y, or1.u1) annotation (Line(points={{82,50},{100,50},{100,36},{-10,
          36},{-10,-60},{-2,-60}}, color={255,0,255}));
  connect(booRep4.y[1], chiDem.u2) annotation (Line(points={{82,19.5},{110,19.5},
          {110,140},{138,140}}, color={255,0,255}));
  connect(enaChiIsoVal.yChaChiWatIsoVal, lat4.u) annotation (Line(points={{62,-94},
          {80,-94},{80,-110},{98,-110}}, color={255,0,255}));
  connect(enaChiIsoVal.y1ChiWatIsoVal, chiWatIsoVal.u1) annotation (Line(points
        ={{62,-106},{70,-106},{70,-62},{138,-62}}, color={255,0,255}));
  connect(uChi, chiWatIsoVal.u3) annotation (Line(points={{-180,120},{-40,120},{
          -40,-78},{138,-78}}, color={255,0,255}));
  connect(u1ChiIsoOpe, enaChiIsoVal.u1ChiIsoOpe) annotation (Line(points={{-180,
          -90},{-100,-90},{-100,-98},{38,-98}}, color={255,0,255}));
  connect(u1ChiIsoClo, enaChiIsoVal.u1ChiIsoClo) annotation (Line(points={{-180,
          -130},{-100,-130},{-100,-101},{38,-101}}, color={255,0,255}));
  connect(uChi, enaChiIsoVal.uChi) annotation (Line(points={{-180,120},{-40,120},
          {-40,-95},{38,-95}}, color={255,0,255}));
  connect(minBypRes.yMinBypRes, lat1.u) annotation (Line(points={{82,110},{100,
          110},{100,80},{54,80},{54,50},{58,50}}, color={255,0,255}));
annotation (
  defaultComponentName="staStaDow",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-200},{180,220}})),
    Icon(coordinateSystem(extent={{-100,-200},{100,200}}),
      graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,240},{100,200}},
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
          extent={{-98,-154},{-58,-166}},
          textColor={255,127,0},
          textString="nexDisChi"),
        Text(
          extent={{-98,70},{-46,58}},
          textColor={0,0,127},
          textString="vChiWat_flow"),
        Text(
          extent={{-98,128},{-58,116}},
          textColor={0,0,127},
          textString="yOpeParLoaRatMin",
          visible=need_reduceChillerDemand),
        Text(
          extent={{-100,108},{-64,98}},
          textColor={0,0,127},
          textString="uChiLoa",
          visible=need_reduceChillerDemand),
        Text(
          extent={{-102,88},{-74,78}},
          textColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{-98,178},{-64,166}},
          textColor={255,0,255},
          textString="uStaDow"),
        Text(
          extent={{-100,8},{-66,-2}},
          textColor={255,0,255},
          textString="uOnOff"),
        Text(
          extent={{-98,-22},{-54,-34}},
          textColor={255,127,0},
          textString="nexEnaChi"),
        Text(
          extent={{-98,-44},{-52,-54}},
          textColor={255,0,255},
          textString="uChiHeaCon"),
        Text(
          extent={{64,98},{100,88}},
          textColor={0,0,127},
          textString="yChiDem",
          visible=need_reduceChillerDemand),
        Text(
          extent={{46,-14},{100,-24}},
          textColor={255,0,255},
          textString="y1ChiWatIsoVal"),
        Text(
          extent={{54,26},{96,14}},
          textColor={255,0,255},
          textString="yChiHeaCon"),
        Text(
          extent={{66,-54},{104,-64}},
          textColor={255,0,255},
          textString="yChi"),
        Text(
          extent={{54,-82},{96,-94}},
          textColor={255,0,255},
          textString="yReaDemLim",
          visible=need_reduceChillerDemand),
        Text(
          extent={{32,66},{98,56}},
          textColor={0,0,127},
          textString="yChiWatMinFloSet"),
        Text(
          extent={{-100,26},{-84,16}},
          textColor={255,0,255},
          textString="clr"),
        Text(
          extent={{-100,-74},{-54,-84}},
          textColor={255,0,255},
          textString="u1ChiIsoOpe",
          visible=have_isoValEndSwi),
        Text(
          extent={{-100,-106},{-54,-116}},
          textColor={255,0,255},
          visible=have_isoValEndSwi,
          textString="u1ChiIsoClo"),
        Text(
          extent={{48,-82},{100,-94}},
          textColor={255,0,255},
          textString="yReaDemLim")}),
Documentation(info="<html>
<p>
Block that controls devices at the first step of the chiller staging down process.
This development is based on ASHRAE Guideline 36-2021,
section 5.20.4.17, item a and b. The sections specifies the first step of
the staging down process.
</p>
<p>
For the stage-down process that requires a smaller chiller being enabled and a
larger chiller being disabled (<code>uOnOff=true</code>):
</p>
<ol>
<li>
Command operating chillers to reduce demand to 75% (<code>chiDemRedFac</code>) of
their current load or a percentage equal to the current stage minimum cycling operative
partial load ratio (<code>yOpeParLoaRatMin</code>), whichever is greater. Wait until actual
demand &lt; 80% of current load up to a maximum of 5 minutes (<code>holChiDemTim</code>)
before proceeding. This is implemented in block <code>chiDemRed</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.ReduceDemand\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.ReduceDemand</a>
for more descriptions.
</li>
<li>
Slowly change the minimum chilled water flow setpoint to that appropriate for the
stage transition (<code>minChiWatSet</code>). After the new setpoint is achieved, wait
1 minute (<code>aftByPasSetTim</code>) to allow the loop to stabilize (<code>minBypRes</code>).
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.MinimumFlowBypass.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.MinimumFlowBypass.FlowSetpoint</a>
and
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.ResetMinBypass\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.ResetMinBypass</a>
for more descriptions.
</li>
<li>
Enable head pressure control for the chiller being enabled. Wait 30 seconds (<code>waiTim</code>).
It is implemented in block <code>enaHeaCon</code>, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.HeadControl\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.HeadControl</a>
for more descriptions.
</li>
<li>
Slowly open the chilled water isolation valve of the smaller chiller being enabled.
Determine valve timing <code>chaChiWatIsoTim</code> in the field as that is required
to prevent nuisance trips.
It is implemented in block <code>enaChiIsoVal</code>, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.CHWIsoVal\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.CHWIsoVal</a>
for more descriptions.
</li>
<li>
Start the smaller chiller after its chilled water isolation valve is fully open.
Wait 5 minutes (<code>proOnTim</code>) after the newly enabled chiller to prove that
it is operating correctly, then shut off the larger chiller and release the demand
limit (<code>yReaDemLim=true</code>).
It is implemented in block <code>disChi</code>, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.DisableChiller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.DisableChiller</a>
for more descriptions.
</li>
</ol>
<p>
For staging down from any other stage (<code>uOnOff=false</code>), just shut off
the last stage chiller. This is implemented in block <code>disChi</code>, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.DisableChiller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.DisableChiller</a>
for more descriptions.
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
