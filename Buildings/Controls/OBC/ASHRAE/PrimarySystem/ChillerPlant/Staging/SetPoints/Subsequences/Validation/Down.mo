within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Validation;
model Down "Validate change stage down condition sequence"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Down
    withWSE(have_locSen=true)
            "Generates stage down signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Down
    withWSE1(have_locSen=true)
             "Generates stage down signal"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Down
    noWSE(have_WSE=false, have_locSen=true)
                          "Generates stage down signal for a plant with a WSE"
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
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant WSESta1(
    final k=true) "WSE status"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TCWSupSet(
    final k=273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpChiWatSet(
    final k=65*6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TCWSup(
    final k=273.15 + 14) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpChiWat(
    final k=65*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant splrDown(
    final k=0.8)
    "Staging down part load ratio"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin oplrDown(
    final amplitude=0.1,
    final startTime=0,
    final freqHz=1/4800,
    final phase(displayUnit="deg") = -1.5707963267949,
    final offset=0.75) "Operating part load ratio of the next stage down"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TWsePre(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TowFanSpeMax(
    final k=0.9)
    "Maximum cooling tower speed signal"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TCWSupSet1(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpChiWatSet1(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TCWSup1(
    final k=273.15 + 14)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpChiWat1(
    final k=62*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant oplrDown1(final k=1)
    "Operating part load ratio of stage 0"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TowFanSpeMax1(
    final k=0.9)
    "Maximum cooling tower speed signal"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TWsePre1(
    final amplitude=4,
    final freqHz=1/2100,
    final offset=273.15 + 12.5)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  CDL.Reals.Sources.Constant                        splrDown1(final k=1)
    "Staging down part load ratio"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
equation

  connect(TCWSupSet.y, withWSE.TChiWatSupSet) annotation (Line(points={{-138,
          -10},{-70,-10},{-70,48.8},{-42,48.8}},
                                             color={0,0,127}));
  connect(TCWSup.y, withWSE.TChiWatSup) annotation (Line(points={{-138,-50},{
          -68,-50},{-68,46.8},{-42,46.8}},
                                       color={0,0,127}));
  connect(dpChiWatSet.y, withWSE.dpChiWatPumSet_local) annotation (Line(points=
          {{-98,10},{-76,10},{-76,57},{-42,57}}, color={0,0,127}));
  connect(dpChiWat.y, withWSE.dpChiWatPum_local) annotation (Line(points={{-98,
          -30},{-72,-30},{-72,55},{-42,55}}, color={0,0,127}));
  connect(oplrDown.y, withWSE.uOpeDow) annotation (Line(points={{-98,130},{-70,
          130},{-70,61},{-42,61}}, color={0,0,127}));
  connect(splrDown.y, withWSE.uStaDow) annotation (Line(points={{-138,110},{-72,
          110},{-72,59},{-42,59}}, color={0,0,127}));
  connect(WSESta.y, withWSE.uWseSta) annotation (Line(points={{-98,-70},{-66,
          -70},{-66,39},{-42,39}}, color={255,0,255}));
  connect(stage2.y, withWSE.u) annotation (Line(points={{-138,-90},{-62,-90},{
          -62,41},{-42,41}}, color={255,127,0}));
  connect(TWsePre.y, withWSE.TWsePre) annotation (Line(points={{-138,30},{-80,
          30},{-80,44.8},{-42,44.8}},
                                  color={0,0,127}));
  connect(TowFanSpeMax.y, withWSE.uTowFanSpeMax) annotation (Line(points={{-98,50},
          {-90,50},{-90,42.8},{-42,42.8}}, color={0,0,127}));
  connect(TCWSupSet1.y, withWSE1.TChiWatSupSet) annotation (Line(points={{42,-10},
          {110,-10},{110,48.8},{138,48.8}},  color={0,0,127}));
  connect(TCWSup1.y, withWSE1.TChiWatSup) annotation (Line(points={{42,-50},{
          112,-50},{112,46.8},{138,46.8}},
                                       color={0,0,127}));
  connect(dpChiWatSet1.y, withWSE1.dpChiWatPumSet_local) annotation (Line(
        points={{82,10},{104,10},{104,57},{138,57}}, color={0,0,127}));
  connect(dpChiWat1.y, withWSE1.dpChiWatPum_local) annotation (Line(points={{82,
          -30},{108,-30},{108,55},{138,55}}, color={0,0,127}));
  connect(oplrDown1.y, withWSE1.uOpeDow) annotation (Line(points={{82,130},{110,
          130},{110,61},{138,61}}, color={0,0,127}));
  connect(WSESta1.y, withWSE1.uWseSta) annotation (Line(points={{82,-70},{114,
          -70},{114,39},{138,39}}, color={255,0,255}));
  connect(stage1.y, withWSE1.u) annotation (Line(points={{42,-90},{116,-90},{
          116,41},{138,41}}, color={255,127,0}));
  connect(TowFanSpeMax1.y, withWSE1.uTowFanSpeMax) annotation (Line(points={{82,50},
          {90,50},{90,42.8},{138,42.8}}, color={0,0,127}));
  connect(TWsePre1.y, withWSE1.TWsePre) annotation (Line(points={{42,30},{106,
          30},{106,44.8},{138,44.8}},
                                  color={0,0,127}));
  connect(oplrDown.y, noWSE.uOpeDow) annotation (Line(points={{-98,130},{-70,
          130},{-70,101},{-42,101}}, color={0,0,127}));
  connect(splrDown.y, noWSE.uStaDow) annotation (Line(points={{-138,110},{-72,
          110},{-72,99},{-42,99}},   color={0,0,127}));
  connect(dpChiWatSet.y, noWSE.dpChiWatPumSet_local) annotation (Line(points={{
          -98,10},{-82,10},{-82,86},{-56,86},{-56,97},{-42,97}}, color={0,0,127}));
  connect(dpChiWat.y, noWSE.dpChiWatPum_local) annotation (Line(points={{-98,
          -30},{-86,-30},{-86,84},{-54,84},{-54,95},{-42,95}}, color={0,0,127}));
  connect(TCWSup.y, noWSE.TChiWatSup) annotation (Line(points={{-138,-50},{-88,
          -50},{-88,82},{-50,82},{-50,86.8},{-42,86.8}},
                                                     color={0,0,127}));
  connect(TCWSupSet.y, noWSE.TChiWatSupSet) annotation (Line(points={{-138,-10},
          {-84,-10},{-84,80},{-52,80},{-52,88.8},{-42,88.8}},
                                                          color={0,0,127}));
  connect(stage2.y, noWSE.u) annotation (Line(points={{-138,-90},{-64,-90},{-64,
          81},{-42,81}}, color={255,127,0}));
  connect(splrDown1.y, withWSE1.uStaDow) annotation (Line(points={{62,90},{100,
          90},{100,59},{138,59}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Subsequences/Validation/Down.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Down</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2020, by Milica Grahovac:<br/>
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
          textColor={0,0,127},
          textString="Tests stage down from stages higher than stage 1.

The tests assumes a false output of the failsafe condition and 
checks functionality for the next available stage down SPLR and OPLR inputs."),
        Text(
          extent={{38,-120},{98,-142}},
          textColor={0,0,127},
          textString="Tests stage down from stage 1.

Test assumes WSE is on and 
maximum tower fan speed signal
is less than 1. The test ensures stage down gets initiated as the 
cooling capacity of the first stage exceeds the demand
given the presence of WSE.")}));
end Down;
