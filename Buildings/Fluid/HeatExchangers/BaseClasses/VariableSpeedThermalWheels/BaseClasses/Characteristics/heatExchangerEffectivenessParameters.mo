within Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels.BaseClasses.Characteristics;
record heatExchangerEffectivenessParameters
  "Parameters for defining heat exchanger effectiveness at different wheel speed ratios"
  extends Modelica.Icons.Record;

  parameter Real uSpe[:](
    each final min=0,
    each final unit="1")
    "Wheel speed ratio";
  parameter Real epsCor[:](
    each final max=1,
    each final unit="1")
    "Correction of the heat exchange effectiveness at a given speed ratio";
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(info="<html>
<p>
Data record that describes wheel speed ratio <code>uSpe</code> versus
heat exchange effectiveness corrections <code>epsCor</code>, i.e., the ratio of the heat exchange effectiveness 
to that when the <code>uSpe</code> is <i>1</i>.
The elements of the vector <code>uSpe</code> should be in ascending order, 
i.e.,<code>uSpe[i] &lt; uSpe[i+1]</code>.
Both vectors, <code>uSpe</code> and <code>epsCor</code>
must have the same size.
</p>
</html>", revisions="<html>
<ul>
<li>
May 28, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end heatExchangerEffectivenessParameters;
