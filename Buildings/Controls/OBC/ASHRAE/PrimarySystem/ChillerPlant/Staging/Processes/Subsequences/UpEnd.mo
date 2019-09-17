within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block UpEnd "Sequence for ending stage-up process"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Integer nSta = 3 "Total number of stages";
  parameter Modelica.SIunits.Time proOnTim = 300
    "Threshold time to check if newly enabled chiller being operated by more than 5 minutes";
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[nSta]={0,0.0089,0.0177}
    "Minimum bypass flow rate at each chiller stage";
  parameter Modelica.SIunits.Time byPasSetTim=300
    "Time to slowly reset minimum by-pass flow";
  parameter Modelica.SIunits.Time aftByPasSetTim=60
    "Time after minimum bypass flow being resetted to new setpoint";
  parameter Modelica.SIunits.VolumeFlowRate minFloDif=0.01
    "Minimum flow rate difference to check if bybass flow achieves setpoint";

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
    each final unit="1",
    each final min=0,
    each final max=1) "Chilled water isolation valve position"
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
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta
    "Current stage index"
    annotation (Placement(transformation(extent={{-240,-170},{-200,-130}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBypas_flow(
    final unit="m3/s")
    "Measured bypass flow rate"
    annotation (Placement(transformation(extent={{-240,-204},{-200,-164}}),
      iconTransformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{200,130},{220,150}}),
      iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{200,50},{220,70}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{200,-60},{220,-40}}),
      iconTransformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatBypSet(
    final unit="m3/s")
    "Chilled water minimum flow bypass setpoint"
    annotation (Placement(transformation(extent={{200,-120},{220,-100}}),
      iconTransformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSta
    "Flag to indicate if the staging process is finished"
    annotation (Placement(transformation(extent={{200,-240},{220,-220}}),
      iconTransformation(extent={{100,-100},{120,-80}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr(
    final threshold=0.5)
    "Check if the disabled chiller is not requiring chilled water"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences.EnableChiIsoVal
    disChiIsoVal(
    final nChi=nChi,
    final iniValPos=1,
    final endValPos=0) "Disable isolation valve of the chiller being disabled"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=true) "True constant"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr1(
    final threshold=0.5)
    "Check if the disabled chiller is not requiring condenser water"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 "Logical and"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences.EnableHeadControl
    disHeaCon(final nChi=nChi, final heaStaCha=false)
    "Disable head pressure control of the chiller being disabled"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint minBypSet(
    final nSta=nSta,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet) "Reset minimum bypass flow setpoint"
    annotation (Placement(transformation(extent={{80,-138},{100,-118}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-60,-146},{-40,-126}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences.ResetMinBypass
    minBypSet1(
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
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences.EnableChiller
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
  connect(lesEquThr.y, and4.u2) annotation (Line(points={{-58,20},{0,20},{0,32},
          {18,32}}, color={255,0,255}));
  connect(uNexDisChi,disChiIsoVal. uNexChaChi)
    annotation (Line(points={{-220,70},{-180,70},{-180,-2},{98,-2}},
      color={255,127,0}));
  connect(uChiWatIsoVal,disChiIsoVal. uChiWatIsoVal)
    annotation (Line(points={{-220,-6},{98,-6}}, color={0,0,127}));
  connect(and4.y,disChiIsoVal. yUpsDevSta)
    annotation (Line(points={{41,40},{60,40},{60,-14},{98,-14}},  color={255,0,255}));
  connect(con2.y,disChiIsoVal. uStaCha)
    annotation (Line(points={{-79,-30},{20,-30},{20,-18},{98,-18}}, color={255,0,255}));
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
    annotation (Line(points={{121,-4},{160,-4},{160,10},{-40,10},{-40,-78},
      {-22,-78}}, color={255,0,255}));
  connect(con2.y, disHeaCon.uStaCha)
    annotation (Line(points={{-79,-30},{20,-30},{20,-66},{78,-66}}, color={255,0,255}));
  connect(and5.y, disHeaCon.uUpsDevSta) annotation (Line(points={{1,-70},{40,-70},
          {40,-62},{78,-62}},   color={255,0,255}));
  connect(uNexDisChi, disHeaCon.uNexChaChi)
    annotation (Line(points={{-220,70},{-180,70},{-180,-90},{40,-90},{40,-74},{78,
          -74}},            color={255,127,0}));
  connect(disHeaCon.uChiHeaCon, uChiHeaCon) annotation (Line(points={{78,-78},{60,
          -78},{60,-100},{-220,-100}},     color={255,0,255}));
  connect(uNexDisChi, curDisChi.index) annotation (Line(points={{-220,70},{-180,
          70},{-180,-2},{-110,-2},{-110,8}},        color={255,127,0}));
  connect(con3.y, minBypSet.uStaUp) annotation (Line(points={{-38,-136},{0,-136},
          {0,-119},{79,-119}},   color={255,0,255}));
  connect(con3.y, minBypSet.uOnOff) annotation (Line(points={{-38,-136},{0,-136},
          {0,-135},{79,-135}},   color={255,0,255}));
  connect(con3.y, minBypSet.uStaDow) annotation (Line(points={{-38,-136},{20,
          -136},{20,-137},{79,-137}},
                                 color={255,0,255}));
  connect(uSta, minBypSet.uSta)
    annotation (Line(points={{-220,-150},{-20,-150},{-20,-128},{78,-128}},
      color={255,127,0}));
  connect(disHeaCon.yEnaHeaCon, minBypSet.uUpsDevSta)
    annotation (Line(points={{101,-64},{120,-64},{120,-104},{40,-104},{40,-124},
          {78,-124}},       color={255,0,255}));
  connect(disHeaCon.yEnaHeaCon, minBypSet1.uUpsDevSta)
    annotation (Line(points={{101,-64},{120,-64},{120,-104},{40,-104},{40,-172},
          {78,-172}},       color={255,0,255}));
  connect(con2.y, minBypSet1.uStaCha) annotation (Line(points={{-79,-30},{20,-30},
          {20,-176},{78,-176}}, color={255,0,255}));
  connect(minBypSet.yChiWatBypSet, minBypSet1.VBypas_setpoint)
    annotation (Line(points={{101,-128},{120,-128},{120,-148},{60,-148},{60,-188},
          {78,-188}},       color={0,0,127}));
  connect(minBypSet1.VBypas_flow, VBypas_flow)
    annotation (Line(points={{78,-184},{-220,-184}}, color={0,0,127}));
  connect(not2.y, booRep4.u) annotation (Line(points={{-138,100},{-130,100},{
          -130,60},{-62,60}},
                           color={255,0,255}));
  connect(uChiHeaCon, logSwi3.u1) annotation (Line(points={{-220,-100},{130,-100},
          {130,-42},{158,-42}},   color={255,0,255}));
  connect(disHeaCon.yChiHeaCon, logSwi3.u3) annotation (Line(points={{101,-76},{
          140,-76},{140,-58},{158,-58}},     color={255,0,255}));
  connect(logSwi3.y, yChiHeaCon)
    annotation (Line(points={{182,-50},{210,-50}},   color={255,0,255}));
  connect(booRep4.y, logSwi3.u2) annotation (Line(points={{-38,60},{50,60},{50,
          -50},{158,-50}},   color={255,0,255}));
  connect(booRep4.y, chiWatIso.u2)
    annotation (Line(points={{-38,60},{158,60}},   color={255,0,255}));
  connect(uChiWatIsoVal, chiWatIso.u1) annotation (Line(points={{-220,-6},{80,-6},
          {80,68},{158,68}},   color={0,0,127}));
  connect(disChiIsoVal.yChiWatIsoVal, chiWatIso.u3) annotation (Line(points={{121,-10},
          {140,-10},{140,52},{158,52}},    color={0,0,127}));
  connect(chiWatIso.y, yChiWatIsoVal)
    annotation (Line(points={{182,60},{210,60}},   color={0,0,127}));
  connect(not2.y, logSwi4.u2) annotation (Line(points={{-138,100},{-130,100},{
          -130,-160},{158,-160}},
                             color={255,0,255}));
  connect(con2.y, logSwi4.u1) annotation (Line(points={{-78,-30},{20,-30},{20,
          -152},{158,-152}}, color={255,0,255}));
  connect(minBypSet1.yMinBypRes, logSwi4.u3) annotation (Line(points={{101,-180},
          {120,-180},{120,-168},{158,-168}}, color={255,0,255}));
  connect(not2.y, chiWatByp.u2) annotation (Line(points={{-138,100},{-130,100},
          {-130,-110},{158,-110}},color={255,0,255}));
  connect(minBypSet.yChiWatBypSet, chiWatByp.u3) annotation (Line(points={{101,-128},
          {120,-128},{120,-118},{158,-118}}, color={0,0,127}));
  connect(VBypas_flow, chiWatByp.u1) annotation (Line(points={{-220,-184},{40,-184},
          {40,-200},{140,-200},{140,-102},{158,-102}}, color={0,0,127}));
  connect(chiWatByp.y, yChiWatBypSet)
    annotation (Line(points={{182,-110},{210,-110}}, color={0,0,127}));
  connect(not2.y, logSwi5.u2) annotation (Line(points={{-138,100},{-130,100},{
          -130,-230},{158,-230}},
                             color={255,0,255}));
  connect(logSwi4.y, logSwi5.u3) annotation (Line(points={{182,-160},{190,-160},
          {190,-210},{140,-210},{140,-238},{158,-238}}, color={255,0,255}));
  connect(logSwi5.y, yEndSta)
    annotation (Line(points={{182,-230},{210,-230}}, color={255,0,255}));

  connect(uNexEnaChi, enaChi.uNexEnaChi) annotation (Line(points={{-220,240},{-80,
          240},{-80,150},{-62,150}}, color={255,127,0}));
  connect(uStaUp, enaChi.uStaUp) annotation (Line(points={{-220,210},{-90,210},{
          -90,146},{-62,146}}, color={255,0,255}));
  connect(uEnaChiWatIsoVal, enaChi.uEnaChiWatIsoVal) annotation (Line(points={{-220,
          180},{-100,180},{-100,142},{-62,142}}, color={255,0,255}));
  connect(uChi, enaChi.uChi) annotation (Line(points={{-220,150},{-120,150},{-120,
          138},{-62,138}}, color={255,0,255}));
  connect(uOnOff, enaChi.uOnOff) annotation (Line(points={{-220,100},{-180,100},
          {-180,134},{-62,134}}, color={255,0,255}));
  connect(uNexDisChi, enaChi.uNexDisChi) annotation (Line(points={{-220,70},{-100,
          70},{-100,130},{-62,130}}, color={255,127,0}));
  connect(enaChi.yNewChi, and4.u1) annotation (Line(points={{-39,132},{-30,132},
          {-30,40},{18,40}}, color={255,0,255}));
  connect(enaChi.yNewChi, logSwi5.u1) annotation (Line(points={{-39,132},{-30,132},
          {-30,-222},{158,-222}}, color={255,0,255}));
  connect(enaChi.yChi, yChi)
    annotation (Line(points={{-39,140},{210,140}}, color={255,0,255}));
annotation (
  defaultComponentName="endUp",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-260},{200,260}}), graphics={
          Rectangle(
          extent={{-198,58},{198,-18}},
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
          extent={{-198,-42},{198,-78}},
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
          extent={{-198,258},{198,82}},
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
