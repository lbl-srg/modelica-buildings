within Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses;
record Generic "Generic data record for DX coil"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.AngularVelocity spe(unit="1/s", displayUnit="1/min")
    "Rotational speed";
  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues nomVal
    "Nominal values"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Generic perCur
    "Performance curves"
    annotation (choicesAllMatching = true, Placement(transformation(extent={{60,20},{80,40}})));
annotation (defaultComponentName="per",
              preferedView="info",
  Documentation(info="<html>
This is the base record for DX cooling coil model at a compressor speed. 
</html>",
revisions="<html>
<ul>
<li>
August 13, 2012 by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));
end Generic;
