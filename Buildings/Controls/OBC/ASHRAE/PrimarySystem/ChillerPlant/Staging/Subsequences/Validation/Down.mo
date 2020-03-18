within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Down "Validate change stage down condition sequence"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down
    staDow "Generates stage down signal"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down
    staDow1 "Generates stage down signal"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down
    noWSE(have_WSE=false) "Generates stage down signal for a plant with a WSE"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage2(
    final k=2)
    "Second stage"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant WSESta(
    final k=true)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(
    final k=1) "2nd stage"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant WSESta1(
    final k=true) "WSE status"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrMin(
    final k=0.6)
    "Minimum OPLR of the current stage"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(
    final k=65*6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplr(final k=0.5)
    "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSup(
    final k=273.15 + 14) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWat(
    final k=62*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrDown(
    final k=0.8)
    "Staging down part load ratio"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine oplrDown(
    final amplitude=0.1,
    final startTime=0,
    final freqHz=1/2100,
    final phase(displayUnit="deg") = -1.5707963267949,
    final offset=0.75) "Operating part load ratio of the next stage down"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TWsePre(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TowFanSpeMax(
    final k=0.9)
    "Maximum cooling tower speed signal"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrMin1(final k=0.6)
    "Minimum OPLR of the current stage"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet1(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet1(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplr1(
    final k=0.5)
    "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSup1(
    final k=273.15 + 14)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWat1(
    final k=62*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrDown1(final k=0.8)
    "Staging down part load ratio"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrDown1(
    final k=0.0001)
    "Operating part load ratio of stage 0"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TowFanSpeMax1(
    final k=0.9)
    "Maximum cooling tower speed signal"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TWsePre1(
    final amplitude=4,
    final freqHz=1/2100,
    final offset=273.15 + 12.5)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

protected
  CDL.Logical.Sources.Constant chaPro(final k=false)
    "Stage change is currently in process"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
equation

  connect(TCWSupSet.y, staDow.TChiWatSupSet) annotation (Line(points={{-138,-10},
          {-70,-10},{-70,48},{-62,48}}, color={0,0,127}));
  connect(TCWSup.y, staDow.TChiWatSup) annotation (Line(points={{-138,-50},{-68,
          -50},{-68,46},{-62,46}}, color={0,0,127}));
  connect(dpChiWatSet.y, staDow.dpChiWatPumSet) annotation (Line(points={{-98,10},
          {-76,10},{-76,53},{-62,53}}, color={0,0,127}));
  connect(dpChiWat.y, staDow.dpChiWatPum) annotation (Line(points={{-98,-30},{-72,
          -30},{-72,51},{-62,51}},     color={0,0,127}));
  connect(oplrDown.y, staDow.uOpeDow) annotation (Line(points={{-98,130},{-70,130},
          {-70,58},{-62,58}},      color={0,0,127}));
  connect(splrDown.y, staDow.uStaDow) annotation (Line(points={{-138,110},{-72,110},
          {-72,56},{-62,56}},      color={0,0,127}));
  connect(oplr.y, staDow.uOpe) annotation (Line(points={{-98,90},{-76,90},{-76,63},
          {-62,63}},     color={0,0,127}));
  connect(oplrMin.y, staDow.uOpeMin) annotation (Line(points={{-138,70},{-80,70},
          {-80,61},{-62,61}},     color={0,0,127}));
  connect(WSESta.y, staDow.uWseSta) annotation (Line(points={{-98,-70},{-66,-70},
          {-66,36},{-62,36}}, color={255,0,255}));
  connect(stage2.y, staDow.u) annotation (Line(points={{-138,-90},{-64,-90},{-64,
          40},{-62,40}},     color={255,127,0}));
  connect(TWsePre.y, staDow.TWsePre) annotation (Line(points={{-138,30},{-80,30},
          {-80,44},{-62,44}}, color={0,0,127}));
  connect(TowFanSpeMax.y, staDow.uTowFanSpeMax) annotation (Line(points={{-98,50},
          {-90,50},{-90,42},{-62,42}},     color={0,0,127}));
  connect(TCWSupSet1.y, staDow1.TChiWatSupSet) annotation (Line(points={{62,-10},
          {130,-10},{130,48},{138,48}}, color={0,0,127}));
  connect(TCWSup1.y, staDow1.TChiWatSup) annotation (Line(points={{62,-50},{132,
          -50},{132,46},{138,46}}, color={0,0,127}));
  connect(dpChiWatSet1.y, staDow1.dpChiWatPumSet) annotation (Line(points={{102,10},
          {124,10},{124,53},{138,53}},     color={0,0,127}));
  connect(dpChiWat1.y, staDow1.dpChiWatPum) annotation (Line(points={{102,-30},{
          128,-30},{128,51},{138,51}}, color={0,0,127}));
  connect(oplrDown1.y, staDow1.uOpeDow) annotation (Line(points={{102,130},{130,
          130},{130,58},{138,58}},     color={0,0,127}));
  connect(splrDown1.y, staDow1.uStaDow) annotation (Line(points={{62,110},{128,110},
          {128,56},{138,56}},      color={0,0,127}));
  connect(oplr1.y, staDow1.uOpe) annotation (Line(points={{102,90},{124,90},{124,
          63},{138,63}},     color={0,0,127}));
  connect(oplrMin1.y, staDow1.uOpeMin) annotation (Line(points={{62,70},{120,70},
          {120,61},{138,61}},     color={0,0,127}));
  connect(WSESta1.y, staDow1.uWseSta) annotation (Line(points={{102,-70},{134,-70},
          {134,36},{138,36}},      color={255,0,255}));
  connect(stage1.y, staDow1.u) annotation (Line(points={{62,-90},{136,-90},{136,
          40},{138,40}}, color={255,127,0}));
  connect(TowFanSpeMax1.y, staDow1.uTowFanSpeMax) annotation (Line(points={{102,50},
          {110,50},{110,42},{138,42}},   color={0,0,127}));
  connect(TWsePre1.y, staDow1.TWsePre) annotation (Line(points={{62,30},{126,30},
          {126,44},{138,44}}, color={0,0,127}));
  connect(oplrDown.y, noWSE.uOpeDow) annotation (Line(points={{-98,130},{-70,130},
          {-70,98},{-42,98}},        color={0,0,127}));
  connect(splrDown.y, noWSE.uStaDow) annotation (Line(points={{-138,110},{-72,110},
          {-72,96},{-42,96}},        color={0,0,127}));
  connect(oplr.y, noWSE.uOpe) annotation (Line(points={{-98,90},{-60,90},{-60,103},
          {-42,103}},    color={0,0,127}));
  connect(oplrMin.y, noWSE.uOpeMin) annotation (Line(points={{-138,70},{-80,70},
          {-80,88},{-58,88},{-58,101},{-42,101}},
                                                color={0,0,127}));
  connect(dpChiWatSet.y, noWSE.dpChiWatPumSet) annotation (Line(points={{-98,10},
          {-82,10},{-82,86},{-56,86},{-56,93},{-42,93}}, color={0,0,127}));
  connect(dpChiWat.y, noWSE.dpChiWatPum) annotation (Line(points={{-98,-30},{-86,
          -30},{-86,84},{-54,84},{-54,91},{-42,91}},     color={0,0,127}));
  connect(TCWSup.y, noWSE.TChiWatSup) annotation (Line(points={{-138,-50},{-88,-50},
          {-88,82},{-52,82},{-52,86},{-42,86}},      color={0,0,127}));
  connect(TCWSupSet.y, noWSE.TChiWatSupSet) annotation (Line(points={{-138,-10},
          {-84,-10},{-84,80},{-50,80},{-50,88},{-42,88}}, color={0,0,127}));
  connect(chaPro.y, noWSE.chaPro) annotation (Line(points={{-78,170},{-46,170},{
          -46,78},{-42,78}}, color={255,0,255}));
  connect(chaPro.y, staDow.chaPro) annotation (Line(points={{-78,170},{-66,170},
          {-66,104},{-62,104},{-62,38}}, color={255,0,255}));
  connect(chaPro.y, staDow1.chaPro) annotation (Line(points={{-78,170},{138,170},
          {138,38}}, color={255,0,255}));
  connect(stage2.y, noWSE.u) annotation (Line(points={{-138,-90},{-66,-90},{-66,
          80},{-42,80}}, color={255,127,0}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Down.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Down</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},{180,180}}),
        graphics={
        Text(
          extent={{-136,-120},{-76,-142}},
          lineColor={0,0,127},
          textString="Tests stage down from stages higher than stage 1.

The tests assumes a false output of the failsafe condition and 
checks functionality for the next available stage down SPLR and OPLR inputs."),
        Text(
          extent={{58,-120},{118,-142}},
          lineColor={0,0,127},
          textString="Tests stage down from stage 1.

Test assumes WSE is on and 
maximum tower fan speed signal
is less than 1. The test ensures stage down gets initiated as the 
cooling capacity of the first stage exceeds the demand
given the presence of WSE.")}));
end Down;
