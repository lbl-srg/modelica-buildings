within Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels.BaseClasses.Characteristics;
record motorEfficiencyParameters
  "Parameters for defining motor efficiency at different wheel speed ratios"
  extends Modelica.Icons.Record;

  parameter Real uSpe[:](
    each final min=0,
    each final unit="1")
    "Wheel speed ratio";
  parameter Modelica.Units.SI.Efficiency eta[size(uSpe, 1)](
    each final max=1,
    each final unit="1")
    "Wheel motor efficiency at a given speed ratio";
  annotation (Documentation(info="<html>
<p>
This model describes wheel speed ratio <code>uSpe</code> versus
the motor percent full-load efficiency (see 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve</a>).
It is based on
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
