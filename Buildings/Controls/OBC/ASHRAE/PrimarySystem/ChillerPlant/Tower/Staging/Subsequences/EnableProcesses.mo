within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences;
block EnableProcesses "Sequence for process of enabling cells"

  parameter Integer nTowCel = 4
    "Total number of cooling tower cells";
  parameter Modelica.SIunits.Time chaTowCelIsoTim = 90
    "Nominal time needed for open isolation valve";
  parameter Real iniValPos = 0
    "Initial valve position, 0 if the corresponded cell is originally disabled, 1 otherwise";
  parameter Real endValPos = 1
    "Ending valve position, 1 if the corresponded cell is originally disabled, 0 otherwise";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCelInd[nTowCel]
    "Array of cells to be enabled or disabled"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel)) "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaCel
    "Cell enabling status: true=start enabling cell status"
    annotation (Placement(transformation(extent={{-180,-10},{-140,30}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Cooling tower operating status: true=running tower cell"
    annotation (Placement(transformation(extent={{-180,-210},{-140,-170}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel)) "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{140,40},{180,80}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Cooling tower operating status: true=running tower cell"
    annotation (Placement(transformation(extent={{140,-180},{180,-140}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  final parameter Integer towCelInd[nTowCel]={i for i in 1:nTowCel}
    "Tower cell index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nTowCel](
    final k=towCelInd)
    "Cooling tower cell index array"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nTowCel]
    "Check next enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count the time after changing up-stream device status"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6(
    final k=iniValPos)
    "Initial isolation valve position"
    annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con9(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-20,180},{0,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(
    final k=chaTowCelIsoTim) "Time to change cooling tower isolation valve"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(final k=endValPos)
    "Ending valve position"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin1
    "Chilled water isolation valve setpoint"
    annotation (Placement(transformation(extent={{20,150},{40,170}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(final nout=nTowCel)
    "Replicate real input"
    annotation (Placement(transformation(extent={{60,150},{80,170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3[nTowCel](
    final uLow=fill(0.025, nTowCel),
    final uHigh=fill(0.05, nTowCel)) "Check if isolation valve is enabled"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4[nTowCel](
    final uLow=fill(0.925, nTowCel),
    final uHigh=fill(0.975, nTowCel)) "Check if isolation valve is open more than 95%"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3[nTowCel] "Logical not"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4[nTowCel] "Logical not"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nTowCel] "Logical and"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And and3[nTowCel] "Logical and"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2[nTowCel] "Logical or"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(final nu=nTowCel)
    "Logical and"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=chaTowCelIsoTim)
    "Check if it has past the target time of open isolation valve "
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nTowCel] "Check enabling tower cell"
    annotation (Placement(transformation(extent={{20,-170},{40,-150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nTowCel](
    final k=fill(true, nTowCel))  "Logical false"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[nTowCel]
    "Check next disabling cell"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));

equation
  connect(uCelInd, intEqu.u1)
    annotation (Line(points={{-160,90},{-42,90}}, color={255,127,0}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-98,60},{-80,60},{-80,82},{-42,82}},
      color={255,127,0}));
  connect(intEqu.y, swi2.u2)
    annotation (Line(points={{-18,90},{38,90}},   color={255,0,255}));
  connect(uEnaCel, tim.u)
    annotation (Line(points={{-160,10},{-130,10},{-130,160},{-122,160}},
      color={255,0,255}));
  connect(con9.y, lin1.x1)
    annotation (Line(points={{2,190},{10,190},{10,168},{18,168}},
      color={0,0,127}));
  connect(con6.y, lin1.f1)
    annotation (Line(points={{-38,190},{-30,190},{-30,164},{18,164}},
      color={0,0,127}));
  connect(con7.y, lin1.x2)
    annotation (Line(points={{-38,130},{-30,130},{-30,156},{18,156}},
      color={0,0,127}));
  connect(con8.y, lin1.f2)
    annotation (Line(points={{2,130},{10,130},{10,152},{18,152}},
      color={0,0,127}));
  connect(tim.y, lin1.u)
    annotation (Line(points={{-98,160},{18,160}}, color={0,0,127}));
  connect(lin1.y, reaRep.u)
    annotation (Line(points={{42,160},{58,160}}, color={0,0,127}));
  connect(reaRep.y, swi2.u1)
    annotation (Line(points={{82,160},{100,160},{100,120},{20,120},{20,98},
      {38,98}}, color={0,0,127}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{62,90},{80,90},{80,68},{98,68}}, color={0,0,127}));
  connect(uIsoVal, swi2.u3)
    annotation (Line(points={{-160,40},{20,40},{20,82},{38,82}},
      color={0,0,127}));
  connect(uEnaCel, booRep.u)
    annotation (Line(points={{-160,10},{-62,10}}, color={255,0,255}));
  connect(booRep.y, swi.u2)
    annotation (Line(points={{-38,10},{40,10},{40,60},{98,60}},
      color={255,0,255}));
  connect(uIsoVal, swi.u3)
    annotation (Line(points={{-160,40},{20,40},{20,52},{98,52}},
      color={0,0,127}));
  connect(swi.y, yIsoVal)
    annotation (Line(points={{122,60},{160,60}},   color={0,0,127}));
  connect(hys3.y,and3. u1)
    annotation (Line(points={{-78,-20},{-2,-20}}, color={255,0,255}));
  connect(hys4.y,and3. u2)
    annotation (Line(points={{-78,-80},{-60,-80},{-60,-28},{-2,-28}},
      color={255,0,255}));
  connect(hys4.y,not4. u)
    annotation (Line(points={{-78,-80},{-42,-80}}, color={255,0,255}));
  connect(hys3.y,not3. u)
    annotation (Line(points={{-78,-20},{-50,-20},{-50,-50},{-42,-50}},
      color={255,0,255}));
  connect(not4.y,and4. u2)
    annotation (Line(points={{-18,-80},{-12,-80},{-12,-58},{-2,-58}},
      color={255,0,255}));
  connect(not3.y,and4. u1)
    annotation (Line(points={{-18,-50},{-2,-50}}, color={255,0,255}));
  connect(and3.y,or2. u1)
    annotation (Line(points={{22,-20},{38,-20}}, color={255,0,255}));
  connect(and4.y,or2. u2)
    annotation (Line(points={{22,-50},{30,-50},{30,-28},{38,-28}},
      color={255,0,255}));
  connect(or2.y,mulAnd1. u)
    annotation (Line(points={{62,-20},{78,-20}}, color={255,0,255}));
  connect(greEquThr.y, and5.u2)
    annotation (Line(points={{42,-100},{50,-100},{50,-88},{58,-88}},
      color={255,0,255}));
  connect(mulAnd1.y, and5.u1)
    annotation (Line(points={{102,-20},{120,-20},{120,-50},{50,-50},{50,-80},
      {58,-80}}, color={255,0,255}));
  connect(uIsoVal, hys4.u)
    annotation (Line(points={{-160,40},{-120,40},{-120,-80},{-102,-80}}, color={0,0,127}));
  connect(uIsoVal, hys3.u)
    annotation (Line(points={{-160,40},{-120,40},{-120,-20},{-102,-20}}, color={0,0,127}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{-98,160},{-70,160},{-70,-100},{18,-100}},
      color={0,0,127}));
  connect(intEqu.y, and1.u2)
    annotation (Line(points={{-18,90},{-8,90},{-8,-168},{18,-168}}, color={255,0,255}));
  connect(and5.y, booRep1.u)
    annotation (Line(points={{82,-80},{98,-80}}, color={255,0,255}));
  connect(booRep1.y, and1.u1)
    annotation (Line(points={{122,-80},{130,-80},{130,-130},{0,-130},{0,-160},
      {18,-160}}, color={255,0,255}));
  connect(and1.y, logSwi1.u2)
    annotation (Line(points={{42,-160},{78,-160}}, color={255,0,255}));
  connect(con1.y, logSwi1.u1)
    annotation (Line(points={{-78,-140},{60,-140},{60,-152},{78,-152}},
      color={255,0,255}));
  connect(uTowSta, logSwi1.u3)
    annotation (Line(points={{-160,-190},{60,-190},{60,-168},{78,-168}},
      color={255,0,255}));
  connect(logSwi1.y, yTowSta)
    annotation (Line(points={{102,-160},{160,-160}}, color={255,0,255}));

annotation (
  defaultComponentName="towCelStaPro",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-220},{140,220}}), graphics={
          Rectangle(
          extent={{-138,-2},{138,-118}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-14,-38},{118,-62}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Check if all enabled isolation valves 
have been fully open")}), Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
Documentation(info="<html>
<p>
This block outputs vector of cells to be enabled. These enabling cells should be 
enabled only when their supply isolation valves have been proven fully open. 
It is implemented according to 
ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 6 on July 25, 2019), 
section 5.2.12.1, item 5 which specifies the process of enabling tower fan cells.
</p>
<p>
When tower fan cells need to be enabled, <code>uEnaCel=true</code>, the supply
isolation valves of the enabling cells, which are denoted by <code>uCelInd</code>,
should be turned on with moving time (nominal valve timing) 
<code>chaTowCelIsoTim</code>.
</p>
<p>
Once the enabling supply isolation valves have been fully open, then enable
the additional fans <code>uCelInd</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 12, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableProcesses;
