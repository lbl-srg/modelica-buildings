within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Down "Validate change stage down condition sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down
    staDow "Generates stage down signal"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant                        stage2(k=2) "2nd stage"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant WSESta(k=true)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down
    staDow1 "Generates stage down signal"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant                        stage1(k=1) "2nd stage"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant WSESta1(k=true) "Waterside economizer status"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down
    noWSE(hasWSE=false) "Generates stage down signal"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrMin(final k=0.6)
    "Minimum OPLR of the current stage"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(final k=273.15
         + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(final k=65*
        6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplr(final k=0.5)
    "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                    TCWSup(k=273.15 + 14)
                        "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                    dpChiWat(k=62*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrDown(final k=0.8)
    "Staging down part load ratio"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine oplrDown(
    final amplitude=0.1,
    final startTime=0,
    final freqHz=1/2100,
    final phase(displayUnit="deg") = -1.5707963267949,
    final offset=0.75)   "Operating part load ratio of the next stage down"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TWsePre(final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TowFanSpeMax(final k=0.9)
    "Maximum cooling tower speed signal"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                        oplrMin1(final k=0.6)
    "Minimum OPLR of the current stage"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                        TCWSupSet1(final k=273.15
         + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                        dpChiWatSet1(final k=65
        *6895)
              "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                        oplr1(final k=0.5)
    "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                    TCWSup1(k=273.15 + 14)
                        "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                    dpChiWat1(k=62*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrDown1(final k=0.8)
    "Staging down part load ratio"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant
                              oplrDown1(k=0.0001)
    "Operating part load ratio of stage 0"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TowFanSpeMax1(final k=0.9)
    "Maximum cooling tower speed signal"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TWsePre1(
    final amplitude=1,
    final freqHz=1/2100,
    final offset=273.15 + 12.5)
                       "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
equation

  connect(TCWSupSet.y, staDow.TChiWatSupSet) annotation (Line(points={{-139,-10},
          {-70,-10},{-70,50},{-61,50}}, color={0,0,127}));
  connect(TCWSup.y, staDow.TChiWatSup) annotation (Line(points={{-139,-50},{-68,
          -50},{-68,48},{-61,48}}, color={0,0,127}));
  connect(dpChiWatSet.y, staDow.dpChiWatPumSet) annotation (Line(points={{-99,10},
          {-76,10},{-76,54},{-61,54}},     color={0,0,127}));
  connect(dpChiWat.y, staDow.dpChiWatPum) annotation (Line(points={{-99,-30},{-72,
          -30},{-72,52},{-61,52}}, color={0,0,127}));
  connect(oplrDown.y, staDow.uOplrDow) annotation (Line(points={{-99,130},{-70,130},
          {-70,62},{-61,62}},      color={0,0,127}));
  connect(splrDown.y, staDow.uSplrDow) annotation (Line(points={{-139,110},{-72,
          110},{-72,60},{-61,60}}, color={0,0,127}));
  connect(oplr.y, staDow.uOplr) annotation (Line(points={{-99,90},{-76,90},{-76,
          58},{-61,58}}, color={0,0,127}));
  connect(oplrMin.y, staDow.uOplrMin) annotation (Line(points={{-139,70},{-80,70},
          {-80,56},{-61,56}},     color={0,0,127}));
  connect(WSESta.y, staDow.uWseSta) annotation (Line(points={{-99,-70},{-66,-70},
          {-66,42},{-61,42}}, color={255,0,255}));
  connect(stage2.y, staDow.uChiSta) annotation (Line(points={{-139,-90},{-64,-90},
          {-64,40},{-61,40}}, color={255,127,0}));
  connect(TWsePre.y, staDow.TWsePre) annotation (Line(points={{-139,30},{-80,30},
          {-80,46},{-61,46}}, color={0,0,127}));
  connect(TowFanSpeMax.y, staDow.uTowFanSpeMax) annotation (Line(points={{-99,50},
          {-90,50},{-90,44},{-61,44}},     color={0,0,127}));
  connect(TCWSupSet1.y, staDow1.TChiWatSupSet) annotation (Line(points={{61,-10},
          {130,-10},{130,50},{139,50}}, color={0,0,127}));
  connect(TCWSup1.y, staDow1.TChiWatSup) annotation (Line(points={{61,-50},{132,
          -50},{132,48},{139,48}}, color={0,0,127}));
  connect(dpChiWatSet1.y, staDow1.dpChiWatPumSet) annotation (Line(points={{101,10},
          {124,10},{124,54},{139,54}},     color={0,0,127}));
  connect(dpChiWat1.y, staDow1.dpChiWatPum) annotation (Line(points={{101,-30},{
          128,-30},{128,52},{139,52}}, color={0,0,127}));
  connect(oplrDown1.y, staDow1.uOplrDow) annotation (Line(points={{101,130},{130,
          130},{130,62},{139,62}}, color={0,0,127}));
  connect(splrDown1.y, staDow1.uSplrDow) annotation (Line(points={{61,110},{128,
          110},{128,60},{139,60}}, color={0,0,127}));
  connect(oplr1.y, staDow1.uOplr) annotation (Line(points={{101,90},{124,90},{124,
          58},{139,58}},     color={0,0,127}));
  connect(oplrMin1.y, staDow1.uOplrMin) annotation (Line(points={{61,70},{120,70},
          {120,56},{139,56}},     color={0,0,127}));
  connect(WSESta1.y, staDow1.uWseSta) annotation (Line(points={{101,-70},{134,-70},
          {134,42},{139,42}}, color={255,0,255}));
  connect(stage1.y, staDow1.uChiSta) annotation (Line(points={{61,-90},{136,-90},
          {136,40},{139,40}}, color={255,127,0}));
  connect(TowFanSpeMax1.y, staDow1.uTowFanSpeMax) annotation (Line(points={{101,50},
          {110,50},{110,44},{139,44}},   color={0,0,127}));
  connect(TWsePre1.y, staDow1.TWsePre) annotation (Line(points={{61,30},{126,30},
          {126,46},{139,46}},                  color={0,0,127}));
  connect(oplrDown.y, noWSE.uOplrDow) annotation (Line(points={{-99,130},{-70,
          130},{-70,102},{-41,102}}, color={0,0,127}));
  connect(splrDown.y, noWSE.uSplrDow) annotation (Line(points={{-139,110},{-72,
          110},{-72,100},{-41,100}}, color={0,0,127}));
  connect(oplr.y, noWSE.uOplr) annotation (Line(points={{-99,90},{-60,90},{-60,
          98},{-41,98}}, color={0,0,127}));
  connect(oplrMin.y, noWSE.uOplrMin) annotation (Line(points={{-139,70},{-80,70},
          {-80,88},{-58,88},{-58,96},{-41,96}}, color={0,0,127}));
  connect(dpChiWatSet.y, noWSE.dpChiWatPumSet) annotation (Line(points={{-99,10},
          {-82,10},{-82,86},{-56,86},{-56,94},{-41,94}}, color={0,0,127}));
  connect(dpChiWat.y, noWSE.dpChiWatPum) annotation (Line(points={{-99,-30},{-86,
          -30},{-86,84},{-54,84},{-54,92},{-41,92}}, color={0,0,127}));
  connect(TCWSup.y, noWSE.TChiWatSup) annotation (Line(points={{-139,-50},{-88,
          -50},{-88,82},{-52,82},{-52,88},{-41,88}}, color={0,0,127}));
  connect(TCWSupSet.y, noWSE.TChiWatSupSet) annotation (Line(points={{-139,-10},
          {-84,-10},{-84,80},{-50,80},{-50,90},{-41,90}}, color={0,0,127}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},{180,160}}),
        graphics={
        Text(
          extent={{-138,-120},{-78,-142}},
          lineColor={0,0,127},
          textString="Tests stage down from stages higher than 
stage 1.

The tests assumes a failed failsafe condition and 
checks functionality for SPLR down and OPLR down inputs."),
        Text(
          extent={{60,-120},{120,-142}},
          lineColor={0,0,127},
          textString="Tests stage down from stage 1.

Test assumes WSE is on and 
maximum tower fan speed signal
is less than 1 and checks functionality
for predicted downstream WSE temperature
in relation to chilled water temperature setpoint.")}));
end Down;
