within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging;
block Controller "Sequence of staging cooling tower cells"

  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Boolean hasWSE=true
    "Flag to indicate if the plant has waterside economizer";
  parameter Integer totChiSta=6
    "Total number of stages, stage zero should be counted as one stage";
  parameter Real staVec[totChiSta]={0,0.5,1,1.5,2,2.5}
    "Chiller stage vector, element value like x.5 means chiller stage x plus WSE";
  parameter Real towCelOnSet[totChiSta] = {0,2,2,4,4,4}
    "Design number of tower fan cells that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(group="Setpoint according to stage"));
  parameter Modelica.SIunits.Time chaTowCelIsoTim=90
    "Time to slowly change isolation valve"
    annotation (Dialog(group="Enable cell isolation valve"));
  parameter Real iniValPos=0
    "Initial valve position, if it needs to turn on tower cell, the value should be 0"
    annotation (Dialog(group="Enable cell isolation valve"));
  parameter Real endValPos=1
    "Ending valve position, if it needs to turn on tower cell, the value should be 1"
    annotation (Dialog(group="Enable cell isolation valve"));
  parameter Modelica.SIunits.Time fallDelay = 1
    "Fan cells stage off delay time, so it can trige the cell disable output"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-140,110},{-100,150}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Cooling tower operating status: true=running tower cell"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uTowCelPri[nTowCel]
    "Cooling tower cell enabling priority"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Plant stage up status: true=stage-up"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowStaUp
    "Cooling tower stage-up command"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Plant stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowStaDow
    "Cooling tower stage-down command"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel)) "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{-140,-150},{-100,-110}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Cooling tower cell enabling status"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel)) "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  final parameter Integer towCelInd[nTowCel]={i for i in 1:nTowCel}
    "Tower cell index, {1,2,...,n}";
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells
    enaTowCel(
    final hasWSE=hasWSE,
    final nTowCel=nTowCel,
    final totChiSta=totChiSta,
    final staVec=staVec,
    final towCelOnSet=towCelOnSet) "Identifying enabing and disabling cells"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableProcesses
    towCelStaPro(
    final nTowCel=nTowCel,
    final chaTowCelIsoTim=chaTowCelIsoTim,
    final iniValPos=iniValPos,
    final endValPos=endValPos) "Sequence for process of enabling cells"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger enaCel[nTowCel]
    "Convert real number to integer"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[nTowCel]
    "Check next disabling cell"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(
    final nout=nTowCel)  "Replicate boolean input"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nTowCel](
    final k=towCelInd)
    "Cooling tower cell index array"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nTowCel]
    "Check next enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger disCel[nTowCel]
    "Convert real number to integer"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con9[nTowCel](
    final k=fill(0, nTowCel)) "Constant zero"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel[nTowCel](
    final delayTime=fill(fallDelay, nTowCel)) "Delay true input"
    annotation (Placement(transformation(extent={{30,100},{50,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nTowCel] "Logical not"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nTowCel] "Logical not"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

equation
  connect(enaTowCel.yEnaCel, towCelStaPro.uEnaCel)
    annotation (Line(points={{-38,115}, {-14,115},{-14,-24},{-2,-24}},
      color={255,0,255}));
  connect(enaTowCel.uWSE, uWSE)
    annotation (Line(points={{-62,117},{-92.5,117},{-92.5,100},{-120,100}},
      color={255,0,255}));
  connect(enaTowCel.uChiSta, uChiSta)
    annotation (Line(points={{-62,119},{-80,119},{-80,130},{-120,130}},
      color={255,127,0}));
  connect(enaTowCel.uTowSta, uTowSta)
    annotation (Line(points={{-62,115},{-90,115},{-90,70},{-120,70}},
      color={255,0,255}));
  connect(enaTowCel.uTowCelPri, uTowCelPri)
    annotation (Line(points={{-62,113},{-88,113},{-88,40},{-120,40}},
      color={255,127,0}));
  connect(enaTowCel.uStaUp, uStaUp)
    annotation (Line(points={{-62,107},{-86,107},{-86,10},{-120,10}},
      color={255,0,255}));
  connect(enaTowCel.uTowStaUp, uTowStaUp)
    annotation (Line(points={{-62,105},{-84,105},{-84,-20},{-120,-20}},
      color={255,0,255}));
  connect(enaTowCel.uStaDow, uStaDow)
    annotation (Line(points={{-62,103},{-82,103},{-82,-50},{-120,-50}},
      color={255,0,255}));
  connect(enaTowCel.uTowStaDow, uTowStaDow)
    annotation (Line(points={{-62,101},{-80,101},{-80,-80},{-120,-80}},
      color={255,0,255}));
  connect(enaTowCel.yEnaCelInd, enaCel.u)
    annotation (Line(points={{-38,105},{-26,105},{-26,80},{-78,80},{-78,50},
      {-62,50}}, color={0,0,127}));
  connect(enaCel.y, towCelStaPro.uCelInd)
    annotation (Line(points={{-38,50},{-26,50},{-26,-12},{-2,-12}},
      color={255,127,0}));
  connect(towCelStaPro.uIsoVal, uIsoVal)
    annotation (Line(points={{-2,-16},{-78,-16},{-78,-130},{-120,-130}},
      color={0,0,127}));
  connect(uTowSta, towCelStaPro.uTowSta)
    annotation (Line(points={{-120,70},{-90,70},{-90,-28},{-2,-28}},
      color={255,0,255}));
  connect(booRep1.y, logSwi1.u2)
    annotation (Line(points={{22,50},{58,50}}, color={255,0,255}));
  connect(enaTowCel.yDisCel, booRep1.u)
    annotation (Line(points={{-38,110},{-20,110},{-20,50},{-2,50}},
      color={255,0,255}));
  connect(towCelStaPro.yTowSta, logSwi1.u3)
    annotation (Line(points={{22,-29},{30,-29},{30,42},{58,42}},
      color={255,0,255}));
  connect(logSwi1.y, yTowSta)
    annotation (Line(points={{82,50},{120,50}}, color={255,0,255}));
  connect(enaTowCel.yDisCelInd, disCel.u)
    annotation (Line(points={{-38,101},{-30,101},{-30,0},{-76,0},
      {-76,-80},{-62,-80}}, color={0,0,127}));
  connect(disCel.y, intEqu.u1)
    annotation (Line(points={{-38,-80},{-30,-80},{-30,-100},{-22,-100}},
      color={255,127,0}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-38,-110},{-30,-110},{-30,-108},{-22,-108}},
      color={255,127,0}));
  connect(intEqu.y, swi.u2)
    annotation (Line(points={{2,-100},{18,-100}}, color={255,0,255}));
  connect(con9.y, swi.u1)
    annotation (Line(points={{2,-60},{10,-60},{10,-92},{18,-92}},
      color={0,0,127}));
  connect(uIsoVal, swi.u3)
    annotation (Line(points={{-120,-130},{10,-130},{10,-108},{18,-108}},
      color={0,0,127}));
  connect(swi.y, swi1.u1)
    annotation (Line(points={{42,-100},{50,-100},{50,8},{58,8}},
      color={0,0,127}));
  connect(booRep1.y, swi1.u2)
    annotation (Line(points={{22,50},{40,50},{40,0},{58,0}},
      color={255,0,255}));
  connect(towCelStaPro.yIsoVal, swi1.u3)
    annotation (Line(points={{22,-20},{40,-20},{40,-8},{58,-8}}, color={0,0,127}));
  connect(swi1.y, yIsoVal)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(not1.y, truDel.u)
    annotation (Line(points={{22,110},{28,110}}, color={255,0,255}));
  connect(truDel.y, not2.u)
    annotation (Line(points={{52,110},{58,110}}, color={255,0,255}));
  connect(enaTowCel.yTarTowSta, not1.u)
    annotation (Line(points={{-38,119},{-8,119},{-8,110},{-2,110}}, color={255,0,255}));
  connect(not2.y, logSwi1.u1)
    annotation (Line(points={{82,110},{90,110},{90,80},{40,80},{40,58},{58,58}},
      color={255,0,255}));

annotation (
  defaultComponentName="towSta",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-140},{100,140}})),
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name")}),
Documentation(info="<html>
<p>
Block controls cooling tower fan staging. This is implemented accoding to 
ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II – 
Central Plants and Hydronic Systems (Draft 6 on July 25, 2019), section 5.2.12.1, 
which specifies tower fan staging process. It includes two subsequences and one
implementation for disabling tower fan:
</p>
<ul>
<li>
Sequence of staging tower fans. It generates targeting tower cell status. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells</a>
for a description.
</li>
<li>
Sequence of process for enabling cells. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableProcesses\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableProcesses</a>
for a description.
</li>
<li>
When disabling a tower cell, command the fan off and shut its supply isolation valve 
<code>yIsoVal = 0</code>.
</li>
</ul>
<p>
Note that in this implementation, inputs <code>uTowStaUp</code> and <code>uTowStaDow</code>
are from chiller staging process sequence. These inputs are also used for the 
condenser water pump staging. Thus, the tower stage changes are initiated concurrentlyl
with condenser water pump stage.
</p>
</html>", revisions="<html>
<ul>
<li>
September 14, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
