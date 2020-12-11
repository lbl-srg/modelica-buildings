within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging;
block Controller "Sequence of staging cooling tower cells"

  parameter Boolean have_WSE=true
    "Flag to indicate if the plant has waterside economizer";
  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Integer totChiSta=6
    "Total number of plant stages, stage zero should be counted as one stage";
  parameter Real staVec[totChiSta]={0,0.5,1,1.5,2,2.5}
    "Plant stage vector with size of total number of stages, element value like x.5 means chiller stage x plus WSE";
  parameter Real towCelOnSet[totChiSta]={0,2,2,4,4,4}
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
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWse
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaConWatPum
    "Enabling status of lead condenser water pump"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
      final unit=fill("1", nConWatPum)) "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChaCel[nTowCel]
    "Vector of boolean flags to show if a cell should change its status: true = the cell should change status (be enabled or disabled)"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final max=fill(1, nTowCel))
    "Vector of tower cells isolation valve position"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cells proven on status: true=proven on"
    annotation (Placement(transformation(extent={{-142,-150},{-102,-110}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yNumCel
    "Total number of enabled cells"
    annotation (Placement(transformation(extent={{100,100},{140,140}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaCel
    "Lead tower cell status"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel))
    "Vector of tower cells isolation valve position"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
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
    final totChiSta=totChiSta,
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

equation
  connect(uChiSta, enaCel.uChiSta) annotation (Line(points={{-120,130},{-74,130},
          {-74,99},{-42,99}}, color={255,127,0}));
  connect(uChiStaSet, enaCel.uChiStaSet) annotation (Line(points={{-120,100},{-80,
          100},{-80,96},{-42,96}}, color={255,127,0}));
  connect(enaCel.uTowStaCha, uTowStaCha) annotation (Line(points={{-42,92},{-80,
          92},{-80,60},{-120,60}}, color={255,0,255}));
  connect(uWse, enaCel.uWse) annotation (Line(points={{-120,30},{-74,30},{-74,88},
          {-42,88}}, color={255,0,255}));
  connect(enaCel.uLeaConWatPum, uLeaConWatPum) annotation (Line(points={{-42,84},
          {-68,84},{-68,0},{-120,0}}, color={255,0,255}));
  connect(enaCel.uConWatPumSpe, uConWatPumSpe) annotation (Line(points={{-42,81},
          {-62,81},{-62,-40},{-120,-40}}, color={0,0,127}));
  connect(enaCel.yNumCel, yNumCel) annotation (Line(points={{-18,90},{40,90},{40,
          120},{120,120}}, color={255,127,0}));
  connect(enaCel.yLeaCel, yLeaCel) annotation (Line(points={{-18,84},{40,84},{40,
          60},{120,60}}, color={255,0,255}));
  connect(staPro.yIsoVal, yIsoVal)
    annotation (Line(points={{22,6},{72,6},{72,0},{120,0}}, color={0,0,127}));
  connect(staPro.yTowSta, yTowSta) annotation (Line(points={{22,0},{60,0},{60,-60},
          {120,-60}}, color={255,0,255}));
  connect(uTowSta, staPro.uTowSta) annotation (Line(points={{-122,-130},{-20,-130},
          {-20,-8},{-2,-8}}, color={255,0,255}));
  connect(uIsoVal, staPro.uIsoVal) annotation (Line(points={{-120,-100},{-26,-100},
          {-26,0},{-2,0}}, color={0,0,127}));
  connect(staPro.uChaCel, uChaCel) annotation (Line(points={{-2,8},{-40,8},{-40,
          -70},{-120,-70}}, color={255,0,255}));
  connect(staPro.yEndSta, yEndSta) annotation (Line(points={{22,-6},{50,-6},{50,
          -100},{120,-100}}, color={255,0,255}));

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
          textString="%name"),
        Text(
          extent={{-100,-44},{-56,-56}},
          lineColor={255,0,255},
          textString="uChaCel"),
        Text(
          extent={{-98,-64},{-62,-76}},
          lineColor={0,0,127},
          textString="uIsoVal"),
        Text(
          extent={{-98,76},{-44,64}},
          lineColor={255,127,0},
          textString="uChiStaSet"),
        Text(
          extent={{-98,96},{-60,84}},
          lineColor={255,127,0},
          textString="uChiSta"),
        Text(
          extent={{-98,56},{-38,44}},
          lineColor={255,0,255},
          textString="uTowStaCha"),
        Text(
          extent={{-100,36},{-70,24}},
          lineColor={255,0,255},
          textString="uWse"),
        Text(
          extent={{-98,6},{-20,-6}},
          lineColor={255,0,255},
          textString="uLeaConWatPum"),
        Text(
          extent={{-98,-24},{-20,-36}},
          lineColor={0,0,127},
          textString="uConWatPumSpe"),
        Text(
          extent={{-98,-82},{-58,-96}},
          lineColor={255,0,255},
          textString="uTowSta"),
        Text(
          extent={{56,-32},{98,-44}},
          lineColor={255,0,255},
          textString="yTowSta"),
        Text(
          extent={{62,6},{100,-6}},
          lineColor={0,0,127},
          textString="yIsoVal"),
        Text(
          extent={{60,48},{98,36}},
          lineColor={255,0,255},
          textString="yLeaCel"),
        Text(
          extent={{56,88},{98,76}},
          lineColor={255,127,0},
          textString="yNumCel"),
        Text(
          extent={{58,-82},{100,-94}},
          lineColor={255,0,255},
          textString="yEndSta")}),
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
</html>", revisions="<html>
<ul>
<li>
September 14, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
