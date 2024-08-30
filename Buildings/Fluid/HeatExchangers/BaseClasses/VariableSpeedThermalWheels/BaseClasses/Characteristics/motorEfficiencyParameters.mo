within Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels.BaseClasses.Characteristics;
record motorEfficiencyParameters
  "Parameters for defining motor efficiency at different wheel speed ratio"
  extends Modelica.Icons.Record;
  parameter Real uSpe[:](each min=0)
    "Wheel speed ratio";
  parameter Modelica.Units.SI.Efficiency eta[size(uSpe, 1)](each max=1)
    "Wheel motor efficiency at wheel speed ratios";
  annotation (Documentation(info="<html>
<p>
This model describes wheel speed ratio <code>uSpe</code> versus
the motor percent full-load efficiency (see 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve</a>).
It is developed based on
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot</a>.
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
