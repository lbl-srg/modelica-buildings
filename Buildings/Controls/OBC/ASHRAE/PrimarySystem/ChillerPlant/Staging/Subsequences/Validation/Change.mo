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
    staCha annotation (Placement(transformation(extent={{20,0},{40,20}})));
  CDL.Continuous.Sources.Constant                        TCWSupSet1(final k=
        TChiWatSupSet)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  CDL.Continuous.Sources.Sine                        TChiWatRet(
    final amplitude=2,
    final freqHz=1/300,
    final offset=aveTChiWatRet) "Chiller water return temeprature"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  CDL.Continuous.Sources.Sine                        chiWatFlow(
    final freqHz=1/600,
    final offset=aveVChiWat_flow,
    final amplitude=0.01) "Chilled water flow"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
protected
  CDL.Integers.Sources.Constant stage0(final k=0)
               "0th stage"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  CDL.Continuous.Sources.Constant dpChiWat(final k=65*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  CDL.Continuous.Sources.Constant                        TCWSupSet(final k=
        273.15 + 14)
               "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-18},{-140,2}})));
  CDL.Continuous.Sources.Constant dpChiWatSet(final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
equation

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
