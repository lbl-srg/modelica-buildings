within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.PlantEnable;
block DisableChillers
  "Disable devices when the plant is disabled from chiller mode"

  parameter Boolean have_WSE=true
    "True if the plant has waterside economizer. When the plant has waterside economizer, the condenser water pump speed must be variable";
  parameter Integer nChi=2
    "Total number of chillers";
  parameter Integer nChiWatPum = 2
    "Total number of chilled water pumps";
  parameter Integer nConWatPum = 2
    "Total number of condenser water pumps";
  parameter Integer nTowCel = 2
    "Total number of cooling tower cells";
  parameter Boolean have_fixSpeConWatPum = false
    "True: the plant has fixed speed condenser water pumps. When the plant has waterside economizer, it must be false";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller commanded on"
    annotation (Placement(transformation(extent={{-240,210},{-200,250}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water requst status for each chiller"
    annotation (Placement(transformation(extent={{-240,170},{-200,210}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi)) "Chilled water isolation valve position"
    annotation(Placement(transformation(extent={{-240,140},{-200,180}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water requst status for each chiller"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller condenser water isolation valve position"
    annotation (Placement(transformation(extent={{-240,30},{-200,70}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ConWatIsoVal[nChi]
    "Condenser water isolation valve commanded setpoint"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatPumSpe[nChiWatPum]
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{-240,-70},{-200,-30}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum]
    if not have_fixSpeConWatPum
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-240,-160},{-200,-120}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-240,-110},{-200,-70}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[nConWatPum]
    "Condenser water pump commanded status"
    annotation (Placement(transformation(extent={{-240,-200},{-200,-160}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if have_WSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-240,-280},{-200,-240}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi))
    "Chiller chilled water isolation valve position setpoints"
    annotation (Placement(transformation(extent={{200,210},{240,250}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiWatIsoVal[nChi]
    "Chiller chilled water isolation valve commanded setpoint"
    annotation (Placement(transformation(extent={{200,170},{240,210}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi))
    "Chiller condenser water isolation valve position setpoints"
    annotation (Placement(transformation(extent={{200,80},{240,120}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ConWatIsoVal[nChi]
    "Condenser water isolation valve commanded setpoint"
    annotation (Placement(transformation(extent={{200,40},{240,80}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe[nChiWatPum](
    final unit=fill("1", nChiWatPum),
    final min=fill(0, nChiWatPum),
    final max=fill(1, nChiWatPum))
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{200,-50},{240,-10}}),
        iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpe[nConWatPum](
    final unit=fill("1", nConWatPum),
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum)) if not have_fixSpeConWatPum
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{200,-140},{240,-100}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatPum[nConWatPum]
    "Condenser water pump commanded status: true-comanded on"
    annotation (Placement(transformation(extent={{200,-210},{240,-170}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowCel
    "True: the tower cells should be enabled"
    annotation (Placement(transformation(extent={{200,-250},{240,-210}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

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
    final nin=nChi)
    "Check if there is any condenser water request"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep2(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep3(
    final nout=nChiWatPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep5(
    final nout=nConWatPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not noChi "No enabled chiller"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));
  Buildings.Controls.OBC.CDL.Logical.Not noChiWatReq "No chilled water request"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloChiIsoVal
    "Close all chilled water isolation valve"
    annotation (Placement(transformation(extent={{-40,220},{-20,240}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi] "Close valve"
    annotation (Placement(transformation(extent={{140,220},{160,240}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloConIsoVal
    "Close all condenser water isolation valve"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not noConWatReq
    "No condenser water request"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nChi]
    "Close valve"
    annotation (Placement(transformation(extent={{140,90},{160,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloPums "Disable pumps"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2[nChiWatPum]
    "Disable pumps"
    annotation (Placement(transformation(extent={{160,-40},{180,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3[nConWatPum]
    if not have_fixSpeConWatPum
    "Disable pumps"
    annotation (Placement(transformation(extent={{160,-130},{180,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{40,220},{60,240}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Not in staging process"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr chiMod(
    final nin=nChi)
    "True: the plant has chiller mode"
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nChi](
    final k=fill(0, nChi)) "Constant zero"
    annotation (Placement(transformation(extent={{20,270},{40,290}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1[nChiWatPum](
    final k=fill(0, nChiWatPum))
    "Constant zero"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2[nConWatPum](
    final k=fill(0, nConWatPum)) if not have_fixSpeConWatPum
    "Constant zero"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 if have_WSE
    "Not in staging process"
    annotation (Placement(transformation(extent={{-80,-270},{-60,-250}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and6
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(
    final k=true) if not have_WSE
    "Logical true"
    annotation (Placement(transformation(extent={{-80,-220},{-60,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Or disTow
    "Disable cooling tower"
    annotation (Placement(transformation(extent={{80,-240},{100,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4(
    final k=false)
    if not have_WSE "Logical false"
    annotation (Placement(transformation(extent={{-20,-290},{0,-270}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[nChi](
    final h=fill(0.05, nChi))
    "Check if the chiller isolation valve is enabled"
    annotation (Placement(transformation(extent={{160,180},{180,200}})));
  Buildings.Controls.OBC.CDL.Logical.And and7[nChi]
    "Condenser water isolation valve commended setpoint"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  Buildings.Controls.OBC.CDL.Logical.And conWatPum[nConWatPum]
    "Condenser water pump commanded status"
    annotation (Placement(transformation(extent={{160,-200},{180,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nConWatPum]
    "Not disable pumps"
    annotation (Placement(transformation(extent={{160,-160},{180,-140}})));

equation
  connect(uChiWatReq, mulOr.u)
    annotation (Line(points={{-220,190},{-182,190}}, color={255,0,255}));
  connect(mulOr.y, noChiWatReq.u)
    annotation (Line(points={{-158,190},{-142,190}}, color={255,0,255}));
  connect(truDel.y, cloChiIsoVal.u1)
    annotation (Line(points={{-78,230},{-42,230}},color={255,0,255}));
  connect(noChiWatReq.y, cloChiIsoVal.u2) annotation (Line(points={{-118,190},{-50,
          190},{-50,222},{-42,222}},    color={255,0,255}));
  connect(booScaRep1.y, swi.u2)
    annotation (Line(points={{102,230},{138,230}}, color={255,0,255}));
  connect(uChiWatIsoVal, swi.u3) annotation (Line(points={{-220,160},{110,160},{
          110,222},{138,222}}, color={0,0,127}));
  connect(truDel.y, cloConIsoVal.u1) annotation (Line(points={{-78,230},{-60,230},
          {-60,120},{-42,120}},   color={255,0,255}));
  connect(mulOr1.y, noConWatReq.u)
    annotation (Line(points={{-158,80},{-142,80}}, color={255,0,255}));
  connect(uConWatReq, mulOr1.u)
    annotation (Line(points={{-220,80},{-182,80}},   color={255,0,255}));
  connect(noConWatReq.y, cloConIsoVal.u2) annotation (Line(points={{-118,80},{-60,
          80},{-60,112},{-42,112}},  color={255,0,255}));
  connect(booScaRep2.y, swi1.u2)
    annotation (Line(points={{82,120},{100,120},{100,100},{138,100}},
                                                 color={255,0,255}));
  connect(uConWatIsoVal, swi1.u3) annotation (Line(points={{-220,50},{60,50},{60,
          92},{138,92}},     color={0,0,127}));
  connect(cloChiIsoVal.y, cloPums.u2) annotation (Line(points={{-18,230},{-10,230},
          {-10,170},{-100,170},{-100,-38},{-82,-38}}, color={255,0,255}));
  connect(cloConIsoVal.y, cloPums.u1) annotation (Line(points={{-18,120},{-10,120},
          {-10,60},{-90,60},{-90,-30},{-82,-30}},color={255,0,255}));
  connect(booScaRep3.y, swi2.u2) annotation (Line(points={{122,-30},{158,-30}},
          color={255,0,255}));
  connect(uChiWatPumSpe, swi2.u3) annotation (Line(points={{-220,-50},{140,-50},
          {140,-38},{158,-38}}, color={0,0,127}));
  connect(uConWatPumSpe, swi3.u3) annotation (Line(points={{-220,-140},{140,-140},
          {140,-128},{158,-128}}, color={0,0,127}));
  connect(booScaRep5.y, swi3.u2)
    annotation (Line(points={{122,-120},{158,-120}}, color={255,0,255}));
  connect(and2.y, booScaRep1.u)
    annotation (Line(points={{62,230},{78,230}}, color={255,0,255}));
  connect(cloChiIsoVal.y, and2.u1)
    annotation (Line(points={{-18,230},{38,230}}, color={255,0,255}));
  connect(and1.y, booScaRep2.u)
    annotation (Line(points={{42,120},{58,120}},
                                               color={255,0,255}));
  connect(cloConIsoVal.y, and1.u1)
    annotation (Line(points={{-18,120},{18,120}},
                                               color={255,0,255}));
  connect(chaPro, not4.u)
    annotation (Line(points={{-220,-90},{-82,-90}},   color={255,0,255}));
  connect(not4.y, and1.u2) annotation (Line(points={{-58,-90},{0,-90},{0,112},{18,
          112}},    color={255,0,255}));
  connect(not4.y, and2.u2) annotation (Line(points={{-58,-90},{0,-90},{0,222},{38,
          222}},          color={255,0,255}));
  connect(cloPums.y, and3.u1)
    annotation (Line(points={{-58,-30},{18,-30}}, color={255,0,255}));
  connect(cloPums.y, and4.u1) annotation (Line(points={{-58,-30},{-10,-30},{-10,
          -120},{18,-120}}, color={255,0,255}));
  connect(not4.y, and4.u2) annotation (Line(points={{-58,-90},{0,-90},{0,-128},{
          18,-128}},   color={255,0,255}));
  connect(not4.y, and3.u2) annotation (Line(points={{-58,-90},{0,-90},{0,-38},{18,
          -38}},     color={255,0,255}));
  connect(swi3.y, yConWatPumSpe)
    annotation (Line(points={{182,-120},{220,-120}}, color={0,0,127}));
  connect(swi2.y, yChiWatPumSpe)
    annotation (Line(points={{182,-30},{220,-30}}, color={0,0,127}));
  connect(swi1.y, yConWatIsoVal)
    annotation (Line(points={{162,100},{220,100}},
                                                 color={0,0,127}));
  connect(swi.y, yChiWatIsoVal)
    annotation (Line(points={{162,230},{220,230}}, color={0,0,127}));
  connect(uChi, chiMod.u)
    annotation (Line(points={{-220,230},{-182,230}}, color={255,0,255}));
  connect(chiMod.y, noChi.u)
    annotation (Line(points={{-158,230},{-142,230}}, color={255,0,255}));
  connect(con.y, swi.u1) annotation (Line(points={{42,280},{120,280},{120,238},{
          138,238}}, color={0,0,127}));
  connect(con.y, swi1.u1) annotation (Line(points={{42,280},{120,280},{120,108},
          {138,108}},
                    color={0,0,127}));
  connect(con1.y, swi2.u1) annotation (Line(points={{122,20},{140,20},{140,-22},
          {158,-22}}, color={0,0,127}));
  connect(con2.y, swi3.u1) annotation (Line(points={{42,-80},{140,-80},{140,-112},
          {158,-112}}, color={0,0,127}));
  connect(uWSE, not1.u)
    annotation (Line(points={{-220,-260},{-82,-260}}, color={255,0,255}));
  connect(and3.y, and5.u1)
    annotation (Line(points={{42,-30},{58,-30}}, color={255,0,255}));
  connect(and5.y, booScaRep3.u)
    annotation (Line(points={{82,-30},{98,-30}}, color={255,0,255}));
  connect(and4.y, and6.u1)
    annotation (Line(points={{42,-120},{58,-120}}, color={255,0,255}));
  connect(and6.y, booScaRep5.u)
    annotation (Line(points={{82,-120},{98,-120}}, color={255,0,255}));
  connect(not1.y, and5.u2) annotation (Line(points={{-58,-260},{50,-260},{50,-38},
          {58,-38}}, color={255,0,255}));
  connect(not1.y, and6.u2) annotation (Line(points={{-58,-260},{50,-260},{50,-128},
          {58,-128}}, color={255,0,255}));
  connect(con3.y, and5.u2) annotation (Line(points={{-58,-210},{50,-210},{50,-38},
          {58,-38}}, color={255,0,255}));
  connect(con3.y, and6.u2) annotation (Line(points={{-58,-210},{50,-210},{50,-128},
          {58,-128}}, color={255,0,255}));
  connect(chiMod.y, disTow.u1) annotation (Line(points={{-158,230},{-150,230},{-150,
          -230},{78,-230}}, color={255,0,255}));
  connect(disTow.y, yTowCel)
    annotation (Line(points={{102,-230},{220,-230}}, color={255,0,255}));
  connect(uWSE, disTow.u2) annotation (Line(points={{-220,-260},{-150,-260},{-150,
          -238},{78,-238}}, color={255,0,255}));
  connect(con4.y, disTow.u2) annotation (Line(points={{2,-280},{60,-280},{60,-238},
          {78,-238}}, color={255,0,255}));
  connect(noChi.y, truDel.u)
    annotation (Line(points={{-118,230},{-102,230}}, color={255,0,255}));
  connect(swi.y, greThr.u) annotation (Line(points={{162,230},{170,230},{170,210},
          {150,210},{150,190},{158,190}}, color={0,0,127}));
  connect(greThr.y, y1ChiWatIsoVal)
    annotation (Line(points={{182,190},{220,190}}, color={255,0,255}));
  connect(u1ConWatIsoVal, and7.u2) annotation (Line(points={{-220,20},{78,20},{78,
          52},{138,52}},     color={255,0,255}));
  connect(booScaRep2.y, and7.u1) annotation (Line(points={{82,120},{100,120},{100,
          60},{138,60}}, color={255,0,255}));
  connect(and7.y, y1ConWatIsoVal)
    annotation (Line(points={{162,60},{220,60}}, color={255,0,255}));
  connect(booScaRep5.y, not2.u) annotation (Line(points={{122,-120},{130,-120},{
          130,-150},{158,-150}}, color={255,0,255}));
  connect(not2.y, conWatPum.u1) annotation (Line(points={{182,-150},{190,-150},{
          190,-168},{150,-168},{150,-190},{158,-190}}, color={255,0,255}));
  connect(uConWatPum, conWatPum.u2) annotation (Line(points={{-220,-180},{140,-180},
          {140,-198},{158,-198}}, color={255,0,255}));
  connect(conWatPum.y, yConWatPum)
    annotation (Line(points={{182,-190},{220,-190}}, color={255,0,255}));
annotation (defaultComponentName = "disChi",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-300},{200,300}})),
  Documentation(info="<html>
<p>
It disables the devices when the chiller plant is disabled in chiller mode.
It is implemented as ASHRAE Guideline36-2021, section 5.20.2.5 and 5.20.2.7.
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
