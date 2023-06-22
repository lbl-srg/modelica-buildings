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
    annotation (Placement(transformation(extent={{-200,220},{-160,260}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-200,180},{-160,220}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water requst status for each chiller"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi)) "Chilled water isolation valve position"
    annotation(Placement(transformation(extent={{-200,10},{-160,50}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water requst status for each chiller"
    annotation (Placement(transformation(extent={{-200,-30},{-160,10}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller condenser water isolation valve position"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatPumSpe[nChiWatPum]
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum]
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-200,-170},{-160,-130}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-200,-228},{-160,-188}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cells status setpoint"
    annotation (Placement(transformation(extent={{-200,-200},{-160,-160}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller commanded on"
    annotation(Placement(transformation(extent={{160,180},{200,220}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi))
    "Chiller chilled water isolation valve position setpoints"
    annotation (Placement(transformation(extent={{160,80},{200,120}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi))
    "Chiller condenser water isolation valve position setpoints"
    annotation (Placement(transformation(extent={{160,-10},{200,30}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe[nChiWatPum](
    final unit=fill("1", nChiWatPum),
    final min=fill(0, nChiWatPum),
    final max=fill(1, nChiWatPum))
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{160,-100},{200,-60}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpe[nConWatPum](
    final unit=fill("1", nConWatPum),
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum))
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{160,-150},{200,-110}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Cooling tower commanded on"
    annotation (Placement(transformation(extent={{158,-228},{198,-188}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{0,190},{20,210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nChi] "Chiller commanded on"
    annotation (Placement(transformation(extent={{120,190},{140,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nChi](
    final k=fill(false, nChi))
    "Disable chillers"
    annotation (Placement(transformation(extent={{0,160},{20,180}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=180)
    "Threshold time after chiller being disabled"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChi)
    "Check if there is any chilled water request"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nChi)
    "Check if there is any condenser water request"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep2(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep3(
    final nout=nChiWatPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep5(
    final nout=nConWatPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "No chilled water request"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloChiIsoVal
    "Close all chilled water isolation valve"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[nChi](
    final k=fill(0, nChi)) "Close valve"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi[nChi] "Close valve"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloChiIsoVal1
    "Close all chilled water isolation valve"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "No condenser water request"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1[nChi]
    "Close valve"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloPums "Disable pumps"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2[nChiWatPum]
    "Disable pumps"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3[nConWatPum]
    "Disable pumps"
    annotation (Placement(transformation(extent={{120,-140},{140,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2[nTowCel]
    "Tower cell status"
    annotation (Placement(transformation(extent={{120,-218},{140,-198}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep4(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{20,-250},{40,-230}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep6(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{20,-218},{40,-198}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Not in staging process"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Plant is disabled and it is not in staging process"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
equation
  connect(uPla, booScaRep.u)
    annotation (Line(points={{-180,200},{-2,200}}, color={255,0,255}));
  connect(booScaRep.y, logSwi.u2)
    annotation (Line(points={{22,200},{118,200}},color={255,0,255}));
  connect(uChi, logSwi.u1) annotation (Line(points={{-180,240},{60,240},{60,208},
          {118,208}},color={255,0,255}));
  connect(con.y, logSwi.u3) annotation (Line(points={{22,170},{60,170},{60,192},
          {118,192}},color={255,0,255}));
  connect(logSwi.y, yChi)
    annotation (Line(points={{142,200},{180,200}}, color={255,0,255}));
  connect(uPla, not1.u) annotation (Line(points={{-180,200},{-150,200},{-150,100},
          {-142,100}},color={255,0,255}));
  connect(not1.y, truDel.u)
    annotation (Line(points={{-118,100},{-102,100}}, color={255,0,255}));
  connect(uChiWatReq, mulOr.u)
    annotation (Line(points={{-180,60},{-142,60}}, color={255,0,255}));
  connect(mulOr.y, not2.u)
    annotation (Line(points={{-118,60},{-102,60}}, color={255,0,255}));
  connect(truDel.y, cloChiIsoVal.u1)
    annotation (Line(points={{-78,100},{-42,100}},color={255,0,255}));
  connect(not2.y, cloChiIsoVal.u2) annotation (Line(points={{-78,60},{-60,60},{-60,
          92},{-42,92}},color={255,0,255}));
  connect(booScaRep1.y, swi.u2)
    annotation (Line(points={{82,100},{118,100}},color={255,0,255}));
  connect(con1.y, swi.u1) annotation (Line(points={{-58,140},{100,140},{100,108},
          {118,108}}, color={0,0,127}));
  connect(uChiWatIsoVal, swi.u3) annotation (Line(points={{-180,30},{90,30},{90,
          92},{118,92}},color={0,0,127}));
  connect(truDel.y, cloChiIsoVal1.u1) annotation (Line(points={{-78,100},{-50,100},
          {-50,10},{-42,10}},  color={255,0,255}));
  connect(mulOr1.y, not3.u)
    annotation (Line(points={{-98,-10},{-82,-10}}, color={255,0,255}));
  connect(uConWatReq, mulOr1.u)
    annotation (Line(points={{-180,-10},{-122,-10}}, color={255,0,255}));
  connect(not3.y, cloChiIsoVal1.u2) annotation (Line(points={{-58,-10},{-50,-10},
          {-50,2},{-42,2}},    color={255,0,255}));
  connect(booScaRep2.y, swi1.u2)
    annotation (Line(points={{82,10},{118,10}},  color={255,0,255}));
  connect(con1.y, swi1.u1) annotation (Line(points={{-58,140},{100,140},{100,18},
          {118,18}}, color={0,0,127}));
  connect(uConWatIsoVal, swi1.u3) annotation (Line(points={{-180,-40},{90,-40},{
          90,2},{118,2}},    color={0,0,127}));
  connect(cloChiIsoVal.y, cloPums.u2) annotation (Line(points={{-18,100},{-10,100},
          {-10,40},{-90,40},{-90,-68},{-42,-68}},  color={255,0,255}));
  connect(cloChiIsoVal1.y, cloPums.u1) annotation (Line(points={{-18,10},{-10,10},
          {-10,-30},{-60,-30},{-60,-60},{-42,-60}},  color={255,0,255}));
  connect(booScaRep3.y, swi2.u2) annotation (Line(points={{82,-80},{118,-80}},
          color={255,0,255}));
  connect(con1.y, swi2.u1) annotation (Line(points={{-58,140},{100,140},{100,-72},
          {118,-72}}, color={0,0,127}));
  connect(uChiWatPumSpe, swi2.u3) annotation (Line(points={{-180,-100},{90,-100},
          {90,-88},{118,-88}},  color={0,0,127}));
  connect(con1.y, swi3.u1) annotation (Line(points={{-58,140},{100,140},{100,-122},
          {118,-122}},color={0,0,127}));
  connect(uConWatPumSpe, swi3.u3) annotation (Line(points={{-180,-150},{90,-150},
          {90,-138},{118,-138}},color={0,0,127}));
  connect(booScaRep5.y, swi3.u2)
    annotation (Line(points={{82,-130},{118,-130}},color={255,0,255}));
  connect(cloPums.y, booScaRep4.u) annotation (Line(points={{-18,-60},{-10,-60},
          {-10,-240},{18,-240}}, color={255,0,255}));
  connect(booScaRep4.y, logSwi2.u3) annotation (Line(points={{42,-240},{100,-240},
          {100,-216},{118,-216}}, color={255,0,255}));
  connect(uTowSta, logSwi2.u1) annotation (Line(points={{-180,-180},{80,-180},{80,
          -200},{118,-200}}, color={255,0,255}));
  connect(chaPro, booScaRep6.u)
    annotation (Line(points={{-180,-208},{18,-208}}, color={255,0,255}));
  connect(booScaRep6.y, logSwi2.u2)
    annotation (Line(points={{42,-208},{118,-208}}, color={255,0,255}));
  connect(logSwi2.y, yTowSta)
    annotation (Line(points={{142,-208},{178,-208}}, color={255,0,255}));
  connect(and2.y, booScaRep1.u)
    annotation (Line(points={{42,100},{58,100}}, color={255,0,255}));
  connect(cloChiIsoVal.y, and2.u1)
    annotation (Line(points={{-18,100},{18,100}}, color={255,0,255}));
  connect(and1.y, booScaRep2.u)
    annotation (Line(points={{42,10},{58,10}}, color={255,0,255}));
  connect(cloChiIsoVal1.y, and1.u1)
    annotation (Line(points={{-18,10},{18,10}}, color={255,0,255}));
  connect(chaPro, not4.u) annotation (Line(points={{-180,-208},{-120,-208},{-120,
          -120},{-82,-120}}, color={255,0,255}));
  connect(not4.y, and1.u2) annotation (Line(points={{-58,-120},{0,-120},{0,2},{18,
          2}}, color={255,0,255}));
  connect(not4.y, and2.u2) annotation (Line(points={{-58,-120},{0,-120},{0,92},{
          18,92}}, color={255,0,255}));
  connect(cloPums.y, and3.u1) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -80},{18,-80}}, color={255,0,255}));
  connect(cloPums.y, and4.u1) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -130},{18,-130}}, color={255,0,255}));
  connect(not4.y, and4.u2) annotation (Line(points={{-58,-120},{0,-120},{0,-138},
          {18,-138}}, color={255,0,255}));
  connect(not4.y, and3.u2) annotation (Line(points={{-58,-120},{0,-120},{0,-88},
          {18,-88}}, color={255,0,255}));
  connect(and3.y, booScaRep3.u)
    annotation (Line(points={{42,-80},{58,-80}}, color={255,0,255}));
  connect(and4.y, booScaRep5.u)
    annotation (Line(points={{42,-130},{58,-130}}, color={255,0,255}));
  connect(swi3.y, yConWatPumSpe)
    annotation (Line(points={{142,-130},{180,-130}}, color={0,0,127}));
  connect(swi2.y, yChiWatPumSpe)
    annotation (Line(points={{142,-80},{180,-80}}, color={0,0,127}));
  connect(swi1.y, yConWatIsoVal)
    annotation (Line(points={{142,10},{180,10}}, color={0,0,127}));
  connect(swi.y, yChiWatIsoVal)
    annotation (Line(points={{142,100},{180,100}}, color={0,0,127}));
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
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-160,-260},{160,260}})),
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
