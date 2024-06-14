within Buildings.Fluid.HeatExchangers.BaseClasses.VariableSpeedThermalWheels.BaseClasses.Characteristics;
record efficiencyParameters_yMot
  "Record for efficiency parameters vs. motor part load ratio"
  extends Modelica.Icons.Record;
  parameter Real y[:](each min=0)
    "Part load ratio, y = PEle/PEle_nominal";
  parameter Modelica.Units.SI.Efficiency eta[size(y, 1)](each max=1)
    "Wheel motor efficiency at these part load ratios";
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
end efficiencyParameters_yMot;
