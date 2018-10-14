within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage.Validation;
model StageChangePositiveDisplacement
  "Validates stage change for positive displacement chillers (screw, scroll)"

  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Real aveVChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") = 0.05
    "Average measured chilled water flow rate";

  CDL.Continuous.Sources.Constant TCWSupSet(k=TChiWatSupSet)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  CDL.Continuous.Sources.Sine TChiWatRet(
    amplitude=2,
    freqHz=1/300,
    offset=aveTChiWatRet) "Chiller water return temeprature"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  CDL.Continuous.Sources.Sine chiWatFlow(
    freqHz=1/600,
    offset=aveVChiWat_flow,
    amplitude=0.01)         "Chilled water flow"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage.StageChangePositiveDisplacement
    staChaPosDis
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage.StageChangePositiveDisplacement
    staChaPosDis1
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
equation

annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Stage/Validation/CapacityRequirement.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.TowerWaterLevel\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.TowerWaterLevel</a>.
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
        coordinateSystem(preserveAspectRatio=false)));
end StageChangePositiveDisplacement;
