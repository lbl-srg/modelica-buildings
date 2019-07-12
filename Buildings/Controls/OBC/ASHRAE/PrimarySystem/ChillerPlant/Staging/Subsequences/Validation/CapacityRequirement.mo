within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model CapacityRequirement
  "Validates the cooling capacity requirement calculation"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.CapacityRequirement
    capReq "Capacity requirement when no stage chage occurs"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.CapacityRequirement
    capReq1 "Capacity requirement when stage change occurs and the process is shorter than 15 minutes"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.CapacityRequirement
    capReq2 "Capacity requirement when stage change occurs and the process is longer than 15 minutes"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));

protected
  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Real aveVChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") = 0.02
    "Average measured chilled water flow rate";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=TChiWatSupSet) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TChiWatRet(
    final amplitude=2,
    final freqHz=1/300,
    final offset=aveTChiWatRet) "Chiller water return temeprature"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatFlow(
    final freqHz=1/600,
    final offset=aveVChiWat_flow,
    final amplitude=0.01) "Chilled water flow"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chaPro(final k=false)
    "Stage change is not in process"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet1(
    final k=TChiWatSupSet) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TChiWatRet1(
    final amplitude=2,
    final freqHz=1/300,
    final offset=aveTChiWatRet) "Chiller water return temeprature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatFlow1(
    final freqHz=1/600,
    final offset=aveVChiWat_flow,
    final amplitude=0.01) "Chilled water flow"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chaPro1(
    final period=24*60,
    final startTime=5*60)
    "Stage change process status signal"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet2(
    final k= TChiWatSupSet) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TChiWatRet2(
    final amplitude=2,
    final freqHz=1/300,
    final offset=aveTChiWatRet) "Chiller water return temeprature"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatFlow2(
    final freqHz=1/600,
    final offset=aveVChiWat_flow,
    final amplitude=0.01) "Chilled water flow"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chaPro2(
    final period=32*60,
    final startTime=5*60)
    "Stage change process status signal"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

equation
  connect(TCWSupSet.y, capReq.TChiWatSupSet) annotation (Line(points={{-119,20},
          {-90,20},{-90,13},{-81,13}}, color={0,0,127}));
  connect(TChiWatRet.y, capReq.TChiWatRet) annotation (Line(points={{-119,-20},{
          -100,-20},{-100,7},{-81,7}}, color={0,0,127}));
  connect(chiWatFlow.y, capReq.VChiWat_flow) annotation (Line(points={{-119,-60},
          {-88,-60},{-88,1},{-81,1}},color={0,0,127}));
  connect(chaPro.y, capReq.chaPro) annotation (Line(points={{-119,70},{-86,70},{
          -86,19},{-81,19}}, color={255,0,255}));
  connect(TCWSupSet1.y, capReq1.TChiWatSupSet) annotation (Line(points={{-19,20},
          {10,20},{10,13},{19,13}}, color={0,0,127}));
  connect(TChiWatRet1.y, capReq1.TChiWatRet) annotation (Line(points={{-19,-20},
          {0,-20},{0,7},{19,7}}, color={0,0,127}));
  connect(chiWatFlow1.y, capReq1.VChiWat_flow) annotation (Line(points={{-19,-60},
          {12,-60},{12,1},{19,1}}, color={0,0,127}));
  connect(chaPro1.y, capReq1.chaPro) annotation (Line(points={{-19,70},{14,70},{
          14,19},{19,19}}, color={255,0,255}));
  connect(TCWSupSet2.y, capReq2.TChiWatSupSet) annotation (Line(points={{81,20},
          {110,20},{110,13},{119,13}}, color={0,0,127}));
  connect(TChiWatRet2.y, capReq2.TChiWatRet) annotation (Line(points={{81,-20},{
          100,-20},{100,7},{119,7}}, color={0,0,127}));
  connect(chiWatFlow2.y, capReq2.VChiWat_flow) annotation (Line(points={{81,-60},
          {112,-60},{112,1},{119,1}}, color={0,0,127}));
  connect(chaPro2.y, capReq2.chaPro) annotation (Line(points={{81,70},{114,70},{
          114,19},{119,19}}, color={255,0,255}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/CapacityRequirement.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 5, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})));
end CapacityRequirement;
