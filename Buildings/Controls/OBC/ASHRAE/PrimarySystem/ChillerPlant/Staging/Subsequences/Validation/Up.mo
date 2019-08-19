within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Up "Validate change stage up condition sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up
    staUp "Generates stage up signal"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up
    staUp1 "Generates stage up signal"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));

  CDL.Logical.Sources.Constant                        higSta(final k=false)
    "Highest stage is on"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  CDL.Logical.Sources.Constant                        higSta1(final k=false)
    "Highest stage is on"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
protected
  CDL.Integers.Sources.Constant stage0(
    final k=0) "0th stage"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(
    final k=1) "1st stage"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUpMin(final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(
    final k=65*6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUp(
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine oplr(
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100,
    final amplitude=0.05) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrUp(
    final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUpMin1(
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUp1(
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine oplr1(
    final amplitude=0.1,
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrUp1(final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
equation

  connect(splrUp.y, staUp.uSplrUp) annotation (Line(points={{-98,10},{-88,10},{
          -88,18},{-41,18}},
                    color={0,0,127}));
  connect(oplr.y, staUp.uOplr) annotation (Line(points={{-98,50},{-60,50},{-60,
          20},{-41,20}},
                   color={0,0,127}));
  connect(oplrUp.y, staUp.uOplrUp) annotation (Line(points={{-138,30},{-80,30},
          {-80,15},{-41,15}},
                        color={0,0,127}));
  connect(oplrUpMin.y, staUp.uOplrUpMin) annotation (Line(points={{-138,-10},{
          -80,-10},{-80,13},{-41,13}},
                            color={0,0,127}));
  connect(TCWSupSet.y, staUp.TChiWatSupSet) annotation (Line(points={{-138,-50},
          {-70,-50},{-70,10},{-41,10}},
                                    color={0,0,127}));
  connect(TCWSup.y, staUp.TChiWatSup) annotation (Line(points={{-138,-90},{-60,
          -90},{-60,8},{-41,8}},
                            color={0,0,127}));
  connect(dpChiWatSet.y, staUp.dpChiWatPumSet) annotation (Line(points={{-98,-30},
          {-56,-30},{-56,5},{-41,5}},color={0,0,127}));
  connect(dpChiWat.y, staUp.dpChiWatPum) annotation (Line(points={{-98,-70},{
          -52,-70},{-52,3},{-41,3}},
                            color={0,0,127}));
  connect(stage0.y, staUp.uChiSta) annotation (Line(points={{-138,70},{-50,70},
          {-50,0},{-41,0}},  color={255,127,0}));
  connect(splrUp1.y, staUp1.uSplrUp) annotation (Line(points={{82,10},{92,10},{
          92,18},{139,18}},
                         color={0,0,127}));
  connect(oplr1.y, staUp1.uOplr) annotation (Line(points={{82,50},{120,50},{120,
          20},{139,20}}, color={0,0,127}));
  connect(oplrUp1.y, staUp1.uOplrUp) annotation (Line(points={{42,30},{100,30},
          {100,15},{139,15}},color={0,0,127}));
  connect(oplrUpMin1.y, staUp1.uOplrUpMin) annotation (Line(points={{42,-10},{
          100,-10},{100,13},{139,13}},
                                  color={0,0,127}));
  connect(TCWSupSet1.y, staUp1.TChiWatSupSet) annotation (Line(points={{42,-50},
          {110,-50},{110,10},{139,10}}, color={0,0,127}));
  connect(TCWSup1.y, staUp1.TChiWatSup) annotation (Line(points={{42,-90},{120,
          -90},{120,8},{139,8}},
                              color={0,0,127}));
  connect(dpChiWatSet1.y, staUp1.dpChiWatPumSet) annotation (Line(points={{82,-30},
          {124,-30},{124,5},{139,5}},   color={0,0,127}));
  connect(dpChiWat1.y, staUp1.dpChiWatPum) annotation (Line(points={{82,-70},{
          128,-70},{128,3},{139,3}},
                                   color={0,0,127}));
  connect(stage1.y, staUp1.uChiSta) annotation (Line(points={{42,70},{130,70},{
          130,0},{139,0}},
                         color={255,127,0}));
  connect(higSta.y, staUp.uHigSta) annotation (Line(points={{-138,110},{-48,110},
          {-48,-2},{-41,-2}}, color={255,0,255}));
  connect(higSta1.y, staUp1.uHigSta) annotation (Line(points={{42,110},{132,110},
          {132,-2},{139,-2}}, color={255,0,255}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}}),
        graphics={
        Text(
          extent={{-140,-112},{-78,-136}},
          lineColor={0,0,127},
          textString="Tests stage 0 to stage 1 enable
based on chilled water supply
temperature.

Other inputs are kept the same 
as in the example on the right."),
        Text(
          extent={{44,-108},{104,-130}},
          lineColor={0,0,127},
          textString="Tests stage up enable for any stage above 
and including stage 1")}));
end Up;
