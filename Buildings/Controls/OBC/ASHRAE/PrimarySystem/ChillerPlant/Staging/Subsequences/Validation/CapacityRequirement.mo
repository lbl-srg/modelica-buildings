within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model CapacityRequirement
  "Validates the cooling capacity requirement calculation"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.CapacityRequirement
    capReq annotation (Placement(transformation(extent={{20,0},{40,20}})));

//protected
  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Real aveVChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") = 0.05
    "Average measured chilled water flow rate";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=TChiWatSupSet)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TChiWatRet(
    final amplitude=2,
    final freqHz=1/300,
    final offset=aveTChiWatRet) "Chiller water return temeprature"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatFlow(
    final freqHz=1/600,
    final offset=aveVChiWat_flow,
    final amplitude=0.01) "Chilled water flow"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

equation

  connect(TCWSupSet.y, capReq.TChiWatSupSet) annotation (Line(points={{-59,60},{
          -20,60},{-20,15},{19,15}}, color={0,0,127}));
  connect(TChiWatRet.y, capReq.TChiWatRet) annotation (Line(points={{-59,20},{-30,
          20},{-30,10},{19,10}}, color={0,0,127}));
  connect(chiWatFlow.y, capReq.VChiWat_flow) annotation (Line(points={{-59,-30},
          {-20,-30},{-20,5},{19,5}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
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
end CapacityRequirement;
