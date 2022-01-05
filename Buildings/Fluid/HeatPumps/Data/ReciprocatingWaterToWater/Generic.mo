within Buildings.Fluid.HeatPumps.Data.ReciprocatingWaterToWater;
record Generic "Record for reciprocating water to water heat pump"
  extends BaseClasses.HeatPumps;

  parameter Modelica.Units.SI.VolumeFlowRate pisDis "Piston displacement"
    annotation (Dialog(group="Compressor"));

  parameter Real cleFac(min = 0, unit = "1")
    "Clearance factor"
    annotation (Dialog(group="Compressor"));

  parameter Modelica.Units.SI.AbsolutePressure pDro
    "Pressure drop at suction and discharge of the compressor"
    annotation (Dialog(group="Compressor"));

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
This is the base record for reciprocating water to water heat pump models.
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
