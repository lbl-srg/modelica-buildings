within Buildings.Templates.Components.Valves;
model TwoWay "Two-way valve"
  extends Buildings.Templates.Components.Valves.Interfaces.PartialValve(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWay);

  replaceable Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val
    constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
      redeclare final package Medium=Medium,
      final m_flow_nominal=m_flow_nominal,
      final dpValve_nominal=dpValve_nominal,
      final dpFixed_nominal=dpFixed_nominal)
    "Valve"
    annotation (
      choicesAllMatching=true,
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0)));
equation
  connect(port_a, val.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(val.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(bus.y, val.y) annotation (Line(
      points={{0,100},{0,12}},
      color={255,204,51},
      thickness=0.5));
  connect(val.y_actual, bus.y_actual) annotation (Line(points={{5,7},{40,7},{40,
          96},{0,96},{0,100}}, color={0,0,127}));
end TwoWay;
