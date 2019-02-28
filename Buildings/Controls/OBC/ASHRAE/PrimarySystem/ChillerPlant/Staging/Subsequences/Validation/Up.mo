within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Up "Validate change stage up condition sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up
    staUp "Generates stage up signal"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up
    staUp1 "Generates stage up signal"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up
    noWSE(hasWSE=false) "Generates stage up signal"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

protected
  CDL.Integers.Sources.Constant stage0(
    final k=0) "0th stage"
    annotation (Placement(transformation(extent={{-160,200},{-140,220}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(
    final k=1) "1st stage"
    annotation (Placement(transformation(extent={{20,200},{40,220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUpMin(final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(
    final k=65*6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUp(
    final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-160,160},{-140,180}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup(
    final amplitude=1.5,
    final freqHz=1/1800,
    final offset=273.15 + 16) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine oplr(
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100,
    final amplitude=0.05) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrUp(
    final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUpMin1(
    final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet1(
    final k=273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet1(
    final k=65*6895)
   "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUp1(
    final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{20,160},{40,180}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup1(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/600) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat1(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine oplr1(
    final amplitude=0.1,
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrUp1(final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));
  CDL.Continuous.Sources.Constant                        oplrUpMin2(final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  CDL.Continuous.Sources.Constant                        TCWSupSet2(final k=273.15
         + 14)           "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));
  CDL.Continuous.Sources.Constant                        dpChiWatSet2(final k=65
        *6895)
   "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  CDL.Continuous.Sources.Constant                        oplrUp2(final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  CDL.Continuous.Sources.Sine                        TCWSup2(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/600) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-160,-190},{-140,-170}})));
  CDL.Continuous.Sources.Sine                        dpChiWat2(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  CDL.Continuous.Sources.Sine                        oplr2(
    final amplitude=0.1,
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  CDL.Continuous.Sources.Constant                        splrUp2(final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
equation

  connect(splrUp.y, staUp.uSplrUp) annotation (Line(points={{-99,150},{-88,150},
          {-88,158},{-41,158}},
                    color={0,0,127}));
  connect(oplr.y, staUp.uOplr) annotation (Line(points={{-99,190},{-60,190},{-60,
          160},{-41,160}},
                   color={0,0,127}));
  connect(oplrUp.y, staUp.uOplrUp) annotation (Line(points={{-139,170},{-80,170},
          {-80,155},{-41,155}},
                        color={0,0,127}));
  connect(oplrUpMin.y, staUp.uOplrUpMin) annotation (Line(points={{-139,130},{-80,
          130},{-80,153},{-41,153}},
                            color={0,0,127}));
  connect(TCWSupSet.y, staUp.TChiWatSupSet) annotation (Line(points={{-139,90},{
          -70,90},{-70,150},{-41,150}},
                                    color={0,0,127}));
  connect(TCWSup.y, staUp.TChiWatSup) annotation (Line(points={{-139,50},{-60,50},
          {-60,148},{-41,148}},
                            color={0,0,127}));
  connect(dpChiWatSet.y, staUp.dpChiWatPumSet) annotation (Line(points={{-99,110},
          {-56,110},{-56,145},{-41,145}},
                                     color={0,0,127}));
  connect(dpChiWat.y, staUp.dpChiWatPum) annotation (Line(points={{-99,70},{-52,
          70},{-52,143},{-41,143}},
                            color={0,0,127}));
  connect(stage0.y, staUp.uChiSta) annotation (Line(points={{-139,210},{-50,210},
          {-50,140},{-41,140}},
                             color={255,127,0}));
  connect(splrUp1.y, staUp1.uSplrUp) annotation (Line(points={{81,150},{92,150},
          {92,158},{139,158}},
                         color={0,0,127}));
  connect(oplr1.y, staUp1.uOplr) annotation (Line(points={{81,190},{120,190},{120,
          160},{139,160}},
                         color={0,0,127}));
  connect(oplrUp1.y, staUp1.uOplrUp) annotation (Line(points={{41,170},{100,170},
          {100,155},{139,155}},
                             color={0,0,127}));
  connect(oplrUpMin1.y, staUp1.uOplrUpMin) annotation (Line(points={{41,130},{100,
          130},{100,153},{139,153}},
                                  color={0,0,127}));
  connect(TCWSupSet1.y, staUp1.TChiWatSupSet) annotation (Line(points={{41,90},{
          110,90},{110,150},{139,150}}, color={0,0,127}));
  connect(TCWSup1.y, staUp1.TChiWatSup) annotation (Line(points={{41,50},{120,50},
          {120,148},{139,148}},
                              color={0,0,127}));
  connect(dpChiWatSet1.y, staUp1.dpChiWatPumSet) annotation (Line(points={{81,110},
          {124,110},{124,145},{139,145}},
                                        color={0,0,127}));
  connect(dpChiWat1.y, staUp1.dpChiWatPum) annotation (Line(points={{81,70},{128,
          70},{128,143},{139,143}},color={0,0,127}));
  connect(stage1.y, staUp1.uChiSta) annotation (Line(points={{41,210},{130,210},
          {130,140},{139,140}},
                         color={255,127,0}));
  connect(splrUp2.y, noWSE.uSplrUp) annotation (Line(points={{-99,-80},{-88,-80},
          {-88,-72},{-41,-72}}, color={0,0,127}));
  connect(oplr2.y, noWSE.uOplr) annotation (Line(points={{-99,-40},{-60,-40},{-60,
          -70},{-41,-70}}, color={0,0,127}));
  connect(oplrUp2.y, noWSE.uOplrUp) annotation (Line(points={{-139,-60},{-80,-60},
          {-80,-75},{-41,-75}}, color={0,0,127}));
  connect(oplrUpMin2.y, noWSE.uOplrUpMin) annotation (Line(points={{-139,-100},{
          -80,-100},{-80,-77},{-41,-77}}, color={0,0,127}));
  connect(TCWSupSet2.y, noWSE.TChiWatSupSet) annotation (Line(points={{-139,-140},
          {-70,-140},{-70,-80},{-41,-80}}, color={0,0,127}));
  connect(TCWSup2.y, noWSE.TChiWatSup) annotation (Line(points={{-139,-180},{-60,
          -180},{-60,-82},{-41,-82}}, color={0,0,127}));
  connect(dpChiWatSet2.y, noWSE.dpChiWatPumSet) annotation (Line(points={{-99,-120},
          {-56,-120},{-56,-85},{-41,-85}}, color={0,0,127}));
  connect(dpChiWat2.y, noWSE.dpChiWatPum) annotation (Line(points={{-99,-160},{-52,
          -160},{-52,-87},{-41,-87}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Up.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Up</a>.

fixme: To implement, pg 31: When enabling the plant, skip Stage 0 + WSE if PHXLWT calculated with PLRHX set equal to 1 is not 1°F < CHWST setpoint.
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-240},{180,240}}),
        graphics={
        Text(
          extent={{-140,28},{-78,4}},
          lineColor={0,0,127},
          textString="Tests stage 0 to stage 1 enable
based on chilled water supply
temperature.

Other inputs are kept the same 
as in the example on the right."),
        Text(
          extent={{44,32},{104,10}},
          lineColor={0,0,127},
          textString="Tests stage up enable for any stage above 
and including stage 1"),
        Text(
          extent={{-136,-202},{-76,-224}},
          lineColor={0,0,127},
          textString="Tests staging up
for a plant without a WSE")}));
end Up;
