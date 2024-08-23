within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Validation;
model PredictedOutletTemperature
  "Validate water side economizer outlet temperature prediction"

  parameter Real aveTWetBul(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=288.15
    "Chilled water supply set temperature";

  parameter Real aveVChiWat_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    displayUnit="m3/s")=0.01
    "Average measured chilled water return temperature";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.PredictedOutletTemperature
    wseTOut "Waterside economizer outlet temperature prediction"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TOutWetSig(
    final amplitude=2,
    final freqHz=1/600,
    final offset=aveTWetBul)
    "Measured outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin chiWatFlow(
    final freqHz=1/600,
    final offset=aveVChiWat_flow,
    final amplitude=0.002) "Chilled water flow"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler sam1(
    final samplePeriod=60) "Sampler"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram(
    final offset=-0.2,
    final height=0.7,
    final duration=2100) "Ramp"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

equation
  connect(ram.y, sam1.u)
    annotation (Line(points={{-38,-50},{-22,-50}}, color={0,0,127}));
  connect(sam1.y, wseTOut.uTunPar) annotation (Line(points={{2,-50},{20,-50},{20,
          2},{38,2}},     color={0,0,127}));
  connect(TOutWetSig.y, wseTOut.TOutWet) annotation (Line(points={{-38,50},{20,50},
          {20,18},{38,18}},color={0,0,127}));
  connect(chiWatFlow.y, wseTOut.VChiWat_flow)
    annotation (Line(points={{-38,10},{38,10}},   color={0,0,127}));

annotation (
 experiment(StopTime=2100.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Economizers/Subsequences/Validation/PredictedOutletTemperature.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.PredictedOutletTemperature\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.PredictedOutletTemperature</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2018, by Milica Grahovac:<br/>
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
end PredictedOutletTemperature;
