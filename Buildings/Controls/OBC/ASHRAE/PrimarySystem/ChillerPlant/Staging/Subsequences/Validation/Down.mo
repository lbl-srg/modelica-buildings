within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Down "Validate change stage down condition sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down
    staDow "Generates stage down signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant                        stage2(k=2) "2nd stage"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant WSESta(k=true) "Waterside economizer status"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down
    staDow1 "Generates stage down signal"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant                        stage1(k=1) "2nd stage"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant WSESta1(k=true) "Waterside economizer status"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrMin(final k=0.6)
    "Minimum OPLR of the current stage"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(final k=273.15
         + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(final k=65*
        6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplr(final k=0.5)
    "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                    TCWSup(k=273.15 + 14)
                        "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                    dpChiWat(k=62*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrDown(final k=0.8)
    "Staging down part load ratio"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine oplrDown(
    final amplitude=0.1,
    final startTime=0,
    final freqHz=1/2100,
    final phase(displayUnit="deg") = -1.5707963267949,
    final offset=0.75)   "Operating part load ratio of the next stage down"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TWsePre(final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TowFanSpeMax(final k=0.9)
    "Maximum cooling tower speed signal"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                        oplrMin1(final k=0.6)
    "Minimum OPLR of the current stage"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                        TCWSupSet1(final k=273.15
         + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                        dpChiWatSet1(final k=65
        *6895)
              "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                        oplr1(final k=0.5)
    "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                    TCWSup1(k=273.15 + 14)
                        "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                    dpChiWat1(k=62*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrDown1(final k=0.8)
    "Staging down part load ratio"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant
                              oplrDown1(k=0.0001)
    "Operating part load ratio of stage 0"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TowFanSpeMax1(final k=0.9)
    "Maximum cooling tower speed signal"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TWsePre1(
    final amplitude=1,
    final freqHz=1/2100,
    final offset=273.15 + 12.5)
                       "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
equation

  connect(TCWSupSet.y, staDow.TChiWatSupSet) annotation (Line(points={{-119,-10},
          {-50,-10},{-50,48},{-41,48}}, color={0,0,127}));
  connect(TCWSup.y, staDow.TChiWatSup) annotation (Line(points={{-119,-50},{-48,
          -50},{-48,46},{-41,46}}, color={0,0,127}));
  connect(dpChiWatSet.y, staDow.dpChiWatPumSet) annotation (Line(points={{-79,
          10},{-56,10},{-56,54},{-41,54}}, color={0,0,127}));
  connect(dpChiWat.y, staDow.dpChiWatPum) annotation (Line(points={{-79,-30},{-52,
          -30},{-52,52},{-41,52}}, color={0,0,127}));
  connect(oplrDown.y, staDow.uOplrDow) annotation (Line(points={{-79,130},{-50,
          130},{-50,62},{-41,62}}, color={0,0,127}));
  connect(splrDown.y, staDow.uSplrDow) annotation (Line(points={{-119,110},{-52,
          110},{-52,60},{-41,60}}, color={0,0,127}));
  connect(oplr.y, staDow.uOplr) annotation (Line(points={{-79,90},{-56,90},{-56,
          58},{-41,58}}, color={0,0,127}));
  connect(oplrMin.y, staDow.uOplrMin) annotation (Line(points={{-119,70},{-60,
          70},{-60,56},{-41,56}}, color={0,0,127}));
  connect(WSESta.y, staDow.uWseSta) annotation (Line(points={{-79,-70},{-46,-70},
          {-46,42},{-41,42}}, color={255,0,255}));
  connect(stage2.y, staDow.uChiSta) annotation (Line(points={{-119,-90},{-44,-90},
          {-44,40},{-41,40}}, color={255,127,0}));
  connect(TWsePre.y, staDow.TWsePre) annotation (Line(points={{-119,30},{-60,30},
          {-60,50},{-41,50}}, color={0,0,127}));
  connect(TowFanSpeMax.y, staDow.uTowFanSpeMax) annotation (Line(points={{-79,
          50},{-70,50},{-70,44},{-41,44}}, color={0,0,127}));
  connect(TCWSupSet1.y, staDow1.TChiWatSupSet) annotation (Line(points={{41,-10},
          {110,-10},{110,48},{119,48}}, color={0,0,127}));
  connect(TCWSup1.y, staDow1.TChiWatSup) annotation (Line(points={{41,-50},{112,
          -50},{112,46},{119,46}}, color={0,0,127}));
  connect(dpChiWatSet1.y, staDow1.dpChiWatPumSet) annotation (Line(points={{81,
          10},{104,10},{104,54},{119,54}}, color={0,0,127}));
  connect(dpChiWat1.y, staDow1.dpChiWatPum) annotation (Line(points={{81,-30},{
          108,-30},{108,52},{119,52}}, color={0,0,127}));
  connect(oplrDown1.y, staDow1.uOplrDow) annotation (Line(points={{81,130},{110,
          130},{110,62},{119,62}}, color={0,0,127}));
  connect(splrDown1.y, staDow1.uSplrDow) annotation (Line(points={{41,110},{108,
          110},{108,60},{119,60}}, color={0,0,127}));
  connect(oplr1.y, staDow1.uOplr) annotation (Line(points={{81,90},{104,90},{
          104,58},{119,58}}, color={0,0,127}));
  connect(oplrMin1.y, staDow1.uOplrMin) annotation (Line(points={{41,70},{100,
          70},{100,56},{119,56}}, color={0,0,127}));
  connect(WSESta1.y, staDow1.uWseSta) annotation (Line(points={{81,-70},{114,-70},
          {114,42},{119,42}}, color={255,0,255}));
  connect(stage1.y, staDow1.uChiSta) annotation (Line(points={{41,-90},{116,-90},
          {116,40},{119,40}}, color={255,127,0}));
  connect(TowFanSpeMax1.y, staDow1.uTowFanSpeMax) annotation (Line(points={{81,
          50},{90,50},{90,44},{119,44}}, color={0,0,127}));
  connect(TWsePre1.y, staDow1.TWsePre) annotation (Line(points={{41,30},{74,30},
          {74,32},{106,32},{106,50},{119,50}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Down.mos"
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
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}}),
        graphics={
        Text(
          extent={{-118,-120},{-58,-142}},
          lineColor={0,0,127},
          textString="Tests stage down from stages higher than 
stage 1.

The tests assumes a failed failsafe condition and 
checks functionality for SPLR down and OPLR down inputs."),
        Text(
          extent={{40,-120},{100,-142}},
          lineColor={0,0,127},
          textString="Tests stage down from stage 1.

Test assumes WSE is on and 
maximum tower fan speed signal
is less than 1 and checks functionality
for predicted downstream WSE temperature
in relation to chilled water temperature setpoint.")}));
end Down;
