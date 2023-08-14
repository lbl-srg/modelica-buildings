within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record CriteriaLimits
  "Record that is used for summary of the test acceptance criteria limits"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Energy lowerLimit "Lower limit of the test acceptance criteria";
  parameter Modelica.Units.SI.Energy upperLimit "Upper limit of the test acceptance criteria";
 annotation (
   Documentation(info=
"<html>
<p>
Record that is used for the test acceptance criteria limits.</p>
</html>",
revisions="<html>
<ul>
<li>
May 12, 2023, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CriteriaLimits;
