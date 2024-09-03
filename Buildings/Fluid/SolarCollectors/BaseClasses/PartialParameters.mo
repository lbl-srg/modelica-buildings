within Buildings.Fluid.SolarCollectors.BaseClasses;
block PartialParameters "Partial model for parameters"

  parameter Modelica.Units.SI.Area A_c "Area of the collector";
  parameter Integer nSeg=3 "Number of segments";

  annotation(Documentation(info="<html>
<p>
Partial parameters used in all solar collector models
</p>
</html>", revisions="<html>
<ul>
<li>
February 15, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
Apr 17, 2013, by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"));
end PartialParameters;
