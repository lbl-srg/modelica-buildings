within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging;
block Controller "Sequence of staging cooling tower cells"

  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Integer nSta=3
    "Total number of stages, stage zero should be counted as one stage";
  parameter Real towCelOnSet[2*nSta]={0,2,2,4,4,4}
    "Number of condenser water pumps that should be ON, according to current chiller stage and WSE status";
  parameter Modelica.SIunits.Time chaTowCelIsoTim=300
    "Time to slowly change isolation valve"
    annotation (Dialog(group="Enable_Disable cell isolation valve"));
  parameter Real iniValPos=0
    "Initial valve position, if it needs to turn on tower cell, the value should be 0"
    annotation (Dialog(group="Enable_Disable cell isolation valve"));
  parameter Real endValPos=1
    "Ending valve position, if it needs to turn on tower cell, the value should be 1"
    annotation (Dialog(group="Enable_Disable cell isolation valve"));

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
    each final unit="1",
    each final min=0,
    each final max=1) "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{-140,-150},{-100,-110}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Cooling tower cell enabling status"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    each final unit="1",
    each final min=0,
    each final max=1) "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  final parameter Integer towCelInd[nTowCel]={i for i in 1:nTowCel}
    "Tower cell index, {1,2,...,n}";
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells
    enaTowCel(
    final nTowCel=nTowCel,
    final nSta=nSta,
    final towCelOnSet=towCelOnSet) "Identifying enabing and disabling cells"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableProcesses
    towCelStaPro(
    final nTowCel=nTowCel,
    final chaTowCelIsoTim=chaTowCelIsoTim,
    final iniValPos=iniValPos,
    final endValPos=endValPos) "Sequence for process of enabling cells"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
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
    each final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(enaTowCel.yEnaCel, towCelStaPro.uEnaCel) annotation (Line(points={{-39,113},
          {-14,113},{-14,-14},{-2,-14}},      color={255,0,255}));
  connect(enaTowCel.uWSE, uWSE) annotation (Line(points={{-61,117},{-92.5,117},{
          -92.5,100},{-120,100}}, color={255,0,255}));
  connect(enaTowCel.uChiSta, uChiSta) annotation (Line(points={{-61,119},{-80,119},
          {-80,130},{-120,130}}, color={255,127,0}));
  connect(enaTowCel.uTowSta, uTowSta) annotation (Line(points={{-61,115},{-90,115},
          {-90,70},{-120,70}}, color={255,0,255}));
  connect(enaTowCel.uTowCelPri, uTowCelPri) annotation (Line(points={{-61,113},{
          -88,113},{-88,40},{-120,40}}, color={255,127,0}));
  connect(enaTowCel.uStaUp, uStaUp) annotation (Line(points={{-61,107},{-86,107},
          {-86,10},{-120,10}}, color={255,0,255}));
  connect(enaTowCel.uTowStaUp, uTowStaUp) annotation (Line(points={{-61,105},{-84,
          105},{-84,-20},{-120,-20}}, color={255,0,255}));
  connect(enaTowCel.uStaDow, uStaDow) annotation (Line(points={{-61,103},{-82,103},
          {-82,-50},{-120,-50}}, color={255,0,255}));
  connect(enaTowCel.uTowStaDow, uTowStaDow) annotation (Line(points={{-61,101},{
          -80,101},{-80,-80},{-120,-80}}, color={255,0,255}));
  connect(enaTowCel.yEnaCelInd, enaCel.u) annotation (Line(points={{-39,105},{-26,
          105},{-26,80},{-78,80},{-78,50},{-62,50}}, color={0,0,127}));
  connect(enaCel.y, towCelStaPro.uCelInd) annotation (Line(points={{-38,50},{
          -26,50},{-26,-2},{-2,-2}},
                                   color={255,127,0}));
  connect(towCelStaPro.uIsoVal, uIsoVal) annotation (Line(points={{-2,-6},{-78,-6},
          {-78,-130},{-120,-130}},      color={0,0,127}));
  connect(uTowSta, towCelStaPro.uTowSta) annotation (Line(points={{-120,70},{-90,
          70},{-90,-18},{-2,-18}}, color={255,0,255}));
  connect(booRep1.y, logSwi1.u2)
    annotation (Line(points={{22,50},{58,50}}, color={255,0,255}));
  connect(enaTowCel.yDisCel, booRep1.u) annotation (Line(points={{-39,109},{-20,
          109},{-20,50},{-2,50}}, color={255,0,255}));
  connect(enaTowCel.yTowSta, logSwi1.u1) annotation (Line(points={{-39,119},{50,
          119},{50,58},{58,58}}, color={255,0,255}));
  connect(towCelStaPro.yTowSta, logSwi1.u3) annotation (Line(points={{21,-19},{30,
          -19},{30,42},{58,42}}, color={255,0,255}));
  connect(logSwi1.y, yTowSta)
    annotation (Line(points={{82,50},{120,50}}, color={255,0,255}));
  connect(enaTowCel.yDisCelInd, disCel.u) annotation (Line(points={{-39,101},{-30,
          101},{-30,0},{-76,0},{-76,-80},{-62,-80}}, color={0,0,127}));
  connect(disCel.y, intEqu.u1) annotation (Line(points={{-38,-80},{-30,-80},{
          -30,-100},{-22,-100}},
                             color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-38,-110},{-30,-110},{
          -30,-108},{-22,-108}},
                             color={255,127,0}));
  connect(intEqu.y, swi.u2)
    annotation (Line(points={{2,-100},{18,-100}}, color={255,0,255}));
  connect(con9.y, swi.u1) annotation (Line(points={{2,-60},{10,-60},{10,-92},{
          18,-92}},
                 color={0,0,127}));
  connect(uIsoVal, swi.u3) annotation (Line(points={{-120,-130},{10,-130},{10,-108},
          {18,-108}}, color={0,0,127}));
  connect(swi.y, swi1.u1) annotation (Line(points={{42,-100},{50,-100},{50,8},{
          58,8}},    color={0,0,127}));
  connect(booRep1.y, swi1.u2) annotation (Line(points={{22,50},{40,50},{40,0},{
          58,0}},    color={255,0,255}));
  connect(towCelStaPro.yIsoVal, swi1.u3)
    annotation (Line(points={{21,-10},{40,-10},{40,-8},{58,-8}}, color={0,0,127}));
  connect(swi1.y, yIsoVal)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));

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
          textString="%name")}));
end Controller;
