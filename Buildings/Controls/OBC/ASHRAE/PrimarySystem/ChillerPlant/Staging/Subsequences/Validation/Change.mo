within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Change "Validates chiller stage signal"

  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Real aveVChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") = 0.05
    "Average measured chilled water flow rate";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change
    staCha annotation (Placement(transformation(extent={{0,0},{20,20}})));
  CDL.Continuous.Sources.Sine                        TChiWatRet(
    final amplitude=2,
    final freqHz=1/300,
    final offset=aveTChiWatRet) "Chiller water return temeprature"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  CDL.Continuous.Sources.Sine                        chiWatFlow(
    final freqHz=1/600,
    final offset=aveVChiWat_flow,
    final amplitude=0.01) "Chilled water flow"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  CDL.Logical.Sources.Constant con[2](k={true,true})
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  CDL.Logical.Sources.Constant                        WSESta(k=true) "Waterside economizer status"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
protected
  CDL.Integers.Sources.Constant stage1(final k=1) "Chiller stage"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  CDL.Continuous.Sources.Constant dpChiWat(final k=65*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  CDL.Continuous.Sources.Constant                        TCWSupSet(final k=
        273.15 + 14)
               "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  CDL.Continuous.Sources.Constant dpChiWatSet(final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  CDL.Continuous.Sources.Constant                        TWsePre(final k=273.15
         + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  CDL.Continuous.Sources.Constant                        TowFanSpeMax(final k=1)
    "Maximum cooling tower speed signal"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
equation

  connect(dpChiWatSet.y, staCha.dpChiWatPumSet) annotation (Line(points={{-79,
          -50},{-72,-50},{-72,6},{-1,6}}, color={0,0,127}));
  connect(dpChiWat.y, staCha.dpChiWatPum) annotation (Line(points={{-79,-100},{
          -70,-100},{-70,4},{-1,4}}, color={0,0,127}));
  connect(TowFanSpeMax.y, staCha.uTowFanSpeMax) annotation (Line(points={{-39,
          -100},{-30,-100},{-30,0},{-1,0}}, color={0,0,127}));
  connect(TWsePre.y, staCha.TWsePre) annotation (Line(points={{-39,-50},{-32,
          -50},{-32,2},{-1,2}}, color={0,0,127}));
  connect(TCWSupSet.y, staCha.TChiWatSupSet) annotation (Line(points={{-79,50},
          {-12,50},{-12,15},{-1,15}}, color={0,0,127}));
  connect(con.y, staCha.uStaAva) annotation (Line(points={{-79,90},{-8,90},{-8,
          20},{-1,20}}, color={255,0,255}));
  connect(staCha.uSta, stage1.y) annotation (Line(points={{-1,22},{-6,22},{-6,
          130},{-79,130}}, color={255,127,0}));
  connect(chiWatFlow.y, staCha.VChiWat_flow) annotation (Line(points={{-99,-10},
          {-74,-10},{-74,11},{-1,11}}, color={0,0,127}));
  connect(TChiWatRet.y, staCha.TChiWatRet) annotation (Line(points={{-119,30},{
          -20,30},{-20,13},{-1,13}}, color={0,0,127}));
  connect(staCha.uWseSta, WSESta.y) annotation (Line(points={{-1,18},{-10,18},{
          -10,70},{-119,70}}, color={255,0,255}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/ChangeDeprecated.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PositiveDisplacement\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PositiveDisplacement</a>.
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},{180,160}})));
end Change;
