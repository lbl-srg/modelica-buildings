within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences;
block StageProcesses "Sequence for process of staging cells"

  parameter Integer nTowCel = 4
    "Total number of cooling tower cells";
  parameter Real chaTowCelIsoTim(final quantity="Time", final unit="s") = 90
    "Nominal time needed for open isolation valve";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChaCel[nTowCel]
    "Vector of boolean flags to show if a cell should change its status: true = the cell should change status (be enabled or disabled)"
    annotation (Placement(transformation(extent={{-200,280},{-160,320}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel)) "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{-200,50},{-160,90}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cells proven on status: true=enabled tower cell"
    annotation (Placement(transformation(extent={{-200,-180},{-160,-140}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel)) "Cooling tower cells isolation valve setpoint"
    annotation (Placement(transformation(extent={{160,90},{200,130}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Vector of tower cells status setpoint"
    annotation (Placement(transformation(extent={{160,-200},{200,-160}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSta
    "Rising edge to indicate the staging process is done"
    annotation (Placement(transformation(extent={{160,-300},{200,-260}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count the time after changing up-stream device status"
    annotation (Placement(transformation(extent={{-100,230},{-80,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con9(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-40,250},{-20,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(
    final k=chaTowCelIsoTim) "Time to change cooling tower isolation valve"
    annotation (Placement(transformation(extent={{-100,200},{-80,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(final k=1)
    "Fully open valve"
    annotation (Placement(transformation(extent={{-40,200},{-20,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin1
    "Chilled water isolation valve setpoint"
    annotation (Placement(transformation(extent={{20,230},{40,250}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=nTowCel)
    "Replicate real input"
    annotation (Placement(transformation(extent={{100,160},{120,180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3[nTowCel](
    final uLow=fill(0.025, nTowCel),
    final uHigh=fill(0.05, nTowCel)) "Check if isolation valve is enabled"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4[nTowCel](
    final uLow=fill(0.925, nTowCel),
    final uHigh=fill(0.975, nTowCel)) "Check if isolation valve is open more than 95%"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(final nu=nTowCel)
    "Logical and"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greEquThr(
    final t=chaTowCelIsoTim)
    "Check if it has past the target time of open isolation valve "
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nTowCel]
    "True: cells should be enabled"
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nTowCel](
    final k=fill(true, nTowCel)) "Enable cells"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch enaNexCel[nTowCel]
    "Enable next cells"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[nTowCel] "Logical and"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nTowCel] "Logical and"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd enaCel(
    final nu=nTowCel) "New cells should be enabled"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch celPosSet
    "Slowly change the opening setpoint to 1 of the enabling cells isolation valve, or change the setpoint to 0 of the disabling cells"
    annotation (Placement(transformation(extent={{60,160},{80,180}})));
  Buildings.Controls.OBC.CDL.Logical.And enaPro "Enabling cells process"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical and"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Logical.And disPro "Disabling cells process"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch newTowCell[nTowCel]
    "New tower cell status"
    annotation (Placement(transformation(extent={{100,-190},{120,-170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(
    final nout=nTowCel) "In the enabling process"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch disExiCel[nTowCel]
    "Disable existing cells"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep3(
    final nout=nTowCel) "In the disabling process"
    annotation (Placement(transformation(extent={{-40,-220},{-20,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nTowCel](
    final k=fill(false, nTowCel)) "Disable cells"
    annotation (Placement(transformation(extent={{-80,-200},{-60,-180}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr staPro(
    final nu=nTowCel) "In tower staging process"
    annotation (Placement(transformation(extent={{20,290},{40,310}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr opeVal(
    final nu=nTowCel) "Check if there is any opened valve"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Check if the opened valves are fully open"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nTowCel]
    "Convert boolean input to integer"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nTowCel]
    "Convert boolean input to integer"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nTowCel]
    "Check if the opened valves are fully open"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep4(
    final nout=nTowCel) "In the disabling process"
    annotation (Placement(transformation(extent={{60,-270},{80,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Or celChaSta[nTowCel]
    "True: there are cells changed status"
    annotation (Placement(transformation(extent={{-60,-290},{-40,-270}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg[nTowCel]
    "Check if there is any cell being disabled"
    annotation (Placement(transformation(extent={{-120,-270},{-100,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg[nTowCel] "Check if there is any cell being enabled"
    annotation (Placement(transformation(extent={{-120,-310},{-100,-290}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr endStaPro(
    final nu=nTowCel)
    "Check if there is any cell changed status so it means that the staging process is done"
    annotation (Placement(transformation(extent={{0,-290},{20,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat[nTowCel] "Change cells status"
    annotation (Placement(transformation(extent={{-100,290},{-80,310}})));

equation
  connect(con9.y, lin1.x1)
    annotation (Line(points={{-18,260},{10,260},{10,248},{18,248}},
      color={0,0,127}));
  connect(con7.y, lin1.x2)
    annotation (Line(points={{-78,210},{-60,210},{-60,236},{18,236}},
      color={0,0,127}));
  connect(con8.y, lin1.f2)
    annotation (Line(points={{-18,210},{-10,210},{-10,232},{18,232}},
      color={0,0,127}));
  connect(tim.y, lin1.u)
    annotation (Line(points={{-78,240},{18,240}}, color={0,0,127}));
  connect(reaRep.y, swi2.u1)
    annotation (Line(points={{122,170},{130,170},{130,150},{40,150},{40,138},{58,
          138}},color={0,0,127}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{82,130},{100,130},{100,118},{118,118}},
      color={0,0,127}));
  connect(uIsoVal, swi2.u3)
    annotation (Line(points={{-180,70},{30,70},{30,122},{58,122}},
      color={0,0,127}));
  connect(booRep.y, swi.u2)
    annotation (Line(points={{82,30},{100,30},{100,110},{118,110}},
      color={255,0,255}));
  connect(uIsoVal, swi.u3)
    annotation (Line(points={{-180,70},{30,70},{30,102},{118,102}},
      color={0,0,127}));
  connect(swi.y, yIsoVal)
    annotation (Line(points={{142,110},{180,110}}, color={0,0,127}));
  connect(greEquThr.y, and5.u2)
    annotation (Line(points={{62,-90},{70,-90},{70,-78},{78,-78}},
      color={255,0,255}));
  connect(uIsoVal, hys4.u)
    annotation (Line(points={{-180,70},{-130,70},{-130,-60},{-62,-60}},
      color={0,0,127}));
  connect(uIsoVal, hys3.u)
    annotation (Line(points={{-180,70},{-130,70},{-130,-30},{-62,-30}},
      color={0,0,127}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{-78,240},{-70,240},{-70,-90},{38,-90}},
      color={0,0,127}));
  connect(and5.y, booRep1.u)
    annotation (Line(points={{102,-70},{118,-70}},   color={255,0,255}));
  connect(booRep1.y, and1.u1)
    annotation (Line(points={{142,-70},{150,-70},{150,-112},{0,-112},{0,-140},{18,
          -140}},     color={255,0,255}));
  connect(and1.y, enaNexCel.u2)
    annotation (Line(points={{42,-140},{78,-140}}, color={255,0,255}));
  connect(con1.y, enaNexCel.u1) annotation (Line(points={{-38,-120},{60,-120},{60,
          -132},{78,-132}}, color={255,0,255}));
  connect(uTowSta, enaNexCel.u3) annotation (Line(points={{-180,-160},{60,-160},
          {60,-148},{78,-148}}, color={255,0,255}));
  connect(celPosSet.y, reaRep.u)
    annotation (Line(points={{82,170},{98,170}}, color={0,0,127}));
  connect(uTowSta, and2.u2) annotation (Line(points={{-180,-160},{-110,-160},{-110,
          162},{-102,162}}, color={255,0,255}));
  connect(and2.y, not1.u)
    annotation (Line(points={{-78,170},{-62,170}}, color={255,0,255}));
  connect(not1.y, enaCel.u) annotation (Line(points={{-38,170},{-22,170}},
                      color={255,0,255}));
  connect(enaCel.y, celPosSet.u2)
    annotation (Line(points={{2,170},{58,170}}, color={255,0,255}));
  connect(lin1.y, celPosSet.u1) annotation (Line(points={{42,240},{50,240},{50,178},
          {58,178}}, color={0,0,127}));
  connect(con9.y, celPosSet.u3) annotation (Line(points={{-18,260},{10,260},{10,
          162},{58,162}}, color={0,0,127}));
  connect(enaCel.y, enaPro.u1) annotation (Line(points={{2,170},{20,170},{20,150},
          {-100,150},{-100,50},{-62,50}}, color={255,0,255}));
  connect(enaCel.y, not2.u) annotation (Line(points={{2,170},{20,170},{20,150},{
          -100,150},{-100,110},{-62,110}}, color={255,0,255}));
  connect(not2.y, disPro.u1)
    annotation (Line(points={{-38,110},{-22,110}}, color={255,0,255}));
  connect(booRep2.y, newTowCell.u2)
    annotation (Line(points={{62,-180},{98,-180}}, color={255,0,255}));
  connect(enaNexCel.y, newTowCell.u1) annotation (Line(points={{102,-140},{120,-140},
          {120,-160},{80,-160},{80,-172},{98,-172}}, color={255,0,255}));
  connect(booRep3.y, disExiCel.u2)
    annotation (Line(points={{-18,-210},{38,-210}}, color={255,0,255}));
  connect(con2.y, disExiCel.u1) annotation (Line(points={{-58,-190},{20,-190},{20,
          -202},{38,-202}}, color={255,0,255}));
  connect(uTowSta, disExiCel.u3) annotation (Line(points={{-180,-160},{0,-160},{
          0,-218},{38,-218}}, color={255,0,255}));
  connect(disPro.y, booRep3.u) annotation (Line(points={{2,110},{20,110},{20,80},
          {-90,80},{-90,-210},{-42,-210}}, color={255,0,255}));
  connect(enaPro.y, booRep2.u) annotation (Line(points={{-38,50},{-30,50},{-30,-180},
          {38,-180}}, color={255,0,255}));
  connect(disExiCel.y, newTowCell.u3) annotation (Line(points={{62,-210},{80,-210},
          {80,-188},{98,-188}}, color={255,0,255}));
  connect(newTowCell.y, yTowSta)
    annotation (Line(points={{122,-180},{180,-180}}, color={255,0,255}));
  connect(con9.y, lin1.f1) annotation (Line(points={{-18,260},{10,260},{10,244},
          {18,244}}, color={0,0,127}));
  connect(staPro.y, tim.u) annotation (Line(points={{42,300},{60,300},{60,280},{
          -120,280},{-120,240},{-102,240}},  color={255,0,255}));
  connect(staPro.y, disPro.u2) annotation (Line(points={{42,300},{60,300},{60,280},
          {-120,280},{-120,90},{-30,90},{-30,102},{-22,102}},      color={255,0,255}));
  connect(staPro.y, enaPro.u2) annotation (Line(points={{42,300},{60,300},{60,280},
          {-120,280},{-120,42},{-62,42}},      color={255,0,255}));
  connect(hys3.y, booToInt.u)
    annotation (Line(points={{-38,-30},{-2,-30}}, color={255,0,255}));
  connect(hys4.y, booToInt1.u)
    annotation (Line(points={{-38,-60},{-2,-60}},   color={255,0,255}));
  connect(booToInt.y, intEqu.u1)
    annotation (Line(points={{22,-30},{38,-30}}, color={255,127,0}));
  connect(booToInt1.y, intEqu.u2) annotation (Line(points={{22,-60},{30,-60},{30,
          -38},{38,-38}}, color={255,127,0}));
  connect(intEqu.y, mulAnd1.u) annotation (Line(points={{62,-30},{78,-30}},
    color={255,0,255}));
  connect(hys3.y, opeVal.u) annotation (Line(points={{-38,-30},{-20,-30},{-20,0},
          {-2,0}}, color={255,0,255}));
  connect(opeVal.y, and3.u1)
    annotation (Line(points={{22,0},{118,0}},     color={255,0,255}));
  connect(mulAnd1.y, and3.u2) annotation (Line(points={{102,-30},{110,-30},{110,
          -8},{118,-8}},   color={255,0,255}));
  connect(and3.y, and5.u1) annotation (Line(points={{142,0},{150,0},{150,-50},{70,
          -50},{70,-70},{78,-70}},       color={255,0,255}));
  connect(staPro.y, booRep.u) annotation (Line(points={{42,300},{60,300},{60,280},
          {-120,280},{-120,30},{58,30}}, color={255,0,255}));
  connect(endStaPro.y, yEndSta)
    annotation (Line(points={{22,-280},{180,-280}},  color={255,0,255}));
  connect(uTowSta, falEdg.u) annotation (Line(points={{-180,-160},{-140,-160},{-140,
          -260},{-122,-260}}, color={255,0,255}));
  connect(uTowSta, edg.u) annotation (Line(points={{-180,-160},{-140,-160},{-140,
          -300},{-122,-300}}, color={255,0,255}));
  connect(uChaCel, lat.u)
    annotation (Line(points={{-180,300},{-102,300}}, color={255,0,255}));
  connect(lat.y, staPro.u) annotation (Line(points={{-78,300},{-30,300},{-30,300},
          {18,300}},            color={255,0,255}));
  connect(endStaPro.y, booRep4.u) annotation (Line(points={{22,-280},{40,-280},{
          40,-260},{58,-260}},   color={255,0,255}));
  connect(booRep4.y, lat.clr) annotation (Line(points={{82,-260},{100,-260},{100,
          -230},{-150,-230},{-150,294},{-102,294}}, color={255,0,255}));
  connect(falEdg.y, celChaSta.u1) annotation (Line(points={{-98,-260},{-80,-260},
          {-80,-280},{-62,-280}}, color={255,0,255}));
  connect(edg.y, celChaSta.u2) annotation (Line(points={{-98,-300},{-80,-300},{-80,
          -288},{-62,-288}}, color={255,0,255}));
  connect(celChaSta.y, endStaPro.u) annotation (Line(points={{-38,-280},{-20,-280},
          {-20,-280},{-2,-280}}, color={255,0,255}));
  connect(lat.y, and2.u1) annotation (Line(points={{-78,300},{-60,300},{-60,286},
          {-140,286},{-140,170},{-102,170}}, color={255,0,255}));
  connect(lat.y, swi2.u2) annotation (Line(points={{-78,300},{-60,300},{-60,286},
          {-140,286},{-140,130},{58,130}}, color={255,0,255}));
  connect(lat.y, and1.u2) annotation (Line(points={{-78,300},{-60,300},{-60,286},
          {-140,286},{-140,-148},{18,-148}}, color={255,0,255}));

annotation (
  defaultComponentName="towCelStaPro",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-320},{160,320}}), graphics={
          Rectangle(
          extent={{-158,18},{158,-118}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{12,-100},{144,-124}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
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
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,88},{-54,76}},
          lineColor={255,0,255},
          textString="uChaCel"),
        Text(
          extent={{-100,6},{-62,-6}},
          lineColor={0,0,127},
          textString="uIsoVal"),
        Text(
          extent={{-100,-74},{-56,-86}},
          lineColor={255,0,255},
          textString="uTowSta"),
        Text(
          extent={{62,66},{100,54}},
          lineColor={0,0,127},
          textString="yIsoVal"),
        Text(
          extent={{56,8},{100,-4}},
          lineColor={255,0,255},
          textString="yTowSta"),
        Text(
          extent={{56,-52},{100,-64}},
          lineColor={255,0,255},
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
