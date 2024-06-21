within Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels.BaseClasses.Characteristics;
record motorEfficiencyParameters
  "Record for motor efficiency parameters vs. wheel speed ratio"
  extends Modelica.Icons.Record;
  parameter Real uSpe[:](each min=0)
    "Wheel speed ratio";
  parameter Modelica.Units.SI.Efficiency eta[size(uSpe, 1)](each max=1)
    "Wheel motor efficiency at wheel speed ratios";
  annotation (Documentation(info="<html>
<p>
This function is identical to
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot</a>,
with the original definition expanded to cover wheels.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 11, 2024, by Sen Huang:<br/>
First implementation based on <a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot</a>.
</li>
</ul>
</html>"));
end motorEfficiencyParameters;
