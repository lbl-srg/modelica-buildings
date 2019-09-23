within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block UpEnd "Sequence for ending stage-up process"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Boolean isParallelChiller=true
    "Flag: true means that the plant has parallel chillers";

  parameter Modelica.SIunits.Time proOnTim = 300
    "Threshold time to check if newly enabled chiller being operated by more than 5 minutes"
    annotation (Dialog(group="Enable next chiller"));
  parameter Modelica.SIunits.Time chaChiWatIsoTim=300
    "Time to slowly change isolation valve"
    annotation (Dialog(group="Chilled water isolation valve"));
  parameter Modelica.SIunits.Time byPasSetTim=300
    "Time to slowly reset minimum by-pass flow"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[nChi]={0.0089,0.0089}
    "Minimum chilled water flow through each chiller"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Modelica.SIunits.VolumeFlowRate maxFloSet[nChi]={0.025,0.025}
    "Maximum chilled water flow through each chiller"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Modelica.SIunits.Time aftByPasSetTim=60
    "Time after minimum bypass flow being resetted to new setpoint"
    annotation (Dialog(group="Reset bypass"));
  parameter Modelica.SIunits.VolumeFlowRate minFloDif=0.01
    "Minimum flow rate difference to check if bybass flow achieves setpoint"
    annotation (Dialog(group="Reset bypass"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-240,220},{-200,260}}),
      iconTransformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Indicate if there is stage up"
    annotation (Placement(transformation(extent={{-240,190},{-200,230}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaChiWatIsoVal
    "Status of chiller chilled water isolation valve control: true=enabled valve is fully open"
    annotation (Placement(transformation(extent={{-240,160},{-200,200}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
     annotation (Placement(transformation(extent={{-240,130},{-200,170}}),
       iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexDisChi
    "Next disabling chiller when there is any stage up that need one chiller on and another off"
    annotation (Placement(transformation(extent={{-240,50},{-200,90}}),
      iconTransformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water requst status for each chiller"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
      iconTransformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi)) "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-240,-26},{-200,14}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water requst status for each chiller"
    annotation (Placement(transformation(extent={{-240,-90},{-200,-50}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-240,-120},{-200,-80}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-240,-204},{-200,-164}}),
      iconTransformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{200,120},{240,160}}),
      iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{200,40},{240,80}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{200,-70},{240,-30}}),
      iconTransformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinSet(
    final unit="m3/s") "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{200,-130},{240,-90}}),
      iconTransformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSta
    "Flag to indicate if the staging process is finished"
    annotation (Placement(transformation(extent={{200,-250},{240,-210}}),
      iconTransformation(extent={{100,-100},{120,-80}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  final parameter Real iniValPos=1
    "Initial valve position, if it needs to turn off chiller, the value should be 1"
    annotation (Dialog(group="Chilled water isolation valve"));
  final parameter Real endValPos=0
    "Ending valve position, if it needs to turn off chiller, the value should be 0"
    annotation (Dialog(group="Chilled water isolation valve"));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr(
    final threshold=0.5)
    "Check if the disabled chiller is not requiring chilled water"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableChiIsoVal
    disChiIsoVal(
    final nChi=nChi,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final iniValPos=iniValPos,
    final endValPos=endValPos) "Disable isolation valve of the chiller being disabled"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=true) "True constant"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr1(
    final threshold=0.5)
    "Check if the disabled chiller is not requiring condenser water"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 "Logical and"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableHeadControl
    disHeaCon(
    final nChi=nChi,
    final thrTimEnb=0,
    final waiTim=0,
    final heaStaCha=false)
    "Disable head pressure control of the chiller being disabled"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint
    minChiWatSet(
    final nChi=nChi,
    isParallelChiller=isParallelChiller,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet) "Reset minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass
    minBypSet(
    final aftByPasSetTim=aftByPasSetTim,
    final minFloDif=minFloDif)
    "Check if minimum bypass flow has been resetted"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor  curDisChi(final nin=nChi)
    "Current disabling chiller"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor curDisChi1(final nin=nChi)
    "Current disabling chiller"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi3[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{160,-60},{180,-40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep4(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiWatIso[nChi]
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi4
    "Logical switch"
    annotation (Placement(transformation(extent={{160,-170},{180,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiWatByp
    "Chilled water bypass flow setpoint"
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi5 "Logical switch"
    annotation (Placement(transformation(extent={{160,-240},{180,-220}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableChiller
    enaChi(final nChi=nChi, final proOnTim=proOnTim) "Enable next chiller"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));

equation
  connect(uOnOff, not2.u)
    annotation (Line(points={{-220,100},{-162,100}}, color={255,0,255}));
  connect(booToRea1.y,curDisChi. u)
    annotation (Line(points={{-138,20},{-122,20}},   color={0,0,127}));
  connect(uChiWatReq, booToRea1.u)
    annotation (Line(points={{-220,20},{-162,20}},   color={255,0,255}));
  connect(curDisChi.y, lesEquThr.u)
    annotation (Line(points={{-98,20},{-82,20}}, color={0,0,127}));
  connect(lesEquThr.y, and4.u2)
    annotation (Line(points={{-58,20},{0,20},{0,32}, {18,32}}, color={255,0,255}));
  connect(uNexDisChi,disChiIsoVal. uNexChaChi)
    annotation (Line(points={{-220,70},{-180,70},{-180,-2},{98,-2}},
      color={255,127,0}));
  connect(uChiWatIsoVal,disChiIsoVal. uChiWatIsoVal)
    annotation (Line(points={{-220,-6},{-62,-6},{-62,-5},{98,-5}},
      color={0,0,127}));
  connect(and4.y,disChiIsoVal. yUpsDevSta)
    annotation (Line(points={{42,40},{60,40},{60,-15},{98,-15}},  color={255,0,255}));
  connect(con2.y,disChiIsoVal. uStaCha)
    annotation (Line(points={{-58,-30},{20,-30},{20,-18},{98,-18}}, color={255,0,255}));
  connect(uConWatReq, booToRea2.u)
    annotation (Line(points={{-220,-70},{-162,-70}},   color={255,0,255}));
  connect(booToRea2.y, curDisChi1.u)
    annotation (Line(points={{-138,-70},{-122,-70}},   color={0,0,127}));
  connect(uNexDisChi, curDisChi1.index)
    annotation (Line(points={{-220,70},{-180,70},{-180,-90},{-110,-90},{-110,-82}},
      color={255,127,0}));
  connect(curDisChi1.y,lesEquThr1. u)
    annotation (Line(points={{-98,-70},{-82,-70}}, color={0,0,127}));
  connect(lesEquThr1.y, and5.u1)
    annotation (Line(points={{-58,-70},{-22,-70}}, color={255,0,255}));
  connect(disChiIsoVal.yEnaChiWatIsoVal, and5.u2)
    annotation (Line(points={{122,-4},{160,-4},{160,10},{-40,10},{-40,-78},{-22,
          -78}},  color={255,0,255}));
  connect(con2.y, disHeaCon.uStaCha)
    annotation (Line(points={{-58,-30},{20,-30},{20,-66},{78,-66}}, color={255,0,255}));
  connect(and5.y, disHeaCon.uUpsDevSta) annotation (Line(points={{2,-70},{40,
          -70},{40,-62},{78,-62}},
                                color={255,0,255}));
  connect(uNexDisChi, disHeaCon.uNexChaChi)
    annotation (Line(points={{-220,70},{-180,70},{-180,-90},{40,-90},{40,-74},{78,
          -74}},            color={255,127,0}));
  connect(disHeaCon.uChiHeaCon, uChiHeaCon) annotation (Line(points={{78,-78},{60,
          -78},{60,-100},{-220,-100}},     color={255,0,255}));
  connect(uNexDisChi, curDisChi.index) annotation (Line(points={{-220,70},{-180,
          70},{-180,-2},{-110,-2},{-110,8}},        color={255,127,0}));
  connect(con3.y, minChiWatSet.uStaDow) annotation (Line(points={{-138,-150},{0,
          -150},{0,-139},{78,-139}},  color={255,0,255}));
  connect(disHeaCon.yEnaHeaCon, minChiWatSet.uUpsDevSta) annotation (Line(
        points={{102,-64},{120,-64},{120,-104},{40,-104},{40,-123},{78,-123}},
        color={255,0,255}));
  connect(disHeaCon.yEnaHeaCon, minBypSet.uUpsDevSta) annotation (Line(points={{
          102,-64},{120,-64},{120,-104},{40,-104},{40,-172},{78,-172}}, color={255,
          0,255}));
  connect(con2.y, minBypSet.uStaCha) annotation (Line(points={{-58,-30},{20,-30},
          {20,-176},{78,-176}}, color={255,0,255}));
  connect(minBypSet.VChiWat_flow, VChiWat_flow)
    annotation (Line(points={{78,-184},{-220,-184}}, color={0,0,127}));
  connect(not2.y, booRep4.u) annotation (Line(points={{-138,100},{-130,100},{
          -130,60},{-62,60}},
                           color={255,0,255}));
  connect(uChiHeaCon, logSwi3.u1) annotation (Line(points={{-220,-100},{130,-100},
          {130,-42},{158,-42}},   color={255,0,255}));
  connect(disHeaCon.yChiHeaCon, logSwi3.u3) annotation (Line(points={{102,-76},
          {140,-76},{140,-58},{158,-58}},    color={255,0,255}));
  connect(logSwi3.y, yChiHeaCon)
    annotation (Line(points={{182,-50},{220,-50}},   color={255,0,255}));
  connect(booRep4.y, logSwi3.u2) annotation (Line(points={{-38,60},{50,60},{50,
          -50},{158,-50}},   color={255,0,255}));
  connect(booRep4.y, chiWatIso.u2)
    annotation (Line(points={{-38,60},{158,60}},   color={255,0,255}));
  connect(uChiWatIsoVal, chiWatIso.u1) annotation (Line(points={{-220,-6},{80,-6},
          {80,68},{158,68}},   color={0,0,127}));
  connect(disChiIsoVal.yChiWatIsoVal, chiWatIso.u3) annotation (Line(points={{122,-16},
          {140,-16},{140,52},{158,52}},    color={0,0,127}));
  connect(chiWatIso.y, yChiWatIsoVal)
    annotation (Line(points={{182,60},{220,60}},   color={0,0,127}));
  connect(not2.y, logSwi4.u2) annotation (Line(points={{-138,100},{-130,100},{
          -130,-160},{158,-160}},
                             color={255,0,255}));
  connect(con2.y, logSwi4.u1) annotation (Line(points={{-58,-30},{20,-30},{20,-152},
          {158,-152}},       color={255,0,255}));
  connect(minBypSet.yMinBypRes, logSwi4.u3) annotation (Line(points={{102,-180},
          {120,-180},{120,-168},{158,-168}}, color={255,0,255}));
  connect(not2.y, chiWatByp.u2) annotation (Line(points={{-138,100},{-130,100},{
          -130,-110},{158,-110}}, color={255,0,255}));
  connect(VChiWat_flow, chiWatByp.u1) annotation (Line(points={{-220,-184},{40,-184},
          {40,-200},{140,-200},{140,-102},{158,-102}}, color={0,0,127}));
  connect(chiWatByp.y,yChiWatMinSet)
    annotation (Line(points={{182,-110},{220,-110}}, color={0,0,127}));
  connect(not2.y, logSwi5.u2) annotation (Line(points={{-138,100},{-130,100},{
          -130,-230},{158,-230}},
                             color={255,0,255}));
  connect(logSwi4.y, logSwi5.u3) annotation (Line(points={{182,-160},{190,-160},
          {190,-210},{140,-210},{140,-238},{158,-238}}, color={255,0,255}));
  connect(logSwi5.y, yEndSta)
    annotation (Line(points={{182,-230},{220,-230}}, color={255,0,255}));

  connect(uNexEnaChi, enaChi.uNexEnaChi) annotation (Line(points={{-220,240},{-88,
          240},{-88,149},{-62,149}}, color={255,127,0}));
  connect(uStaUp, enaChi.uStaUp) annotation (Line(points={{-220,210},{-94,210},{
          -94,146},{-62,146}}, color={255,0,255}));
  connect(uEnaChiWatIsoVal, enaChi.uEnaChiWatIsoVal) annotation (Line(points={{-220,
          180},{-100,180},{-100,142},{-62,142}}, color={255,0,255}));
  connect(uChi, enaChi.uChi) annotation (Line(points={{-220,150},{-170,150},{-170,
          138},{-62,138}}, color={255,0,255}));
  connect(uOnOff, enaChi.uOnOff) annotation (Line(points={{-220,100},{-190,100},
          {-190,134},{-62,134}}, color={255,0,255}));
  connect(uNexDisChi, enaChi.uNexDisChi) annotation (Line(points={{-220,70},{
          -100,70},{-100,131},{-62,131}},
                                     color={255,127,0}));
  connect(enaChi.yNewChiEna, and4.u1) annotation (Line(points={{-38,132},{-30,
          132},{-30,40},{18,40}}, color={255,0,255}));
  connect(enaChi.yNewChiEna, logSwi5.u1) annotation (Line(points={{-38,132},{
          -30,132},{-30,-222},{158,-222}}, color={255,0,255}));
  connect(enaChi.yChi, yChi)
    annotation (Line(points={{-38,148},{92,148},{92,140},{220,140}},
                                                   color={255,0,255}));
  connect(uStaUp, minChiWatSet.uStaUp) annotation (Line(points={{-220,210},{-94,
          210},{-94,-121},{78,-121}}, color={255,0,255}));
  connect(uChi, minChiWatSet.uChi) annotation (Line(points={{-220,150},{-170,
          150},{-170,-126},{78,-126}},
                                  color={255,0,255}));
  connect(uNexEnaChi, minChiWatSet.nexEnaChi) annotation (Line(points={{-220,
          240},{-88,240},{-88,-129},{78,-129}},
                                           color={255,127,0}));
  connect(uNexDisChi, minChiWatSet.nexDisChi) annotation (Line(points={{-220,70},
          {-180,70},{-180,-131},{78,-131}}, color={255,127,0}));
  connect(uOnOff, minChiWatSet.uOnOff) annotation (Line(points={{-220,100},{
          -190,100},{-190,-137},{78,-137}},
                                       color={255,0,255}));
  connect(con3.y, minChiWatSet.uSubCha) annotation (Line(points={{-138,-150},{0,
          -150},{0,-134},{78,-134}}, color={255,0,255}));
  connect(minChiWatSet.yChiWatMinFloSet, chiWatByp.u3) annotation (Line(points={{102,
          -130},{120,-130},{120,-118},{158,-118}},      color={0,0,127}));
  connect(minChiWatSet.yChiWatMinFloSet, minBypSet.VMinChiWat_setpoint)
    annotation (Line(points={{102,-130},{120,-130},{120,-146},{60,-146},{60,
          -188},{78,-188}},
                      color={0,0,127}));
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
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Close chilled water 
isolation valve"),
          Rectangle(
          extent={{-198,-60},{198,-96}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{76,-64},{192,-72}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable head
pressure control"),
          Rectangle(
          extent={{-198,-98},{198,-198}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-182,-168},{-66,-176}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
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
          lineColor={0,0,127},
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
          lineColor={0,0,127},
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
          lineColor={0,0,255},
          textString="%name")}));
end UpEnd;
