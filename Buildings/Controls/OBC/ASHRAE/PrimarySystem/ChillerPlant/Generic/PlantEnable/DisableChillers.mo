within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable;
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

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller commanded on"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water requst status for each chiller"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi)) "Chilled water isolation valve position"
    annotation(Placement(transformation(extent={{-240,110},{-200,150}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water requst status for each chiller"
    annotation (Placement(transformation(extent={{-240,30},{-200,70}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller condenser water isolation valve position"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatPumSpe[nChiWatPum]
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum]
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-240,-210},{-200,-170}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-240,-160},{-200,-120}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if have_WSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-240,-280},{-200,-240}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi))
    "Chiller chilled water isolation valve position setpoints"
    annotation (Placement(transformation(extent={{200,180},{240,220}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi))
    "Chiller condenser water isolation valve position setpoints"
    annotation (Placement(transformation(extent={{200,50},{240,90}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe[nChiWatPum](
    final unit=fill("1", nChiWatPum),
    final min=fill(0, nChiWatPum),
    final max=fill(1, nChiWatPum))
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{200,-80},{240,-40}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpe[nConWatPum](
    final unit=fill("1", nConWatPum),
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum))
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{200,-190},{240,-150}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowCel
    "True: the tower cells should be enabled"
    annotation (Placement(transformation(extent={{200,-250},{240,-210}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=180)
    "Threshold time after chiller being disabled"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChi)
    "Check if there is any chilled water request"
    annotation (Placement(transformation(extent={{-180,150},{-160,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,190},{100,210}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nChi)
    "Check if there is any condenser water request"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep2(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep3(
    final nout=nChiWatPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep5(
    final nout=nConWatPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Not noChi "No enabled chiller"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  Buildings.Controls.OBC.CDL.Logical.Not noChiWatReq "No chilled water request"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloChiIsoVal
    "Close all chilled water isolation valve"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi] "Close valve"
    annotation (Placement(transformation(extent={{160,190},{180,210}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloConIsoVal
    "Close all condenser water isolation valve"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not noConWatReq
    "No condenser water request"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nChi]
    "Close valve"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloPums "Disable pumps"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2[nChiWatPum]
    "Disable pumps"
    annotation (Placement(transformation(extent={{160,-70},{180,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3[nConWatPum]
    "Disable pumps"
    annotation (Placement(transformation(extent={{160,-180},{180,-160}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{40,190},{60,210}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Not in staging process"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr chiMod(
    final nin=nChi)
    "True: the plant has chiller mode"
    annotation (Placement(transformation(extent={{-180,190},{-160,210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nChi](
    final k=fill(0, nChi)) "Constant zero"
    annotation (Placement(transformation(extent={{20,240},{40,260}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1[nChiWatPum](
    final k=fill(0, nChiWatPum))
    "Constant zero"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2[nConWatPum](
    final k=fill(0, nConWatPum))
    "Constant zero"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 if have_WSE
    "Not in staging process"
    annotation (Placement(transformation(extent={{-80,-270},{-60,-250}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and6
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));
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

equation
  connect(noChi.y, truDel.u)
    annotation (Line(points={{-118,200},{-102,200}}, color={255,0,255}));
  connect(uChiWatReq, mulOr.u)
    annotation (Line(points={{-220,160},{-182,160}}, color={255,0,255}));
  connect(mulOr.y, noChiWatReq.u)
    annotation (Line(points={{-158,160},{-142,160}}, color={255,0,255}));
  connect(truDel.y, cloChiIsoVal.u1)
    annotation (Line(points={{-78,200},{-42,200}},color={255,0,255}));
  connect(noChiWatReq.y, cloChiIsoVal.u2) annotation (Line(points={{-118,160},{-50,
          160},{-50,192},{-42,192}},    color={255,0,255}));
  connect(booScaRep1.y, swi.u2)
    annotation (Line(points={{102,200},{158,200}}, color={255,0,255}));
  connect(uChiWatIsoVal, swi.u3) annotation (Line(points={{-220,130},{130,130},{
          130,192},{158,192}}, color={0,0,127}));
  connect(truDel.y, cloConIsoVal.u1) annotation (Line(points={{-78,200},{-60,200},
          {-60,70},{-42,70}},     color={255,0,255}));
  connect(mulOr1.y, noConWatReq.u)
    annotation (Line(points={{-158,50},{-102,50}}, color={255,0,255}));
  connect(uConWatReq, mulOr1.u)
    annotation (Line(points={{-220,50},{-182,50}},   color={255,0,255}));
  connect(noConWatReq.y, cloConIsoVal.u2) annotation (Line(points={{-78,50},{-60,
          50},{-60,62},{-42,62}},    color={255,0,255}));
  connect(booScaRep2.y, swi1.u2)
    annotation (Line(points={{102,70},{158,70}}, color={255,0,255}));
  connect(uConWatIsoVal, swi1.u3) annotation (Line(points={{-220,20},{140,20},{140,
          62},{158,62}},     color={0,0,127}));
  connect(cloChiIsoVal.y, cloPums.u2) annotation (Line(points={{-18,200},{-10,200},
          {-10,140},{-100,140},{-100,-68},{-82,-68}}, color={255,0,255}));
  connect(cloConIsoVal.y, cloPums.u1) annotation (Line(points={{-18,70},{-10,70},
          {-10,30},{-90,30},{-90,-60},{-82,-60}},color={255,0,255}));
  connect(booScaRep3.y, swi2.u2) annotation (Line(points={{122,-60},{158,-60}},
          color={255,0,255}));
  connect(uChiWatPumSpe, swi2.u3) annotation (Line(points={{-220,-80},{140,-80},
          {140,-68},{158,-68}}, color={0,0,127}));
  connect(uConWatPumSpe, swi3.u3) annotation (Line(points={{-220,-190},{140,-190},
          {140,-178},{158,-178}}, color={0,0,127}));
  connect(booScaRep5.y, swi3.u2)
    annotation (Line(points={{122,-170},{158,-170}}, color={255,0,255}));
  connect(and2.y, booScaRep1.u)
    annotation (Line(points={{62,200},{78,200}}, color={255,0,255}));
  connect(cloChiIsoVal.y, and2.u1)
    annotation (Line(points={{-18,200},{38,200}}, color={255,0,255}));
  connect(and1.y, booScaRep2.u)
    annotation (Line(points={{62,70},{78,70}}, color={255,0,255}));
  connect(cloConIsoVal.y, and1.u1)
    annotation (Line(points={{-18,70},{38,70}},color={255,0,255}));
  connect(chaPro, not4.u)
    annotation (Line(points={{-220,-140},{-82,-140}}, color={255,0,255}));
  connect(not4.y, and1.u2) annotation (Line(points={{-58,-140},{0,-140},{0,62},{
          38,62}},  color={255,0,255}));
  connect(not4.y, and2.u2) annotation (Line(points={{-58,-140},{0,-140},{0,192},
          {38,192}},      color={255,0,255}));
  connect(cloPums.y, and3.u1)
    annotation (Line(points={{-58,-60},{18,-60}}, color={255,0,255}));
  connect(cloPums.y, and4.u1) annotation (Line(points={{-58,-60},{-10,-60},{-10,
          -170},{18,-170}}, color={255,0,255}));
  connect(not4.y, and4.u2) annotation (Line(points={{-58,-140},{0,-140},{0,-178},
          {18,-178}},  color={255,0,255}));
  connect(not4.y, and3.u2) annotation (Line(points={{-58,-140},{0,-140},{0,-68},
          {18,-68}}, color={255,0,255}));
  connect(swi3.y, yConWatPumSpe)
    annotation (Line(points={{182,-170},{220,-170}}, color={0,0,127}));
  connect(swi2.y, yChiWatPumSpe)
    annotation (Line(points={{182,-60},{220,-60}}, color={0,0,127}));
  connect(swi1.y, yConWatIsoVal)
    annotation (Line(points={{182,70},{220,70}}, color={0,0,127}));
  connect(swi.y, yChiWatIsoVal)
    annotation (Line(points={{182,200},{220,200}}, color={0,0,127}));
  connect(uChi, chiMod.u)
    annotation (Line(points={{-220,200},{-182,200}}, color={255,0,255}));
  connect(chiMod.y, noChi.u)
    annotation (Line(points={{-158,200},{-142,200}}, color={255,0,255}));
  connect(con.y, swi.u1) annotation (Line(points={{42,250},{140,250},{140,208},{
          158,208}}, color={0,0,127}));
  connect(con.y, swi1.u1) annotation (Line(points={{42,250},{140,250},{140,78},{
          158,78}}, color={0,0,127}));
  connect(con1.y, swi2.u1) annotation (Line(points={{42,-10},{140,-10},{140,-52},
          {158,-52}}, color={0,0,127}));
  connect(con2.y, swi3.u1) annotation (Line(points={{42,-110},{140,-110},{140,-162},
          {158,-162}}, color={0,0,127}));
  connect(uWSE, not1.u)
    annotation (Line(points={{-220,-260},{-82,-260}}, color={255,0,255}));
  connect(and3.y, and5.u1)
    annotation (Line(points={{42,-60},{58,-60}}, color={255,0,255}));
  connect(and5.y, booScaRep3.u)
    annotation (Line(points={{82,-60},{98,-60}}, color={255,0,255}));
  connect(and4.y, and6.u1)
    annotation (Line(points={{42,-170},{58,-170}}, color={255,0,255}));
  connect(and6.y, booScaRep5.u)
    annotation (Line(points={{82,-170},{98,-170}}, color={255,0,255}));
  connect(not1.y, and5.u2) annotation (Line(points={{-58,-260},{50,-260},{50,-68},
          {58,-68}}, color={255,0,255}));
  connect(not1.y, and6.u2) annotation (Line(points={{-58,-260},{50,-260},{50,-178},
          {58,-178}}, color={255,0,255}));
  connect(con3.y, and5.u2) annotation (Line(points={{-58,-210},{50,-210},{50,-68},
          {58,-68}}, color={255,0,255}));
  connect(con3.y, and6.u2) annotation (Line(points={{-58,-210},{50,-210},{50,-178},
          {58,-178}}, color={255,0,255}));
  connect(chiMod.y, disTow.u1) annotation (Line(points={{-158,200},{-150,200},{-150,
          -230},{78,-230}}, color={255,0,255}));
  connect(disTow.y, yTowCel)
    annotation (Line(points={{102,-230},{220,-230}}, color={255,0,255}));
  connect(uWSE, disTow.u2) annotation (Line(points={{-220,-260},{-150,-260},{-150,
          -238},{78,-238}}, color={255,0,255}));
  connect(con4.y, disTow.u2) annotation (Line(points={{2,-280},{60,-280},{60,-238},
          {78,-238}}, color={255,0,255}));
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
