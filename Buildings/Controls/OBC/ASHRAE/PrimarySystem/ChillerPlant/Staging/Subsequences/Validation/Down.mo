within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Down "Validate change stage down condition sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down
    staDown
          annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  CDL.Integers.Sources.Constant                        stage0(k=1) "0th stage"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUp(final k=0.4)
    "Minimum operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(final k=273.15
         + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(final k=65*
        6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplr(final k=0.5)
    "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/600) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  CDL.Continuous.Sources.Constant splrDown(final k=0.8)
    "Staging down part load ratio"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));

  CDL.Continuous.Sources.Sine oplrDown(
    final amplitude=0.1,
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100) "Operating part load ratio of the next stage down"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  CDL.Continuous.Sources.Constant TWsePre(final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
equation

  connect(TCWSupSet.y, staDown.TChiWatSupSet) annotation (Line(points={{-139,
          -30},{-70,-30},{-70,28},{-61,28}},
                                       color={0,0,127}));
  connect(TCWSup.y, staDown.TChiWatSup) annotation (Line(points={{-139,-70},{
          -68,-70},{-68,26},{-61,26}},
                                   color={0,0,127}));
  connect(dpChiWatSet.y, staDown.dpChiWatPumSet) annotation (Line(points={{-99,-10},
          {-76,-10},{-76,34},{-61,34}},color={0,0,127}));
  connect(dpChiWat.y, staDown.dpChiWatPum) annotation (Line(points={{-99,-50},{
          -72,-50},{-72,32},{-61,32}},
                                   color={0,0,127}));
  connect(oplrDown.y, staDown.uOplrDow) annotation (Line(points={{-99,110},{-70,
          110},{-70,42},{-61,42}}, color={0,0,127}));
  connect(splrDown.y, staDown.uSplrDow) annotation (Line(points={{-139,90},{-72,
          90},{-72,40},{-61,40}}, color={0,0,127}));
  connect(oplr.y, staDown.uOplr) annotation (Line(points={{-99,70},{-76,70},{
          -76,38},{-61,38}}, color={0,0,127}));
  connect(oplrUp.y, staDown.uOplrMin) annotation (Line(points={{-139,50},{-80,
          50},{-80,36},{-61,36}}, color={0,0,127}));
  connect(con.y, staDown.uWseSta) annotation (Line(points={{-99,-90},{-66,-90},
          {-66,22},{-61,22}}, color={255,0,255}));
  connect(stage0.y, staDown.uChiSta) annotation (Line(points={{-139,-110},{-64,
          -110},{-64,20},{-61,20}}, color={255,127,0}));
  connect(TWsePre.y, staDown.uTWsePre) annotation (Line(points={{-139,10},{-80,
          10},{-80,30},{-61,30}}, color={0,0,127}));
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
Icon(coordinateSystem(extent={{-180,-140},{180,140}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,
            140}})));
end Down;
