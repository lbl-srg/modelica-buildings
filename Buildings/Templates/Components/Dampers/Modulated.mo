within Buildings.Templates.Components.Dampers;
model Modulated
  extends Buildings.Templates.Components.Dampers.Interfaces.PartialDamper(
    final typ=Buildings.Templates.Components.Types.Damper.Modulated,
    typBla=Buildings.Templates.Components.Types.DamperBlades.Parallel);

  Buildings.Fluid.Actuators.Dampers.Exponential dam(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal) "Exponential damper"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, dam.port_a) annotation (Line(points={{-100,0},{-56,0},{-56,0},
          {-10,0}}, color={0,127,255}));
  connect(dam.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(bus.y, dam.y) annotation (Line(
      points={{0,100},{0,56},{0,56},{0,12}},
      color={255,204,51},
      thickness=0.5));
  connect(dam.y_actual, bus.y_actual) annotation (Line(points={{5,7},{40,7},{40,
          96},{0,96},{0,100}}, color={0,0,127}));
end Modulated;
