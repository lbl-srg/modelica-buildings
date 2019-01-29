within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Up "Validate change stage up condition sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up
    staUp "Generates stage up signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));


  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up
    staUp1 "Generates stage up signal"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));

protected
  CDL.Integers.Sources.Constant stage0(
    final k=0) "0th stage"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(
    final k=1) "1st stage"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUpMin(final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(final k=273.15
         + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(final k=65*
        6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUp(final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup(
    final amplitude=1.5,
    final freqHz=1/1800,
    final offset=273.15 + 16) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine oplr(
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100,
    final amplitude=0.05) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrUp(
    final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUpMin1(
    final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet1(
    final k=273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet1(
    final k=65*6895)
   "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUp1(
    final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup1(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/600) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat1(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine oplr1(
    final amplitude=0.1,
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrUp1(final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
equation

  connect(splrUp.y, staUp.uSplrUp) annotation (Line(points={{-99,30},{-88,30},{
          -88,38},{-41,38}},
                    color={0,0,127}));
  connect(oplr.y, staUp.uOplr) annotation (Line(points={{-99,70},{-60,70},{-60,
          40},{-41,40}},
                   color={0,0,127}));
  connect(oplrUp.y, staUp.uOplrUp) annotation (Line(points={{-139,50},{-80,50},
          {-80,35},{-41,35}},
                        color={0,0,127}));
  connect(oplrUpMin.y, staUp.uOplrUpMin) annotation (Line(points={{-139,10},{
          -80,10},{-80,33},{-41,33}},
                            color={0,0,127}));
  connect(TCWSupSet.y, staUp.TChiWatSupSet) annotation (Line(points={{-139,-30},
          {-70,-30},{-70,30},{-41,30}},
                                    color={0,0,127}));
  connect(TCWSup.y, staUp.TChiWatSup) annotation (Line(points={{-139,-70},{-60,
          -70},{-60,28},{-41,28}},
                            color={0,0,127}));
  connect(dpChiWatSet.y, staUp.dpChiWatPumSet) annotation (Line(points={{-99,-10},
          {-56,-10},{-56,25},{-41,25}},
                                     color={0,0,127}));
  connect(dpChiWat.y, staUp.dpChiWatPum) annotation (Line(points={{-99,-50},{
          -52,-50},{-52,23},{-41,23}},
                            color={0,0,127}));
  connect(stage0.y, staUp.uChiSta) annotation (Line(points={{-139,90},{-50,90},
          {-50,20},{-41,20}},color={255,127,0}));
  connect(splrUp1.y, staUp1.uSplrUp) annotation (Line(points={{81,30},{92,30},{
          92,38},{139,38}},
                         color={0,0,127}));
  connect(oplr1.y, staUp1.uOplr) annotation (Line(points={{81,70},{120,70},{120,
          40},{139,40}}, color={0,0,127}));
  connect(oplrUp1.y, staUp1.uOplrUp) annotation (Line(points={{41,50},{100,50},
          {100,35},{139,35}},color={0,0,127}));
  connect(oplrUpMin1.y, staUp1.uOplrUpMin) annotation (Line(points={{41,10},{
          100,10},{100,33},{139,33}},
                                  color={0,0,127}));
  connect(TCWSupSet1.y, staUp1.TChiWatSupSet) annotation (Line(points={{41,-30},
          {110,-30},{110,30},{139,30}}, color={0,0,127}));
  connect(TCWSup1.y, staUp1.TChiWatSup) annotation (Line(points={{41,-70},{120,
          -70},{120,28},{139,28}},
                              color={0,0,127}));
  connect(dpChiWatSet1.y, staUp1.dpChiWatPumSet) annotation (Line(points={{81,-10},
          {124,-10},{124,25},{139,25}}, color={0,0,127}));
  connect(dpChiWat1.y, staUp1.dpChiWatPum) annotation (Line(points={{81,-50},{
          128,-50},{128,23},{139,23}},
                                   color={0,0,127}));
  connect(stage1.y, staUp1.uChiSta) annotation (Line(points={{41,90},{130,90},{
          130,20},{139,20}},
                         color={255,127,0}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Up.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Up</a>.

fixme: if in the test on the left one sets a large difference between CWT and setpoint, the output is 
simply true, without a delay. If this is desired, we should consider replacing true delay with
timer+greater than in a few of the subsequences used in staging.
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}}),
        graphics={
        Text(
          extent={{-136,-90},{-76,-112}},
          lineColor={0,0,127},
          textString="Tests stage 0 to stage 1 enable
based on chilled water supply
temperature.

Other inputs are kept the same 
as in the example on the right."),
        Text(
          extent={{44,-90},{104,-112}},
          lineColor={0,0,127},
          textString="Tests stage up enable for any stage above 
and including stage 1")}));
end Up;
