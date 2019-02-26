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
    staChaPosDis
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
protected
  CDL.Integers.Sources.Constant stage0(final k=0)
               "0th stage"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  CDL.Continuous.Sources.Constant                        oplrUp(final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  CDL.Continuous.Sources.Constant                        splrUp(final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  CDL.Continuous.Sources.Constant                        oplrUpMin(final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  CDL.Continuous.Sources.Constant                        dpChiWatSet(final k=65
        *6895)
              "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  CDL.Continuous.Sources.Constant                        TCWSupSet(final k=
        273.15 + 14)
               "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
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
