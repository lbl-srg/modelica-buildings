within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Up "Validate change stage up condition sequence"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up
    staUp "Generates stage up signal"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up
    staUp1(final have_WSE=true)
    "Generates stage up signal"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant avaCur(final k=true)
    "Current stage availability"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant avaCur1(final k=true)
    "Current stage availability"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant higSta(final k=false)
    "Not operating at the highest available stage"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant higSta1(final k=false)
    "Not operating at the highest available stage"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(
    final k=0) "0th stage"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(
    final k=1) "1st stage"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant OpeUpMin(
    final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(
    final k=65*6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant OpeUp(
    final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup(
    final amplitude=1.5,
    final freqHz=1/1800,
    final offset=273.15 + 16) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine Ope(
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100,
    final amplitude=0.05) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant StaUp(
    final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant OpeUpMin1(
    final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet1(
    final k=273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet1(
    final k=65*6895)
   "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant OpeUp1(
    final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup1(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/600) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat1(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine Ope1(
    final amplitude=0.1,
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant StaUp1(
    final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chaPro(final k=false)
    "Stage change is currently in process"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
equation

  connect(StaUp.y, staUp.uStaUp) annotation (Line(points={{-98,10},{-88,10},{-88,
          18},{-42,18}}, color={0,0,127}));
  connect(Ope.y, staUp.uOpe) annotation (Line(points={{-98,50},{-60,50},{-60,20},
          {-42,20}}, color={0,0,127}));
  connect(OpeUp.y, staUp.uOpeUp) annotation (Line(points={{-138,30},{-80,30},{-80,
          15},{-42,15}}, color={0,0,127}));
  connect(OpeUpMin.y, staUp.uOpeUpMin) annotation (Line(points={{-138,-10},{-80,
          -10},{-80,13},{-42,13}}, color={0,0,127}));
  connect(TCWSupSet.y, staUp.TChiWatSupSet) annotation (Line(points={{-138,-50},
          {-70,-50},{-70,10},{-42,10}},  color={0,0,127}));
  connect(TCWSup.y, staUp.TChiWatSup) annotation (Line(points={{-138,-90},{-60,-90},
          {-60,8},{-42,8}},       color={0,0,127}));
  connect(dpChiWatSet.y, staUp.dpChiWatPumSet) annotation (Line(points={{-98,-30},
          {-56,-30},{-56,5},{-42,5}},color={0,0,127}));
  connect(dpChiWat.y, staUp.dpChiWatPum) annotation (Line(points={{-98,-70},{-52,
          -70},{-52,3},{-42,3}},     color={0,0,127}));
  connect(stage0.y, staUp.u) annotation (Line(points={{-138,70},{-50,70},{-50,0},
          {-42,0}}, color={255,127,0}));
  connect(StaUp1.y, staUp1.uStaUp) annotation (Line(points={{82,10},{92,10},{92,
          18},{138,18}}, color={0,0,127}));
  connect(Ope1.y, staUp1.uOpe) annotation (Line(points={{82,50},{120,50},{120,20},
          {138,20}}, color={0,0,127}));
  connect(OpeUp1.y, staUp1.uOpeUp) annotation (Line(points={{42,30},{100,30},{100,
          15},{138,15}}, color={0,0,127}));
  connect(OpeUpMin1.y, staUp1.uOpeUpMin) annotation (Line(points={{42,-10},{100,
          -10},{100,13},{138,13}}, color={0,0,127}));
  connect(TCWSupSet1.y, staUp1.TChiWatSupSet) annotation (Line(points={{42,-50},
          {110,-50},{110,10},{138,10}}, color={0,0,127}));
  connect(TCWSup1.y, staUp1.TChiWatSup) annotation (Line(points={{42,-90},{120,-90},
          {120,8},{138,8}},      color={0,0,127}));
  connect(dpChiWatSet1.y, staUp1.dpChiWatPumSet) annotation (Line(points={{82,-30},
          {124,-30},{124,5},{138,5}},   color={0,0,127}));
  connect(dpChiWat1.y, staUp1.dpChiWatPum) annotation (Line(points={{82,-70},{128,
          -70},{128,3},{138,3}},     color={0,0,127}));
  connect(stage1.y, staUp1.u) annotation (Line(points={{42,70},{130,70},{130,0},
          {138,0}}, color={255,127,0}));
  connect(higSta.y, staUp.uHigSta) annotation (Line(points={{-138,110},{-48,110},
          {-48,-2},{-42,-2}}, color={255,0,255}));
  connect(higSta1.y, staUp1.uHigSta) annotation (Line(points={{42,110},{132,110},
          {132,-2},{138,-2}}, color={255,0,255}));
  connect(chaPro.y, staUp.chaPro) annotation (Line(points={{-78,130},{-46,130},{
          -46,-4},{-42,-4}},    color={255,0,255}));
  connect(chaPro.y, staUp1.chaPro) annotation (Line(points={{-78,130},{136,130},
          {136,-4},{138,-4}},   color={255,0,255}));
  connect(avaCur.y, staUp.uAvaCur) annotation (Line(points={{-58,-110},{-46,-110},
          {-46,-6},{-42,-6}}, color={255,0,255}));
  connect(avaCur1.y, staUp1.uAvaCur) annotation (Line(points={{122,-110},{132,-110},
          {132,-6},{138,-6}}, color={255,0,255}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Up.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Up</a>.
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},{180,160}}),
        graphics={
        Text(
          extent={{-138,-130},{-76,-154}},
          lineColor={0,0,127},
          textString="Tests stage 0 to stage 1 enable
based on chilled water supply
temperature.

Other inputs are kept the same 
as in the example on the right."),
        Text(
          extent={{46,-126},{106,-148}},
          lineColor={0,0,127},
          textString="Tests stage up enable for any stage above 
and including stage 1. In this test the plant has a WSE. 
The same applies for any stage in case the plant does not have a WSE.")}));
end Up;
