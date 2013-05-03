within Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.BaseClasses;
record HeatingStage
  "Generic data record for a stage of a heat pump in heating mode"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.AngularVelocity spe(displayUnit="1/min")
    "Rotational speed";
  parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.BaseClasses.HeatingNominalValues
    nomVal "Nominal values"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.BaseClasses.PerformanceCurve
    perCur "Performance curves for this stage"
    annotation (choicesAllMatching = true, Placement(transformation(extent={{60,20},{80,40}})));
annotation (defaultComponentName="per",
              preferedView="info",
  Documentation(info="<html>
<p>
This is the base record for heat pump model at a compressor speed.
See the information section of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData</a>
for a description of the data.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 24, 2013 by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));
end HeatingStage;
