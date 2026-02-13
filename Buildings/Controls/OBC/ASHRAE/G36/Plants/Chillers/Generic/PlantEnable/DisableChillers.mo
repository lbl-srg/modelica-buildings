within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.PlantEnable;
block DisableChillers
  "Disable devices when the plant is disabled from chiller mode"
  parameter Boolean have_airCoo=false
    "True: the plant has air cooled chiller";
  parameter Boolean have_WSE=true
    "True if the plant has waterside economizer. When the plant has waterside economizer, the condenser water pump speed must be variable"
    annotation (Dialog(enable=not have_airCoo));
  parameter Integer nChi=2
    "Total number of chillers";
  parameter Integer nChiWatPum = 2
    "Total number of chilled water pumps";
  parameter Integer nConWatPum = 2
    "Total number of condenser water pumps"
    annotation (Dialog(enable=not have_airCoo));
  parameter Integer nTowCel = 2
    "Total number of cooling tower cells"
    annotation (Dialog(enable=not have_airCoo));
  parameter Boolean have_fixSpeConWatPum = false
    "True: the plant has fixed speed condenser water pumps. When the plant has waterside economizer, it must be false"
    annotation (Dialog(enable=not have_airCoo));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller commanded on"
    annotation (Placement(transformation(extent={{-240,210},{-200,250}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water requst status for each chiller"
    annotation (Placement(transformation(extent={{-240,170},{-200,210}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiWatIsoVal[nChi]
    "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    if not have_airCoo
    "Condenser water requst status for each chiller"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi)) if not have_airCoo
    "Chiller condenser water isolation valve position"
    annotation (Placement(transformation(extent={{-240,70},{-200,110}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ConWatIsoVal[nChi]
    if not have_airCoo
    "Condenser water isolation valve commanded setpoint"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nChiWatPum]
    "Chilled water pump commanded status"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatPumSpe
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{-240,-90},{-200,-50}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-240,-120},{-200,-80}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe
    if not have_fixSpeConWatPum and not have_airCoo
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-240,-170},{-200,-130}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[nConWatPum]
    if not have_airCoo "Condenser water pump commanded status"
    annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    if have_WSE and not have_airCoo
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-240,-290},{-200,-250}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiWatIsoVal[nChi]
    "Chiller chilled water isolation valve commanded setpoint"
    annotation (Placement(transformation(extent={{200,210},{240,250}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi)) if not have_airCoo
    "Chiller condenser water isolation valve position setpoints"
    annotation (Placement(transformation(extent={{200,100},{240,140}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ConWatIsoVal[nChi]
    if not have_airCoo
    "Condenser water isolation valve commanded setpoint"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiWatPum[nChiWatPum]
    "Chilled water pump commanded status: true-comanded on"
    annotation (Placement(transformation(extent={{200,20},{240,60}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe(
    final unit="1",
    final min=0,
    final max=1) "Chilled water pump speed"
    annotation (Placement(transformation(extent={{200,-70},{240,-30}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpe(
    final unit="1",
    final min=0,
    final max=1) if not have_fixSpeConWatPum and not have_airCoo
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{200,-150},{240,-110}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatPum[nConWatPum]
    if not have_airCoo
    "Condenser water pump commanded status: true-comanded on"
    annotation (Placement(transformation(extent={{200,-230},{240,-190}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowCel if not
    have_airCoo
    "True: the tower cells should be enabled"
    annotation (Placement(transformation(extent={{200,-270},{240,-230}}),
        iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=180)
    "Threshold time after chiller being disabled"
    annotation (Placement(transformation(extent={{-100,220},{-80,240}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChi)
    "Check if there is any chilled water request"
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,220},{100,240}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nChi) if not have_airCoo
    "Check if there is any condenser water request"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep2(
    final nout=nChi) if not have_airCoo
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,130},{80,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep5(
    final nout=nConWatPum) if not have_airCoo
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Not noChi
    "No enabled chiller"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));
  Buildings.Controls.OBC.CDL.Logical.Not noChiWatReq
    "No chilled water request"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloChiIsoVal
    "Close all chilled water isolation valve"
    annotation (Placement(transformation(extent={{-40,220},{-20,240}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nChi] "Close valve"
    annotation (Placement(transformation(extent={{140,220},{160,240}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloConIsoVal if not have_airCoo
    "Close all condenser water isolation valve"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not noConWatReq if not have_airCoo
    "No condenser water request"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nChi] if not have_airCoo
    "Close valve"
    annotation (Placement(transformation(extent={{140,110},{160,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloPums "Disable pumps"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2 "Disable pumps"
    annotation (Placement(transformation(extent={{160,-60},{180,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3
    if not have_fixSpeConWatPum and not have_airCoo "Disable pumps"
    annotation (Placement(transformation(extent={{160,-140},{180,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{40,220},{60,240}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 if not have_airCoo
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Not in staging process"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 if not have_airCoo
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr chiMod(
    final nin=nChi)
    "True: the plant has chiller mode"
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nChi](
    final k=fill(0, nChi)) "Constant zero"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(final k=0)
    if not have_fixSpeConWatPum and not have_airCoo "Constant zero"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 if have_WSE and not have_airCoo
    "Not in staging process"
    annotation (Placement(transformation(extent={{-80,-240},{-60,-220}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And and6 if not have_airCoo
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(
    final k=true) if not have_WSE or have_airCoo
    "Logical true"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Or disTow if not have_airCoo
    "Disable cooling tower"
    annotation (Placement(transformation(extent={{80,-260},{100,-240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4(
    final k=false) if not have_WSE and not have_airCoo
    "Logical false"
    annotation (Placement(transformation(extent={{-20,-290},{0,-270}})));
  Buildings.Controls.OBC.CDL.Logical.And and7[nChi] if not have_airCoo
    "Condenser water isolation valve commended setpoint"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));
  Buildings.Controls.OBC.CDL.Logical.And conWatPum[nConWatPum]
    if not have_airCoo
    "Condenser water pump commanded status"
    annotation (Placement(transformation(extent={{160,-220},{180,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nConWatPum] if not have_airCoo
    "Not disable pumps"
    annotation (Placement(transformation(extent={{160,-180},{180,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5(
    final k=false) if have_airCoo "Logical true"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And chiWatPum1[nChiWatPum]
    "Chilled water pump commanded status"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep3(
    final nout=nChiWatPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3[nChiWatPum]
    "Not disable pumps"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6[nChi](
    final k=fill(false, nChi))
    "Logical false"
    annotation (Placement(transformation(extent={{80,260},{100,280}})));

equation
  connect(uChiWatReq, mulOr.u)
    annotation (Line(points={{-220,190},{-182,190}}, color={255,0,255}));
  connect(mulOr.y, noChiWatReq.u)
    annotation (Line(points={{-158,190},{-142,190}}, color={255,0,255}));
  connect(truDel.y, cloChiIsoVal.u1)
    annotation (Line(points={{-78,230},{-42,230}},color={255,0,255}));
  connect(noChiWatReq.y, cloChiIsoVal.u2) annotation (Line(points={{-118,190},{-50,
          190},{-50,222},{-42,222}}, color={255,0,255}));
  connect(booScaRep1.y, logSwi.u2)
    annotation (Line(points={{102,230},{138,230}}, color={255,0,255}));
  connect(truDel.y, cloConIsoVal.u1) annotation (Line(points={{-78,230},{-60,230},
          {-60,140},{-42,140}}, color={255,0,255}));
  connect(mulOr1.y, noConWatReq.u)
    annotation (Line(points={{-158,120},{-142,120}}, color={255,0,255}));
  connect(uConWatReq, mulOr1.u)
    annotation (Line(points={{-220,120},{-182,120}}, color={255,0,255}));
  connect(noConWatReq.y, cloConIsoVal.u2) annotation (Line(points={{-118,120},{-60,
          120},{-60,132},{-42,132}}, color={255,0,255}));
  connect(booScaRep2.y, swi1.u2)
    annotation (Line(points={{82,140},{100,140},{100,120},{138,120}},
          color={255,0,255}));
  connect(uConWatIsoVal, swi1.u3) annotation (Line(points={{-220,90},{60,90},{60,
          112},{138,112}}, color={0,0,127}));
  connect(cloChiIsoVal.y, cloPums.u2) annotation (Line(points={{-18,230},{-10,230},
          {-10,170},{-100,170},{-100,-58},{-82,-58}}, color={255,0,255}));
  connect(cloConIsoVal.y, cloPums.u1) annotation (Line(points={{-18,140},{-10,140},
          {-10,100},{-90,100},{-90,-50},{-82,-50}}, color={255,0,255}));
  connect(uChiWatPumSpe, swi2.u3) annotation (Line(points={{-220,-70},{140,-70},
          {140,-58},{158,-58}}, color={0,0,127}));
  connect(uConWatPumSpe, swi3.u3) annotation (Line(points={{-220,-150},{140,-150},
          {140,-138},{158,-138}}, color={0,0,127}));
  connect(and2.y, booScaRep1.u)
    annotation (Line(points={{62,230},{78,230}}, color={255,0,255}));
  connect(cloChiIsoVal.y, and2.u1)
    annotation (Line(points={{-18,230},{38,230}}, color={255,0,255}));
  connect(and1.y, booScaRep2.u)
    annotation (Line(points={{42,140},{58,140}}, color={255,0,255}));
  connect(cloConIsoVal.y, and1.u1)
    annotation (Line(points={{-18,140},{18,140}}, color={255,0,255}));
  connect(chaPro, not4.u)
    annotation (Line(points={{-220,-100},{-82,-100}}, color={255,0,255}));
  connect(not4.y, and1.u2) annotation (Line(points={{-58,-100},{0,-100},{0,132},
          {18,132}}, color={255,0,255}));
  connect(not4.y, and2.u2) annotation (Line(points={{-58,-100},{0,-100},{0,222},
          {38,222}}, color={255,0,255}));
  connect(cloPums.y, and3.u1)
    annotation (Line(points={{-58,-50},{18,-50}}, color={255,0,255}));
  connect(cloPums.y, and4.u1) annotation (Line(points={{-58,-50},{-10,-50},{-10,
          -130},{18,-130}}, color={255,0,255}));
  connect(not4.y, and4.u2) annotation (Line(points={{-58,-100},{0,-100},{0,-138},
          {18,-138}},color={255,0,255}));
  connect(not4.y, and3.u2) annotation (Line(points={{-58,-100},{0,-100},{0,-58},
          {18,-58}}, color={255,0,255}));
  connect(swi3.y, yConWatPumSpe)
    annotation (Line(points={{182,-130},{220,-130}}, color={0,0,127}));
  connect(swi2.y, yChiWatPumSpe)
    annotation (Line(points={{182,-50},{220,-50}}, color={0,0,127}));
  connect(swi1.y, yConWatIsoVal)
    annotation (Line(points={{162,120},{220,120}}, color={0,0,127}));
  connect(uChi, chiMod.u)
    annotation (Line(points={{-220,230},{-182,230}}, color={255,0,255}));
  connect(chiMod.y, noChi.u)
    annotation (Line(points={{-158,230},{-142,230}}, color={255,0,255}));
  connect(con.y, swi1.u1) annotation (Line(points={{82,180},{130,180},{130,128},
          {138,128}}, color={0,0,127}));
  connect(con1.y, swi2.u1) annotation (Line(points={{42,-20},{100,-20},{100,-42},
          {158,-42}}, color={0,0,127}));
  connect(con2.y, swi3.u1) annotation (Line(points={{122,-90},{140,-90},{140,-122},
          {158,-122}}, color={0,0,127}));
  connect(uWSE, not1.u)
    annotation (Line(points={{-220,-270},{-180,-270},{-180,-230},{-82,-230}},
          color={255,0,255}));
  connect(and3.y, and5.u1)
    annotation (Line(points={{42,-50},{58,-50}}, color={255,0,255}));
  connect(and4.y, and6.u1)
    annotation (Line(points={{42,-130},{58,-130}}, color={255,0,255}));
  connect(and6.y, booScaRep5.u)
    annotation (Line(points={{82,-130},{90,-130},{90,-170},{98,-170}}, color={255,0,255}));
  connect(not1.y, and5.u2) annotation (Line(points={{-58,-230},{50,-230},{50,-58},
          {58,-58}}, color={255,0,255}));
  connect(not1.y, and6.u2) annotation (Line(points={{-58,-230},{50,-230},{50,-138},
          {58,-138}}, color={255,0,255}));
  connect(con3.y, and5.u2) annotation (Line(points={{-58,-180},{50,-180},{50,-58},
          {58,-58}}, color={255,0,255}));
  connect(con3.y, and6.u2) annotation (Line(points={{-58,-180},{50,-180},{50,-138},
          {58,-138}}, color={255,0,255}));
  connect(chiMod.y, disTow.u1) annotation (Line(points={{-158,230},{-150,230},{-150,
          -250},{78,-250}}, color={255,0,255}));
  connect(disTow.y, yTowCel)
    annotation (Line(points={{102,-250},{220,-250}}, color={255,0,255}));
  connect(uWSE, disTow.u2) annotation (Line(points={{-220,-270},{-180,-270},{-180,
          -258},{78,-258}}, color={255,0,255}));
  connect(con4.y, disTow.u2) annotation (Line(points={{2,-280},{60,-280},{60,-258},
          {78,-258}}, color={255,0,255}));
  connect(noChi.y, truDel.u)
    annotation (Line(points={{-118,230},{-102,230}}, color={255,0,255}));
  connect(u1ConWatIsoVal, and7.u2) annotation (Line(points={{-220,60},{80,60},{80,
          72},{138,72}}, color={255,0,255}));
  connect(booScaRep2.y, and7.u1) annotation (Line(points={{82,140},{100,140},{100,
          80},{138,80}}, color={255,0,255}));
  connect(and7.y, y1ConWatIsoVal)
    annotation (Line(points={{162,80},{220,80}}, color={255,0,255}));
  connect(booScaRep5.y, not2.u) annotation (Line(points={{122,-170},{158,-170}},
          color={255,0,255}));
  connect(not2.y, conWatPum.u1) annotation (Line(points={{182,-170},{190,-170},{
          190,-188},{150,-188},{150,-210},{158,-210}}, color={255,0,255}));
  connect(uConWatPum, conWatPum.u2) annotation (Line(points={{-220,-200},{80,-200},
          {80,-218},{158,-218}},  color={255,0,255}));
  connect(conWatPum.y, yConWatPum)
    annotation (Line(points={{182,-210},{220,-210}}, color={255,0,255}));
  connect(con5.y, cloPums.u1)
    annotation (Line(points={{-118,-50},{-82,-50}}, color={255,0,255}));
  connect(and5.y, swi2.u2)
    annotation (Line(points={{82,-50},{158,-50}}, color={255,0,255}));
  connect(and6.y, swi3.u2)
    annotation (Line(points={{82,-130},{158,-130}}, color={255,0,255}));
  connect(and5.y, booScaRep3.u) annotation (Line(points={{82,-50},{90,-50},{90,0},
          {98,0}}, color={255,0,255}));
  connect(not3.y, chiWatPum1.u2) annotation (Line(points={{162,0},{170,0},{170,20},
          {150,20},{150,32},{158,32}}, color={255,0,255}));
  connect(booScaRep3.y, not3.u)
    annotation (Line(points={{122,0},{138,0}}, color={255,0,255}));
  connect(uChiWatPum, chiWatPum1.u1) annotation (Line(points={{-220,0},{-20,0},{
          -20,40},{158,40}}, color={255,0,255}));
  connect(chiWatPum1.y, yChiWatPum)
    annotation (Line(points={{182,40},{220,40}}, color={255,0,255}));
  connect(logSwi.y, y1ChiWatIsoVal)
    annotation (Line(points={{162,230},{220,230}}, color={255,0,255}));
  connect(u1ChiWatIsoVal, logSwi.u3) annotation (Line(points={{-220,160},{120,160},
          {120,222},{138,222}}, color={255,0,255}));
  connect(con6.y, logSwi.u1) annotation (Line(points={{102,270},{120,270},{120,238},
          {138,238}}, color={255,0,255}));
annotation (defaultComponentName = "disChi",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,160}}),
    graphics={
        Rectangle(
          extent={{-100,-160},{100,160}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,200},{100,160}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-300},{200,300}})),
  Documentation(info="<html>
<p>
It disables the devices when the chiller plant is disabled in chiller mode.
It is implemented as ASHRAE Guideline 36-2021, section 5.20.2.5 and 5.20.2.7.
</p>
<p>
When the plant is disabled:
</p>
<ul>
<li>
Shut off all enabled chillers, if any.
</li>
<li>
For each enabled chiller, close the chilled water isolation valve after
3 minutes or the chiller is not requesting chilled water flow.
</li>
<li>
For each enabled chiller, close the condenser water isolation valve after
3 minutes or the chiller is not requesting condenser water flow.
</li>
<li>
Disable the operating primary chilled water pumps, condenser water pumps, and
cooling towers.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
July 20, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DisableChillers;
