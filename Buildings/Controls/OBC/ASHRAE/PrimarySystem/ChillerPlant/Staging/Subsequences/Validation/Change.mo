within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Change "Validates chiller stage signal"

  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Modelica.SIunits.Time minStaRuntime = 900
    "Minimum stage runtime";

  parameter Modelica.SIunits.VolumeFlowRate aveVChiWat_flow = 0.05
    "Average measured chilled water flow rate";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change
    staCha(
    hasWSE=false,
    nVsdCen=0,
    nConCen=1,
    nPosDis=2,
    staNomCap={3e5,6e5,1e5})
    "Stage change"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TChiWatRet(
    final amplitude=7,
    final offset=273.15 + 15,
    final freqHz=1/21600)
    "Chiller water return temeprature"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatFlow(
    final offset=0,
    final freqHz=1/21600,
    final amplitude=0.0376)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staAva[3](final k={true,
        false,true})
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant WSESta(
    final k=true)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max "Maximum"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWat(
    final k=65*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TWsePre(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TowFanSpeMax(
    final k=1)
    "Maximum cooling tower speed signal"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSup(
    final k=273.15 + 14)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zero(
    final k=0) "Constant"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

equation
  connect(dpChiWatSet.y, staCha.dpChiWatPumSet) annotation (Line(points={{-39,-70},
          {-32,-70},{-32,-14},{39,-14}},  color={0,0,127}));
  connect(dpChiWat.y, staCha.dpChiWatPum) annotation (Line(points={{-39,-120},{-30,
          -120},{-30,-16},{39,-16}}, color={0,0,127}));
  connect(TowFanSpeMax.y, staCha.uTowFanSpeMax) annotation (Line(points={{1,-120},
          {10,-120},{10,-20},{39,-20}},     color={0,0,127}));
  connect(TWsePre.y, staCha.TWsePre) annotation (Line(points={{1,-70},{8,-70},{8,
          -18},{39,-18}},       color={0,0,127}));
  connect(TCWSupSet.y, staCha.TChiWatSupSet) annotation (Line(points={{-39,30},{
          28,30},{28,-5},{39,-5}},    color={0,0,127}));
  connect(staAva.y, staCha.uStaAva) annotation (Line(points={{-39,70},{32,70},{32,
          0},{39,0}},    color={255,0,255}));
  connect(staCha.uWseSta, WSESta.y) annotation (Line(points={{39,-2},{30,-2},{30,
          50},{-79,50}},      color={255,0,255}));
  connect(TCWSup.y, staCha.TChiWatSup) annotation (Line(points={{-39,-30},{-34,-30},
          {-34,-12},{39,-12}},  color={0,0,127}));
  connect(zero.y, max.u2) annotation (Line(points={{-119,-70},{-110,-70},{-110,
          -56},{-102,-56}}, color={0,0,127}));
  connect(chiWatFlow.y, max.u1) annotation (Line(points={{-119,-30},{-110,-30},
          {-110,-44},{-102,-44}}, color={0,0,127}));
  connect(staCha.VChiWat_flow, max.y) annotation (Line(points={{39,-9},{-70,-9},
          {-70,-50},{-79,-50}}, color={0,0,127}));
  connect(TChiWatRet.y, staCha.TChiWatRet) annotation (Line(points={{-119,10},{-70,
          10},{-70,-7},{39,-7}},     color={0,0,127}));
annotation (
 experiment(StopTime=20000.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Change.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change</a>.
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
