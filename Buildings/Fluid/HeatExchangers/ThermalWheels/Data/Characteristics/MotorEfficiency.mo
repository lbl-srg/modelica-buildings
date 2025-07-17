within Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics;
record MotorEfficiency
  "Parameters for defining relative motor efficiency at different wheel speeds"
  extends Modelica.Icons.Record;

  parameter Real uSpe[:](
    each final min=0,
    each final unit="1")
    "Wheel speed ratio";
  parameter Modelica.Units.SI.Efficiency eta[size(uSpe, 1)](
    each final max=1)
    "Ratio of the wheel motor efficiency at the given speed to the one when the speed is 1";
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(info="<html>
<p>
This model describes wheel speed ratio <code>uSpe</code> versus
the ratio of motor efficiency <code>eta</code>, i.e., the ratio of the 
motor efficiency at the given speed to the one when the <code>uSpe</code> is 1.
The elements of the vector <code>uSpe</code> should be in ascending order,
i.e.,<code>uSpe[i] &lt; uSpe[i+1]</code>.
Both vectors, <code>uSpe</code> and <code>eta</code>
must have the same size.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 11, 2024, by Sen Huang:<br/>
First implementation based on
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot</a>.
</li>
</ul>
</html>"));
end MotorEfficiency;
