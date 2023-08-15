within Buildings.Fluid.Storage.Ice;
model TankWithLoss
  extends Tank;
  parameter Modelica.Units.SI.ThermalConductance G=0
  "Constant thermal conductance of material to calculate thermal losses";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorLos
    "Heat port that connects to external temperature to estimate losses"
    annotation (Placement(transformation(extent={{-6,60},{6,72}}),
        iconTransformation(extent={{-6,60},{6,72}})));
protected
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor heaLossCon(each G=G)
    "Overall thermal conductance to estimate thermal losses"
    annotation (Placement(transformation(extent={{-18,14},{-8,26}})));
equation
  connect(heaLossCon.port_a, vol.heatPort) annotation (Line(points={{-18,20},{
          -20,20},{-20,-10},{-9,-10}}, color={191,0,0}));
  connect(heaLossCon.port_b, heaPorLos)
    annotation (Line(points={{-8,20},{0,20},{0,66}}, color={191,0,0}));
end TankWithLoss;
