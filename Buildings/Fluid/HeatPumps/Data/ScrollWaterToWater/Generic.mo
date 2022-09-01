within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater;
record Generic "Record for scroll water to water heat pump"
  extends BaseClasses.HeatPumps;

  parameter Real volRat(
    min = 1.0,
    unit = "1")
    "Built-in volume ratio"
    annotation (Dialog(group="Compressor"));

  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal(min=0)
    "Refrigerant volume flow rate at suction"
    annotation (Dialog(group="Compressor"));

  parameter Modelica.Units.SI.MassFlowRate leaCoe(min=0) "Leakage coefficient"
    annotation (Dialog(group="Compressor"));

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
This is the base record for scroll water to water heat pump models.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 6, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));

end Generic;
