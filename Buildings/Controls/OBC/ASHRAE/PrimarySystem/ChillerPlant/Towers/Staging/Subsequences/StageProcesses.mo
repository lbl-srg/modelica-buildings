within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences;
block StageProcesses "Sequence for process of staging cells"

  parameter Integer nTowCel = 4
    "Total number of cooling tower cells";
  parameter Real chaTowCelIsoTim(
    final quantity="Time",
    final unit="s") = 90
    "Nominal time needed for open isolation valve";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChaCel[nTowCel]
    "Vector of boolean flags to show if a cell should change its status: true = the cell should change status (be enabled or disabled)"
    annotation (Placement(transformation(extent={{-240,270},{-200,310}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel)) "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{-240,30},{-200,70}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cells proven on status: true=enabled tower cell"
    annotation (Placement(transformation(extent={{-240,-200},{-200,-160}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel)) "Cooling tower cells isolation valve setpoint"
    annotation (Placement(transformation(extent={{200,70},{240,110}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Vector of tower cells status setpoint"
    annotation (Placement(transformation(extent={{200,-220},{240,-180}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSta
    "Rising edge to indicate the staging process is done"
    annotation (Placement(transformation(extent={{200,-320},{240,-280}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Switch swi2[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count the time after changing up-stream device status"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con9(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-40,230},{-20,250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con7(
    final k=chaTowCelIsoTim) "Time to change cooling tower isolation valve"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con8(final k=1)
    "Fully open valve"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin1
    "Chilled water isolation valve setpoint"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nTowCel)
    "Replicate real input"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{160,80},{180,100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3[nTowCel](
    final uLow=fill(0.025, nTowCel),
    final uHigh=fill(0.05, nTowCel)) "Check if isolation valve is enabled"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys4[nTowCel](
    final uLow=fill(0.925, nTowCel),
    final uHigh=fill(0.975, nTowCel)) "Check if isolation valve is open more than 95%"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(final nin=nTowCel)
    "Logical and"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greEquThr(
    final t=chaTowCelIsoTim)
    "Check if it has past the target time of open isolation valve "
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nTowCel]
    "True: cells should be enabled"
    annotation (Placement(transformation(extent={{20,-170},{40,-150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nTowCel](
    final k=fill(true, nTowCel)) "Enable cells"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch enaNexCel[nTowCel]
    "Enable next cells"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[nTowCel] "Logical and"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nTowCel] "Logical and"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd enaCel(
    final nin=nTowCel) "New cells should be enabled"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Buildings.Controls.OBC.CDL.Reals.Switch celPosSet
    "Slowly change the opening setpoint to 1 of the enabling cells isolation valve, or change the setpoint to 0 of the disabling cells"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));
  Buildings.Controls.OBC.CDL.Logical.And enaPro "Enabling cells process"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical and"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Logical.And disPro "Disabling cells process"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch newTowCell[nTowCel]
    "New tower cell status"
    annotation (Placement(transformation(extent={{160,-210},{180,-190}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nTowCel) "In the enabling process"
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch disExiCel[nTowCel]
    "Disable existing cells"
    annotation (Placement(transformation(extent={{80,-250},{100,-230}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(
    final nout=nTowCel) "In the disabling process"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr staPro(nin=nTowCel)
    "In tower staging process"
    annotation (Placement(transformation(extent={{60,280},{80,300}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr opeVal(
    final nin=nTowCel) "Check if there is any opened valve"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Check if the opened valves are fully open"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nTowCel]
    "Convert boolean input to integer"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nTowCel]
    "Convert boolean input to integer"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nTowCel]
    "Check if the opened valves are fully open"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(
    final nout=nTowCel) "In the disabling process"
    annotation (Placement(transformation(extent={{60,-290},{80,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Or celChaSta[nTowCel]
    "True: there are cells changed status"
    annotation (Placement(transformation(extent={{-60,-310},{-40,-290}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg[nTowCel]
    "Check if there is any cell being disabled"
    annotation (Placement(transformation(extent={{-120,-290},{-100,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg[nTowCel]
    "Check if there is any cell being enabled"
    annotation (Placement(transformation(extent={{-120,-330},{-100,-310}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr endStaPro(
    final nin=nTowCel)
    "Check if there is any cell changed status so it means that the staging process is done"
    annotation (Placement(transformation(extent={{-20,-310},{0,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat[nTowCel] "Change cells status"
    annotation (Placement(transformation(extent={{-100,280},{-80,300}})));
  Buildings.Controls.OBC.CDL.Logical.Edge havCha[nTowCel] "Edge"
    annotation (Placement(transformation(extent={{-180,280},{-160,300}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nTowCel]
    "True: cells should be disabled"
    annotation (Placement(transformation(extent={{-140,-210},{-120,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch disExiCel1[nTowCel]
    "Disable existing cells"
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nTowCel](
    final k=fill(false, nTowCel)) "Disable cells"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
equation
  connect(con9.y, lin1.x1)
    annotation (Line(points={{-18,240},{10,240},{10,228},{18,228}},
      color={0,0,127}));
  connect(con7.y, lin1.x2)
    annotation (Line(points={{-98,190},{-60,190},{-60,216},{18,216}},
      color={0,0,127}));
  connect(con8.y, lin1.f2)
    annotation (Line(points={{-18,190},{-10,190},{-10,212},{18,212}},
      color={0,0,127}));
  connect(tim.y, lin1.u)
    annotation (Line(points={{-98,220},{18,220}}, color={0,0,127}));
  connect(reaRep.y, swi2.u1)
    annotation (Line(points={{122,150},{140,150},{140,130},{80,130},{80,118},{98,
          118}},color={0,0,127}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{122,110},{140,110},{140,98},{158,98}},
      color={0,0,127}));
  connect(uIsoVal, swi2.u3)
    annotation (Line(points={{-220,50},{30,50},{30,102},{98,102}},
      color={0,0,127}));
  connect(booRep.y, swi.u2)
    annotation (Line(points={{82,30},{140,30},{140,90},{158,90}},
      color={255,0,255}));
  connect(uIsoVal, swi.u3)
    annotation (Line(points={{-220,50},{30,50},{30,82},{158,82}},
      color={0,0,127}));
  connect(swi.y, yIsoVal)
    annotation (Line(points={{182,90},{220,90}},   color={0,0,127}));
  connect(greEquThr.y, and5.u2)
    annotation (Line(points={{22,-110},{70,-110},{70,-98},{98,-98}},
      color={255,0,255}));
  connect(uIsoVal, hys4.u)
    annotation (Line(points={{-220,50},{-160,50},{-160,-80},{-142,-80}},
      color={0,0,127}));
  connect(uIsoVal, hys3.u)
    annotation (Line(points={{-220,50},{-160,50},{-160,-50},{-142,-50}},
      color={0,0,127}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{-98,220},{-70,220},{-70,-110},{-2,-110}},
      color={0,0,127}));
  connect(and5.y, booRep1.u)
    annotation (Line(points={{122,-90},{138,-90}},   color={255,0,255}));
  connect(booRep1.y, and1.u1)
    annotation (Line(points={{162,-90},{180,-90},{180,-132},{0,-132},{0,-160},{18,
          -160}},     color={255,0,255}));
  connect(and1.y, enaNexCel.u2)
    annotation (Line(points={{42,-160},{78,-160}}, color={255,0,255}));
  connect(con1.y, enaNexCel.u1) annotation (Line(points={{-38,-140},{60,-140},{60,
          -152},{78,-152}}, color={255,0,255}));
  connect(uTowSta, enaNexCel.u3) annotation (Line(points={{-220,-180},{60,-180},
          {60,-168},{78,-168}}, color={255,0,255}));
  connect(celPosSet.y, reaRep.u)
    annotation (Line(points={{82,150},{98,150}}, color={0,0,127}));
  connect(uTowSta, and2.u2) annotation (Line(points={{-220,-180},{-180,-180},{-180,
          142},{-122,142}}, color={255,0,255}));
  connect(and2.y, not1.u)
    annotation (Line(points={{-98,150},{-62,150}}, color={255,0,255}));
  connect(not1.y, enaCel.u) annotation (Line(points={{-38,150},{-22,150}},
                      color={255,0,255}));
  connect(enaCel.y, celPosSet.u2)
    annotation (Line(points={{2,150},{58,150}}, color={255,0,255}));
  connect(lin1.y, celPosSet.u1) annotation (Line(points={{42,220},{50,220},{50,158},
          {58,158}}, color={0,0,127}));
  connect(con9.y, celPosSet.u3) annotation (Line(points={{-18,240},{10,240},{10,
          142},{58,142}}, color={0,0,127}));
  connect(enaCel.y, enaPro.u1) annotation (Line(points={{2,150},{20,150},{20,120},
          {-120,120},{-120,0},{-62,0}},   color={255,0,255}));
  connect(enaCel.y, not2.u) annotation (Line(points={{2,150},{20,150},{20,120},{
          -120,120},{-120,90},{-102,90}},  color={255,0,255}));
  connect(not2.y, disPro.u1)
    annotation (Line(points={{-78,90},{-22,90}},   color={255,0,255}));
  connect(booRep2.y, newTowCell.u2)
    annotation (Line(points={{102,-200},{158,-200}}, color={255,0,255}));
  connect(enaNexCel.y, newTowCell.u1) annotation (Line(points={{102,-160},{120,-160},
          {120,-192},{158,-192}},                    color={255,0,255}));
  connect(booRep3.y, disExiCel.u2)
    annotation (Line(points={{22,-240},{78,-240}},  color={255,0,255}));
  connect(uTowSta, disExiCel.u3) annotation (Line(points={{-220,-180},{60,-180},
          {60,-248},{78,-248}}, color={255,0,255}));
  connect(disPro.y, booRep3.u) annotation (Line(points={{2,90},{20,90},{20,60},{
          -100,60},{-100,-240},{-2,-240}}, color={255,0,255}));
  connect(enaPro.y, booRep2.u) annotation (Line(points={{-38,0},{-30,0},{-30,-200},
          {78,-200}}, color={255,0,255}));
  connect(disExiCel.y, newTowCell.u3) annotation (Line(points={{102,-240},{140,-240},
          {140,-208},{158,-208}}, color={255,0,255}));
  connect(newTowCell.y, yTowSta)
    annotation (Line(points={{182,-200},{220,-200}}, color={255,0,255}));
  connect(con9.y, lin1.f1) annotation (Line(points={{-18,240},{10,240},{10,224},
          {18,224}}, color={0,0,127}));
  connect(staPro.y, tim.u) annotation (Line(points={{82,290},{100,290},{100,260},
          {-140,260},{-140,220},{-122,220}}, color={255,0,255}));
  connect(staPro.y, disPro.u2) annotation (Line(points={{82,290},{100,290},{100,
          260},{-140,260},{-140,70},{-40,70},{-40,82},{-22,82}},   color={255,0,255}));
  connect(staPro.y, enaPro.u2) annotation (Line(points={{82,290},{100,290},{100,
          260},{-140,260},{-140,-8},{-62,-8}}, color={255,0,255}));
  connect(hys3.y, booToInt.u)
    annotation (Line(points={{-118,-50},{-2,-50}},color={255,0,255}));
  connect(hys4.y, booToInt1.u)
    annotation (Line(points={{-118,-80},{-2,-80}},  color={255,0,255}));
  connect(booToInt.y, intEqu.u1)
    annotation (Line(points={{22,-50},{38,-50}}, color={255,127,0}));
  connect(booToInt1.y, intEqu.u2) annotation (Line(points={{22,-80},{30,-80},{30,
          -58},{38,-58}}, color={255,127,0}));
  connect(intEqu.y, mulAnd1.u) annotation (Line(points={{62,-50},{78,-50}},
    color={255,0,255}));
  connect(hys3.y, opeVal.u) annotation (Line(points={{-118,-50},{-20,-50},{-20,-20},
          {-2,-20}}, color={255,0,255}));
  connect(opeVal.y, and3.u1)
    annotation (Line(points={{22,-20},{138,-20}}, color={255,0,255}));
  connect(mulAnd1.y, and3.u2) annotation (Line(points={{102,-50},{120,-50},{120,
          -28},{138,-28}}, color={255,0,255}));
  connect(and3.y, and5.u1) annotation (Line(points={{162,-20},{180,-20},{180,-70},
          {70,-70},{70,-90},{98,-90}},   color={255,0,255}));
  connect(staPro.y, booRep.u) annotation (Line(points={{82,290},{100,290},{100,260},
          {-140,260},{-140,30},{58,30}}, color={255,0,255}));
  connect(uTowSta, falEdg.u) annotation (Line(points={{-220,-180},{-180,-180},{-180,
          -280},{-122,-280}}, color={255,0,255}));
  connect(uTowSta, edg.u) annotation (Line(points={{-220,-180},{-180,-180},{-180,
          -320},{-122,-320}}, color={255,0,255}));
  connect(booRep4.y, lat.clr) annotation (Line(points={{82,-280},{100,-280},{100,
          -260},{-150,-260},{-150,284},{-102,284}}, color={255,0,255}));
  connect(falEdg.y, celChaSta.u1) annotation (Line(points={{-98,-280},{-80,-280},
          {-80,-300},{-62,-300}}, color={255,0,255}));
  connect(edg.y, celChaSta.u2) annotation (Line(points={{-98,-320},{-80,-320},{-80,
          -308},{-62,-308}}, color={255,0,255}));
  connect(celChaSta.y, endStaPro.u) annotation (Line(points={{-38,-300},{-22,-300}},
          color={255,0,255}));
  connect(uChaCel, havCha.u) annotation (Line(points={{-220,290},{-182,290}},
          color={255,0,255}));
  connect(havCha.y, lat.u) annotation (Line(points={{-158,290},{-102,290}},
          color={255,0,255}));
  connect(lat.y, staPro.u)
    annotation (Line(points={{-78,290},{58,290}}, color={255,0,255}));
  connect(lat.y, and2.u1) annotation (Line(points={{-78,290},{-60,290},{-60,266},
          {-168,266},{-168,150},{-122,150}}, color={255,0,255}));
  connect(lat.y, swi2.u2) annotation (Line(points={{-78,290},{-60,290},{-60,266},
          {-168,266},{-168,110},{98,110}}, color={255,0,255}));
  connect(lat.y, and1.u2) annotation (Line(points={{-78,290},{-60,290},{-60,266},
          {-168,266},{-168,-168},{18,-168}}, color={255,0,255}));
  connect(endStaPro.y, yEndSta)
    annotation (Line(points={{2,-300},{220,-300}}, color={255,0,255}));
  connect(endStaPro.y, booRep4.u) annotation (Line(points={{2,-300},{20,-300},{20,
          -280},{58,-280}}, color={255,0,255}));
  connect(uTowSta, and4.u2) annotation (Line(points={{-220,-180},{-180,-180},{-180,
          -208},{-142,-208}}, color={255,0,255}));
  connect(uChaCel, and4.u1) annotation (Line(points={{-220,290},{-190,290},{-190,
          -200},{-142,-200}}, color={255,0,255}));
  connect(and4.y, disExiCel1.u2) annotation (Line(points={{-118,-200},{-80,-200},
          {-80,-220},{-62,-220}}, color={255,0,255}));
  connect(uTowSta, disExiCel1.u3) annotation (Line(points={{-220,-180},{-180,-180},
          {-180,-228},{-62,-228}}, color={255,0,255}));
  connect(con2.y, disExiCel1.u1) annotation (Line(points={{-118,-150},{-70,-150},
          {-70,-212},{-62,-212}}, color={255,0,255}));
  connect(disExiCel1.y, disExiCel.u1) annotation (Line(points={{-38,-220},{50,-220},
          {50,-232},{78,-232}}, color={255,0,255}));
annotation (
  defaultComponentName="towCelStaPro",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-340},{200,340}}), graphics={
          Rectangle(
          extent={{-138,-2},{178,-138}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{12,-120},{144,-144}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Check if all enabled isolation valves 
          have been fully open")}),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,88},{-54,76}},
          textColor={255,0,255},
          textString="uChaCel"),
        Text(
          extent={{-100,6},{-62,-6}},
          textColor={0,0,127},
          textString="uIsoVal"),
        Text(
          extent={{-100,-74},{-56,-86}},
          textColor={255,0,255},
          textString="uTowSta"),
        Text(
          extent={{62,66},{100,54}},
          textColor={0,0,127},
          textString="yIsoVal"),
        Text(
          extent={{56,8},{100,-4}},
          textColor={255,0,255},
          textString="yTowSta"),
        Text(
          extent={{56,-52},{100,-64}},
          textColor={255,0,255},
          textString="yEndSta")}),
Documentation(info="<html>
<p>
This block outputs new status vector of cells. When staging up cells, the cells
should be enabled only when their supply isolation valves have been proven fully
open. It is implemented according to ASHRAE RP-1711 Advanced Sequences of Operation
for HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft on March 23, 2020), 
section 5.2.12.1, item 5 and 6 which specifies the process of enabling and disabling
tower fan cells.
</p>
<ul>
<li>
When tower fan cells need to be enabled, which means that it is in the staging process
(not all <code>uChaCel</code> are false) and the cells that should change status (<code>uChaCel=true</code>)
are not enabled (<code>uTowSta=true</code>), the supply isolation valves position
(<code>uIsoVal</code>) of the enabling cells should change to
fully open with moving time (nominal valve timing) <code>chaTowCelIsoTim</code>.
Once the enabling supply isolation valves have been fully open, then enable
the additional fans.
</li>
<li>
When disabling tower cells, command the fan off and shut its supply isolation
valve, and outlet isolation valves if provided.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 12, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end StageProcesses;
