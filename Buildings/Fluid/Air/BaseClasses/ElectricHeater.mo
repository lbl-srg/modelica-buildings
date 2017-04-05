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
        coordinateSystem(preserveAspectRatio=false)));
end ElectricHeater;
