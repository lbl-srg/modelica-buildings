within Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels.BaseClasses.Characteristics;
record heatExchangerEffectivenessParameters
  "Record for heat exchanger effectiveness correction vs. wheel speed ratio"
  extends Modelica.Icons.Record;
  parameter Real uSpe[:](each min=0)
    "Wheel speed ratio";
  parameter Real epsCor[:](each max=1)
    "Correction of the heat exchange effectiveness under a given speed ratio";
  annotation (Documentation(info="<html>
<p>
Data record that describes wheel speed ratio versus
heat exchange effectiveness corrections, i.e., the ratio of the heat exchange effectiveness 
to that when the <code>uSpe</code> is <i>1</i>.
The wheel speed ratio <code>uSpe</code> must be increasing, 
i.e.,<code>uSpe[i] &lt; uSpe[i+1]</code>.
Both vectors, <code>uSpe</code> and <code>uSpe</code>
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