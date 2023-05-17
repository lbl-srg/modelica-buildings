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
    annotation (Placement(transformation(extent={{-180,220},{-140,260}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-180,180},{-140,220}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water requst status for each chiller"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi)) "Chilled water isolation valve position"
    annotation(Placement(transformation(extent={{-180,10},{-140,50}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water requst status for each chiller"
    annotation (Placement(transformation(extent={{-180,-50},{-140,-10}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller condenser water isolation valve position"
    annotation (Placement(transformation(extent={{-180,-90},{-140,-50}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatPumSpe[nChiWatPum]
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{-180,-160},{-140,-120}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum]
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-180,-200},{-140,-160}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller commanded on"
    annotation(Placement(transformation(extent={{140,180},{180,220}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi))
    "Chiller chilled water isolation valve position setpoints"
    annotation (Placement(transformation(extent={{140,80},{180,120}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi))
    "Chiller condenser water isolation valve position setpoints"
    annotation (Placement(transformation(extent={{140,-30},{180,10}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe[nChiWatPum](
    final unit=fill("1", nChiWatPum),
    final min=fill(0, nChiWatPum),
    final max=fill(1, nChiWatPum))
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{140,-140},{180,-100}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpe[nConWatPum](
    final unit=fill("1", nConWatPum),
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum))
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{140,-180},{180,-140}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTow
    "Cooling tower commanded on" annotation (Placement(transformation(extent={{140,
            -250},{180,-210}}), iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{20,190},{40,210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nChi]
    "Chiller commanded on"
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nChi](
    final k=fill(false, nChi))
    "Disable chillers"
    annotation (Placement(transformation(extent={{20,160},{40,180}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=180)
    "Threshold time after chiller being disabled"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChi)
    "Check if there is any chilled water request"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nChi)
    "Check if there is any condenser water request"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep2(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep3(
    final nout=nChiWatPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep5(
    final nout=nConWatPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "No chilled water request"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloChiIsoVal
    "Close all chilled water isolation valve"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[nChi](
    final k=fill(0, nChi)) "Close valve"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi[nChi] "Close valve"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloChiIsoVal1
    "Close all chilled water isolation valve"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "No condenser water request"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1[nChi]
    "Close valve"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Logical.Or cloPums "Disable pumps"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2[nChiWatPum]
    "Disable pumps"
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3[nConWatPum]
    "Disable pumps"
    annotation (Placement(transformation(extent={{100,-170},{120,-150}})));

equation
  connect(uPla, booScaRep.u)
    annotation (Line(points={{-160,200},{18,200}}, color={255,0,255}));
  connect(booScaRep.y, logSwi.u2)
    annotation (Line(points={{42,200},{98,200}}, color={255,0,255}));
  connect(uChi, logSwi.u1) annotation (Line(points={{-160,240},{80,240},{80,208},
          {98,208}}, color={255,0,255}));
  connect(con.y, logSwi.u3) annotation (Line(points={{42,170},{80,170},{80,192},
          {98,192}}, color={255,0,255}));
  connect(logSwi.y, yChi)
    annotation (Line(points={{122,200},{160,200}}, color={255,0,255}));
  connect(uPla, not1.u) annotation (Line(points={{-160,200},{-120,200},{-120,100},
          {-102,100}},color={255,0,255}));
  connect(not1.y, truDel.u)
    annotation (Line(points={{-78,100},{-62,100}}, color={255,0,255}));
  connect(uChiWatReq, mulOr.u)
    annotation (Line(points={{-160,60},{-102,60}}, color={255,0,255}));
  connect(mulOr.y, not2.u)
    annotation (Line(points={{-78,60},{-62,60}}, color={255,0,255}));
  connect(truDel.y, cloChiIsoVal.u1)
    annotation (Line(points={{-38,100},{-2,100}}, color={255,0,255}));
  connect(not2.y, cloChiIsoVal.u2) annotation (Line(points={{-38,60},{-20,60},{-20,
          92},{-2,92}}, color={255,0,255}));
  connect(cloChiIsoVal.y, booScaRep1.u)
    annotation (Line(points={{22,100},{38,100}}, color={255,0,255}));
  connect(booScaRep1.y, swi.u2)
    annotation (Line(points={{62,100},{98,100}}, color={255,0,255}));
  connect(con1.y, swi.u1) annotation (Line(points={{-38,140},{80,140},{80,108},{
          98,108}}, color={0,0,127}));
  connect(uChiWatIsoVal, swi.u3) annotation (Line(points={{-160,30},{70,30},{70,
          92},{98,92}}, color={0,0,127}));
  connect(swi.y, yChiWatIsoVal)
    annotation (Line(points={{122,100},{160,100}}, color={0,0,127}));
  connect(truDel.y, cloChiIsoVal1.u1) annotation (Line(points={{-38,100},{-10,100},
          {-10,-10},{-2,-10}}, color={255,0,255}));
  connect(mulOr1.y, not3.u)
    annotation (Line(points={{-78,-30},{-62,-30}}, color={255,0,255}));
  connect(uConWatReq, mulOr1.u)
    annotation (Line(points={{-160,-30},{-102,-30}}, color={255,0,255}));
  connect(not3.y, cloChiIsoVal1.u2) annotation (Line(points={{-38,-30},{-20,-30},
          {-20,-18},{-2,-18}}, color={255,0,255}));
  connect(swi1.y, yConWatIsoVal)
    annotation (Line(points={{122,-10},{160,-10}}, color={0,0,127}));
  connect(cloChiIsoVal1.y, booScaRep2.u)
    annotation (Line(points={{22,-10},{38,-10}}, color={255,0,255}));
  connect(booScaRep2.y, swi1.u2)
    annotation (Line(points={{62,-10},{98,-10}}, color={255,0,255}));
  connect(con1.y, swi1.u1) annotation (Line(points={{-38,140},{80,140},{80,-2},{
          98,-2}}, color={0,0,127}));
  connect(uConWatIsoVal, swi1.u3) annotation (Line(points={{-160,-70},{72,-70},{
          72,-18},{98,-18}}, color={0,0,127}));
  connect(cloChiIsoVal.y, cloPums.u2) annotation (Line(points={{22,100},{30,100},
          {30,40},{-70,40},{-70,-108},{-22,-108}}, color={255,0,255}));
  connect(cloChiIsoVal1.y, cloPums.u1) annotation (Line(points={{22,-10},{30,-10},
          {30,-60},{-40,-60},{-40,-100},{-22,-100}}, color={255,0,255}));
  connect(cloPums.y, booScaRep3.u) annotation (Line(points={{2,-100},{20,-100},{
          20,-120},{38,-120}}, color={255,0,255}));
  connect(booScaRep3.y, swi2.u2) annotation (Line(points={{62,-120},{98,-120}},
          color={255,0,255}));
  connect(con1.y, swi2.u1) annotation (Line(points={{-38,140},{80,140},{80,-112},
          {98,-112}}, color={0,0,127}));
  connect(uChiWatPumSpe, swi2.u3) annotation (Line(points={{-160,-140},{70,-140},
          {70,-128},{98,-128}}, color={0,0,127}));
  connect(swi2.y, yChiWatPumSpe)
    annotation (Line(points={{122,-120},{160,-120}}, color={0,0,127}));
  connect(con1.y, swi3.u1) annotation (Line(points={{-38,140},{80,140},{80,-152},
          {98,-152}}, color={0,0,127}));
  connect(uConWatPumSpe, swi3.u3) annotation (Line(points={{-160,-180},{70,-180},
          {70,-168},{98,-168}}, color={0,0,127}));
  connect(swi3.y, yConWatPumSpe)
    annotation (Line(points={{122,-160},{160,-160}}, color={0,0,127}));
  connect(cloPums.y, booScaRep5.u) annotation (Line(points={{2,-100},{20,-100},{
          20,-160},{38,-160}}, color={255,0,255}));
  connect(booScaRep5.y, swi3.u2)
    annotation (Line(points={{62,-160},{98,-160}}, color={255,0,255}));
  connect(cloPums.y, yTow) annotation (Line(points={{2,-100},{20,-100},{20,-230},
          {160,-230}}, color={255,0,255}));
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
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-140,-260},{140,260}})),
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
