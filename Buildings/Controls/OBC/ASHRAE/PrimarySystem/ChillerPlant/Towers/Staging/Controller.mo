within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging;
block Controller "Sequence of staging cooling tower cells"

  parameter Boolean have_WSE=true
    "Flag to indicate if the plant has waterside economizer";
  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Integer totSta=6
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable";
  parameter Real staVec[totSta]={0,0.5,1,1.5,2,2.5}
    "Plant stage vector with size of total number of stages, element value like x.5 means chiller stage x plus WSE";
  parameter Real towCelOnSet[totSta]={0,2,2,4,4,4}
    "Design number of tower fan cells that should be ON, according to current chiller stage and WSE status";
  parameter Real chaTowCelIsoTim=90
    "Nominal time needed for open isolation valve of the tower cells";
  parameter Real speChe=0.01
    "Lower threshold value to check if condenser water pump is proven on"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-140,110},{-100,150}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiStaSet
    "Current chiller stage setpoint"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowStaCha
    "Cooling tower stage change command from plant staging process"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWse if have_WSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaPla
    "True: plant is just enabled"
    annotation(Placement(transformation(extent={{-140,-10},{-100,30}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaConWatPum
    "Enabling status of lead condenser water pump"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
      final unit=fill("1", nConWatPum)) "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final max=fill(1, nTowCel))
    "Vector of tower cells isolation valve position"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cells proven on status: true=proven on"
    annotation (Placement(transformation(extent={{-140,-150},{-100,-110}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaCel
    "Lead tower cell status"
    annotation (Placement(transformation(extent={{100,64},{140,104}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel))
    "Vector of tower cells isolation valve position"
    annotation (Placement(transformation(extent={{100,-14},{140,26}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Vector of tower cells status setpoint"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSta
    "Rising edge to indicate the staging process is done"
    annotation (Placement(transformation(extent={{100,-120},{140,-80}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.CellsNumber
    enaCel(
    final have_WSE=have_WSE,
    final nConWatPum=nConWatPum,
    final nTowCel=nTowCel,
    final totSta=totSta,
    final staVec=staVec,
    final towCelOnSet=towCelOnSet,
    final speChe=speChe)  "Total number of enabled cells"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.StageProcesses
    staPro(
    final nTowCel=nTowCel,
    final chaTowCelIsoTim=chaTowCelIsoTim)
    "Tower staging process"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.ChangeCells ideChaCel(
    final nTowCel=nTowCel)
    "Identify which cell should change status"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

equation
  connect(uChiSta, enaCel.uChiSta) annotation (Line(points={{-120,130},{-74,130},
          {-74,99},{-42,99}}, color={255,127,0}));
  connect(uChiStaSet, enaCel.uChiStaSet) annotation (Line(points={{-120,100},{-80,
          100},{-80,96},{-42,96}}, color={255,127,0}));
  connect(enaCel.uTowStaCha, uTowStaCha) annotation (Line(points={{-42,92},{-80,
          92},{-80,70},{-120,70}}, color={255,0,255}));
  connect(uWse, enaCel.uWse) annotation (Line(points={{-120,40},{-74,40},{-74,89},
          {-42,89}}, color={255,0,255}));
  connect(enaCel.uLeaConWatPum, uLeaConWatPum) annotation (Line(points={{-42,84},
          {-62,84},{-62,-20},{-120,-20}}, color={255,0,255}));
  connect(enaCel.uConWatPumSpe, uConWatPumSpe) annotation (Line(points={{-42,81},
          {-56,81},{-56,-50},{-120,-50}}, color={0,0,127}));
  connect(enaCel.yLeaCel, yLeaCel) annotation (Line(points={{-18,84},{120,84}},
          color={255,0,255}));
  connect(staPro.yIsoVal, yIsoVal)
    annotation (Line(points={{22,6},{120,6}}, color={0,0,127}));
  connect(staPro.yTowSta, yTowSta) annotation (Line(points={{22,0},{60,0},{60,-60},
          {120,-60}}, color={255,0,255}));
  connect(uTowSta, staPro.uTowSta) annotation (Line(points={{-120,-130},{-20,-130},
          {-20,-8},{-2,-8}}, color={255,0,255}));
  connect(uIsoVal, staPro.uIsoVal) annotation (Line(points={{-120,-100},{-26,-100},
          {-26,0},{-2,0}}, color={0,0,127}));
  connect(staPro.yEndSta, yEndSta) annotation (Line(points={{22,-6},{50,-6},{50,
          -100},{120,-100}}, color={255,0,255}));
  connect(uEnaPla, enaCel.uEnaPla) annotation (Line(points={{-120,10},{-68,10},
          {-68,87},{-42,87}},color={255,0,255}));
  connect(enaCel.yNumCel, ideChaCel.uCelNum) annotation (Line(points={{-18,90},{
          0,90},{0,64},{18,64}}, color={255,127,0}));
  connect(uTowSta, ideChaCel.uTowSta) annotation (Line(points={{-120,-130},{-50,
          -130},{-50,56},{18,56}}, color={255,0,255}));
  connect(ideChaCel.yChaCel, staPro.uChaCel) annotation (Line(points={{42,56},{
          60,56},{60,20},{-20,20},{-20,8},{-2,8}}, color={255,0,255}));
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
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,-64},{-62,-76}},
          textColor={0,0,127},
          textString="uIsoVal"),
        Text(
          extent={{-98,76},{-44,64}},
          textColor={255,127,0},
          textString="uChiStaSet"),
        Text(
          extent={{-98,96},{-60,84}},
          textColor={255,127,0},
          textString="uChiSta"),
        Text(
          extent={{-98,56},{-38,44}},
          textColor={255,0,255},
          textString="uTowStaCha"),
        Text(
          extent={{-100,36},{-70,24}},
          textColor={255,0,255},
          textString="uWse",
          visible=have_WSE),
        Text(
          extent={{-98,-4},{-20,-16}},
          textColor={255,0,255},
          textString="uLeaConWatPum"),
        Text(
          extent={{-98,-24},{-20,-36}},
          textColor={0,0,127},
          textString="uConWatPumSpe"),
        Text(
          extent={{-98,-82},{-58,-96}},
          textColor={255,0,255},
          textString="uTowSta"),
        Text(
          extent={{56,-32},{98,-44}},
          textColor={255,0,255},
          textString="yTowSta"),
        Text(
          extent={{62,6},{100,-6}},
          textColor={0,0,127},
          textString="yIsoVal"),
        Text(
          extent={{60,48},{98,36}},
          textColor={255,0,255},
          textString="yLeaCel"),
        Text(
          extent={{58,-82},{100,-94}},
          textColor={255,0,255},
          textString="yEndSta"),
        Text(
          extent={{-96,16},{-58,2}},
          textColor={255,0,255},
          textString="uEnaPla")}),
Documentation(info="<html>
<p>
Block controls cooling tower fan staging. This is implemented accoding to 
ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II – 
Central Plants and Hydronic Systems (Draft on March 23, 2020), section 5.2.12.1, 
which specifies tower fan staging process. It includes two subsequences:
</p>
<ul>
<li>
Sequence of identifying total number of enabled cells. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.CellsNumber\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.CellsNumber</a>
for a description.
</li>
<li>
Sequence of identifying cells that should change status. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.ChangeCells\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.ChangeCells</a>
for a description.
</li>
<li>
Sequence of process for enabling cells. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.StageProcesses\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.StageProcesses</a>
for a description.
</li>
</ul>
<p>
Note that in this implementation, input <code>uTowStaCha</code>
is from chiller staging process sequence. The input is also used for the 
condenser water pump staging. Thus, the tower stage changes are initiated concurrentlyl
with condenser water pump stage.
</p>
<p>
The sequence also assumes the cells are enabled in order as it is labelled, meaning
that it enabled the cells as cell 1, 2, 3, etc.
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
