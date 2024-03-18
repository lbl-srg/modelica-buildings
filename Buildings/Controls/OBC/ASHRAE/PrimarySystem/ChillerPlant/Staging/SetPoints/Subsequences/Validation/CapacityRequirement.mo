within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Validation;
model CapacityRequirement
  "Validates the cooling capacity requirement calculation"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.CapacityRequirement
    capReq "Capacity requirement when no stage chage occurs"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.CapacityRequirement
    capReq1 "Capacity requirement when stage change occurs and the process is shorter than 15 minutes"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.CapacityRequirement
    capReq2 "Capacity requirement when stage change occurs and the process is longer than 15 minutes"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));

protected
  parameter Real TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=285.15
    "Chilled water supply set temperature";

  parameter Real aveTChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=288.15
    "Average measured chilled water return temperature";

  parameter Real aveVChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") = 0.02
    "Average measured chilled water flow rate";

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TCWSupSet(
    final k=TChiWatSupSet) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet(
    final amplitude=2,
    final freqHz=1/300,
    final offset=aveTChiWatRet) "Chilled water return temeprature"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin chiWatFlow(
    final freqHz=1/600,
    final offset=aveVChiWat_flow,
    final amplitude=0.01) "Chilled water flow"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chaPro(final k=false)
    "Stage change is not in process"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TCWSupSet1(
    final k=TChiWatSupSet) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet1(
    final amplitude=2,
    final freqHz=1/300,
    final offset=aveTChiWatRet) "Chilled water return temeprature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin chiWatFlow1(
    final freqHz=1/600,
    final offset=aveVChiWat_flow,
    final amplitude=0.01) "Chilled water flow"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chaPro1(
    final period=24*60,
    final shift=5*60)
    "Stage change process status signal"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TCWSupSet2(
    final k= TChiWatSupSet) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet2(
    final amplitude=2,
    final freqHz=1/300,
    final offset=aveTChiWatRet) "Chilled water return temeprature"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin chiWatFlow2(
    final freqHz=1/600,
    final offset=aveVChiWat_flow,
    final amplitude=0.01) "Chilled water flow"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chaPro2(
    final period=32*60,
    final shift=5*60)
    "Stage change process status signal"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

equation
  connect(TCWSupSet.y, capReq.TChiWatSupSet) annotation (Line(points={{-118,20},
          {-90,20},{-90,19},{-82,19}}, color={0,0,127}));
  connect(TChiWatRet.y, capReq.TChiWatRet) annotation (Line(points={{-118,-20},
          {-100,-20},{-100,14},{-82,14}},
                                       color={0,0,127}));
  connect(chiWatFlow.y, capReq.VChiWat_flow) annotation (Line(points={{-118,-60},
          {-88,-60},{-88,9},{-82,9}},color={0,0,127}));
  connect(chaPro.y, capReq.chaPro) annotation (Line(points={{-118,70},{-86,70},
          {-86,2},{-82,2}},  color={255,0,255}));
  connect(TCWSupSet1.y, capReq1.TChiWatSupSet) annotation (Line(points={{-18,20},
          {10,20},{10,19},{18,19}}, color={0,0,127}));
  connect(TChiWatRet1.y, capReq1.TChiWatRet) annotation (Line(points={{-18,-20},
          {0,-20},{0,14},{18,14}},
                                 color={0,0,127}));
  connect(chiWatFlow1.y, capReq1.VChiWat_flow) annotation (Line(points={{-18,-60},
          {12,-60},{12,9},{18,9}}, color={0,0,127}));
  connect(chaPro1.y, capReq1.chaPro) annotation (Line(points={{-18,70},{14,70},
          {14,2},{18,2}},  color={255,0,255}));
  connect(TCWSupSet2.y, capReq2.TChiWatSupSet) annotation (Line(points={{82,20},
          {110,20},{110,19},{118,19}}, color={0,0,127}));
  connect(TChiWatRet2.y, capReq2.TChiWatRet) annotation (Line(points={{82,-20},
          {100,-20},{100,14},{118,14}},
                                     color={0,0,127}));
  connect(chiWatFlow2.y, capReq2.VChiWat_flow) annotation (Line(points={{82,-60},
          {112,-60},{112,9},{118,9}}, color={0,0,127}));
  connect(chaPro2.y, capReq2.chaPro) annotation (Line(points={{82,70},{114,70},
          {114,2},{118,2}},  color={255,0,255}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Subsequences/Validation/CapacityRequirement.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.CapacityRequirement\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.CapacityRequirement</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 1, 2019, by Milica Grahovac:<br/>
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
