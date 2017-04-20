within Buildings.Fluid.Air.BaseClasses;
model ElectricHeater "Model for electric heater"
  extends Buildings.Fluid.HeatExchangers.HeaterCooler_u;
  parameter Real eff "Effciency of electrical heater";
  Modelica.Blocks.Interfaces.RealOutput P(unit="W") "Power"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Sources.RealExpression powCal(y=gai.y/eff) "Power calculator"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(powCal.y, P)
    annotation (Line(points={{11,-60},{110,-60},{110,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model can be used to simulate electric heaters with continuously variable control signal. 
The control signal is reheating heat flow. This electric heater has constant efficiency.
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ElectricHeater;
