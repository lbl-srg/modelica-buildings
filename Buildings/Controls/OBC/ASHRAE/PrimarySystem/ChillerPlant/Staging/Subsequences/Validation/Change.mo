within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Change "Validates chiller stage signal"

  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Modelica.SIunits.Time minStaRuntime = 900
    "Minimum stage runtime";

  parameter Modelica.SIunits.VolumeFlowRate aveVChiWat_flow = 0.05
    "Average measured chilled water flow rate";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change
    cha(
    chiDesCap={500000,1000000},
    chiMinCap={100000,200000},
    chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal},
    anyVsdCen=false,
    hasWSE=false) "Stage change"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TChiWatRet(
    final amplitude=7,
    final offset=273.15 + 15,
    final freqHz=1/21600)
    "Chiller water return temeprature"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatFlow(
    final offset=0,
    final freqHz=1/21600,
    final amplitude=0.037)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiAva[2](final k={true,true})
    "Chiller availability vector"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant WSESta(
    final k=true) "Waterside economizer status"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max "Maximum"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant higSta(final k=false)
    "Operating at a highes available stage"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(samplePeriod=1)
    annotation (Placement(transformation(extent={{140,20},{160,40}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{180,20},{200,40}})));

  CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=0, falseHoldDuration=900)
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWat(
    final k=65*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TWsePre(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TowFanSpeMax(
    final k=1)
    "Maximum cooling tower speed signal"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSup(
    final k=273.15 + 14)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zero(
    final k=0) "Constant"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));

equation
  connect(dpChiWatSet.y, cha.dpChiWatPumSet) annotation (Line(points={{-98,-50},
          {-92,-50},{-92,31},{58,31}}, color={0,0,127}));
  connect(dpChiWat.y, cha.dpChiWatPum) annotation (Line(points={{-98,-100},{-90,
          -100},{-90,33},{58,33}}, color={0,0,127}));
  connect(TowFanSpeMax.y, cha.uTowFanSpeMax) annotation (Line(points={{-58,-100},
          {-50,-100},{-50,28},{58,28}}, color={0,0,127}));
  connect(TWsePre.y, cha.TWsePre) annotation (Line(points={{-58,-50},{-52,-50},{
          -52,23},{58,23}}, color={0,0,127}));
  connect(TCWSupSet.y, cha.TChiWatSupSet) annotation (Line(points={{-98,50},{-32,
          50},{-32,45},{58,45}}, color={0,0,127}));
  connect(chiAva.y, cha.uChiAva) annotation (Line(points={{-98,90},{-28,90},{-28,
          11},{58,11}}, color={255,0,255}));
  connect(cha.uWseSta, WSESta.y) annotation (Line(points={{58,17},{-30,17},{-30,
          70},{-138,70}}, color={255,0,255}));
  connect(TCWSup.y, cha.TChiWatSup) annotation (Line(points={{-98,-10},{-94,-10},
          {-94,43},{58,43}}, color={0,0,127}));
  connect(zero.y, max.u2) annotation (Line(points={{-178,-50},{-170,-50},{-170,-36},
          {-162,-36}}, color={0,0,127}));
  connect(chiWatFlow.y, max.u1) annotation (Line(points={{-178,-10},{-170,-10},{
          -170,-24},{-162,-24}}, color={0,0,127}));
  connect(cha.VChiWat_flow, max.y) annotation (Line(points={{58,21},{-130,21},{-130,
          -30},{-138,-30}}, color={0,0,127}));
  connect(TChiWatRet.y, cha.TChiWatRet) annotation (Line(points={{-178,30},{-130,
          30},{-130,25},{58,25}}, color={0,0,127}));
  connect(higSta.y, cha.uHigSta) annotation (Line(points={{2,-10},{20,-10},{20,15},
          {58,15}}, color={255,0,255}));
  connect(cha.y, intToRea.u)
    annotation (Line(points={{82,30},{98,30}}, color={255,127,0}));
  connect(intToRea.y, zerOrdHol.u)
    annotation (Line(points={{122,30},{138,30}}, color={0,0,127}));
  connect(zerOrdHol.y, reaToInt.u)
    annotation (Line(points={{162,30},{178,30}}, color={0,0,127}));
  connect(reaToInt.y, cha.u) annotation (Line(points={{202,30},{210,30},{210,-20},
          {50,-20},{50,19},{58,19}}, color={255,127,0}));
  connect(cha.yCha, truFalHol.u) annotation (Line(points={{82,37},{90,37},{90,-50},
          {98,-50}}, color={255,0,255}));
  connect(truFalHol.y, pre.u)
    annotation (Line(points={{122,-50},{138,-50}}, color={255,0,255}));
  connect(pre.y, cha.chaPro) annotation (Line(points={{162,-50},{170,-50},{170,-70},
          {40,-70},{40,13},{58,13}}, color={255,0,255}));
annotation (
 experiment(StopTime=20000.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Change.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,160}})));
end Change;
