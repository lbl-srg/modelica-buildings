within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable;
block DisableChillers
  "Disable devices when the plant is disabled from chiller mode"

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
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water requst status for each chiller"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi)) "Chilled water isolation valve position"
    annotation(Placement(transformation(extent={{-240,110},{-200,150}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water requst status for each chiller"
    annotation (Placement(transformation(extent={{-240,30},{-200,70}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller condenser water isolation valve position"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatPumSpe[nChiWatPum]
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum]
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-240,-210},{-200,-170}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-240,-160},{-200,-120}}),
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
    annotation (Placement(transformation(extent={{200,-260},{240,-220}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=180)
    "Threshold time after chiller being disabled"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChi)
    "Check if there is any chilled water request"
    annotation (Placement(transformation(extent={{-180,150},{-160,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nChi)
    "Check if there is any condenser water request"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep2(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep3(
    final nout=nChiWatPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep5(
    final nout=nConWatPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Not noChi "No enabled chiller"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Logical.Not noChiWatReq "No chilled water request"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloChiIsoVal
    "Close all chilled water isolation valve"
    annotation (Placement(transformation(extent={{0,190},{20,210}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi] "Close valve"
    annotation (Placement(transformation(extent={{160,190},{180,210}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloConIsoVal
    "Close all condenser water isolation valve"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not noConWatReq
    "No condenser water request"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nChi]
    "Close valve"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloPums "Disable pumps"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2[nChiWatPum]
    "Disable pumps"
    annotation (Placement(transformation(extent={{160,-70},{180,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3[nConWatPum]
    "Disable pumps"
    annotation (Placement(transformation(extent={{160,-180},{180,-160}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{60,190},{80,210}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Not in staging process"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr chiMod(
    final nin=nChi)
      "True: the plant has chiller mode"
    annotation (Placement(transformation(extent={{-180,190},{-160,210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nChi](
    final k=fill(0, nChi)) "Constant zero"
    annotation (Placement(transformation(extent={{60,240},{80,260}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1[nChiWatPum](
    final k=fill(0, nChiWatPum))
    "Constant zero"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2[nConWatPum](
    final k=fill(0, nConWatPum))
    "Constant zero"
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
equation
  connect(noChi.y, truDel.u)
    annotation (Line(points={{-78,200},{-62,200}}, color={255,0,255}));
  connect(uChiWatReq, mulOr.u)
    annotation (Line(points={{-220,160},{-182,160}}, color={255,0,255}));
  connect(mulOr.y, noChiWatReq.u)
    annotation (Line(points={{-158,160},{-102,160}}, color={255,0,255}));
  connect(truDel.y, cloChiIsoVal.u1)
    annotation (Line(points={{-38,200},{-2,200}}, color={255,0,255}));
  connect(noChiWatReq.y, cloChiIsoVal.u2) annotation (Line(points={{-78,160},{
          -10,160},{-10,192},{-2,192}}, color={255,0,255}));
  connect(booScaRep1.y, swi.u2)
    annotation (Line(points={{122,200},{158,200}}, color={255,0,255}));
  connect(uChiWatIsoVal, swi.u3) annotation (Line(points={{-220,130},{130,130},{
          130,192},{158,192}}, color={0,0,127}));
  connect(truDel.y, cloConIsoVal.u1) annotation (Line(points={{-38,200},{-20,
          200},{-20,70},{-2,70}}, color={255,0,255}));
  connect(mulOr1.y, noConWatReq.u)
    annotation (Line(points={{-158,50},{-102,50}}, color={255,0,255}));
  connect(uConWatReq, mulOr1.u)
    annotation (Line(points={{-220,50},{-182,50}},   color={255,0,255}));
  connect(noConWatReq.y, cloConIsoVal.u2) annotation (Line(points={{-78,50},{
          -20,50},{-20,62},{-2,62}}, color={255,0,255}));
  connect(booScaRep2.y, swi1.u2)
    annotation (Line(points={{122,70},{158,70}}, color={255,0,255}));
  connect(uConWatIsoVal, swi1.u3) annotation (Line(points={{-220,20},{140,20},{140,
          62},{158,62}},     color={0,0,127}));
  connect(cloChiIsoVal.y, cloPums.u2) annotation (Line(points={{22,200},{30,200},
          {30,140},{-60,140},{-60,-68},{-42,-68}}, color={255,0,255}));
  connect(cloConIsoVal.y, cloPums.u1) annotation (Line(points={{22,70},{30,70},
          {30,30},{-50,30},{-50,-60},{-42,-60}}, color={255,0,255}));
  connect(booScaRep3.y, swi2.u2) annotation (Line(points={{122,-60},{158,-60}},
          color={255,0,255}));
  connect(uChiWatPumSpe, swi2.u3) annotation (Line(points={{-220,-80},{140,-80},
          {140,-68},{158,-68}}, color={0,0,127}));
  connect(uConWatPumSpe, swi3.u3) annotation (Line(points={{-220,-190},{140,-190},
          {140,-178},{158,-178}}, color={0,0,127}));
  connect(booScaRep5.y, swi3.u2)
    annotation (Line(points={{122,-170},{158,-170}}, color={255,0,255}));
  connect(and2.y, booScaRep1.u)
    annotation (Line(points={{82,200},{98,200}}, color={255,0,255}));
  connect(cloChiIsoVal.y, and2.u1)
    annotation (Line(points={{22,200},{58,200}},  color={255,0,255}));
  connect(and1.y, booScaRep2.u)
    annotation (Line(points={{82,70},{98,70}}, color={255,0,255}));
  connect(cloConIsoVal.y, and1.u1)
    annotation (Line(points={{22,70},{58,70}}, color={255,0,255}));
  connect(chaPro, not4.u)
    annotation (Line(points={{-220,-140},{-42,-140}}, color={255,0,255}));
  connect(not4.y, and1.u2) annotation (Line(points={{-18,-140},{40,-140},{40,62},
          {58,62}}, color={255,0,255}));
  connect(not4.y, and2.u2) annotation (Line(points={{-18,-140},{40,-140},{40,
          192},{58,192}}, color={255,0,255}));
  connect(cloPums.y, and3.u1)
    annotation (Line(points={{-18,-60},{58,-60}}, color={255,0,255}));
  connect(cloPums.y, and4.u1) annotation (Line(points={{-18,-60},{30,-60},{30,-170},
          {58,-170}}, color={255,0,255}));
  connect(not4.y, and4.u2) annotation (Line(points={{-18,-140},{40,-140},{40,
          -178},{58,-178}}, color={255,0,255}));
  connect(not4.y, and3.u2) annotation (Line(points={{-18,-140},{40,-140},{40,
          -68},{58,-68}}, color={255,0,255}));
  connect(and3.y, booScaRep3.u)
    annotation (Line(points={{82,-60},{98,-60}}, color={255,0,255}));
  connect(and4.y, booScaRep5.u)
    annotation (Line(points={{82,-170},{98,-170}}, color={255,0,255}));
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
    annotation (Line(points={{-158,200},{-102,200}}, color={255,0,255}));
  connect(con.y, swi.u1) annotation (Line(points={{82,250},{140,250},{140,208},{
          158,208}}, color={0,0,127}));
  connect(con.y, swi1.u1) annotation (Line(points={{82,250},{140,250},{140,78},{
          158,78}}, color={0,0,127}));
  connect(con1.y, swi2.u1) annotation (Line(points={{82,-10},{140,-10},{140,-52},
          {158,-52}}, color={0,0,127}));
  connect(con2.y, swi3.u1) annotation (Line(points={{82,-110},{140,-110},{140,-162},
          {158,-162}}, color={0,0,127}));
  connect(chiMod.y, yTowCel) annotation (Line(points={{-158,200},{-120,200},{-120,
          -240},{220,-240}}, color={255,0,255}));
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
It is implemented as provided in sections 5.2.2.5 and 5.2.2.7.
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
